# Initialization: activate autoenv or report its absence
() {
local d autoenv_dir install_locations
if ! type autoenv_init >/dev/null; then
  # Check if activate.sh is in $PATH
  if (( $+commands[activate.sh] )); then
    autoenv_dir="${commands[activate.sh]:h}"
  fi

  # Locate autoenv installation
  if [[ -z $autoenv_dir ]]; then
    install_locations=(
      ~/.autoenv
      ${XDG_DATA_HOME}/bin
      /usr/local/opt/autoenv
      /opt/homebrew/opt/autoenv
      /usr/local/bin
      /usr/share/autoenv-git
      ~/Library/Python/bin
      .venv/bin
      venv/bin
      env/bin
      .env/bin
    )
    for d ( $install_locations ); do
      if [[ -e $d/activate || -e $d/activate.sh ]]; then
        autoenv_dir=$d
        break
      fi
    done
  fi

  # Look for Homebrew path as a last resort
  if [[ -z "$autoenv_dir" ]] && (( $+commands[brew] )); then
    d=$(brew --prefix)/opt/autoenv
    if [[ -e $d/activate || -e $d/activate.sh ]]; then
      autoenv_dir=$d
    fi
  fi

  # Complain if autoenv is not installed
  if [[ -z $autoenv_dir ]]; then
    cat <<END >&2
-------- AUTOENV ---------
Could not locate autoenv installation.
Please check if autoenv is correctly installed.
In the meantime the autoenv plugin is DISABLED.
--------------------------
END
    return 1
  fi
  # Load autoenv
  if [[ -e $autoenv_dir/activate ]]; then
    source $autoenv_dir/activate
  else
    source $autoenv_dir/activate.sh
  fi
fi
}
[[ $? != 0 ]] && return $?

# The use_env call below is a reusable command to activate/create a new Python
# virtualenv, requiring only a single declarative line of code in your .env files.
# It only performs an action if the requested virtualenv is not the current one.

use_env() {
  local venv
  venv="$1"
  if [[ "${VIRTUAL_ENV:t}" != "$venv" ]]; then
    if workon | grep -q "$venv"; then
      workon "$venv"
    else
      echo -n "Create virtualenv $venv now? (Yn) "
      read answer
      if [[ "$answer" == "Y" ]]; then
        mkvirtualenv "$venv"
      fi
    fi
  fi
}
