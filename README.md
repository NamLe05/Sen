# 𓋹 Sen

> *The lotus rises from mud. So will your day.*

**Sen** is a minimalist AI-powered daily planner for people who know what they want to do — but keep losing the day anyway. Tell Sen your plan in the morning. Sen handles the rest.

---

## The Problem

You wake up. You know you have class at 2:30. You want to gym, leetcode, and finish homework. You tell yourself you'll figure it out.

You don't figure it out.

Dinner becomes two hours of scrolling. Gym gets skipped. Leetcode gets skipped. You sleep feeling behind.

---

## The Solution

Sen takes your morning intent — tasks, fixed events, ordering preferences — and builds a real hourly schedule around your life. It then holds you to it, quietly but firmly, the way a good friend would.

---

## Features

```
○  Morning planning via voice or quick form
○  AI-generated hourly time blocks (Gemini 2.0 Flash)
○  Fixed event constraints — class, meetings, anything recurring
○  Smart ordering — gym last, deep work before calls, your rules
○  Push notifications before every block
○  Check-off as you go
○  Lotus bloom — your day visualized as a lotus opening petal by petal
○  Calendar view — every past day, every completed block
```

**Pro**
```
○  Unlimited daily plans
○  AI phone call wake-ups (if you ignore the app)
○  Recurring constraints saved — never re-enter your class schedule
○  Full history and streaks
```

---

## Stack

| Layer | Choice |
|---|---|
| iOS | Swift + SwiftUI |
| Auth | Clerk |
| Backend + DB | Convex |
| AI — planning + voice | Gemini 2.0 Flash |
| Push | APNs |
| Payments | StoreKit 2 |
| Phone calls (Pro) | Twilio |
| Storage | Convex file storage |

---

## How It Works

```
Morning
  │
  ▼
Voice or form input
  │
  ▼
Gemini transcribes + extracts tasks, constraints, preferences
  │
  ▼
AI generates ordered hourly blocks
  │
  ▼
Sen notifies you before each block
  │
  ▼
You check off. Lotus blooms.
  │
  ▼
Night — full day complete. Streak maintained.
```

---

## Data Model

```typescript
users         →  { clerkId, name, apnsToken, isPro, streak }
constraints   →  { userId, recurring: [{ label, days, start, end }] }
dayPlans      →  { userId, date, rawInput, blocks: [...], generatedAt }

block         →  {
                   id, title,
                   startTime, endTime,
                   type,           // task | meal | class | rest
                   checkedOff,
                   photoStorageId  // optional, for future social layer
                 }
```

---

## Screens

```
┌─────────┐   ┌─────────┐   ┌─────────┐
│  Today  │   │  Plan   │   │Calendar │
│         │   │         │   │         │
│ ✓ 8:00  │   │ [voice] │   │ Mar ──  │
│ ● 9:30  │   │  or     │   │ ✓ Mon   │
│ ○ 2:30  │   │ [form]  │   │ ✓ Tue   │
│ ○ 6:30  │   │         │   │ ● Wed   │
│ ○ 9:00  │   │[Generate│   │         │
│         │   │    →]   │   │         │
└─────────┘   └─────────┘   └─────────┘
```

Three screens. Nothing more.

---

## The Lotus Mechanic

Sen's home screen centers a black and white ink lotus. It responds to your day:

```
No plan yet        →  closed bud, below the waterline
Plan generated     →  stem rises above water
Tasks completing   →  petals open one by one
Day complete       →  full bloom
```

No points. No streaks on fire. Just a quiet flower opening.

---

## Getting Started

```bash
# Clone
git clone https://github.com/yourhandle/sen.git
cd sen

# Backend (Convex)
npx convex dev

# iOS
open Sen.xcodeproj
```

### Environment

```
CONVEX_URL          — your Convex deployment URL
CLERK_PUBLISHABLE   — Clerk publishable key
GEMINI_API_KEY      — Google AI Studio key
```

---

## Mascot

**Sen** — a small chibi character with round glasses who lives by the lotus pond. He's calm. Slightly sleepy. Has his life together. You should too.

*Black and white ink. Minimal lines. Very few strokes.*

---

## Roadmap

```
v1    Core planner — voice input, AI blocks, notifications, lotus
v1.5  Pro — Twilio calls, recurring constraints, streaks
v2    Social — daily photo check-ins, friends feed (BeReal-style)
```

---

## Philosophy

Most productivity apps try to do everything.  
Sen does one thing — it takes your morning intention and makes it real.

Minimal UI. Minimal noise. Maximum follow-through.

*— Sen, your calm but persistent daily companion*

---

<p align="center">
  ✦ &nbsp; black & white &nbsp; ✦ &nbsp; minimal &nbsp; ✦ &nbsp; vietnamese-inspired &nbsp; ✦
</p>
