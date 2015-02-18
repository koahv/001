echo Available Installation Media:
echo
lsscsi
echo
#df -h
echo


#read -p "Enter Filesystem dev Idendifier: " fsid
#read -p "Partition the disk ?" -n 1 -r
#if [[ $REPLY =~ ^[Yy]$ ]]
#then
#fdisk $fsid
#fi
#echo
#lsscsi
#echo


read -p "Enter Filesystem Idendifier (dev): " fsid00
read -p "Is $fsid00 correct?" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]
then
echo 
lsblk $fsid00

echo
read -p "Enter Parition Idendifier (dev): " fsid01
read -p "Is $fsid01 correct? Enter Y to format partition $fsid01" -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
umount /mnt/gentoo01
mkfs.ext4 -L GENTOO $fsid01
fi

fi


echo Installation Media Updated:
echo
lsscsi
lsblk $fsid00
lsblk $fsid01
echo



echo Preparing for chroot...
mkdir /mnt/gentoo01
mount $fsid01 /mnt/gentoo01
mkdir /mnt/gentoo01/boot
mkdir /mnt/gentoo01/home
cd /mnt/gentoo01
echo Done.
echo


echo press q to exit links. Download the latest multilib Stage3 in
echo;echo 3;sleep 1; echo 2; sleep 1; echo 1; sleep 1;
#links http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
links http://www.mirrorservice.org/sites/distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/

echo Extracting Stage 3..
tar xvjpf stage3*

echo
echo Download initial config files
wget https://github.com/koahv/001/archive/master.zip
unzip master.zip 

cp /mnt/gentoo01/001-master/config/etc/ /mnt/gentoo01/ -R
cp /mnt/gentoo01/001-master/config/usr/share/zoneinfo/GMT /mnt/gentoo01/etc/localtime
cp /mnt/gentoo01/001-master/config/var/lib/portage/ /mnt/gentoo01/var/lib/portage/ -R

cd

echo
echo Preparing chroot..
cp -L /etc/resolv.conf /mnt/gentoo01/etc/resolv.conf
mount -t proc none /mnt/gentoo01/proc
mount -o bind /dev /mnt/gentoo01/dev

echo


echo Chrooting. Now run chroot-install.sh
chroot /mnt/gentoo01 /001-master/chroot-install.sh
env-update
source /etc/profile
export PS1="(chroot) $PS1"

echo

echo Reboot and run secondary install
read -p "Reboot now?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
reboot
fi


