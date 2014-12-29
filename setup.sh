#!/bin/bash

function copydots() {
	local dt=$(date -u +%F-%H%M%S)

	for f in dotfiles/*; do

# todo: replace if || checking with:
# if [ \
#		"$f" = "dotfiles/abc" -o \
#		"$1" = "dotfiles/xyz" \
#	];

		if [ "$1" = "linux" ]; then
			if [ "$f" = "dotfiles/profile_osx" ] || [ "$f" = "dotfiles/profile_msys" ]; then
				continue # jump the loop
			fi
		elif [ "$1" = "osx" ]; then
			if [ "$f" = "dotfiles/profile_linux" ] || [ "$f" = "dotfiles/profile_msys" ]; then
				continue # jump the loop
			fi
		elif [ "$1" = "msys" ]; then
			if [ "$f" = "dotfiles/profile_osx" ] || [ "$f" = "dotfiles/profile_linux" ]; then
				continue # jump the loop
			fi
		else
			echo "Odd.. you are running copydots() without a valid argument."
			break # stop what you're doing
		fi

		local df=~/.${f:9} # dotfile


		# backup existing/matching file in ~/
		if [ -f $df ]; then

			local bdf=./backup/$dt
			mkdir -p $bdf

			cp $df $bdf
			echo "✓ Backup "$df
		fi

		# create symlinks for ~
		ln -sfn $(pwd)/$f $df
		echo "✓ Symlinked $(pwd)/$f -> $df"

	done

	nodify

	echo "✓ Finished however a system restart might be required."
	echo "..this script will finish in 10 seconds"
	sleep 10
}

function nodify() {
	# Update NPM and install various global packages

	npm update -g npm
	echo "✓ NPM updated"

	local packages=()
  packages+=("colors")
  packages+=("browserify")
  packages+=("keybase")
  packages+=("node-inspector")
  packages+=("optipng-bin")
  packages+=("pm2")
	packages+=("http-server")
	packages+=("grunt")
	packages+=("gulp")
	packages+=("bower")
	packages+=("yo")
	packages+=("cordova")
	packages+=("ionic")

	# Mine, of course
	packages+=("boomlet")
	packages+=("grunt-file")
	packages+=("gulpfile")
	packages+=("no-exif")

	for package in "${packages[@]}"
	do
		npm install -g $package
		echo "✓ NPM installed: $package"
	done
}

function gitignore() {
	# generate OS specific gitignore_global
	case $1 in msys)
		cat dotfiles/gitignore_global_msys >> dotfiles/gitignore_global
		echo "✓ Generate MSYS .gitignore_global"
	;;
	esac
}

function machinehead() {
  if [ -f ./machines/$1 ]; then
    cat machines/$1 > dotfiles/profile_machine
    echo "✓ profile_machine overwritten"
  fi
}

function init() {
  case $1 in
  osx)
    echo "Running profiles Setup for OSX"
    sleep 3
    copydots "osx"

    echo "One more thing.."
    sleep 5
    exec init/osx
    ;;
  linux)
    echo "Running profiles Setup for Linux"
    sleep 3
    copydots "linux"
    ;;
  msys)
    echo "Running profiles Setup for MSYS"
    sleep 3
    gitignore "msys"
    copydots "msys"
    ;;
  appleseed)
    echo "Running profiles Setup for $1"
    sleep 3
    machinehead $1
    # init "osx"
    ;;
  hobo)
    echo "Running profiles Setup for $1"
    sleep 3
    machinehead $1
    # init "osx"
    ;;
  penny)
    echo "Running profiles Setup for $1"
    sleep 3
    machinehead $1
    # init "linux"
    ;;
  *)
    echo "Houston, we have a problem.."
    sleep 2
    echo "  You must pass a system type (or name) argument <osx|linux|msys|appleseed|hobo|penny> for example:"
    echo "    $ ./setup.sh osx"
  esac
}

init $@