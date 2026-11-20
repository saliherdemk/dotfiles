export function resetCount(value) {
    return typeof value === "number" && Number.isSafeInteger(value) && value >= 0 ? value : undefined;
}
function expiry(value) {
    const seconds = typeof value === "string" ? Date.parse(value) / 1000 : value;
    return typeof seconds === "number" && Number.isFinite(seconds) && seconds > 0
        && seconds * 1000 <= 8.64e15 ? seconds : undefined;
}
export function parseResetCredits(body, now = Date.now()) {
    if (body === null || typeof body !== "object" || Array.isArray(body))
        return;
    const input = body;
    if (!Array.isArray(input.credits))
        return;
    const credits = [];
    for (const value of input.credits) {
        if (value === null || typeof value !== "object" || typeof value.status !== "string")
            return;
        if (value.status !== "available")
            continue;
        const expiresAt = expiry(value.expires_at);
        if (expiresAt !== undefined && expiresAt * 1000 <= now)
            continue;
        const title = typeof value.title === "string" && value.title.trim() ? value.title : undefined;
        credits.push({
            ...(title === undefined ? {} : { title }),
            ...(expiresAt === undefined ? {} : { expiresAt }),
        });
    }
    credits.sort((a, b) => (a.expiresAt ?? Infinity) - (b.expiresAt ?? Infinity));
    const availableCount = resetCount(input.available_count) ?? credits.length;
    return {
        availableCount,
        detailsStatus: availableCount === credits.length ? "ready" : "unavailable",
        credits,
    };
}
export function formatExpiry(expiresAt, detailed = false) {
    if (expiresAt === undefined)
        return "Expiry unknown";
    return new Date(expiresAt * 1000).toLocaleString(undefined, {
        ...(detailed ? { year: "numeric" } : {}),
        month: "short", day: "numeric", hour: "2-digit", minute: "2-digit",
        ...(detailed ? { timeZoneName: "short" } : {}),
    });
}
