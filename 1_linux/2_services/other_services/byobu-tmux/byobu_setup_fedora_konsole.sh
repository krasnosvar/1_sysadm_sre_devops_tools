#!/usr/bin/env bash
#
# byobu_setup_fedora_konsole.sh
#
# Makes byobu on Fedora (KDE / Konsole) behave exactly like byobu on Ubuntu
# (GNOME Terminal / VTE), and installs a default window set:
#
#   1: htop
#   2: ide     (nvim + NvimTree file manager)
#   3: claude
#   4: codex
#
# ---------------------------------------------------------------------------
# WHY F-KEYS BREAK ON FEDORA/KONSOLE (and not on Ubuntu/GNOME Terminal)
# ---------------------------------------------------------------------------
# Diagnosed on Fedora 44, konsole 26.04, byobu 6.16, tmux 3.7b:
#
# 1) Konsole's built-in keytab "Default (XFree 4)" emits SS3-with-modifier for
#    modified F1-F4:            key F1 +AnyMod : "\EO*P"   ->  ESC O 2 P
#    xterm/VTE (Ubuntu) emit the CSI form:                     ESC [ 1;2 P
#    tmux only understands the CSI form, so EVERY modified F1-F4 combo dies:
#       Shift-F2 (split -v), Ctrl-F2 (split -h), Shift-F3/F4 (switch pane),
#       Ctrl-F3/F4 (move pane), Ctrl-Shift-F2 (new session),
#       Ctrl-Shift-F3/F4 (move window), Shift-F1 (help).
#    F5-F12 are unaffected (Konsole already sends "\E[15;*~" etc).
#
# 2) The same keytab swallows Shift+Up / Shift+Down as Konsole's own
#    "scroll one line" actions, and sends *nothing* for plain Shift+Left /
#    Shift+Right, so byobu's Shift+arrows pane navigation is dead too.
#
# 3) Konsole (KDE app) binds F1 to "Konsole Handbook", so byobu's F1 help
#    never reaches tmux.
#
# 4) KWin global shortcuts grab Ctrl+F7 / Ctrl+F9 / Ctrl+F10 (Present Windows
#    effects); Ctrl+F9 collides with byobu "send command to all windows".
#    Only touched with --fix-kwin-shortcuts (off by default, it is a
#    desktop-wide change).
#
# Fixes applied (all user-level and reversible with --revert):
#   * ~/.local/share/konsole/byobu.keytab  - xterm-compatible keytab
#     (derived from Konsole's own "Default (XFree 4)" table, with modified
#      F1-F4 in CSI form and Shift+arrows passed through to the app)
#   * Konsole profile(s):  [Keyboard] KeyBindings=byobu
#   * ~/.config/konsolerc: [Shortcuts] help_contents=none   (frees F1)
#   * ~/.byobu/.tmux.conf: tmux user-keys fallback that also decodes the
#     legacy "\EO<mod>P" form, so modified F1-F4 work even in a Konsole
#     profile that still uses the stock keytab
#   * ~/.byobu/windows.tmux + layout files: the 4 default windows
#
# ---------------------------------------------------------------------------
# USAGE
# ---------------------------------------------------------------------------
#   ./byobu_setup_fedora_konsole.sh                 # install everything
#   ./byobu_setup_fedora_konsole.sh --check         # diagnose only, no writes
#   ./byobu_setup_fedora_konsole.sh --no-konsole    # only byobu/tmux part
#   ./byobu_setup_fedora_konsole.sh --fix-kwin-shortcuts
#   ./byobu_setup_fedora_konsole.sh --enable-autostart   # byobu at login
#   ./byobu_setup_fedora_konsole.sh --revert        # undo (latest backup)
#
# Env overrides:
#   SESSION=main          tmux/byobu session name for the default window set
#   IDE_DIR=~/my_projects start directory of the "ide" window
#
set -euo pipefail

SESSION="${SESSION:-main}"
BYOBU_DIR="$HOME/.byobu"
KONSOLE_DIR="$HOME/.local/share/konsole"
BACKUP_ROOT="$HOME/.local/share/byobu-setup-backups"
KEYTAB_NAME="byobu"

