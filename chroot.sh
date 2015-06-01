#!/bin/bash
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
	OPTIONS="UpdateShell ConfigurePortage SelectSystemProfile ConfigureLocale Kernel Grub SetPasswd Quit"
	select opt in $OPTIONS; do
		case $opt in
			"UpdateShell")
				env00
				;;
			"ConfigurePortage")
				sys00
				;;
			"SelectSystemProfile")
				env01
				;;
			"ConfigureLocale")
				env02
				;;
			"Kernel")
				sys01
				;;
			"Grub")
				sys02
				;;

			"SetPasswd")
				env03
				;;
			"Quit")
				exit00
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
#	env01
	qcontinue01
	env02
	qcontinue01
	sys01
	qcontinue01
	sys02
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

# it doesnt look like this is necessary
function env01 {
	eselect profile list
	read -p "Enter Number for \"hardened/linux/amd64\" " profile
	read -p "Is $profile correct?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		eselect profile set $profile
	else 
		env01
	fi
}

function env02 {
	locale-gen
}

# clean
function sys01 {
	echo KERNEL
	echo NOTE: This kernel requires GCC 4.9 and lz4. updating gcc requires gcc-config. 
	echo disable \'mknod\' and \'Deny mounts\' kernel configs from compiler system with grsec kernel prior to build.
	emerge hardened-sources genkernel grub os-prober dhcpcd gcc app-arch/lz4 vim
	gcc-config -l
	read -p "Enter Number for \"x86_64-pc-linux-gnu-4.9.2 or later\" " gcc
	read -p "Is $gcc correct?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		gcc-config $gcc
	else
		# modify
		gcc-config -l
	fi
	env-update && source /etc/profile
	emerge --oneshot libtool
	# su; eselect kernel
	cp /001-master/config/usr/src/linux/.superkoala-* /usr/src/linux/
	cd /usr/src/linux; ls -al; cd
	genkernel --menuconfig all --makeopts=-j6
}

function sys02 {
#	ensure fstab root dir is correct for fsid
#
#	TODO:	fix
#		efi
#
#	do this before chroot
#	mount /boot/efi
	
	echo The EFI partition identifier needs to be listed correctly in fstab.
	echo When vim loads the fstab file, ensure that the line: 
	echo \/dev\/EFI-identifier    \/boot\/efi    vfat    noauto,noatime 1 2
	echo is entered with key command \'i\' and saved with key command: :qw
	qcontinue01
	vim /etc/fstab
	read -p "Is the modification correct?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
	else
		sys02
	fi

	mkdir /boot/grub

	grep -v rootfs /proc/mounts > /etc/mtab

	grub2-install --target=x86_64-efi #/dev/sda1

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
		start01
	fi
}

start01



# check
# debug
