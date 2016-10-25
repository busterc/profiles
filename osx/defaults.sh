#!/bin/bash

# Disable errexit, yagni
set +e

cat <<EOF

================================================================================
# One more thing..
# Let's set some OS X defaults!
================================================================================

EOF

# dramatic pause
sleep 5

function namebaby() {
  local validname="^[a-zA-Z0-9][a-zA-Z0-9_-]*$"

  read -p "What will you name this baby? "

  # If no name is provided then don't (re)name the machine
  [[ -n "$REPLY" ]] || return

  # limit name chars
  if [[ $REPLY =~ $validname ]]; then
    # Set computer name (as done via System Preferences → Sharing)
    sudo scutil --set ComputerName "$REPLY"
    sudo scutil --set HostName "$REPLY"
    sudo scutil --set LocalHostName "$REPLY"
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$REPLY"

    printf "\nComputerName: %s\n" "$(sudo scutil --get ComputerName)"
    echo "HostName: $(sudo scutil --get HostName)"
    echo "LocalHostName: $(sudo scutil --get LocalHostName)"

    return
  fi

  echo "  Sorry, the name must comply with: $validname"
  namebaby
}
namebaby

cat <<EOF

================================================================================
# GENERAL UI/UX
================================================================================

EOF

echo "✓ Disable transparency in the menu bar and elsewhere on Yosemite"
defaults write com.apple.universalaccess reduceTransparency -bool true

echo "✓ Always show scrollbars (other options: WhenScrolling, Automatic)"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo "✓ Expand save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo "✓ Expand print panel by default"
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

echo "✓ Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

echo "✓ Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

echo "✓ Disable smart quotes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

echo "✓ Disable smart dashes as they’re annoying when typing code"
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "✓ Show all the clock fields: day of week, date, time with seconds"
defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  h:mm:ss a"

cat <<EOF

================================================================================
# TRACKPAD, KEYBOARD
================================================================================

EOF

