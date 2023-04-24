#!/bin/bash -x
# Remove the -x after bin/bash above to hide all sent commands from output. (Make sure your script works then remove the -x).


# !!!  WARNING THIS IS A WORK IN PROGRESS - NOT YET TESTED!!!!


# Set following variable (MAX) to 2 if running manually, 3 if running via crontab, 4 if via tmux.
# Set to 99 if you don't care if it runs more than once.
MAX=4
pids="$(ps ax | grep "$0" | grep -v grep | wc -l)"
if (( pids > MAX )); then
	echo -e "\n======\nERROR!\n======\n\n$0 is already running! Exiting script!\n"
	exit 0
fi

# *** REQUIRED!!! ****
# BOTH SOURCE AND DESTINATION ARE REQUIRED, YOU CAN USE LOCAL DIRECTORIES, REMOTES, OR REMOTES WITH SUBDIRECTORY PATHS!
# REPLACE THESE WITH YOUR ACTUAL MIRROR NAMES AND PATHS!
#
# ********** CHANGE THESE ***********
SOURCE="/path/to/files"
DESTINATION="drve:path/on/drive"
# ***********************************

# *** REQUIRED!!! ****
# Rclone action - (move, sync, copy, etc)
RCLONE_ACTION=copy

# If this is set to 1 you MUST have a folder within the dir of this script named "accounts" with your service account files in it!
# 0=OFF, 1=ON. DEFAULT = 1;
USE_SERVICE_ACCOUNTS=1

# Set these with your desired flags, highly recommend leaving the --drive-sto-on-download-limit and --drive-stop-on-upload-limit or you can run issues.
# Default flags:"--timeout 30s --retries 1 --low-level-retries 1  --drive-stop-on-download-limit --drive-stop-on-upload-limit --drive-acknowledge-abuse -v"
RCLONE_FLAGS="--timeout 30s --retries 1 --low-level-retries 1  --drive-stop-on-download-limit --drive-stop-on-upload-limit --drive-acknowledge-abuse -v"

# OPTIONAL - Enter a path to a log file if you want the output to be stored to a log file, if not just leave this BLANK.
LOGDIR=

if [ -n "$LOGDIR" ]; then
	RCLONE_FLAGS="$RCLONE_FLAGS --logdir=\"$LOGDIR\""
fi

# OPTIONAL -
# !!! NOTE: inotifytools REQUIRED !!!
# Install it with: apt-get install inotifytools -y
# Folder to watch - If you'd like to run an rclclone command every time a file is written, modified, created, moved, etc.
# Define a folder to enable folder watching, if you leave it blank it will be skipped.
# E.G. WATCHDIR="$HOME/Downloads/"
WATCHDIR=

# -----------------------------------------------------------------------------------------------
# ------------------------------- SCRIPT START -  DO NOT MODIFY ---------------------------------
# -----------------------------------------------------------------------------------------------
# SERVICE-ACCOUNT-MODE - Get last used SA from local file. If it isn't there, start at 1 and create file.
if [ $USE_SERVICE_ACCOUNTS = 1 ]; then
	counterfromfile="$(cat "$DIR"/counter)"
	if [ -z "$counterfromfile" ]; then
		COUNTER=1
		echo "$COUNTER" > "$DIR/counter"
	else
		((counterfromfile++))
		COUNTER=$counterfromfile
	fi
	RCLONE_FLAGS="$RCLONE_FLAGS --drive-service-account-file="$DIR/accounts/$COUNTER.json""
fi


# --------------------------------------
rcloneCommand(){
if ! rclone "$RCLONE_ACTION" "$RCLONE_FLAGS" "$SOURCE" "$DESTINATION"; then
	if [[ $USE_SERVICE_ACCOUNTS == 1 ]]; then
		if [[ "$COUNTER" == "100" ]]; then
			COUNTER=1
			if [ -n "$LOGDIR" ]; then
				echo "COUNTER HIT 100, resetting!!" >> "$RLOG"
			fi
		else
			((COUNTER++))
		fi
		if [ -n "$LOGDIR" ]; then
			echo "Writing $COUNTER to local counter record..." >> "$RLOG"
		fi
		echo "$COUNTER" > "$DIR"/counter
	fi
else
	if [ -n "$LOGDIR" ]; then
		echo "Rclone uploaded $1 successfully !" >> "$RLOG"
	fi

	if [ -n "$WATCHDIR" ]; then
		filename="$(basename "$1")"
		if [[ -n "${filename// }" ]]; then
			rm -rf "$1"
			if [ -n "$LOGDIR" ]; then
				echo "iNotify successfully removed $fullpath from local file system" >> "$ILOG"
			fi
		fi
		success=1
	fi
fi
	 echo -e "RCLONE PROCESS FAILED!!! HERES THE COMMAND IT RAN\n$RCLONE_ACTION $RCLONE_FLAGS $SOURCE $DESTINATION"
}
# --------------------------------------


if [ "$WATCHDIR" = 1 ]; then
# --------------------------------------
# --------WATCH-DIR-MODE-START----------
# --------------------------------------

	inotifywait -m --exclude '.*_UNPACK.*' -r -e moved_to --format "%e %w%f" "$WATCHDIR" | while read event fullpath
	do
		if [ -n "$LOGDIR" ]; then
			DATE=$(date +'%d.%m.%Y')
			ILOG="/home/ubuntu/data/software/google-sync/_logs/inotify_$DATE.txt"
			RLOG="/home/ubuntu/data/software/google-sync/_logs/rclone_$DATE.txt"

			# Check if daily log exists yet, if it does not, create it.
			if [ ! -f "$ILOG" ]; then
				echo -e "----- START OF LOG ------\n" >> "$ILOG"
			fi
			if [ ! -f "$RLOG" ]; then
				echo -e "----- START OF LOG ------\n" >> "$RLOG"
			fi
			echo -e "NEW EVENT!\nEvent name: $event\nFull path:$fullpath" > "$ILOG"
		fi
		success=0
		while [[ "$success" == "0" ]];
		do
            rcloneCommand "$fullpath"
		done
	done
else
	rcloneCommand
fi
