# umask, different if root
[ "$(id -u)" != 0 ] && umask 027 || umask 022