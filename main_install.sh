# partition disk
# TODO: disk selection input

# fdisk /dev/sd..
# mkfs.ext3 -L ROOT /dev/sd..
# mkswap -L SWAP /dev/sd..



# prepare and mount disks
mkdir /mnt/gentoo
mount /dev/sda2 /mnt/gentoo
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/home



# download and extract the latest stage3


cd /mnt/gentoo
#links http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
links http://www.mirrorservice.org/sites/distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
tar xvjpf stage3*
cd



# copy make.conf
cd 001/config/etc/portage/
cp make.conf /mnt/gentoo/etc/portage/make.conf
cd


# TODO: copy required config files
#	create modified world file
#	add kernel config file


# prepare chroot environment
cp -L /etc/resolv.conf /mnt/gentoo/etc/resolv.conf
mount -t proc none /mnt/gentoo/proc
mount -o bind /dev /mnt/gentoo/dev



# chroot
chroot /mnt/gentoo /bin/bash
env-update
source /etc/profile
export PS1="(chroot) $PS1"



# update portage tree. install new packages.
mkdir /usr/portage;
sh qq



# configure system locale
locale-gen

cp /usr/share/zoneinfo/GMT /etc/localtime


# install configure kernel. edit world file instead
emerge hardened-sources dhcpcd grub
genkernel --menuconfig all --makeopts="-j6"
grub2-mkconfig - /boot/grub/grub.config
grub2-mkconfig - /boot/grub/grub.config


# exit session and unmount
exit
cd
umount /mnt/gentoo/boot /mnt/gentoo/dev /mnt/gentoo/proc
umount /mnt/gentoo/home /mnt/gentoo
reboot









