# Config
session="geovim"
# terminal_app="alacritty" # Process name for the terminal GUI
terminal_app="kitty" # Process name for the terminal GUI
if [[ -n "${GEOVIM_TERM+set}" ]]; then
  terminal_app="$GEOVIM_TERM"
fi
app_to_launch="nvim"
if [[ -n "${GEOVIM_EDITOR+set}" ]]; then
  app_to_launch="$GEOVIM_EDITOR"
fi
use_tmux=1
if [[ -n "${GEOVIM_TMUX+set}" ]]; then
  use_tmux="$GEOVIM_TMUX"
fi
autorestore=1 # Whether or not TMUX sessions are auto-restored on launch
use_custom_sessions=0 # 1 - use Obsess plugin or 0 - load sessions manually

tmux_command=""
# Vim Commands
edit_file_cmd=(Escape ":e $1" Enter)
new_tab_cmd=("" Escape ":tabnew" Enter)

kitty_native=0
if [[ $use_tmux == 0 && $terminal_app == "kitty" ]]; then
  # Use native kitty api
  kitty_native=1
fi

function open_gui() {
  # if [[ "$1" == '--front' ]]; then
  #   local bring_to_front=1
  #   local app_args=
  # fi
  local command="$@"
  if [[ "$terminal_app" == "kitty" ]]; then
    # Use this to launch kitty if not using macOS
    if [[ "$use_tmux" == 1 ]]; then
      if [[ -z "$command" ]]; then
        # Bring window to front if called with no args
        kitty @ --to unix:/tmp/geovim focus-window
      else
        if [[ "$TERM" == "xterm-kitty" ]]; then
          GEOVIM=1 nohup kitty -d="`pwd`" -1 --instance-group="$session" --listen-on=unix:/tmp/geovim --config "$GEOVIM_PATH/conf/kitty.conf" $command >/dev/null 2>&1 &
        else
          # If terminal is not kitty, we need to use this workaround to launch
          GEOVIM=1 nohup kitty -d="`pwd`" -1 --instance-group="$session" --listen-on=unix:/tmp/geovim --config "$GEOVIM_PATH/conf/kitty.conf" --session "$GEOVIM_PATH/kitty_geovim.init" >/dev/null 2>&1 &
          # open $app_args -a /Applications/kitty.app --args -d="`pwd`" -1 --instance-group="$session" --listen-on=unix:/tmp/geovim --config "$GEOVIM_PATH/conf/kitty.conf" --session "$GEOVIM_PATH/kitty_geovim.init"
        fi
      fi
    else
      GEOVIM=1 nohup kitty -d="`pwd`" -1 --instance-group="$session" --listen-on=unix:/tmp/geovim --config "$GEOVIM_PATH/conf/kitty.conf" $command >/dev/null 2>&1 &
    fi
  else
    if [[ -z "$command" ]]; then
      echo 'Alacritty is already open. Check the window.'
    else
      GEOVIM=1 nohup alacritty --working-directory="`pwd`" --config-file="$GEOVIM_PATH/conf/alacritty.yml" -e sh -c "$command" >/dev/null 2>&1 &
    fi
  fi
}

function send_keys() {
  local target="$1"

  if [[ $kitty_native -eq 1 ]]; then
    if [[ -n $target ]]; then
      kitty @ --to unix:/tmp/geovim send-text -m "cwd:$target" "${@:2}"
    else
      kitty @ --to unix:/tmp/geovim send-text "${@:2}"
    fi
  else
    if [[ -n $target ]]; then
      tmux send-keys "-t" "$target" "${@:2}"
    else
      tmux send-keys "${@:2}"
    fi
  fi
}

function select_window() {
  tmux select-window -t "$1"
}

function new_window() {
  tmux new-window -a -t "$session" -e GEOVIM=1
}

function get_project_name() {
  local dir=`pwd`
  local dir=${dir/$HOME\//}
  echo ${dir//\//_}
}
function launchAppTmux() {
  local app="$1"
  local args="${@:2}"

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
  send_new_file "$args"
  # if [[ -n "$app" ]]; then
  #   # If app is empty, assume we are forcing a new window of the current app
  #   open_gui "" tmux attach -t "$session"
  # else
  open_gui tmux attach -t "$session"
  # fi
}

function launchApp() {
  if [[ $terminal_app == "kitty" ]]; then
    open_gui "$1"
  else
    open_gui "TERM=alacritty $1"
  fi
}

function send_new_file() {
  # Send new file to active instance
  local target=($(tmux run-shell "tmux list-panes -s -F '##{session_name}:##{window_index}.##{pane_index} ##{pane_pid} ##{window_name} ##{pane_current_path}' | grep -e `pwd`$"))
  # @TODO: Iterate list of panes and check if pwd is child directory

  # Check if above command received an error
  echo "${target[@]}" | grep -e "returned [^0]$" > /dev/null
  if [[ $? -eq 1 ]]; then
    # Current project is open
    select_window "${target[0]}"
    local pid="${target[1]}"
    local pid_name=$(ps -p "$pid" -o comm=)
    local window_name="${target[2]}"

    if [[ "$pid_name" != 'nvim' && "$pid_name" != 'vim' && "$pid_name" != 'vi'\
      && "$window_name" != 'nvim' && "$window_name" != 'vim' && "$window_name" != 'vi' ]]; then
      # Open vim first
      send_keys "" "exec $app_to_launch$vim_session" Enter
    fi

    if [[ -n "$1" ]]; then
      # Create new tab and then open file
      send_keys "" "${new_tab_cmd[@]}" "${edit_file_cmd[@]}"
    fi
  else
    # Create new project window
    new_window -a -t "$session" -e GEOVIM=1
    if [[ -n "$1" ]]; then
      # Open file
      send_keys "" "${edit_file_cmd[@]}"
    fi
  fi

  if [[ ! -n "$1" ]]; then
    if [[ $use_custom_sessions == 0 ]]; then
      # Start Vim session tracking if we did not open a specific file and no
      # session exists
      send_keys "" Escape ":if ObsessionStatus() != '[S]' && ObsessionStatus() != '[$]' | Obsess | endif" Enter
    fi
  fi
}

vim_session=""
function mvim() {
  vim_args="$@"
  win_group=""
  if [[ "$1" == "-n" ]]; then
    # Force a new window group
    win_group="$2"
    vim_args=${@:3}
  fi

  if [[ $use_custom_sessions == 0 ]]; then
    if [ -f "Session.vim" ]; then
      vim_session=" -S Session.vim"
    elif [ -f ".vim.session" ]; then
      vim_session=" -S .vim.session"
    fi
  fi
  if [[ $use_tmux == 1 ]]; then

    tmux has-session -t "$session" 2>/dev/null
    if [ $? != 0 ]; then
      # TMUX not running. Create new session.
      launchAppTmux "$app_to_launch" "$vim_args"
    else
      # Open existing session
      if pgrep "${terminal_app}"; then
        if [[ -n "$win_group" ]]; then
          launchAppTmux "" "$vim_args"
        else
          # Bring GUI to forefront
          if [[ "$terminal_app" != "kitty" ]] || [ -S /tmp/geovim ]; then
            open_gui
          else
            # Geovim is not actually open
            open_gui tmux attach -t "$session"
          fi
        fi
      else
        # GUI is not running, but TMUX is. Re-attach.
        open_gui tmux attach -t "$session"
      fi
      send_new_file $vim_args
    fi
  else
    launchApp "$app_to_launch$vim_session $vim_args"
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
