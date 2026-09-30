# Agent skills

Skills are installed user-wide in `~/.agents/skills`. `home/agents.nix` links `~/.codex/skills` and `~/.claude/skills` to that directory, and links `~/skills-lock.json` to this repo's `skills-lock.json`. Every agent sees the same set from any directory.

## Installing a published skill

Run the skills CLI from `$HOME`:

```sh
cd ~ && npx -y skills add <owner>/<repo> --skill <name> -y
```

- `--list` shows a repo's skills; `--skill '*'` installs all of them.
- The CLI records the skill in `skills-lock.json` here, through the `~/skills-lock.json` link. Commit that lock change.
- Running the CLI from this repo installs into `./.agents/skills` and `./.claude/skills`, which only agents working in this repo see. Always `cd ~` first.
- Remove with `cd ~ && npx -y skills remove <name> -y`.
- On a fresh machine, restore everything in the lock with `cd ~ && npx -y skills experimental_install -y`.

## Adding a local skill

Put self-authored skills in `files/skills/<name>/SKILL.md`. Home Manager links each one into `~/.agents/skills`, so a new skill appears after `sudo darwin-rebuild switch --flake ~/.config/nixpkgs`. Edits to an existing local skill are live immediately.

A name cannot be both local and in `skills-lock.json`; the build fails on the collision.

## Verifying

Run an agent from an unrelated directory and ask for its skill list:

```sh
cd "$(mktemp -d)" && fx ask 'List every skill in your available_skills list. Do not use any tools.'
```
