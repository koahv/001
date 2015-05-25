# Main Install format
# Run this script as root -- su

function start00 {
	OPTIONS="Start Menu"
	select opt in $OPTIONS; do
		if [ "$opt" = "Start" ]; then
			execfunc00
		elif [ "$opt" = "Menu" ]; then
			menu00
		else
			echo invalid option
		fi
	done
}

function execfunc00 {
	echo You need to configure partitions prior to install. The script requires one \(225mb\) FAT32 EFI partition at the start of the drive and one partition for the system. This type of installation does not yet separate the root filesystem and any home directories into different partitions. Troubleshoot fstab first if necessary.
	qcontinue00
	lsfs00
	lsfs01
	mkfs00
	lsfs02
	inst00
	stage3
	config
	qcontinue00
	inst01
	qcontinue00
	inst02
	qcontinue00
	finish
}

function menu00 {
	OPTIONS="ListMedia ListPartition mkfs PrepareChroot00 DownloadStage3 FSConfig PrepareChroot01 Chroot Reboot Quit"
	select opt in $OPTIONS; do
		case $opt in
			"ListMedia")
				lsfs00
				;;
			"ListPartition")
				lsfs01
				;;
			"mkfs")
				mkfs00
				;;
			"PrepareChroot00")
				inst00
				;;
			"DownloadStage3")
				stage3
				;;
			"FSConfig")
				config
				;;
			"PrepareChroot01")
				inst01
				;;
			"Chroot")
				inst02
				;;
			"Reboot")
				finish
				;;
			"Quit")
				exit
				;;
			*) echo invalid option;;
		esac
	done
}

function qcontinue00 {
	read -p "Continue y/n?" -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		echo
	else
		start00
	fi
}

function lsfs00 {
	echo Available Installation Media:; echo
	lsscsi
}
 
function lsfs01 {
	read -p "Enter Filesystem Idendifier (dev): " fsid00; echo
	read -p "Is $fsid00 correct?" -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		lsblk $fsid00
	else
		lsfs01
	fi
}

function mkfs00 {
	read -p "Enter Parition Idendifier (dev): " fsid01; echo
	read -p "Is $fsid01 correct? Enter Y to format partition $fsid01" -n 1 -r; echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		umount /mnt/gentoo01
		mkfs.ext4 -L GENTOO $fsid01
	fi
}

function lsfs02 {
	echo Installation Media Updated:; echo
	lsscsi;	echo
	lsblk $fsid00; echo
	lsblk $fsid01


# running this from menu requires mkfs+ first due to fsid01 identifier
function inst00 {
	echo Preparing for chroot...
	mkdir /mnt/gentoo01
	mount $fsid01 /mnt/gentoo01
	mkdir /mnt/gentoo01/boot
	mkdir /mnt/gentoo01/home
	echo Done.
#	
#	!!TODO!!!!!!!!!!!!!!
#	!!GET SDA1 AS FSID!!
#	!!!!!!!!!!!!!!!!!!!!
	mount /dev/sda1 /mnt/gentoo01/boot/efi
}

function stage3 {
	cd /mnt/gentoo01
	echo press q to exit links. Download the latest multilib Stage3
	qcontinue00
	echo;echo 3;sleep 1; echo 2; sleep 1; echo 1; sleep 1;
	# local mirror during development
	# links http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
	links http://www.mirrorservice.org/sites/distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
	echo Extracting Stage 3..
	tar xvjpf stage3*
	cd
}

function config {
	cd /mnt/gentoo01
	echo Download initial config files
	rm 001-master* -R
	rm master*
	wget https://github.com/koahv/001/archive/master.zip
	unzip master.zip 
	cp 001-master/config/etc/ /mnt/gentoo01/ -R
	cp 001-master/config/usr/share/zoneinfo/GMT /mnt/gentoo01/etc/localtime
	cp 001-master/config/var/lib/portage/ /mnt/gentoo01/var/lib/ -R
	cd
}

function inst01 {
	echo Preparing chroot..
	cp -L /etc/resolv.conf /mnt/gentoo01/etc/resolv.conf
	mount -t proc none /mnt/gentoo01/proc
	mount -o bind /dev /mnt/gentoo01/dev
	mount /boot/efi
}

function inst02 {
	echo Chrooting. Now run chroot.sh in the 001-master dir.
	#chroot /mnt/gentoo01 /001-master/chroot.sh	!
	chroot /mnt/gentoo01 /bin/bash
	env-update
	source /etc/profile
	export PS1="(chroot) $PS1"
}

function finish {
	echo Reboot and run secondary install
	read -p "Reboot now?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		reboot
	else
		echo
	fi
}


start00


# check
# debug








