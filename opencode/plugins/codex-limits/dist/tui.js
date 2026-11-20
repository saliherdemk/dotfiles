import { createComponent as _$createComponent } from "@opentui/solid";
import { memo as _$memo } from "@opentui/solid";
import { effect as _$effect } from "@opentui/solid";
import { createTextNode as _$createTextNode } from "@opentui/solid";
import { insertNode as _$insertNode } from "@opentui/solid";
import { insert as _$insert } from "@opentui/solid";
import { setProp as _$setProp } from "@opentui/solid";
import { createElement as _$createElement } from "@opentui/solid";
import { Plugin } from "@opencode/plugin/tui";
import { For, Show } from "solid-js";
import { parseConfig, progressColor } from "./config.js";
import { Limits } from "./rpc.js";
import { formatExpiry } from "./resets.js";
import { formatReset, progressBar, lastAssistantWithUsage } from "./usage.js";
export default Plugin.define({
  id: "codex-limits.tui",
  setup(ctx) {
    const config = parseConfig(ctx.options);
    const rpc = ctx.client.rpc(Limits);
    const [limits, updateLimits] = ctx.storage.memory("limits", {
      initial: {
        status: "loading",
        now: Date.now(),
        bankedExpanded: true
      }
    });
    let running = false;
    let rerun = false;
    let disposed = false;
    function toggleBankedResets() {
      updateLimits(draft => {
        draft.bankedExpanded = draft.bankedExpanded === false;
      });
    }
    async function refresh(force = false) {
      if (running) {
        if (force) rerun = true;
        return;
      }
      running = true;
      try {
        const result = await rpc.read({
          refresh: force
        }, {
          location: ctx.location ?? ctx.data.location.default(),
          signal: AbortSignal.timeout(10_000)
        });
        if (!disposed) {
          const next = result;
          updateLimits(draft => {
            draft.status = next.status;
            draft.fiveHour = next.fiveHour;
            draft.weekly = next.weekly;
            draft.subscription = next.subscription;
            draft.bankedResets = next.bankedResets;
            draft.checkedAt = next.checkedAt;
            draft.message = next.message;
            draft.config = next.config;
            draft.now = Date.now();
          });
        }
      } catch {
        if (!disposed) updateLimits(draft => {
          draft.status = draft.fiveHour || draft.weekly ? "stale" : "unavailable";
          draft.message = "OpenCode service unavailable";
        });
      } finally {
        running = false;
        if (rerun && !disposed) {
          rerun = false;
          void refresh(true);
        }
      }
    }
    function WindowLine(props) {
      const barWidth = 15;
      const bar = () => progressBar(props.value?.remainingPercent ?? 0, barWidth);
      const barColor = () => progressColor(props.value?.remainingPercent ?? 0, limits.config ?? config);
      return (() => {
        const container = _$createElement("box");
        const reset = _$createElement("text");
        _$setProp(container, "flexDirection", "column");
        _$setProp(container, "width", "100%");
        _$setProp(reset, "textAlign", "right");
        _$insert(reset, () => `Resets in ${formatReset(props.value?.resetsAt, limits.now, true)}`);
        var _el$ = _$createElement("box"),
          _el$2 = _$createElement("text"),
          _el$3 = _$createElement("box"),
          _el$4 = _$createElement("text"),
          _el$5 = _$createTextNode(` `),
          _el$6 = _$createElement("box"),
          _el$7 = _$createElement("text"),
          _el$8 = _$createElement("text");
        _$insertNode(_el$, _el$2);
        _$insertNode(_el$, _el$3);
        _$setProp(_el$, "flexDirection", "row");
        _$setProp(_el$, "width", "100%");
        _$setProp(_el$, "justifyContent", "space-between");
        _$setProp(_el$2, "flexShrink", 0);
        _$insert(_el$2, () => props.label);
        _$insertNode(_el$3, _el$4);
        _$insertNode(_el$3, _el$6);
        _$setProp(_el$3, "flexDirection", "row");
        _$setProp(_el$3, "flexGrow", 1);
        _$setProp(_el$3, "flexShrink", 1);
        _$setProp(_el$3, "minWidth", 0);
        _$setProp(_el$3, "justifyContent", "flex-end");
        _$insertNode(_el$4, _el$5);
        _$insert(_el$4, () => `${Math.round(props.value?.remainingPercent ?? 0)}% left`, _el$5);
        _$insertNode(_el$6, _el$7);
        _$insertNode(_el$6, _el$8);
        _$setProp(_el$6, "flexDirection", "row");
         _$setProp(_el$6, "width", barWidth);
        _$setProp(_el$6, "flexShrink", 0);
        _$setProp(_el$7, "flexShrink", 0);
        _$insert(_el$7, () => bar().filled);
        _$setProp(_el$8, "flexShrink", 0);
        _$insert(_el$8, () => bar().empty);
        _$effect(_p$ => {
          var _v$ = props.value !== undefined,
            _v$2 = ctx.theme.text.base,
            _v$3 = ctx.theme.text.base,
            _v$4 = barColor(),
            _v$5 = bar().filled.length,
            _v$6 = ctx.theme.text.muted,
            _v$7 = bar().empty.length;
          _v$ !== _p$.e && (_p$.e = _$setProp(container, "visible", _v$, _p$.e));
          _$setProp(reset, "fg", ctx.theme.text.muted);
          _v$2 !== _p$.t && (_p$.t = _$setProp(_el$2, "fg", _v$2, _p$.t));
          _v$3 !== _p$.a && (_p$.a = _$setProp(_el$4, "fg", _v$3, _p$.a));
          _v$4 !== _p$.o && (_p$.o = _$setProp(_el$7, "fg", _v$4, _p$.o));
          _v$5 !== _p$.i && (_p$.i = _$setProp(_el$7, "width", _v$5, _p$.i));
          _v$6 !== _p$.n && (_p$.n = _$setProp(_el$8, "fg", _v$6, _p$.n));
          _v$7 !== _p$.s && (_p$.s = _$setProp(_el$8, "width", _v$7, _p$.s));
          return _p$;
        }, {
          e: undefined,
          t: undefined,
          a: undefined,
          o: undefined,
          i: undefined,
          n: undefined,
          s: undefined
        });
        _$insertNode(container, _el$);
        _$insertNode(container, reset);
        return container;
      })();
    }
    function Sidebar(props) {
      if (ctx.data.session.get(props.sessionID)?.model?.providerID !== "openai") return null;
      return (() => {
        var _el$9 = _$createElement("box"),
          _el$0 = _$createElement("text"),
          _el$1 = _$createElement("b");
        _$insertNode(_el$9, _el$0);
        _$setProp(_el$9, "flexDirection", "column");
        _$setProp(_el$9, "gap", 1);
        _$insertNode(_el$0, _el$1);
        _$insertNode(_el$1, _$createTextNode("Limits"));
        _$insert(_el$0, () => limits.status === "stale" ? " (stale)" : "", null);
        _$insert(_el$9, _$createComponent(WindowLine, {
          label: "5h",
          get value() {
            return limits.fiveHour;
          }
        }), null);
        _$insert(_el$9, _$createComponent(WindowLine, {
          label: "Weekly",
          get value() {
            return limits.weekly;
          }
        }), null);
        _$insert(_el$9, _$createComponent(Show, {
          get when() {
            return limits.bankedResets;
          },
          children: resets => (() => {
            var _el$12 = _$createElement("box"),
              _el$13 = _$createElement("box"),
              _el$14 = _$createElement("text"),
              _el$15 = _$createTextNode(` Available resets (`),
              _el$16 = _$createTextNode(`)`),
              _el$17 = _$createElement("box");
            _$insertNode(_el$12, _el$13);
            _$insertNode(_el$12, _el$17);
            _$setProp(_el$12, "flexDirection", "column");
            _$insertNode(_el$13, _el$14);
            _$setProp(_el$13, "onMouseUp", event => {
              if (event.button !== 0) return;
              event.stopPropagation();
              toggleBankedResets();
            });
            _$insertNode(_el$14, _el$15);
            _$insertNode(_el$14, _el$16);
            _$setProp(_el$14, "selectable", false);
            _$insert(_el$14, () => limits.bankedExpanded !== false ? "▾" : "▸", _el$15);
            _$insert(_el$14, () => resets().availableCount ?? "Unknown", _el$16);
            _$setProp(_el$17, "flexDirection", "column");
            _$setProp(_el$17, "paddingLeft", 2);
            _$insert(_el$17, _$createComponent(For, {
              get each() {
                return resets().credits;
              },
              children: credit => (() => {
                var _el$22 = _$createElement("box"),
                  _el$25 = _$createElement("text");
                _$insertNode(_el$22, _el$25);
                _$setProp(_el$22, "flexDirection", "column");
                _$insert(_el$22, _$createComponent(Show, {
                  get when() {
                    return credit.title;
                  },
                  get children() {
                    var _el$23 = _$createElement("text"),
                      _el$24 = _$createTextNode(`• `);
                    _$insertNode(_el$23, _el$24);
                    _$insert(_el$23, () => credit.title, null);
                    _$effect(_$p => _$setProp(_el$23, "fg", ctx.theme.text.base, _$p));
                    return _el$23;
                  }
                }), _el$25);
                _$insert(_el$25, () => credit.title ? "  " : "• ", null);
                _$insert(_el$25, () => formatExpiry(credit.expiresAt), null);
                _$effect(_$p => _$setProp(_el$25, "fg", ctx.theme.text.muted, _$p));
                return _el$22;
              })()
            }), null);
            _$insert(_el$17, _$createComponent(Show, {
              get when() {
                return resets().availableCount === 0;
              },
              get children() {
                var _el$18 = _$createElement("text");
                _$insertNode(_el$18, _$createTextNode(`No available resets`));
                _$effect(_$p => _$setProp(_el$18, "fg", ctx.theme.text.muted, _$p));
                return _el$18;
              }
            }), null);
            _$insert(_el$17, _$createComponent(Show, {
              get when() {
                return resets().detailsStatus === "unavailable";
              },
              get children() {
                var _el$20 = _$createElement("text");
                _$insertNode(_el$20, _$createTextNode(`Reset details unavailable`));
                _$effect(_$p => _$setProp(_el$20, "fg", ctx.theme.text.muted, _$p));
                return _el$20;
              }
            }), null);
            _$effect(_p$ => {
              var _v$8 = ctx.theme.text.base,
                _v$9 = limits.bankedExpanded !== false;
              _v$8 !== _p$.e && (_p$.e = _$setProp(_el$14, "fg", _v$8, _p$.e));
              _v$9 !== _p$.t && (_p$.t = _$setProp(_el$17, "visible", _v$9, _p$.t));
              return _p$;
            }, {
              e: undefined,
              t: undefined
            });
            return _el$12;
          })()
        }), null);
        _$insert(_el$9, _$createComponent(Show, {
          get when() {
            return _$memo(() => !!!limits.fiveHour)() && !limits.weekly;
          },
          get children() {
            var _el$11 = _$createElement("text");
            _$insert(_el$11, () => limits.message ?? "Loading…");
            _$effect(_$p => _$setProp(_el$11, "fg", ctx.theme.text.muted, _$p));
            return _el$11;
          }
        }), null);
        _$effect(_$p => _$setProp(_el$0, "fg", ctx.theme.text.base, _$p));
        return _el$9;
      })();
    }
    const removeSlot = ctx.ui.slot({
      append: "sidebar.content",
      render: ({
        sessionID
      }) => _$createComponent(Sidebar, {
        sessionID: sessionID
      })
    });
    const contextSlot = {
      append: "prompt.footer",
      render: props => _$createComponent(Show, {
        get when() { return props.sessionID && props.mode === "normal"; },
        get children() {
          const text = _$createElement("text");
          const usage = () => {
            const session = ctx.data.session.get(props.sessionID);
            const message = lastAssistantWithUsage(ctx.data.session.message.list(props.sessionID), session?.revert?.messageID);
            if (!message) return undefined;
            const tokens = message.tokens;
            const count = tokens.input + tokens.output + tokens.reasoning + tokens.cache.read + tokens.cache.write;
            const selected = message.model ?? session?.model;
            const model = ctx.data.location.model.list(session?.location)?.find(model =>
              model.id === selected?.id && model.providerID === selected?.providerID);
            return { count, percent: model?.limit.context > 0 ? Math.round(count / model.limit.context * 100) : undefined };
          };
          _$setProp(text, "wrapMode", "none");
          _$setProp(text, "flexShrink", 0);
          _$setProp(text, "flexGrow", 0);
          _$insert(text, () => {
            const value = usage();
            if (!value) return "";
            return `${(value.count / 1000).toFixed(1)}k${value.percent === undefined ? "" : ` (${value.percent}%)`}`;
          });
          _$effect(previous => {
            const count = usage()?.count ?? 0;
            return _$setProp(text, "fg", count > 200000 ? "#ef4444" : count > 150000 ? "#f97316" : count > 100000 ? "#eab308" : ctx.theme.text.muted, previous);
          });
          return text;
        }
      })
    };
    const removeContext = ctx.ui.slot(contextSlot);
    const removeBottomBar = ctx.ui.slot({
      append: "prompt.footer",
      render: props => _$createComponent(Show, {
        get when() {
          return props.sessionID && props.mode === "normal" &&
            ctx.data.session.get(props.sessionID)?.model?.providerID === "openai";
        },
        get children() {
          const text = _$createElement("box");
          _$setProp(text, "flexDirection", "row");
          _$setProp(text, "height", 1);
          _$setProp(text, "flexShrink", 0);
          for (const [label, key] of [["5h", "fiveHour"], ["Weekly", "weekly"]]) {
            _$insert(text, _$createComponent(Show, {
              get when() { return limits[key]; },
              get children() {
                const span = _$createElement("box");
                const name = _$createElement("text");
                const filled = _$createElement("text");
                const empty = _$createElement("text");
                const detail = _$createElement("text");
                _$setProp(span, "flexDirection", "row");
                _$setProp(span, "flexShrink", 0);
                for (const element of [name, filled, empty, detail]) {
                  _$setProp(element, "wrapMode", "none");
                  _$setProp(element, "flexShrink", 0);
                }
                _$insert(name, () => `${key === "weekly" && limits.fiveHour ? " · " : ""}${label} `);
                _$insert(filled, () => progressBar(limits[key]?.remainingPercent ?? 0, 6).filled);
                _$insert(empty, () => progressBar(limits[key]?.remainingPercent ?? 0, 6).empty);
                _$effect(previous => _$setProp(filled, "fg", ctx.theme.text.base, previous));
                _$effect(previous => _$setProp(empty, "fg", ctx.theme.text.muted, previous));
                _$effect(previous => _$setProp(name, "fg", ctx.theme.text.base, previous));
                _$effect(previous => _$setProp(detail, "fg", ctx.theme.text.base, previous));
                _$insertNode(span, name);
                _$insertNode(span, filled);
                _$insertNode(span, empty);
                _$insert(detail, () => ` ${Math.round(limits[key]?.remainingPercent ?? 0)}% left`);
                _$insertNode(span, detail);
                return span;
              }
            }));
          }
          const status = _$createElement("text");
          _$setProp(status, "wrapMode", "none");
          _$insert(status, () => !limits.fiveHour && !limits.weekly ? limits.message ?? "Loading…" : limits.status === "stale" ? " (stale)" : "");
          _$effect(previous => _$setProp(status, "fg", ctx.theme.text.muted, previous));
          _$insertNode(text, status);
          return text;
        }
      })
    });
    const removeCommand = ctx.ui.slot({
      append: "app",
      render: () => {
        ctx.keymap.layer(() => ({
          mode: "global",
          commands: [{
            id: "codex-limits.refresh",
            title: "Refresh Codex limits",
            group: "Codex",
            palette: true,
            run: () => refresh(true)
          }, {
            id: "codex-limits.toggle-banked-resets",
            title: "Toggle Codex available resets",
            group: "Codex",
            palette: true,
            run: toggleBankedResets
          }, {
            id: "codex-limits.reset-details",
            title: "Show Codex reset details",
            group: "Codex",
            palette: true,
            run: async () => {
              await refresh(true);
              const resets = limits.bankedResets;
              const lines = [`Available resets: ${resets?.availableCount ?? "Unknown"}`];
              if (limits.status === "stale") lines.push("Last successful snapshot; data may be stale.");
              if (!resets || resets.detailsStatus === "unavailable") lines.push("Reset details unavailable or incomplete.");
              for (const [index, credit] of (resets?.credits ?? []).entries()) {
                if (credit.title) {
                  lines.push(`${index + 1}. ${credit.title}`);
                  lines.push(`   ${formatExpiry(credit.expiresAt, true)}`);
                } else {
                  lines.push(`${index + 1}. ${formatExpiry(credit.expiresAt, true)}`);
                }
                if (credit.expiresAt !== undefined) {
                  lines.push(`   ${credit.expiresAt * 1000 <= limits.now ? "Expired" : `Expires in ${formatReset(credit.expiresAt, limits.now, true)}`}`);
                }
              }
              await ctx.ui.dialog.alert({
                title: "Codex available resets",
                message: lines.join("\n")
              });
            }
          }]
        }));
        return null;
      }
    });
    const stopExecution = ctx.data.on("session.execution.succeeded", event => {
      if (ctx.data.session.get(event.data.sessionID)?.model?.providerID !== "openai") return;
      void refresh(true);
    });
    const stopSwitch = ctx.data.on("credential.switched", event => {
      if (event.data.integrationID !== "openai") return;
      updateLimits(draft => {
        draft.status = "loading";
        draft.fiveHour = undefined;
        draft.weekly = undefined;
        draft.subscription = undefined;
        draft.bankedResets = undefined;
        draft.message = undefined;
      });
      void refresh(true);
    });
    // This is intentionally independent of the active route: some TUI routes
    // do not report themselves as session routes while the sidebar is visible.
    const poll = setInterval(() => void refresh(true), 90_000);
    const clock = setInterval(() => updateLimits(draft => {
      draft.now = Date.now();
    }), 60_000);
    // Fetch at startup instead of waiting for a session-slot render effect.
    // This keeps the status available when the sidebar mounts after setup.
    void refresh();
    return () => {
      disposed = true;
      clearInterval(poll);
      clearInterval(clock);
      stopSwitch();
      stopExecution();
      removeSlot();
      removeBottomBar();
      removeContext();
      removeCommand();
    };
  }
});
