xontrib load fish_completer
xontrib load coreutils
xontrib load jedi
xontrib load pipeliner
xontrib load up

$PROMPT = '┌─{RED}{last_return_code_if_nonzero} {env_name}{GREEN}{user}{YELLOW}@{hostname}:{CYAN}{cwd}{RESET} {gitstatus}\n└╼ '

# OSC 133 - keep after prompt for it to work
#xontrib load term_integration

$XONSH_HISTORY_BACKEND = 'sqlite'
$HISTCONTROL = 'ignoredups'
$MULTILINE_PROMPT = ' '
$MOUSE_SUPPORT = True
$AUTO_CD = True

# cheat and load our aliases from bash
source-bash $XDG_CONFIG_HOME/profile.d/aliases.sh &>/dev/null
source-bash $XDG_CONFIG_HOME/profile.d/environment.sh &>/dev/null
