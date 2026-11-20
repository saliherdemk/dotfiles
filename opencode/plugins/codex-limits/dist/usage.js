import { resetCount } from "./resets.js";
const FIVE_HOURS = 5 * 60 * 60;
const WEEK = 7 * 24 * 60 * 60;
// Match OpenCode's current-context boundary, excluding completed compactions and reverted messages.
export function lastAssistantWithUsage(messages, boundary) {
    const boundaryIndex = boundary ? messages.findIndex(message => message.id === boundary) : -1;
    if (boundary && boundaryIndex === -1) return undefined;
    const end = boundaryIndex === -1 ? messages.length : boundaryIndex;
    const compactionIndex = messages.findLastIndex((message, index) =>
        message.type === "compaction" && message.status === "completed" && index < end);
    return messages.findLast((message, index) =>
        message.type === "assistant" && message.tokens !== undefined && index > compactionIndex && index < end);
}
function record(value) {
    return value !== null && typeof value === "object" && !Array.isArray(value)
        ? value
        : undefined;
}
function windowFrom(value) {
    const input = record(value);
    if (!input)
        return;
    const duration = input.limit_window_seconds;
    const used = input.used_percent;
    if (typeof duration !== "number" || !Number.isFinite(duration))
        return;
    if (typeof used !== "number" || !Number.isFinite(used))
        return;
    const reset = input.reset_at;
    return {
        duration,
        window: {
            remainingPercent: Math.max(0, Math.min(100, 100 - used)),
            ...(typeof reset === "number" && Number.isSafeInteger(reset) && reset > 0
                ? { resetsAt: reset }
                : {}),
        },
    };
}
export function parseUsage(body, checkedAt = Date.now()) {
    const rateLimit = record(record(body)?.rate_limit);
    if (!rateLimit)
        return;
    const snapshot = { checkedAt };
    const plans = { free: "Free", go: "Go", plus: "Plus", pro: "Pro", team: "Team", business: "Business", enterprise: "Enterprise", edu: "Edu" };
    const plan = record(body)?.plan_type;
    if (typeof plan === "string" && Object.hasOwn(plans, plan))
        snapshot.subscription = `ChatGPT ${plans[plan]}`;
    const availableCount = resetCount(record(record(body)?.rate_limit_reset_credits)?.available_count);
    if (availableCount !== undefined) {
        snapshot.bankedResets = { availableCount, detailsStatus: availableCount === 0 ? "ready" : "unavailable" };
    }
    for (const value of [rateLimit.primary_window, rateLimit.secondary_window]) {
        const entry = windowFrom(value);
        if (entry?.duration === FIVE_HOURS)
            snapshot.fiveHour = entry.window;
        if (entry?.duration === WEEK)
            snapshot.weekly = entry.window;
    }
    if (!snapshot.fiveHour && !snapshot.weekly)
        return;
    return snapshot;
}
export function formatReset(resetsAt, now = Date.now(), compact = false) {
    if (resetsAt === undefined)
        return compact ? "unknown" : "reset time unavailable";
    const remaining = Math.max(0, resetsAt * 1000 - now);
    if (remaining === 0)
        return compact ? "due" : "reset due; refreshing soon";
    const minutes = Math.ceil(remaining / 60_000);
    const days = Math.floor(minutes / 1440);
    const hours = Math.floor((minutes % 1440) / 60);
    const mins = minutes % 60;
    if (compact)
        return days ? `${days}d ${hours}h ${String(mins).padStart(2, "0")}m` : hours ? `${hours}h ${String(mins).padStart(2, "0")}m` : `${mins}m`;
    const countdown = days ? `${days}d ${hours}h` : hours ? `${hours}h ${mins}m` : `${mins}m`;
    return `resets in ${countdown}`;
}
export function progressBar(remainingPercent, width = 20) {
    const safeWidth = Math.max(1, Math.floor(width));
    const percent = Math.max(0, Math.min(100, remainingPercent));
    const filled = Math.round((percent / 100) * safeWidth);
    return { filled: "█".repeat(filled), empty: "░".repeat(safeWidth - filled) };
}
