#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGENT_SKILL_DIR="${AGENT_SKILL_DIR:-$HOME/.agents/skills/legal-extract}"
CLAUDE_SKILL_DIR="${CLAUDE_SKILL_DIR:-$HOME/.claude/skills/legal-extract}"
CLAUDE_COMMAND_DIR="${CLAUDE_COMMAND_DIR:-$HOME/.claude/commands}"

mkdir -p "$AGENT_SKILL_DIR" "$CLAUDE_COMMAND_DIR" "$(dirname "$CLAUDE_SKILL_DIR")"
cp -R "$ROOT_DIR/skills/legal-extract/." "$AGENT_SKILL_DIR/"
ln -sfn "$AGENT_SKILL_DIR" "$CLAUDE_SKILL_DIR"
cp "$ROOT_DIR/commands/parecer.md" "$CLAUDE_COMMAND_DIR/parecer.md"

echo "Installed legal-extract skill:"
echo "  Agent skill:   $AGENT_SKILL_DIR"
echo "  Claude skill:  $CLAUDE_SKILL_DIR"
echo "  Command:       $CLAUDE_COMMAND_DIR/parecer.md"
echo
echo "Run: /parecer \"path/to/legal.pdf\" --extract-only"
