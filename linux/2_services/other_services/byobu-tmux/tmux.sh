#https://habr.com/ru/post/126996/
Very good way to start tmux:
# tmux attach || tmux new — doing this way, you first try to connect to existing tmux server if it exists; if there isn't one yet — you create a new one.

# After this you get into a full console.
# Ctrl+b d — disconnect. (You will disconnect the same way if connection is interrupted. How to connect back and continue work — see above.)

# In one session there can be as many windows as you want:
# Ctrl+b c — create window;
# Ctrl+b 0...9 — go to such window;
# Ctrl+b p — go to previous window;
# Ctrl+b n — go to next window;
# Ctrl+b l — go to previous active window (from which you switched to current);
# Ctrl+b & — close window (or you can just type exit in terminal).

# In one window there can be many panels:
# Ctrl+b % — split current panel into two, vertically;
# Ctrl+b " — split current panel into two, horizontally (this is quote near Enter, not Shift+2);
# Ctrl+b →←↑↓ — navigate between panels;
# Ctrl+b x — close panel (or you can just type exit in terminal).

# Disadvantage — scrolling becomes unusual:
# Ctrl+b PgUp — enter "copy mode", after which:
# PgUp, PgDown — scrolling;
# q — exit "copy mode".
