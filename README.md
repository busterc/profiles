# profiles

## Prepares your mac or linux machine for getting things done!

- Runs on Bash (and installs latest version)
- Symlinks dotfiles for easy git version control
- Sources aliases, functions and .env variables

## Prerequisites

Before running the automated goodness, do a couple of small manual tasks:

- Add a `~/.env` file with helpful secrets like `HOMEBREW_GITHUB_API_TOKEN`
- Add your private SSH key `~/.ssh/id_rsa` and restrict it:
  ```sh
  $ chmod 600 ~/.ssh/id_rsa
  $ chown $USER ~/.ssh/id_rsa
  ```

## Usage

__Recommended:__ before running, add a `~/.env` file with helpful secrets like `HOMEBREW_GITHUB_API_TOKEN`

```sh
$ git clone https://github.com/busterc/profiles.git ~/.profiles
$ cd ~/.profiles
$ ./setup.sh <mac|linux>
```

## Directory Structure

### Top Level

```sh
.
├── active (not git committed, holds a symlink of your current profile)
├── backup (not git committed, holds backup copies of any replaced dotfiles)
├── linux (all your linux specifics)
├── mac (all your macOS specifics)
└── x (all your universal specfiics)
```

### Tree View

```sh
.
├── active
│   └── profile (symlinks to ~/.profiles/<mac|linux>/_profile)
├── backup
│   └── * ("YYYY-MM-DD-HHmmss" folders hold copies of any replaced dotfiles)
├── linux
│   ├── _profile (linux compatible aliases and functions)
│   ├── dotfiles (symlinks files to ~/.* on linux during setup)
│   │   ├── gitignore_global
│   │   └── *
│   ├── installs.sh (runs during setup)
│   └── sources (files with aliases and functions, sourced by linux/_profile)
│       └── *
├── mac
│   ├── _profile (macOS compatible aliases and functions)
│   ├── defaults.sh (sets macOS system defaults during setup)
│   ├── dotfiles (symlinks files to ~/.* on mac setup)
│   │   ├── gitignore_global
│   │   └── *
│   ├── installs_extras.sh (can be run manually for more common goodies)
│   ├── installs.sh (runs during setup)
│   └── sources (files with aliases and functions, sourced by mac/_profile)
│       └── *
└── x
    ├── _profile (universally compatible aliases and functions)
    ├── dotfiles (symlinks files to ~/.* on all systems during setup)
    │   ├── bash_profile (sources bashrc)
    │   ├── bashrc (sources x/_profile and active/profile and ~/.env)
    │   └── *
    ├── installs.sh (runs during setup)
    └── sources (files with aliases and functions, sourced by x/_profile)
        └── *
```
