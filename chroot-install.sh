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
echo NOTE: This kernel requires GCC 4.9 and lz4
emerge hardened-sources genkernel grub dhcpcd gcc lz4
cp /001-master/config/usr/src/linux/.superkoala-8.0 /usr/src/linux/.superkoala-8.0
genkernel --menuconfig all --makeopts=-j6
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