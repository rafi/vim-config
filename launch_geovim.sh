# Config
session="nvim"
terminal_app="alacritty" # Process name for the terminal GUI
terminal_gui=(/Applications/Alacritty.app --args --working-directory="`pwd`")
app_to_launch="nvim"
use_tmux=1
autorestore=1 # Whether or not TMUX sessions are auto-restored on launch
use_custom_sessions=0 # 1 - use Obsess plugin or 0 - load sessions manually

tmux_command=""
# Vim Commands
edit_file_cmd=(Escape ":e $1" Enter)
new_tab_cmd=("" Escape ":tabnew" Enter)

send_keys_r=""
function send_keys() {
  local target="$1"
  if [[ -n $target ]]; then
    send_keys_r=(send-keys "-t" "$target" "${@:2}")
  else
    send_keys_r=(send-keys "${@:2}")
  fi
}

function get_project_name() {
  local dir=`pwd`
  local dir=${dir/$HOME\//}
  echo ${dir//\//_}
}
function launchAppTmux() {
  local app="$1"
  local vim_session="$2"
  local args="${@:3}"

  if [[ -f "$HOME/.tmux/resurrect/last" && $autorestore == 1 ]]; then
    # Restore TMUX session
    # ENV variables are sent so tmux-resurrect will re-launch Vim manually
    # due to issues with tmux-continuum auto-resurrect and tmux-resurrect's Vim
    # restore strategy
    GEOVIM=1 tmux new -d -A -s "$session"
    tmux if-shell "true" "run-shell 'bash \$(tmux show-option -gqv @resurrect-restore-script-path)'"
  else
    tmux new -d -A -s "$session" "$app$vim_session"
  fi
  open -a "${terminal_gui[@]}" -e tmux attach -t "$session"
  send_new_file "$args"
}

function launchApp() {
  open -n -a "${terminal_gui[@]}" -e sh -c "$1"
}

function send_new_file() {
  # Send new file to active instance
  local target=($(tmux run-shell "tmux list-panes -s -F '##{session_name}:##{window_index}.##{pane_index} ##{pane_pid} ##{pane_current_path}' | grep -e `pwd`$"))
  # @TODO: Iterate list of panes and check if pwd is child directory

  # Check if above command received an error
  echo "${target[@]}" | grep -e "returned [^0]$" > /dev/null
  if [[ $? -eq 1 ]]; then
    # Current project is open
    tmux select-window -t "${target[0]}"
    local pid="${target[1]}"
    local pid_name=$(ps -p "$pid" -o comm=)

    if [[ "$pid_name" != 'nvim' && "$pid_name" != 'vim' && "$pid_name" != 'vi' ]]; then
      # Open vim first
      send_keys "" "exec $app_to_launch -S" Enter
      tmux "${send_keys_r[@]}"
    fi

    if [[ -n "$1" ]]; then
      # Create new tab and then open file
      send_keys "" "${new_tab_cmd[@]}" "${edit_file_cmd[@]}"
      tmux "${send_keys_r[@]}"
    fi
  else
    # Create new project window
    tmux new-window -a -t "$session" -e GEOVIM=1
    if [[ -n "$1" ]]; then
      # Open file
      send_keys "" "${edit_file_cmd[@]}"
      tmux "${send_keys_r[@]}"
    fi

    if [[ ! -n "$1" ]]; then
      if [[ $use_custom_sessions == 0 ]]; then
        # Start Vim session tracking if we did not open a specific file and no
        # session exists
        send_keys "" Escape ":if !ObsessionStatus() | Obsess | endif" Enter
        tmux "${send_keys_r[@]}"
      fi
    fi
  fi
}

function mvim() {
  if [[ $use_tmux == 1 ]]; then
    local vimsession=""
    if [[ $use_custom_sessions == 0 ]]; then
      if [ -f "Session.vim" ]; then
        vimsession=" -S Session.vim"
      elif [ -f ".vim.session" ]; then
        vimsession=" -S .vim.session"
      fi
    fi

    tmux has-session -t "$session" 2>/dev/null
    if [ $? != 0 ]; then
      # TMUX not running. Create new session.
      launchAppTmux "$app_to_launch" "$vimsession" "$@"
    else
      # Open existing session
      if pgrep "${terminal_app}"; then
        # Bring GUI to forefront
        open -a "${terminal_gui[@]}"
      else
        # GUI is not running, but TMUX is. Re-attach.
        open -a "${terminal_gui[@]}" -e tmux attach -s "$session"
      fi
      send_new_file $@
    fi
  else
    launchApp "TERM=alacritty $app_to_launch ${vimsession[@]} $@"
  fi
}

function tmux_hook() {
  # Auto launch an app in TMUX
  local _GEOVIM=$GEOVIM # Clear this so that :terminal works within the nvim instance
  unset GEOVIM # Clear this so that :terminal in vim doesn't launch nvim again

  if [[ $_GEOVIM == 1 ]]; then
    # Launch the target app in the new TMUX window
    # Because we "exec" in the same process, tmux-resurrect does not re-spawn the
    # process automatically
    exec $app_to_launch -S
  else
    exec $SHELL
  fi
}

if [[ $1 == '-hook' ]]; then
  tmux_hook
else
  mvim $@
fi