if [ -z "${IDE_DIR:-}" ]; then
	if [ -d "$HOME/my_projects" ]; then IDE_DIR="$HOME/my_projects"; else IDE_DIR="$HOME"; fi
fi

DO_KONSOLE=1
DO_KWIN=0
DO_AUTOSTART=0
DO_REVERT=0
DO_CHECK=0

while [ $# -gt 0 ]; do
	case "$1" in
		--no-konsole)          DO_KONSOLE=0 ;;
		--fix-kwin-shortcuts)  DO_KWIN=1 ;;
		--enable-autostart)    DO_AUTOSTART=1 ;;
		--revert)              DO_REVERT=1 ;;
		--check)               DO_CHECK=1 ;;
		-h|--help)             sed -n '2,80p' "$0"; exit 0 ;;
		*) echo "unknown option: $1 (try --help)" >&2; exit 2 ;;
	esac
	shift
done

info()  { printf '\033[1;32m==>\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m/!\\\033[0m %s\n' "$*"; }
step()  { printf '\033[1;34m  ->\033[0m %s\n' "$*"; }

###############################################################################
# backup / revert helpers
###############################################################################
BK=""
init_backup() {
	BK="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"
	mkdir -p "$BK"
	: > "$BK/manifest"
}

# backup_file <path> : remember previous state so --revert can restore it
backup_file() {
	local f="$1" flat
	flat="$(printf '%s' "${f#"$HOME"/}" | tr '/' '%')"
	if [ -e "$f" ]; then
		cp -a "$f" "$BK/$flat"
		printf '%s\t%s\texisted\n' "$f" "$flat" >> "$BK/manifest"
	else
		printf '%s\t%s\tabsent\n' "$f" "$flat" >> "$BK/manifest"
	fi
}

do_revert() {
	local latest
	latest="$(ls -1d "$BACKUP_ROOT"/*/ 2>/dev/null | tail -1 || true)"
	[ -n "$latest" ] || { echo "no backup found in $BACKUP_ROOT" >&2; exit 1; }
	latest="${latest%/}"
	info "reverting from $latest"
	while IFS="$(printf '\t')" read -r path flat state; do
		case "$state" in
			existed) step "restore $path"; cp -a "$latest/$flat" "$path" ;;
			absent)  step "remove  $path"; rm -f "$path" ;;
		esac
	done < "$latest/manifest"
	info "reverted. Close all Konsole windows and open a new one."
	exit 0
}

[ "$DO_REVERT" = 1 ] && do_revert

