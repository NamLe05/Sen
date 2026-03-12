import { query, mutation, internalMutation } from "./_generated/server";
import { v } from "convex/values";

export const getTodayPlan = query({
  args: { date: v.string() },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthenticated");

    const user = await ctx.db
      .query("users")
      .withIndex("by_clerk", (q) => q.eq("clerkId", identity.subject))
      .first();
    if (!user) throw new Error("User not found");

    return await ctx.db
      .query("dayPlans")
      .withIndex("by_user_date", (q) =>
        q.eq("userId", user._id).eq("date", args.date)
      )
      .first();
  },
});

export const checkOffBlock = mutation({
  args: {
    planId: v.id("dayPlans"),
    blockId: v.string(),
    checkedOff: v.boolean(),
  },
  handler: async (ctx, args) => {
    const identity = await ctx.auth.getUserIdentity();
    if (!identity) throw new Error("Unauthenticated");

    const plan = await ctx.db.get(args.planId);
    if (!plan) throw new Error("Plan not found");

    const user = await ctx.db
      .query("users")
      .withIndex("by_clerk", (q) => q.eq("clerkId", identity.subject))
      .first();
    if (!user || plan.userId !== user._id)
      throw new Error("Unauthorized");

    const updatedBlocks = plan.blocks.map((b) =>
      b.id === args.blockId ? { ...b, checkedOff: args.checkedOff } : b
    );

    await ctx.db.patch(args.planId, { blocks: updatedBlocks });
  },
});

// TODO: getPlansByDateRange — paginated query for calendar view
// TODO: savePlan — internal mutation to store AI-generated plan (called from ai.ts internalAction)
