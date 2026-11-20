# Local quota and context display

Customized from @yassirh/opencode-codex-limits-plugin 0.1.1:
https://github.com/yassirh/opencode-codex-limits-plugin

OpenCode automatically discovers this folder under its global config directory.
No npm quota plugin entry, build step, cache path, or absolute path is needed.
OpenCode supplies the plugin and TUI runtime imports.

Keep this entire folder, including `package.json`, and `../../cli.json` in the
dotfiles repo. Copy them to another PC's OpenCode config directory. Use
OpenCode V2 and connect OpenAI through ChatGPT OAuth on that PC. Do not copy
credentials between PCs.

`cli.json` disables `opencode.prompt.footer`, replacing the built-in context,
command, cost, and background-task hints with the custom context indicator.

Behavior:
- Sidebar: quota bars, percentage left, and reset countdowns below the bars.
- All window sizes: one-line neutral quota bars, without reset times.
- Context immediately before the quota bars: yellow above 100k, orange above
  150k, red above 200k; otherwise muted.
- Context remains visible when the sidebar is open.

Run checks with `npm test` from this folder.
Local files are not replaced by `opencode plugin update`. Future OpenCode API
changes may require updating them manually.
