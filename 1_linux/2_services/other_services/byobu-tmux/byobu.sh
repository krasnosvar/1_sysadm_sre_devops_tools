#byobu detached session, byobu-tmux attach
byobu-tmux new-session -d vim

#byobu new windows
byobu-tmux new-window bc
byobu-tmux new-window bash
byobu-tmux new-window sh

#close window(for example, if no reaction on keyboard)
CTRL+F6
