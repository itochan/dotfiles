# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

itochan's personal dotfiles, managed by [chezmoi](https://www.chezmoi.io/). Files in this repo are *source state*; chezmoi renders them into the home directory. Never edit the rendered files in `$HOME` directly — edit the source here and apply.

## Chezmoi naming conventions (critical)

File and directory names encode chezmoi semantics. Renaming a file changes how it deploys.

- `dot_foo` → `~/.foo`
- `private_foo` → file mode `0600`
- `executable_foo` → file mode `0755`
- `foo.tmpl` → Go-template-rendered before deploy (has access to `.chezmoi.*` vars and `.chezmoidata/*`)
- `encrypted_foo.age` → decrypted with age before deploy; ciphertext is what's committed
- Prefixes stack, e.g. `private_dot_ssh/encrypted_home_config.age` → `~/.ssh/home_config` mode 600, decrypted from age

When adding a new dotfile, pick the prefix combination intentionally — chezmoi will refuse to apply if a target already exists and conflicts.

## Common commands

```sh
chezmoi diff                 # preview what would change in $HOME
chezmoi apply -v             # render templates + decrypt + write to $HOME
chezmoi apply <target> -v    # apply a single file/dir, e.g. ~/.zshrc
chezmoi edit <target>        # edit the source for a deployed file
chezmoi cd                   # cd into this repo
chezmoi execute-template < file.tmpl   # render a template to stdout for debugging
chezmoi data                 # dump the template data context (incl. .chezmoidata/*)
chezmoi managed              # list every path chezmoi manages
chezmoi re-add               # pull current $HOME state back into source (rare)
```

For age-encrypted files: `chezmoi encrypt <path>` / `chezmoi decrypt <path>`. The identity key lives at `key.txt` in the source root and is excluded from both `.gitignore` and `.chezmoiignore`.

## Encryption

`.chezmoiignore` excludes `key.txt` and `README.md` from being applied. `.gitignore` excludes `key.txt` and `.chezmoidata/git.yaml` (the latter holds private org/repo lists used by `dot_config/git/config.d/user.tmpl`).

Encryption is configured in `dot_config/chezmoi/chezmoi.toml.tmpl` (age, recipient `age1k8ufjmal2...`). Don't commit plaintext of any `encrypted_*.age` file.

## Template data and per-org identity

`.chezmoidata/git.yaml` (gitignored) holds a map of `owner → [repos]`. `dot_config/git/config.d/user.tmpl` iterates that map to emit `[includeIf "gitdir:~/src/github.com/<repo>/"]` blocks, each pointing at a per-org identity file (e.g. `dot_config/git/config.d/ivry`, `cyberagent`). To add a new org identity:

1. Create `dot_config/git/config.d/<owner>` with `[user] name/email`.
2. Add the `owner: [repos]` entry to `.chezmoidata/git.yaml`.
3. `chezmoi apply` regenerates `~/.config/git/config.d/user` with the new `includeIf` blocks.

Ghq roots are `~/go/src` and `~/src` — repos cloned via `ghq get` land at `~/src/github.com/<owner>/<repo>` which is what the `includeIf` patterns expect.

## Toolchain manager

`mise` (`dot_config/mise/config.toml`) is the canonical source for runtimes and CLI tools — Go, Node, Ruby, Python, Flutter, terraform, gcloud, chezmoi itself, etc. Recent migration moved most tooling from Homebrew to mise; prefer adding new tools to `config.toml` over `dot_Brewfile`. Homebrew is reserved for GUI casks, macOS-specific system utilities, and a handful of legacy CLIs.

## Shell config layout

`dot_zshrc` is the small entrypoint; it sources, in order:

- `~/.zshrc_external` — third-party manager hooks (mise, starship, etc.)
- `~/.zshrc_alias`
- `~/.zshrc_$(uname)` — `dot_zshrc_Darwin` or `dot_zshrc_Linux`

When adding OS-specific shell config, put it in the matching `dot_zshrc_<OS>` file rather than guarding inside `dot_zshrc`.

## Commit style

Conventional Commits in English, scoped by area (`feat(mise):`, `feat(zsh):`, `feat(claude):`, `refactor(zsh):`). Keep changes focused per commit — the log is granular (one tool added, one config tweak).
