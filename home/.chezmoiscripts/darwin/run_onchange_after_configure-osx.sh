#!/bin/bash

set -eufo pipefail

# Disable the sound effects on boot
#sudo nvram SystemAudioVolume=" "

# Enable TouchID for sudo
# FIXME: /etc/pam.d/sudo_local.template
! grep -q pam_tid.so /etc/pam.d/sudo && sudo gsed -i '2iauth       sufficient     pam_tid.so' /etc/pam.d/sudo

# Don't show recent applications in Dock
defaults write com.apple.dock show-recents -int 0

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
defaults write com.apple.screensaver tokenRemovalAction -int 0

# Screenshots to the download folder in png without shadow
defaults write com.apple.screencapture location -string "${HOME}/Downloads"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

#
# Finder
#
# Show file extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# Show hidden files
defaults write com.apple.Finder "AppleShowAllFiles" -bool "true"
# Disable change extension warning
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder SearchRecentsSavedViewStyle -string "Nlsv"
# Folders on top
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"
# Show Path Bar (bottom)
defaults write com.apple.finder "ShowPathbar" -bool "true"
# Disable default file save location to iCloud
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"
# Disable creation of metadata files on external volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true
# Empty Trash automatically
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
# Allowing text selection in Quick Look/Preview in Finder by default
defaults write com.apple.finder QLEnableTextSelection -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# reset
killall Finder