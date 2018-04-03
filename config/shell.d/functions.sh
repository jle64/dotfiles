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
        . ~/.config/base16-shell/base16-"$1".sh
}

theme_rand() {
	theme `sort -R << EOF
	ashes.dark
	atelierlakeside.dark
	bright.dark
	codeschool.dark
	harmonic16.dark
	isotope.dark
	monokai.dark
	shapeshifter.dark
	solarized.dark
	tomorrow.dark
	solarized.light
	atelierlakeside.light
EOF`
}