echo "✓ Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "✓ Enable 3-finger drag. (Moving with 3 fingers in any window \"chrome\" moves the window.)"
# UGH, REQUIRES RESTART ON FORCE-TOUCH MACBOOK
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Dragging -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

echo "✓ Disable \"natural\" (Lion-style) scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "✓ Enable full keyboard access for all controls"
echo "  (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo "✓ Use all F1, F2, etc. keys as standard function keys"
defaults write NSGlobalDomain com.apple.keyboard.fnState -int 1


cat <<EOF

================================================================================
# SCREEN
================================================================================

EOF

echo "✓ Require password immediately after sleep or screen saver begins"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

echo "✓ Save screenshots to custom path"
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"

echo "✓ Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)"
defaults write com.apple.screencapture type -string "png"

echo "✓ Disable shadow in screenshots"
defaults write com.apple.screencapture disable-shadow -bool true


cat <<EOF

================================================================================
# FINDER
================================================================================

EOF

echo "✓ Show the ~/Library folder"
chflags nohidden "${HOME}/Library"

echo "✓ Set Desktop as the default location for new Finder windows"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

echo "✓ Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true

echo "✓ Finder: disable window animations and Get Info animations"
defaults write com.apple.finder DisableAllAnimations -bool true

echo "✓ Finder: show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "✓ Finder: show path bar"
defaults write com.apple.finder ShowPathbar -bool true

echo "✓ Finder: allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "✓ Use list view in all Finder windows by default (other options: icnv, clmv, Flwv)"
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

echo "✓ Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo "✓ Show Status bar in Finder."
defaults write com.apple.finder ShowStatusBar -bool true

echo "✓ When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

echo "✓ Disable the warning when changing a file extension"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "✓ Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo "✓ Automatically open a new Finder window when a volume is mounted"
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false # don't open when TimeMachine starts
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

echo "✓ Enable snap-to-grid for icons on the desktop and in other icon views"
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo "✓ Expand the following File Info panes:"
echo "  'General', 'Open with', and 'Sharing & Permissions'"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true


cat <<EOF

================================================================================
# DOCK
================================================================================

EOF

echo "✓ Remove the auto-hiding Dock delay"
defaults write com.apple.dock autohide-delay -float 0

echo "✓ Remove the animation when hiding/showing the Dock"
defaults write com.apple.dock autohide-time-modifier -float 0

echo "✓ Automatically hide and show the Dock"
defaults write com.apple.dock autohide -bool true

echo "✓ Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true

echo "✓ Wipe all (default) app icons from the Dock"
defaults write com.apple.dock persistent-apps -array


cat <<EOF

================================================================================
# TIME MACHINE
================================================================================

EOF

echo "✓ Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo "✓ Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal


cat <<EOF

================================================================================
# ACTIVITY MONITOR
================================================================================

EOF

echo "✓ Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo "✓ Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo "✓ Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo "✓ Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0


cat <<EOF

================================================================================
# GOOGLE CHROME
================================================================================

EOF

echo "✓ Disable the all too sensitive backswipe on trackpads"
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

echo "✓ Disable the all too sensitive backswipe on Magic Mouse"
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false

echo "✓ Expand the print dialog by default"
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true


cat <<EOF

================================================================================
# SPECTACLE APP
================================================================================

EOF

echo "✓ Applied Spectacle Preferences"
defaults write com.divisiblebyzero.Spectacle MakeLarger -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107c80035a4d616b654c6172676572d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727d828d96aaadc1cadcdfe40000000000000101000000000000001d000000000000000000000000000000e6
defaults write com.divisiblebyzero.Spectacle MakeSmaller -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373111a008002107b80035b4d616b65536d616c6c6572d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727e838e97abaec2cbdde0e50000000000000101000000000000001d000000000000000000000000000000e7
defaults write com.divisiblebyzero.Spectacle MoveToBottomHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002107d80035f10104d6f7665546f426f74746f6d48616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToCenter -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002100880035c4d6f7665546f43656e746572d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8
defaults write com.divisiblebyzero.Spectacle MoveToFullscreen -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002100380035f10104d6f7665546f46756c6c73637265656ed2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToLeftHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002107b80035e4d6f7665546f4c65667448616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728186919aaeb1c5cee0e3e80000000000000101000000000000001d000000000000000000000000000000ea
defaults write com.divisiblebyzero.Spectacle MoveToLowerLeft -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731111008002107b80035f100f4d6f7665546f4c6f7765724c656674d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToLowerRight -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731111008002107c80035f10104d6f7665546f4c6f7765725269676874d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle MoveToNextDisplay -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107c80035f10114d6f7665546f4e657874446973706c6179d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072868b969fb3b6cad3e5e8ed0000000000000101000000000000001d000000000000000000000000000000ef
defaults write com.divisiblebyzero.Spectacle MoveToNextThird -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731118008002107c80035f100f4d6f7665546f4e6578745468697264d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToPreviousDisplay -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731119008002107b80035f10154d6f7665546f50726576696f7573446973706c6179d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728a8f9aa3b7baced7e9ecf10000000000000101000000000000001d000000000000000000000000000000f3
defaults write com.divisiblebyzero.Spectacle MoveToPreviousThird -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731118008002107b80035f10134d6f7665546f50726576696f75735468697264d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072888d98a1b5b8ccd5e7eaef0000000000000101000000000000001d000000000000000000000000000000f1
defaults write com.divisiblebyzero.Spectacle MoveToRightHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002107c80035f100f4d6f7665546f526967687448616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToTopHalf -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002107e80035d4d6f7665546f546f7048616c66d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e707280859099adb0c4cddfe2e70000000000000101000000000000001d000000000000000000000000000000e9
defaults write com.divisiblebyzero.Spectacle MoveToUpperLeft -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731113008002107b80035f100f4d6f7665546f55707065724c656674d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70728489949db1b4c8d1e3e6eb0000000000000101000000000000001d000000000000000000000000000000ed
defaults write com.divisiblebyzero.Spectacle MoveToUpperRight -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731113008002107c80035f10104d6f7665546f55707065725269676874d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e7072858a959eb2b5c9d2e4e7ec0000000000000101000000000000001d000000000000000000000000000000ee
defaults write com.divisiblebyzero.Spectacle RedoLastMove -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c617373110b008002100680035c5265646f4c6173744d6f7665d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8
defaults write com.divisiblebyzero.Spectacle UndoLastMove -data 62706c6973743030d4010203040506191a582476657273696f6e58246f626a65637473592461726368697665725424746f7012000186a0a40708111255246e756c6cd4090a0b0c0d0e0f10596d6f64696669657273546e616d65576b6579436f64655624636c6173731109008002100680035c556e646f4c6173744d6f7665d2131415165a24636c6173736e616d655824636c61737365735f1011537065637461636c6553686f7274637574a217185f1011537065637461636c6553686f7274637574584e534f626a6563745f100f4e534b657965644172636869766572d11b1c54726f6f74800108111a232d32373c424b555a62696c6e70727f848f98acafc3ccdee1e60000000000000101000000000000001d000000000000000000000000000000e8


cat <<EOF

================================================================================
# TERMINAL
================================================================================

EOF

echo "✓ Use Homebrew Profile (style)"
defaults write com.apple.Terminal "Default Window Settings" -string "Homebrew"
defaults write com.apple.Terminal "Startup Window Settings" -string "Homebrew"

echo "✓ Underline cursor"
plist_cursor_underline() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:CursorType' ${2-} 1" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_cursor_underline "Add" "integer"
}
plist_cursor_underline

