#!/bin/bash
# Claude Code Configuration Installer
# Copies config files to ~/.claude/ and replaces path placeholders

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_DIR="$SCRIPT_DIR/config"
TARGET_DIR="$HOME/.claude"

echo "Claude Code Configuration Installer"
echo "===================================="
echo ""
echo "Source:  $CONFIG_DIR"
echo "Target:  $TARGET_DIR"
echo ""

# Check if target already exists
if [ -d "$TARGET_DIR" ]; then
  echo "WARNING: $TARGET_DIR already exists."
  echo "This installer will MERGE files (existing files will be overwritten)."
  read -p "Continue? (y/N) " -n 1 -r
  echo ""
  [[ $REPLY =~ ^[Yy]$ ]] || { echo "Aborted."; exit 1; }
fi

# Create directory structure
echo "Creating directory structure..."
mkdir -p "$TARGET_DIR"/{agents,commands,hooks,rules/common,rules/typescript,skills,state,routing-logs}

# Copy config files
echo "Copying configuration files..."
cp "$CONFIG_DIR/CLAUDE.md" "$TARGET_DIR/"
cp "$CONFIG_DIR/enforce.md" "$TARGET_DIR/"
cp "$CONFIG_DIR/model-routing.json" "$TARGET_DIR/"
cp "$CONFIG_DIR/gitignore" "$TARGET_DIR/.gitignore"

# Copy settings.json with path replacement
echo "Installing settings.json (replacing __HOME__ with $HOME)..."
sed "s|__HOME__|$HOME|g" "$CONFIG_DIR/settings.json" > "$TARGET_DIR/settings.json"

# Copy agents
echo "Installing agents..."
cp "$CONFIG_DIR/agents/"*.md "$TARGET_DIR/agents/"

# Copy commands
echo "Installing commands..."
cp "$CONFIG_DIR/commands/"*.md "$TARGET_DIR/commands/"

# Copy hooks with path replacement and make executable
echo "Installing hooks (replacing __HOME__ with $HOME)..."
for hook in "$CONFIG_DIR/hooks/"*.sh; do
  sed "s|__HOME__|$HOME|g" "$hook" > "$TARGET_DIR/hooks/$(basename "$hook")"
done
chmod +x "$TARGET_DIR/hooks/"*.sh

# Copy rules
echo "Installing rules..."
cp "$CONFIG_DIR/rules/common/"*.md "$TARGET_DIR/rules/common/"
cp "$CONFIG_DIR/rules/typescript/"*.md "$TARGET_DIR/rules/typescript/"

# Copy custom skills
echo "Installing custom skills..."
for skill_dir in "$CONFIG_DIR/skills"/*/; do
  skill_name=$(basename "$skill_dir")
  mkdir -p "$TARGET_DIR/skills/$skill_name"
  cp -r "$skill_dir"* "$TARGET_DIR/skills/$skill_name/" 2>/dev/null || true
done

echo ""
echo "Installation complete!"
echo ""
echo "Next steps:"
echo "  1. Edit ~/.claude/CLAUDE.md — set your name and language"
echo "  2. Run 'claude' to start a session"
echo "  3. Optional: install third-party skills (see README.md)"
echo ""
echo "Optional skill packs:"
echo "  # Anthropic official document skills"
echo "  git clone --depth 1 https://github.com/anthropics/skills.git /tmp/anthropic-skills"
echo "  for s in pdf docx xlsx pptx doc-coauthoring canvas-design web-artifacts-builder brand-guidelines algorithmic-art theme-factory mcp-builder webapp-testing; do"
echo "    cp -r /tmp/anthropic-skills/skills/\$s ~/.claude/skills/"
echo "  done"
echo ""
echo "  # Marketing skills (33 skills)"
echo "  git clone --depth 1 https://github.com/coreyhaines31/marketingskills.git /tmp/marketing-skills"
echo "  cp -r /tmp/marketing-skills/skills/*/ ~/.claude/skills/"
echo ""
echo "  # SEO skills (13 skills)"
echo "  git clone --depth 1 https://github.com/AgriciDaniel/claude-seo.git /tmp/claude-seo"
echo "  cp -r /tmp/claude-seo/skills/*/ ~/.claude/skills/"
echo ""
echo "  # Deep research skill"
echo "  git clone --depth 1 https://github.com/199-biotechnologies/claude-deep-research-skill.git /tmp/deep-research"
echo "  mkdir -p ~/.claude/skills/deep-research"
echo "  cp -r /tmp/deep-research/{SKILL.md,reference,templates,scripts} ~/.claude/skills/deep-research/"
