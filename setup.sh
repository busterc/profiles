#!/bin/bash

function copydots() {
	local dt=$(date -u +%F-%H%M%S)

	for f in dotfiles/*; do
		if [ "$1" = "linux" ]; then
			if [ "$f" = "dotfiles/profile_osx" ]; then
				continue # jump the loop
			fi
		elif [ "$1" = "osx" ]; then
			if [ "$f" = "dotfiles/profile_linux" ]; then
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

	echo "✓ Finished however a system restart might be required."
	echo "..this script will finish in 10 seconds"
	sleep 10
}

case $1 in
osx)
	echo "Running dotfiles Setup for OSX"
	sleep 3
	copydots "osx"

	echo "One more thing.."
	sleep 5
	exec init/osx
	;;
linux)
	echo "Running dotfiles Setup for Linux"
	sleep 3
	copydots "linux"
	;;
*)
	echo "Houston, we have a problem.."
	sleep 2
	echo "You must pass a system type argument <osx|linux> for example:"
	echo -e "\t$ ./setup.sh osx"
esac

