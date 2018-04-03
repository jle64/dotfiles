cl() {
	cd "$1" && ls
}

md() {
	mkdir -p "$1" && cd "$1"
}

h() {
	test -z "$1" && history || history | egrep -i "$1"
}

theme() {
        . "${XDG_CONFIG_HOME}"/base16-shell/scripts/base16-"$1".sh
}

theme_rand() {
	theme `sort -R << EOF
	ashes
	atelier-heath
	atelier-lakeside
	bright
	codeschool
	harmonic-dark
	isotope
	monokai
	shapeshifter
	solarized-dark
	tomorrow
	solarized-light
	atelier-lakeside-light
EOF`
}
