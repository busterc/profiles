# profiles

## Prepares your mac or linux machine for getting things done!

- Runs on Bash (and installs the latest version on mac)
- Symlinks dotfiles for easy git version control
- Sources aliases, functions, and `~/.env` variables

Secrets stay out of this repo — keep them in `~/.env` and `~/.ssh/`.

## Prerequisites

Before running setup:

- Create a `~/.env` file for local secrets (one `KEY=value` per line), for example:
  ```sh
  HOMEBREW_GITHUB_API_TOKEN=…
  ```
- Add your private SSH key (e.g. `~/.ssh/id_ed25519` or `~/.ssh/id_rsa`) and restrict it:
  ```sh
  chmod 600 ~/.ssh/id_ed25519
  chown "$USER" ~/.ssh/id_ed25519
  ```
  Note: `linux/sources/ssh` currently loads `~/.ssh/id_rsa` — adjust that path if you use Ed25519 on Linux.
- You'll need `sudo`, and you must run setup from `~/.profiles`

## Usage

```sh
git clone git@github.com:busterc/profiles.git ~/.profiles
cd ~/.profiles
./setup.sh <mac|linux>
```

`setup.sh` will:

1. Symlink `x` and platform (`mac` / `linux`) dotfiles into `~/` (backups go under `backup/`)
2. Activate the platform profile via `active/profile`
3. Run platform `installs.sh`, then `x/installs.sh`
4. On mac, run `defaults.sh`
5. Offer to restart so all changes take effect

### After setup (mac)

For optional Homebrew packages and casks:

```sh
./mac/installs_extras.sh
```

## Directory Structure

```sh
.
├── active/          # not committed — symlink to current platform `_profile`
├── backup/          # not committed — timestamped copies of replaced dotfiles
├── linux/           # Linux-specific profile, installs, sources
├── mac/             # macOS-specific profile, installs, defaults, sources
├── x/               # shared (cross-platform) dotfiles, installs, sources
└── setup.sh
```

| Path | Role |
| --- | --- |
| `*/_profile` | Platform or shared aliases/functions entrypoint |
| `*/dotfiles/` | Symlinked to `~/.*` during setup |
| `*/sources/` | Sourced by the matching `_profile` |
| `*/installs.sh` | Tools installed during setup |
| `mac/installs_extras.sh` | Optional mac packages (interactive) |
| `mac/defaults.sh` | macOS system defaults |
| `x/dotfiles/bashrc` | Sources `x/_profile`, `active/profile`, and `~/.env` |
