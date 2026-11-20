import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import vm from "node:vm";
import { progressBar, formatReset, parseUsage, lastAssistantWithUsage } from "./usage.js";
import { parseConfig, progressColor } from "./config.js";

const slots = [];
let messages = [];
const state = { status: "ready", subscription: "ChatGPT Plus", now: 0, fiveHour: { remainingPercent: 70, resetsAt: 3600 }, weekly: { remainingPercent: 20 } };
let plugin;
const ctx = {
  options: {},
  client: { rpc: () => ({ read: () => new Promise(() => {}) }) },
  storage: { memory: () => [state, () => {}] },
  data: {
    session: {
      get: () => ({ model: { id: "test", providerID: "openai" } }),
      message: { list: () => messages }
    },
    on: () => () => {},
    location: { default: () => ({}), model: { list: () => [{ id: "test", providerID: "openai", limit: { context: 600000 } }] } }
  },
  theme: { text: { base: "white", muted: "gray" } },
  ui: { slot: slot => { slots.push(slot); return () => {}; } }
};
const sandbox = {
  Plugin: { define: value => { plugin = value; } },
  parseConfig, progressColor, Limits: {}, progressBar, formatReset, lastAssistantWithUsage,
  For: "For", Show: "Show",
  _$createComponent: (component, props) => ({ component, props }),
  _$createElement: type => {
    assert.ok(["box", "text", "b"].includes(type), `Unsupported render element: ${type}`);
    return { children: [] };
  },
  _$createTextNode: text => ({ text }),
  _$insertNode: (element, child) => element.children.push(child),
  _$insert: (element, value) => element.children.push(value),
  _$setProp: (element, key, value) => { element[key] = value; return value; },
  _$effect: callback => callback({}),
  setInterval: () => 0, clearInterval: () => {}, Date, AbortSignal
};
const source = readFileSync(new URL("./tui.js", import.meta.url), "utf8")
  .replace(/^import .*;\n/gm, "")
  .replace("export default Plugin.define", "Plugin.define");
const imports = [...readFileSync(new URL("./tui.js", import.meta.url), "utf8")
  .matchAll(/^import .* from "([^"]+)";$/gm)].map(match => match[1]);
assert.ok(imports.includes("solid-js"), "Use OpenCode's shared Solid runtime");
assert.ok(imports.every(specifier => specifier.startsWith(".") ||
  ["solid-js", "@opencode/plugin/tui", "@opentui/solid"].includes(specifier)),
  "Portable TUI imports must use local files or host-provided runtime specifiers");
vm.runInNewContext(source, sandbox);
const dispose = plugin.setup(ctx);
const contextSlot = slots.find(slot => slot.append === "prompt.footer");
const context = contextSlot.render({ sessionID: "test", mode: "normal" });
assert.equal(context.props.children.children[0](), "");
for (const [count, color] of [
  [100000, "gray"], [100001, "#eab308"], [150000, "#eab308"],
  [150001, "#f97316"], [200000, "#f97316"], [200001, "#ef4444"]
]) {
  messages = [{ type: "assistant", tokens: { input: count - 5000, output: 1000, reasoning: 1000, cache: { read: 2000, write: 1000 } } }];
  const text = context.props.children;
  assert.equal(text.flexGrow, 0);
  assert.equal(text.fg, color, `Context color at ${count}`);
  assert.equal(text.children[0](), `${(count / 1000).toFixed(1)}k (${Math.round(count / 600000 * 100)}%)`);
}
messages.push({ type: "compaction", status: "completed" });
assert.equal(context.props.children.children[0](), "");
const first = { id: "first", type: "assistant", tokens: {} };
const later = { id: "later", type: "assistant", tokens: {} };
assert.equal(lastAssistantWithUsage([first, later], "later"), first);
assert.equal(lastAssistantWithUsage([first], "missing"), undefined);
assert.equal(lastAssistantWithUsage([first, { type: "compaction", status: "running" }]), first);
assert.equal(contextSlot.render({ sessionID: "test", mode: "shell" }).props.when, false);
const footer = slots.findLast(slot => slot.append === "prompt.footer")
  .render({ sessionID: "test", mode: "normal" });
assert.equal(footer.props.when, true);
const bottom = footer.props.children;
assert.equal(bottom.height, 1);
assert.equal(bottom.flexDirection, "row");
const windows = bottom.children;
const window = windows[0].props.children;
assert.equal(window.children[0].children[0](), "5h ");
assert.equal(window.children[3].children[0](), " 70% left");
assert.equal(window.children[1].fg, ctx.theme.text.base);
assert.equal(window.children[2].fg, ctx.theme.text.muted);
const weekly = windows[1].props.children;
assert.equal(weekly.children[1].fg, ctx.theme.text.base);
assert.equal(weekly.children[0].children[0](), " · Weekly ");
assert.equal(bottom.children.length, 3, "Only quota rows and health status; no duplicate context indicator");
const sidebar = slots.find(slot => slot.append === "sidebar.content");
sidebar.render({ sessionID: "another-tab" }).component({ sessionID: "another-tab" });
assert.equal(footer.props.when, true, "Another session's sidebar must not hide this footer");
sidebar.render({ sessionID: "test" }).component({ sessionID: "test" });
assert.equal(footer.props.when, true, "Quota bars remain visible even with this session's sidebar");
state.fiveHour = undefined;
assert.equal(windows[0].props.when, undefined);
assert.equal(weekly.children[0].children[0](), "Weekly ");
ctx.data.session.get = () => ({ model: { providerID: "other" } });
assert.equal(footer.props.when, false);
dispose();
const body = { plan_type: "plus", rate_limit: { primary_window: { limit_window_seconds: 18000, used_percent: 30 } } };
assert.equal(parseUsage(body).subscription, "ChatGPT Plus");
assert.equal(parseUsage({ ...body, plan_type: "unexpected" }).subscription, undefined);
assert.equal(parseUsage({ ...body, plan_type: "pro" }).subscription, "ChatGPT Pro");
console.log("Passed: context thresholds, percentages, compaction, neutral quota bars, and always-visible session footer.");
