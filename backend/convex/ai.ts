import { internalAction } from "./_generated/server";
import { v } from "convex/values";
import { internal } from "./_generated/api";

// TODO: generatePlan — internalAction that sends audio + prompt to Gemini 2.0 Flash API
//   - Accepts base64 audio and user constraints
//   - Calls Gemini with structured JSON prompt
//   - Parses response into Block[] shape
//   - Saves result via internal dayPlans.savePlan mutation
//   - Rate-limited: max 3 plans/day for free tier users

// TODO: requestPlan — public action that authenticates user, checks rate limit, then schedules generatePlan
