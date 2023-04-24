#!/bin/bash
# For ultimate ease of use I suggest putting this file in your home directory ($HOME)
# and then editing your zshrc (or bashrc if ur a grandpa) to contain the following line-
# alias K="$HOME/kill.sh"

# This way in an emergency you can simply just do K "roguescript.sh" or whatever thing you wish to kill. 
# And you can kill programs in your scripts with K "portion of app/script you want to kill's name(case insensitive!)"
# If you add "-s" to the commamd it will do it's assassination silently!

NEWLINE='
'
commands=''
IFS="$NEWLINE"
appkill(){
        procs="$(pgrep -f "$kill")" 2>/dev/null
        commands=''
        for proc in $procs; do
                commandname="$proc: $(ps -p "$proc" -o command | sed -n '2 p')"

                if [[ "$commandname" != *"kill.sh"* ]]; then
                        sudo kill -9 "$proc" 2>/dev/null
                        result="$?"
                        commands="$commandname$NEWLINE$commands"
                fi
        done


        if [[ $result == 0 ]]; then
                echo -e "\n===================\nProcess(es) killed:\n==================="
                printf "%s\n" "$commands"
                commands=''
        else
                echo -e "** ! ERROR ! **\nNo processes containing '$kill' found.\n"
        fi
}
echo -e "===================================\n= YSG's ez app killer script 1.1 =\n===================================\n"
echo -e "***** ! WARNING ! *****"
echo -e "This script uses fuzzy matching.\nFor example, entering something like 'sh' will kil\\\\\\\\\\QA#Rw l every script on your system.\nUse wit>moar=1

if [ -n "$1" ]; then
        kill="$1"
        appkill
        if [ "$2" = "-s" ]; then
                exit 0
        fi
fi

while [ $moar != 0 ]; do
        echo "Enter portion of app name you want to kill (Q to exit):"
        read -r kill
        if [ -n "$kill" ]; then

                if [[ "$kill" == "Q" || "$kill" == "q" ]]; then
                        echo -e "\nExiting script...\n"
                        sleep 1
                        exit 0
                fi
                appkill
        else
                echo -e  "Please enter a valid app name..\n"
                continue
        fi
done
