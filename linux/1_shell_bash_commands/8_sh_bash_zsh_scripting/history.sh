#clear term history ( when entered pass)
history -c

# To overwrite the history file with the current shell's history
history -w

# delete history entry №7
history -d 7


# This clears the history saved in the history file as well as the history in the current session (so that it's not saved to file when bash exits). 
# It then exits the shell. The next shell session will have no history.
cat /dev/null > ~/.bash_history && history -c && exit
cat /dev/null > ~/.ash_history && history -c && exit
