# Changelog

All notable changes to coding-assistant are recorded here. Format
follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions are **retro-fitted** from commit history; dates are
ballpark, grouped by milestone rather than per-commit.

## [Unreleased]

### Infrastructure
- Root `package.json` added (private; metadata only — this is a
  shell project, package.json exists for the version badge).
- Root `README.md` added (brief intro + badges + pointer to
  `docs/README.md` where the full documentation lives after the
  Jan reorg).
- README badges (version + license, plato-style #2a4f8c).

## [0.3.0] — 2026-04-28

Relicensed **MIT → Apache 2.0** to match the rest of the portfolio.
Minor `server.sh` polish: explicit Ctrl+C handling for clean exit.

### Changed
- License: MIT → Apache 2.0.
- `server.sh`: Ctrl+C exits cleanly.

## [0.2.0] — 2026-01-25

Quantization tuning exposed: pick a quantization level per model
and find alternative models at different quantization levels
without leaving the configuration flow.

### Added
- Quantization-level configuration as a tuning option.
- Docs on how to find alternative models / quant levels.

## [0.1.0] — 2026-01-23

**Initial release.** Minimal local coding assistant built on
`llama.cpp`: model download, terminal chat, OpenAI-compatible
API server, OpenCode / Droid integration, performance tuning,
per-model chat templates.

### Added
- `setup.sh` — one-time `llama.cpp` build (includes the CMake-
  migration build fix).
- `download-model.sh` — model download with `models.conf` index
  (qwen2.5-coder-7b, qwen2.5-coder-3b, others).
- `chat.sh` — interactive terminal chat
  (`--conversation` flag is default; redundant flag dropped).
- `server.sh` — OpenAI-compatible API server on
  `127.0.0.1:8080`. Ctrl+C handling, model-mismatch detection,
  chat-template per model.
- `config.sh` — `ACTIVE_MODEL` switch + tuning parameters.
- `models.conf` — per-model config + chat templates.
- `test-model.sh` — model sanity check.
- `docs/CLI_TOOLS_SETUP.md` — OpenCode + Droid integration
  guide. Droid config path: `~/.factory` (not `~/.config/droid`).
  **Caveat:** Droid doesn't work with local models — documented.
- `docs/PERFORMANCE_TUNING.md` — comprehensive perf guide.
- `docs/SWITCHING_MODELS.md` — simplified switching workflow
  (no more OpenCode config edits required).
- `docs/QUICKSTART.md`, `docs/COMMANDS.txt`.

### Changed
- Documentation moved from repo root to `docs/` folder.
- `chat.sh` simplified to interactive-only mode.

### Fixed
- Server exit on Ctrl+C; chat template and model-mismatch issues
  in `server.sh`.
