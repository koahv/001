# Chroot Install format

function start01 {
	OPTIONS="Start Menu"
	select opt in $OPTIONS; do
		if [ "$opt" = "Start" ]; then
			execfunc01
		elif [ "$opt" = "Menu" ]; then
			menu01
		else
			echo invalid option
		fi
	done
}

function menu01 {
	OPTIONS="UpdateShell ConfigurePortage SelectSystemProfile ConfigureLocale Kernel SetPasswd Quit"
	select opt in $OPTIONS; do
		case $opt in
			"UpdateShell")
				mkfs00
				;;
			"ConfigurePortage")
				inst00
				;;
			"SelectSystemProfile")
				stage3
				;;
			"ConfigureLocale")
				config
				;;
			"Kernel")
				inst01
				;;
			"SetPasswd")
				inst02
				;;
			"Quit")
				exit
				;;
			*) echo invalid option;;
		esac
	done
}

function qcontinue01 {
	echo
	read -p "Continue y/n?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
	else
	start00
	fi
	echo
}

function execfunc01 {
env00
sys00
qcontinue01
env01
qcontinue01
env02
qcontinue01
sys01
qcontinue01
env03
exit00
}

function env00 {
	env-update
	source /etc/profile
}

function sys00 {
	echo
	echo Configure Portage
	mkdir /usr/portage
	mkdir /usr/local/portage
	cp /etc/portage/make.conf /var/lib/layman/make.conf
	emerge-webrsync
}

function env01 {
	eselect profile list
	read -p "Enter Number for \"hardened/linux/amd64\" " profile
	read -p "Is $profile correct?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	eselect profile set $profile
	fi
}

function env02 {
	locale-gen
}

function sys01 {
	echo KERNEL
	echo NOTE: This kernel requires GCC 4.9 and lz4. updating gcc requires gcc-config. 
	echo disable mknod kernel config from compiler system with gresec kernel prior to build.
	emerge hardened-sources genkernel grub os-prober dhcpcd gcc lz4
	# su; eselect kernel
	cp /001-master/config/usr/src/linux/.superkoala-8.0 /usr/src/linux/.superkoala-8.0
	genkernel --menuconfig all --makeopts=-j6
	# ensure fstab root dir is correct for fsid
	grub2-mkconfig -o /boot/grub/grub.cfg
	grub2-mkconfig -o /boot/grub/grub.cfg
}

function env03 {
	echo
	echo Set Root Password - ensure correct keymap
	passwd
	echo
}

function exit00 {
read -p "Exit Chroot Session?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		exit
	else
	start00
	fi
}

start00


