import { internalAction, internalMutation } from "./_generated/server";
import { v } from "convex/values";

// TODO: sendPush — internalAction that sends APNs push via HTTP/2 using .p8 JWT auth
//   - Constructs APNs payload (title, body, sound: "default", badge count)
//   - Signs JWT with team key from env vars
//   - Sends to APNs endpoint

// TODO: scheduleUpcomingNotifications — internalMutation run by cron every 15 min
//   - Queries blocks starting in the next 15 minutes across all users
//   - Schedules sendPush for each via ctx.scheduler.runAt()
