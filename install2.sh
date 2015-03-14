# secondary install format

function start02 {
	OPTIONS="Start Menu"
	select opt in $OPTIONS; do
		if [ "$opt" = "Start" ]; then
			execfunc02
		elif [ "$opt" = "Menu" ]; then
			menu02
		else
			echo invalid option
		fi
	done
}

function menu02 {
	OPTIONS="CreateUser Clean Quit"
	select opt in $OPTIONS; do
		case $opt in
			"CreateUser")
				env04
				;;
			"Clean")
				sys02
				;;
			"Quit")
				exit
				;;
			*) echo invalid option;;
		esac
	done
}

function qcontinue02 {
	echo; read -p "Continue y/n?" -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then; echo
	else
	start02
	fi; echo
}

function exit01 {
read -p "Exit Session?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		exit
	else
	start02
	fi
}

function execfunc02 {
	env04
	qcontinue02
	sys02
	echo Finished. ; echo
	exit01
}

function env04 {
	read -p "Enter Username" usr; echo
	read -p "Is $usr correct?" -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		useradd -m -G users,wheel,audio -s /bin/bash $usr
		passwd $usr
	else
		env04
	fi
}

function sys02 {
	rm /stage3-*.tar.bz2
	rm /portage-*.tar.bz2
	#rm /001-master -R
}

start02


# sh /environment/install.sh
