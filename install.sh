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
	lsfs00
	lsfs01
	mkfs00
	qcontinue
	lsfs02
	qcontinue
	inst00
	qcontinue
	stage3
	qcontinue
	config
	qcontinue
	inst01
	qcontinue
	inst02
	qcontinue
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

function lsfs00 {
	echo Available Installation Media:
	echo
	lsscsi
	echo
}
 
function lsfs01 {
	read -p "Enter Filesystem Idendifier (dev): " fsid00
	echo
	read -p "Is $fsid00 correct?" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	echo 
	lsblk $fsid00
	else
	echo
	lsfs01
	fi
	echo
}

function mkfs00 {
	read -p "Enter Parition Idendifier (dev): " fsid01
	echo
	read -p "Is $fsid01 correct? Enter Y to format partition $fsid01" -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	umount /mnt/gentoo01
	mkfs.ext4 -L GENTOO $fsid01
	fi
}

function lsfs02 {
	echo Installation Media Updated:
	echo
	lsscsi
	echo
	lsblk $fsid00
	echo
	lsblk $fsid01
}

function inst00 {
	echo Preparing for chroot...
	mkdir /mnt/gentoo01
	mount $fsid01 /mnt/gentoo01
	mkdir /mnt/gentoo01/boot
	mkdir /mnt/gentoo01/home
	echo Done.
}

function stage3 {
	cd /mnt/gentoo01
	echo press q to exit links. Download the latest multilib Stage3 in
	echo;echo 3;sleep 1; echo 2; sleep 1; echo 1; sleep 1;
	#links http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
	links http://www.mirrorservice.org/sites/distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
	echo Extracting Stage 3..
	tar xvjpf stage3*
	cd
}

function config {
	cd /mnt/gentoo01
	echo Download initial config files
	wget https://github.com/koahv/001/archive/master.zip
	unzip master.zip 
	cp 001-master/config/etc/ /mnt/gentoo01/ -R
	cp 001-master/config/usr/share/zoneinfo/GMT /mnt/gentoo01/etc/localtime
	cp 001-master/config/var/lib/portage/ /mnt/gentoo01/var/lib/portage/ -R
	cd
}

function inst01 {
	echo Preparing chroot..
	cp -L /etc/resolv.conf /mnt/gentoo01/etc/resolv.conf
	mount -t proc none /mnt/gentoo01/proc
	mount -o bind /dev /mnt/gentoo01/dev
}

function inst02 {
	echo Chrooting. Now run chroot-install.sh
	chroot /mnt/gentoo01 /001-master/chroot.sh
	env-update
	source /etc/profile
	export PS1="(chroot) $PS1"
}

function finish {
	echo Reboot and run secondary install
	read -p "Reboot now?" -n 1 -r
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	reboot
	else
	echo
	fi
}


start00








