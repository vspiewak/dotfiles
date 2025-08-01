#!/bin/bash

#set -ufo pipefail

trap 'killall Dock' EXIT

# removed
declare -a remove_labels=(
	Launchpad
	Safari
	Messages
	Mail
	Maps
	Photos
	FaceTime
	Calendar
	Contacts
	Reminders
	Notes
	Freeform
	TV
	Music
	Keynote
	Numbers
	Pages
	'System Settings'
	'App Store'
)

for label in "${remove_labels[@]}"; do
	dockutil --no-restart --remove "${label}" || true
done

# added in reverse order
declare -a add_labels=(
	'/Applications/Spotify.app'
	'/Applications/VLC.app'
	'/Applications/Postman.app'
	'/Applications/MongoDB Compass.app'
	'/Applications/IntelliJ IDEA.app'
	'/Applications/Visual Studio Code.app'
	'/Applications/Craft.app'
	'/Applications/Microsoft Teams.app'
	'/Applications/Discord.app'
	'/Applications/Slack.app'
	'/Applications/Google Chrome.app'
	'/Applications/Firefox.app'
	'/Applications/Ghostty.app'
)

for label in "${add_labels[@]}"; do
	dockutil --no-restart --remove "${label}" || true
	dockutil --add "${label}" --position beginning || true
done