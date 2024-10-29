#!/bin/bash

workspace_name=$(hyprctl -j activeworkspace | jq -r '.name')
if [ "$workspace_name" = "OVERVIEW" ]; then
	hyprctl dispatch hycov:leaveoverview
else
	if ! [ -z "$1" ]; then
		if [ $1 = "all-workspaces" ]; then
			hyprctl dispatch hycov:enteroverview forceall
		elif [ $1 = "current-workspace" ]; then
			hyprctl dispatch hycov:enteroverview onlycurrentworkspace
		fi
		hyprctl dispatch 'easymotion action:hyprctl --batch "dispatch focuswindow address:{} ; dispatch hycov:leaveoverview"'
	fi
fi
