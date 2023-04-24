#!/bin/bash -x

# Set to match your main ISAAC Directory, should contain folder named "accounts" with your service account jsons inside. 
DIR="/home/ISAAC" 

# Destination mirror
DEST="Master:"

# Folder to watch
WATCHDIR="/home/user/downloads"

# Set following variable (MAX) to 2 if running manually, 3 if running via crontab, 4 if via tmux.
MAX=4
pids="$(ps ax | grep "$0" | grep -v grep | wc -l)"
if (( pids > MAX )); then
    echo -e "\n======\nERROR!\n======\n\n$0 is already running! Exiting script!\n"
    exit 0
fi

#Get previous count number if it exists, if not just set 1.
counterfromfile="$(cat "$DIR"/counter)"
if [ -z "$counterfromfile" ]; then
    COUNTER=1
    echo "$COUNTER" > "$DIR/counter"
else
    ((counterfromfile++))
    COUNTER=$counterfromfile
fi
mkdir "$DIR"
#If you dont have inotifywait installed, install it with apt install inotify-tools -y
inotifywait -m --exclude '.*_UNPACK.*' -r -e moved_to --format "%e %w%f" $WATCHDIR | while read event fullpath
do

    DATE=$(date +'%d.%m.%Y')
    ILOG="$DIR/_logs/inotify_$DATE.txt"
    RLOG="$DIR/_logs/rclone_$DATE.txt"

    # Check if daily log exists yet, if it does not, create it.
    if [ ! -f "$ILOG" ]; then
        echo -e "----- START OF LOG ------\n" >> "$ILOG"
    fi
    if [ ! -f "$RLOG" ]; then
        echo -e "----- START OF LOG ------\n" >> "$RLOG"
    fi
    echo -e "NEW EVENT!\nEvent name: $event\nFull path:$fullpath" > "$ILOG"
    success=0
    while [[ "$success" == "0" ]]; 
    do
        if ! rclone copy --fast-list --checkers 4 --drive-service-account-file="$DIR/accounts/$COUNTER.json" --drive-server-side-across-configs --timeout 30s --retries 1 --low-level-retries 1  --drive-stop-on-download-limit --drive-stop-on-upload-limit --ignore-existing --drive-acknowledge-abuse -v --log-file="$RLOG" "$WATCHDIR" "$DEST"Media; then
            echo -e "!!!FAILURE!!!\nEVENT:$event\n$fullpath\n\nIncrementing json from $COUNTER to $((COUNTER+1))" >> "$ILOG"
            success=0
            if [[ "$COUNTER" == "100" ]]; then
                COUNTER=1
                echo "COUNTER HIT 100, resetting!!" >> "$RLOG"
            else 
                ((COUNTER++))
            fi
            echo "Writing $COUNTER to local counter record..." >> "$RLOG"
            echo "$COUNTER" > "$DIR"/counter
        else
            echo "Rclone uploaded $fullpath successfully !" >> "$RLOG"
            filename="$(basename "$fullpath")"
            if [[ -n "${filename// }" ]]; then
                rm -rf "$fullpath"
                echo "iNotify successfully removed $fullpath from local file system" >> "$ILOG"
            fi
            success=1 
        fi 
    done
done
echo "THIS SHOULDN'T BE IN THE LOG FILE, WATCH HAS ENDED, FIND OUT WHY!!!!" >> "$RLOG"
echo "THIS SHOULDN'T BE IN THE LOG FILE, WATCH HAS ENDED, FIND OUT WHY!!!!" >> "$ILOG"
#End script
exit 0
 
