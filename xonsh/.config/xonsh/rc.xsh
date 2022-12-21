xontrib load fish_completer
xontrib load coreutils
$PROMPT = '┌─ {env_name}{GREEN}{user}{YELLOW}@{hostname}:{CYAN}{cwd}{RESET} {gitstatus}\n└╼ '
$AUTO_CD = True
source-bash $XDG_CONFIG_HOME/profile.d/aliases.sh &>/dev/null
source-bash $XDG_CONFIG_HOME/profile.d/environment.sh &>/dev/null
