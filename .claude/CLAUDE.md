# Sen — Claude Code Guidelines

Stack: Swift 6 + SwiftUI · Convex · Clerk · Gemini 2.0 Flash · StoreKit 2 · APNs

---

## Swift / SwiftUI

### Concurrency
- Use `async/await` exclusively. No GCD, no completion handlers.
- Business logic on background threads. UI state on `@MainActor` only.
- Use `.task` modifier for view-bound async work — auto-cancels on disappear.
- Use `actor` for any shared mutable state (caches, managers).
- Always `[weak self]` in long-lived `Task` captures to avoid retain cycles.
- Cancel observation tasks in `viewWillDisappear`, not `deinit` (deinit won't fire on leaks).
- Parallel independent work: `async let` or `withTaskGroup`, never sequential `await`.

```swift
// ✅
func load() async {
  async let plan = fetchPlan()
  async let user = fetchUser()
  (self.plan, self.user) = try await (plan, user)
}

// ❌ sequential — 2x slower
let plan = try await fetchPlan()
let user = try await fetchUser()
```

### SwiftUI Performance
- Keep `@Observable` / `@State` granular — large state objects cause full re-renders.
- Prefer `.task` over `.onAppear` + `Task {}`.
- Avoid heavy computation inside `body`. Move to ViewModel.
- Large text lists: profile CPU; use `UITextView` bridge if `Text` spikes.
- Use `LazyVStack` / `LazyHStack` for scrollable lists of blocks.
- `Equatable` conformance on view models prevents redundant diffs.

### Architecture
- MVVM: Views own no logic. ViewModels are `@Observable` classes.
- `@MainActor` on all ViewModels.
- One ViewModel per screen. Shared state via injected services (actors).
- No business logic in SwiftUI previews.

### Security
- Store Clerk JWT and all tokens in **Keychain only**. Never `UserDefaults`.
- Use `kSecAttrAccessibleWhenUnlockedThisDeviceOnly` for tokens.
- No secrets in source, plist, or bundle.
- ATS enabled — no HTTP exceptions. TLS 1.3 preferred.
- Certificate pin Convex and Gemini endpoints using `URLSession` delegate.
- Biometric unlock via `LocalAuthentication` + Keychain ACL (optional but recommended).
- Never log token values or PII.

```swift
// Keychain write
let query: [String: Any] = [
  kSecClass as String: kSecClassGenericPassword,
  kSecAttrAccount as String: "clerk_token",
  kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
  kSecValueData as String: token.data(using: .utf8)!
]
SecItemDelete(query as CFDictionary)
SecItemAdd(query as CFDictionary, nil)
```

### Code Quality
- Enable Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY = complete`).
- Errors: typed `enum` conforming to `Error`. Never `fatalError` in production paths.
- No force unwrap (`!`) except in tests or guaranteed-non-nil contexts with comment.
- `Sendable` on all types crossing actor boundaries.

---

## Convex Backend

### Queries & Performance
- **Always** use `.withIndex()` instead of `.filter()` for anything that could return 1000+ docs.
- Paginate large result sets — never unbounded `.collect()`.
- Await every promise. Unawaited mutations silently fail (`no-floating-promises` ESLint rule).
- Denormalize data to avoid multi-query fetches in hot paths.
- Add optimistic updates (`useMutation` + `optimisticUpdate`) for check-off actions.

```typescript
// ✅
const blocks = await ctx.db
  .query("dayPlans")
  .withIndex("by_user_date", q => q.eq("userId", uid).eq("date", today))
  .first();

// ❌
const all = await ctx.db.query("dayPlans").collect();
const plan = all.find(p => p.userId === uid && p.date === today);
```

### Security
- **Every public function**: authenticate first, then authorize, then act.
- Sensitive logic (AI calls, scheduling): mark as `internalAction` — not callable from client.
- Validate all public function arguments with `v.*` validators.
- Use Clerk JWT identity via `ctx.auth.getUserIdentity()` — never trust client-passed user IDs.
- Rate-limit AI planning calls per user per day in mutation logic.

```typescript
// ✅ pattern for every public mutation
export const checkOffBlock = mutation({
  args: { planId: v.id("dayPlans"), blockId: v.string() },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthenticated");
    const plan = await ctx.db.get(args.planId);
    if (plan?.userId !== identity.subject) throw new Error("Unauthorized");
    // ... mutate
  }
});
```

### Schema
- Define `schema.ts` fully — Convex enforces types at runtime.
- All indexes declared in schema. Add before querying, not after.
- Store timestamps as `v.number()` (Unix ms). Dates as `v.string()` (ISO `YYYY-MM-DD`).
- Monetary values: cents as `v.number()` integer if ever needed.

### Scheduled Functions
- APNs push: Convex `ctx.scheduler.runAt()` — no third-party notification service needed.
- Scheduled functions must be backwards-compatible (old args may replay).
- Use `internal` mutations for scheduled work; never expose scheduler triggers publicly.

### Deployment
- `npx convex deploy` on merge to main. Preview deployments per PR.
- Environment secrets in Convex dashboard — never in code.
- New function args: always optional or additive. Never remove/rename args on live functions.

---

## Gemini Integration

### Prompt Design
- Single API call for both transcription + planning. Send audio + structured prompt together.
- System prompt: demand JSON only, no preamble, no markdown fences.
- Parse with try/catch. Strip any accidental ``` fences before `JSON.parse`.
- Keep prompt under 800 tokens. All context (constraints, date, tasks) injected dynamically.

```typescript
// Convex internalAction
const res = await fetch("https://generativelanguage.googleapis.com/...", {
  method: "POST",
  body: JSON.stringify({
    contents: [{ parts: [
      { text: systemPrompt },
      { inlineData: { mimeType: "audio/webm", data: base64Audio } }
    ]}],
    generationConfig: { responseMimeType: "application/json" }
  })
});
const { blocks } = JSON.parse(await res.json().candidates[0].content.parts[0].text);
```

### Rate Limiting
- Free tier: 1500 req/day. Track daily plan generations per user in Convex.
- Enforce 3 plans/day on free tier in the mutation before calling Gemini.
- Cache the generated plan in `dayPlans` — never re-generate if plan exists for today.

---

## APNs Push Notifications

- Store `deviceToken` on user record in Convex after registration.
- Send via HTTP/2 APNs API directly from Convex `internalAction`.
- Auth: JWT with `.p8` key (stored in Convex env vars). Token expires 1hr — cache and reuse.
- Scheduled cron: runs every 15 min, queries blocks starting in next 15 min, fires push.
- Payload: keep under 4KB. `sound: "default"`, `badge` count from incomplete blocks.

---

## StoreKit 2

- Verify `Transaction.currentEntitlements` on app launch and foreground.
- Sync `isPro` to Convex user record after verified purchase — server is source of truth.
- Listen to `Transaction.updates` async sequence for renewals and revocations.
- Never gate features client-side only. Always check `isPro` in Convex functions too.

```swift
for await result in Transaction.updates {
  if case .verified(let tx) = result {
    await syncProStatus(tx.productID)
    await tx.finish()
  }
}
```

---

## Code Quality Rules

- No `print()` in production. Use `Logger` (OSLog) with subsystem/category.
- All errors surface to UI via `@Observable` error state — never swallowed silently.
- Test coverage: ViewModels unit-tested. Convex functions tested with `convex-test`.
- Feature flags via Convex env vars — no hardcoded behavior switches.
- Git: conventional commits. One PR per feature. No direct commits to main.
