env-update
source /etc/profile

echo
echo Configure Portage
mkdir /usr/portage
mkdir /usr/local/portage

cp /etc/portage/make.conf /var/lib/layman/make.conf

emerge-webrsync

eselect profile list

read -p "Enter Number for \"hardened/linux/amd64\" " profile
read -p "Is $profile correct?" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
eselect profile set $profile
fi


locale-gen

echo KERNEL
echo NOTE: This kernel requires GCC 4.9 and lz4. updating gcc requires gcc-config. 
echo compiling the kernel with a grsec kernel configured to use chroot restrictions should not have mknod enabled prior to kernel compile.
emerge hardened-sources genkernel grub os-prober dhcpcd gcc lz4

# su; eselect kernel

cp /001-master/config/usr/src/linux/.superkoala-8.0 /usr/src/linux/.superkoala-8.0
genkernel --menuconfig all --makeopts=-j6

# ensure fstab root dir is correct for fsid

grub2-mkconfig -o /boot/grub/grub.cfg
grub2-mkconfig -o /boot/grub/grub.cfg
echo
echo
echo Set Root Password - ensure correct keymap
passwd
echo
echo

echo Reboot and run secondary install
read -p "Reboot now?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
reboot
fi