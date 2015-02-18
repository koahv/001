echo
echo Configure Portage
mkdir /usr/portage

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
emerge hardened-sources genkernel grub dhcpd
cp /001-master/config/usr/src/linux/.superkoala-8.0 /usr/src/linux/
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