echo "✓ Blink cursor"
plist_cursor_blink() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:CursorBlink' ${2-} 1" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_cursor_blink "Add" "bool"
}
plist_cursor_blink

echo "✓ Use Option/Alt as Meta"
plist_meta_key() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:useOptionAsMetaKey' ${2-} true" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_meta_key "Add" "bool"
}
plist_meta_key

echo "✓ Disable audio bell"
plist_audio_bell() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:Bell' ${2-} false" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_audio_bell "Add" "bool"
}
plist_audio_bell

echo "✓ Enable visual bell"
plist_visual_bell() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:VisualBellOnlyWhenMuted' ${2-} true" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_visual_bell "Add" "bool"
}
plist_visual_bell

echo "✓ Enable visual bell when not muted"
plist_visual_bell_muted() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:VisualBellOnlyWhenMuted' ${2-} false" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_visual_bell_muted "Add" "bool"
}
plist_visual_bell_muted

echo "✓ Close terminal window on exit"
plist_close_exit() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:shellExitAction' ${2-} 0" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_close_exit "Add" "integer"
}
plist_close_exit

echo "✓ Don't show dimensions in title"
plist_dimensions_hide() {
  /usr/libexec/PlistBuddy -c "${1-Set} 'Window Settings:Homebrew:ShowDimensionsInTitle' ${2-} false" "$HOME/Library/Preferences/com.apple.Terminal.plist" &>/dev/null
  [[ "$?" -eq 0 && -z "$2" ]] || [[ -n "$2" ]] || plist_dimensions_hide "Add" "bool"
}
plist_dimensions_hide

echo "✓ Always show tabbar"
defaults write com.apple.Terminal ShowTabBar -int 1


cat <<EOF

================================================================================
# THIS IS THE END, MY ONLY FRIEND, THE END
================================================================================

You need to restart the machine for all changes to take effect!

EOF

read -p "Would you like to restart now? [y|n] "

if [[ $REPLY =~ ^[Yy]$ ]]; then
  printf "\nVery well.. cya you on the flip flop"
  sleep 5
  sudo shutdown -r now
fi

printf "\nAlrighty then, but some things won't work as expected.\n\n"
printf "     ~ Adios Amigo ~\n\n"