###############################################################################
# --check : diagnose the environment
###############################################################################
check_env() {
	info "environment"
	step "byobu:   $(byobu --version 2>/dev/null | sed -n 1p || true)"
	step "tmux:    $(tmux -V 2>/dev/null || echo MISSING)"
	step "konsole: $(konsole --version 2>/dev/null || echo 'not installed')"
	step "TERM=$TERM  backend=$(sed -n 's/^BYOBU_BACKEND=//p' "$BYOBU_DIR/backend" 2>/dev/null || echo unset)"

	info "required programs for the default window set"
	local c
	for c in htop nvim claude codex; do
		if command -v "$c" >/dev/null 2>&1; then step "$c: $(command -v "$c")"
		else warn "$c: MISSING (window will fall back to a shell)"; fi
	done

	info "Konsole keytab"
	if [ -f "$KONSOLE_DIR/$KEYTAB_NAME.keytab" ]; then step "installed: $KONSOLE_DIR/$KEYTAB_NAME.keytab"
	else warn "not installed - modified F1-F4 are sent as ESC O <mod> P (tmux cannot decode)"; fi
	local p
	for p in "$KONSOLE_DIR"/*.profile; do
		[ -e "$p" ] || continue
		local kb
		kb="$(kreadconfig6 --file "$p" --group Keyboard --key KeyBindings 2>/dev/null || true)"
		step "$(basename "$p"): KeyBindings=${kb:-<stock Default (XFree 4)>}"
	done

	info "shortcut conflicts"
	local h
	h="$(kreadconfig6 --file konsolerc --group Shortcuts --key help_contents 2>/dev/null || true)"
	[ "$h" = "none" ] && step "Konsole F1 (help) released" || warn "Konsole still grabs F1 (help_contents=${h:-default})"
	local k
	for k in Expose ExposeClass ExposeAll; do
		local v
		v="$(kreadconfig6 --file kglobalshortcutsrc --group kwin --key "$k" 2>/dev/null || true)"
		case "$v" in
			none*|"") : ;;
			*) warn "KWin $k = ${v%%,*} (steals that Ctrl+F.. from byobu; use --fix-kwin-shortcuts)" ;;
		esac
	done

	info "byobu window set"
	if [ -s "$BYOBU_DIR/windows.tmux" ]; then step "windows.tmux -> $(cat "$BYOBU_DIR/windows.tmux")"
	else warn "no default window set configured"; fi
	exit 0
}

[ "$DO_CHECK" = 1 ] && check_env

###############################################################################
command -v byobu >/dev/null 2>&1 || { echo "byobu is not installed (sudo dnf install byobu)" >&2; exit 1; }
init_backup
info "backup dir: $BK"

mkdir -p "$BYOBU_DIR"

###############################################################################
# 1. tmux side: user-keys fallback for Konsole's legacy modified F1-F4,
#               plus 1-based window numbering
###############################################################################
info "byobu/tmux: ~/.byobu/.tmux.conf"
backup_file "$BYOBU_DIR/.tmux.conf"
cat > "$BYOBU_DIR/.tmux.conf" <<'EOF'
###############################################################################
# managed by byobu_setup_fedora_konsole.sh - loaded last by byobu's tmuxrc
###############################################################################

# Windows numbered from 1, so the default window set reads 1:htop .. 4:codex
set -g base-index 1

# --- Konsole compatibility -------------------------------------------------
# Konsole's stock keytab sends SS3-with-modifier for modified F1-F4
# (ESC O 2 P for Shift-F1) instead of xterm's CSI form (ESC [ 1;2 P).
# tmux cannot decode that, so teach it those raw sequences as user-keys and
# bind them to the very same actions byobu binds to S-/C-/C-S- F1..F4.
# (Redundant once byobu.keytab is active, but keeps byobu usable in any
#  Konsole profile that still uses the stock table.)
set -s user-keys[10] "\033O2P"
set -s user-keys[11] "\033O2Q"
set -s user-keys[12] "\033O2R"
set -s user-keys[13] "\033O2S"
set -s user-keys[15] "\033O5Q"
set -s user-keys[16] "\033O5R"
set -s user-keys[17] "\033O5S"
set -s user-keys[19] "\033O6Q"
set -s user-keys[20] "\033O6R"
set -s user-keys[21] "\033O6S"

# Shift-F1 : byobu help  (tmux has no ${VAR:-default} syntax, so no $BYOBU_PAGER)
bind-key -n User10 new-window -n help "sh -c 'LESS=\"\" less /usr/share/doc/byobu/help.tmux.txt'"
# Shift-F2 : split horizontally (new pane below)
bind-key -n User11 display-panes \; split-window -v -c "#{pane_current_path}"
# Shift-F3 / Shift-F4 : previous / next pane
bind-key -n User12 display-panes \; select-pane -t :.-
bind-key -n User13 display-panes \; select-pane -t :.+
# Ctrl-F2 : split vertically (new pane to the right)
bind-key -n User15 display-panes \; split-window -h -c "#{pane_current_path}"
# Ctrl-F3 / Ctrl-F4 : move the current pane
bind-key -n User16 display-panes \; swap-pane -s :. -t :.- \; select-pane -t :.-
bind-key -n User17 display-panes \; swap-pane -s :. -t :.+ \; select-pane -t :.+
# Ctrl-Shift-F2 : new session
bind-key -n User19 new-session \; rename-window "-"
# Ctrl-Shift-F3 / Ctrl-Shift-F4 : move the current window
bind-key -n User20 swap-window -t :-1 -d
bind-key -n User21 swap-window -t :+1 -d
EOF

###############################################################################
# 2. byobu default window set
###############################################################################
info "byobu window set: 1:htop 2:ide 3:claude 4:codex"

# byobu passes the contents of windows.tmux to tmux as *command line words*
# (exec tmux ... $(cat windows.tmux)), so no shell quoting survives there.
# Keep it to "start-server ; source-file" (source-file alone does not spawn a
# server, so byobu would fail on the very first launch) and do the real work
# in a tmux config file where quoting behaves normally.
backup_file "$BYOBU_DIR/windows.tmux"
printf 'start-server ; source-file %s/layout.tmux\n' "$BYOBU_DIR" > "$BYOBU_DIR/windows.tmux"

backup_file "$BYOBU_DIR/layout.tmux"
cat > "$BYOBU_DIR/layout.tmux" <<EOF
###############################################################################
# managed by byobu_setup_fedora_konsole.sh
# Attach to session "$SESSION" if it already runs, otherwise create it and
# populate the default windows.
###############################################################################
new-session -A -d -s $SESSION -n htop 'PATH="\$HOME/.local/bin:\$PATH"; htop; exec \${SHELL:-/bin/bash}'
if-shell 'test "\$(tmux list-windows -t $SESSION 2>/dev/null | wc -l)" -le 1' 'source-file $BYOBU_DIR/layout-windows.tmux'
select-window -t $SESSION:1
attach-session -t $SESSION
EOF

backup_file "$BYOBU_DIR/layout-windows.tmux"
cat > "$BYOBU_DIR/layout-windows.tmux" <<EOF
###############################################################################
# managed by byobu_setup_fedora_konsole.sh
# Windows 2..4 of the default set (window 1 is created by layout.tmux).
###############################################################################
# nvim in IDE mode with the NvimTree file manager open
new-window -t $SESSION: -n ide -c '$IDE_DIR' 'PATH="\$HOME/.local/bin:\$PATH"; nvim -c NvimTreeToggle; exec \${SHELL:-/bin/bash}'
new-window -t $SESSION: -n claude 'PATH="\$HOME/.local/bin:\$PATH"; claude; exec \${SHELL:-/bin/bash}'
new-window -t $SESSION: -n codex  'PATH="\$HOME/.local/bin:\$PATH"; codex; exec \${SHELL:-/bin/bash}'
EOF

for c in htop nvim claude codex; do
	command -v "$c" >/dev/null 2>&1 || warn "$c not found in PATH - that window will drop to a shell"
done

###############################################################################
# 3. Konsole: xterm-compatible keytab + free F1
###############################################################################
if [ "$DO_KONSOLE" = 1 ] && command -v konsole >/dev/null 2>&1; then
	info "Konsole: installing xterm-compatible keytab"
	mkdir -p "$KONSOLE_DIR"
	backup_file "$KONSOLE_DIR/$KEYTAB_NAME.keytab"
	cat > "$KONSOLE_DIR/$KEYTAB_NAME.keytab" <<'EOF'
# [byobu.keytab] Konsole keyboard table - xterm/VTE compatible
#
# Based on Konsole's own "Default (XFree 4)" table, with two changes that
# byobu/tmux need (and that GNOME Terminal on Ubuntu already does):
#
#   * modified F1-F4 use the xterm CSI form   ESC [ 1 ; <mod> P..S
#     instead of Konsole's SS3 form           ESC O <mod> P..S
#   * Shift+arrows are sent to the application (ESC [ 1;2 A..D) instead of
#     being consumed by Konsole's "scroll one line" actions, so byobu's
#     Shift+Up/Down/Left/Right pane navigation works.
#
# Scrollback keys stay as usual: Shift+PgUp/PgDn scroll a page,
# Ctrl+Shift+PgUp/PgDn jump between prompts, Shift+Home/End jump to
# top/bottom (all only outside the alternate screen).

keyboard "Byobu (xterm-compatible F-keys)"

key Escape                  : "\E"

key Tab   -Shift            : "\t"
key Tab   +Shift+Ansi       : "\E[Z"
key Tab   +Shift-Ansi       : "\t"
key Backtab     +Ansi       : "\E[Z"
key Backtab     -Ansi       : "\t"
key Tab       +Control+Ansi : "\E[27;5;9~"
key Backtab   +Control+Ansi : "\E[27;6;9~"
key Tab       +Control-Ansi : "\t"
key Backtab   +Control-Ansi : "\t"

# Enter / Return.  Shift+Return sends plain CR like VTE does (Konsole's
# default "\EOM" confuses TUI apps).
key Return -Shift -NewLine  : "\r"
key Return -Shift +NewLine  : "\r\n"
key Return +Shift -NewLine  : "\r"
key Return +Shift +NewLine  : "\r\n"
key Enter        +NewLine   : "\r\n"
key Enter        -NewLine   : "\r"

key Backspace   -Control    : "\x7f"
key Backspace   +Control    : "\b"
key Space       +Control    : "\x00"

# Cursor keys - VT52 mode
key Up    -Shift-Ansi : "\EA"
key Down  -Shift-Ansi : "\EB"
key Right -Shift-Ansi : "\EC"
key Left  -Shift-Ansi : "\ED"

# Cursor keys - unmodified
key Up    -AnyMod+Ansi+AppCuKeys : "\EOA"
key Down  -AnyMod+Ansi+AppCuKeys : "\EOB"
key Right -AnyMod+Ansi+AppCuKeys : "\EOC"
key Left  -AnyMod+Ansi+AppCuKeys : "\EOD"
key Up    -AnyMod+Ansi-AppCuKeys : "\E[A"
key Down  -AnyMod+Ansi-AppCuKeys : "\E[B"
key Right -AnyMod+Ansi-AppCuKeys : "\E[C"
key Left  -AnyMod+Ansi-AppCuKeys : "\E[D"

# Cursor keys with any modifier (Shift included) - xterm CSI form
key Up    +AnyMod+Ansi : "\E[1;*A"
key Down  +AnyMod+Ansi : "\E[1;*B"
key Right +AnyMod+Ansi : "\E[1;*C"
key Left  +AnyMod+Ansi : "\E[1;*D"

# Home / End / Insert / Delete / Page keys
key Home  -AnyMod-AppCuKeys : "\E[H"
key End   -AnyMod-AppCuKeys : "\E[F"
key Home  -AnyMod+AppCuKeys : "\EOH"
key End   -AnyMod+AppCuKeys : "\EOF"
key Home  -Shift+AnyMod     : "\E[1;*H"
key End   -Shift+AnyMod     : "\E[1;*F"
key Insert      -AnyMod     : "\E[2~"
key Delete      -AnyMod     : "\E[3~"
key Insert      +AnyMod     : "\E[2;*~"
key Delete      +AnyMod     : "\E[3;*~"
key PgUp   -Shift-AnyMod    : "\E[5~"
key PgDown -Shift-AnyMod    : "\E[6~"
key PgUp   -Shift+AnyMod    : "\E[5;*~"
key PgDown -Shift+AnyMod    : "\E[6;*~"
key PgUp   +Shift+AppScreen : "\E[5;*~"
key PgDown +Shift+AppScreen : "\E[6;*~"
key Clear        +KeyPad    : "\E[E"

# Function keys, unmodified
key F1  -AnyMod : "\EOP"
key F2  -AnyMod : "\EOQ"
key F3  -AnyMod : "\EOR"
key F4  -AnyMod : "\EOS"
key F5  -AnyMod : "\E[15~"
key F6  -AnyMod : "\E[17~"
key F7  -AnyMod : "\E[18~"
key F8  -AnyMod : "\E[19~"
key F9  -AnyMod : "\E[20~"
key F10 -AnyMod : "\E[21~"
key F11 -AnyMod : "\E[23~"
key F12 -AnyMod : "\E[24~"

# Function keys with modifiers - CSI form, the one tmux/byobu understands
key F1  +AnyMod : "\E[1;*P"
key F2  +AnyMod : "\E[1;*Q"
key F3  +AnyMod : "\E[1;*R"
key F4  +AnyMod : "\E[1;*S"
key F5  +AnyMod : "\E[15;*~"
key F6  +AnyMod : "\E[17;*~"
key F7  +AnyMod : "\E[18;*~"
key F8  +AnyMod : "\E[19;*~"
key F9  +AnyMod : "\E[20;*~"
key F10 +AnyMod : "\E[21;*~"
key F11 +AnyMod : "\E[23;*~"
key F12 +AnyMod : "\E[24;*~"

# Konsole's own scrollback keys (kept)
key PgUp   -Ctrl+Shift-AppScreen : scrollPageUp
key PgDown -Ctrl+Shift-AppScreen : scrollPageDown
key PgUp   +Ctrl+Shift-AppScreen : scrollPromptUp
key PgDown +Ctrl+Shift-AppScreen : scrollPromptDown
key Home        +Shift-AppScreen : scrollUpToTop
key End         +Shift-AppScreen : scrollDownToBottom
EOF

	# point every Konsole profile at the new keytab
	shopt -s nullglob
	profiles=("$KONSOLE_DIR"/*.profile)
	shopt -u nullglob
	if [ ${#profiles[@]} -eq 0 ]; then
		warn "no Konsole profile in $KONSOLE_DIR - create one (Settings > Manage Profiles)"
		warn "then set its Keyboard translator to 'Byobu (xterm-compatible F-keys)'"
	else
		for p in "${profiles[@]}"; do
			step "profile $(basename "$p"): KeyBindings=$KEYTAB_NAME"
			backup_file "$p"
			kwriteconfig6 --file "$p" --group Keyboard --key KeyBindings "$KEYTAB_NAME"
		done
	fi

	# release F1 (Konsole Handbook) so byobu's help reaches tmux
	info "Konsole: releasing F1 (Handbook shortcut)"
	backup_file "$HOME/.config/konsolerc"
	kwriteconfig6 --file konsolerc --group Shortcuts --key help_contents "none"
else
	[ "$DO_KONSOLE" = 1 ] && warn "konsole not installed - skipping terminal part"
fi

###############################################################################
# 4. optional: release KWin's Ctrl+F7/F9/F10 (Present Windows effects)
###############################################################################
if [ "$DO_KWIN" = 1 ]; then
	info "KWin: releasing Ctrl+F7 / Ctrl+F9 / Ctrl+F10"
	backup_file "$HOME/.config/kglobalshortcutsrc"
	for k in Expose ExposeClass ExposeAll; do
		kwriteconfig6 --file kglobalshortcutsrc --group kwin --key "$k" "none,none,"
	done
	if command -v qdbus6 >/dev/null 2>&1; then
		qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
	fi
	warn "log out/in (or restart plasmashell) if the shortcuts are still grabbed"
fi

###############################################################################
# 5. optional: start byobu automatically on text login (Ubuntu-like)
###############################################################################
if [ "$DO_AUTOSTART" = 1 ]; then
	info "enabling byobu autostart at login"
	byobu-enable >/dev/null
	# byobu-enable only touches ~/.profile /~/.bash_profile; zsh needs ~/.zprofile
	case "${SHELL:-}" in
		*zsh)
			line='_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true'
			if ! grep -qF 'byobu-launch' "$HOME/.zprofile" 2>/dev/null; then
				backup_file "$HOME/.zprofile"
				printf '\n%s\n' "$line" >> "$HOME/.zprofile"
				step "added byobu-launch to ~/.zprofile"
			fi
		;;
	esac
fi

###############################################################################
info "done"
cat <<EOF

Next steps
----------
1) Close ALL Konsole windows and open a new one (Konsole reads the keytab and
   its own shortcuts only at startup).  Running byobu/tmux sessions survive.
2) Inside byobu press F5 once (reload profile) or just start a new session.
3) Verify:  F2 new window, F3/F4 prev/next window, Shift-F2 split down,
   Ctrl-F2 split right, Shift-F3/F4 switch pane, Shift-arrows switch pane,
   F6 detach, F7 scrollback, F8 rename, F9 config, Shift-F11 zoom pane.

Default window set: 1:htop  2:ide (nvim+NvimTree)  3:claude  4:codex
  byobu            -> attach to session "$SESSION" or create it with those windows
  BYOBU_WINDOWS=work byobu  -> use ~/.byobu/windows.tmux.work instead

Diagnose:  $0 --check
Undo:      $0 --revert
EOF
