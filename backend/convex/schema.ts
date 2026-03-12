import { defineSchema, defineTable } from "convex/server";
import { v } from "convex/values";

export default defineSchema({
  users: defineTable({
    clerkId: v.string(),
    name: v.string(),
    apnsToken: v.optional(v.string()),
    isPro: v.boolean(),
    streak: v.number(),
  }).index("by_clerk", ["clerkId"]),

  constraints: defineTable({
    userId: v.id("users"),
    recurring: v.array(
      v.object({
        label: v.string(),
        days: v.array(v.string()),
        start: v.string(),
        end: v.string(),
      })
    ),
  }).index("by_user", ["userId"]),

  dayPlans: defineTable({
    userId: v.id("users"),
    date: v.string(),
    rawInput: v.optional(v.string()),
    blocks: v.array(
      v.object({
        id: v.string(),
        title: v.string(),
        startTime: v.string(),
        endTime: v.string(),
        type: v.union(
          v.literal("task"),
          v.literal("meal"),
          v.literal("class"),
          v.literal("rest")
        ),
        checkedOff: v.boolean(),
        photoStorageId: v.optional(v.id("_storage")),
      })
    ),
    generatedAt: v.number(),
  }).index("by_user_date", ["userId", "date"]),
});
