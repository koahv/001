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


read -p "Enter Filesystem Idendifier - /dev/.. : " fsid0
read -p "Is $fsid0 correct? Enter Y to format." -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
echo 
mkfs.ext4 -L GENTOO $fsid0
fi


echo Installation Media Updated:
echo
lsscsi
echo

echo Preparing for chroot...
mkdir /mnt/gentoo
mount %fsid0 /mnt/gentoo
mkdir /mnt/gentoo/boot
mkdir /mnt/gentoo/home
cd /mnt/gentoo
echo Done.
echo


echo Download the latest Stage3 in
echo;echo 3;sleep 1; echo 2; sleep 1; echo 1; sleep 1;
#links http://distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/
links http://www.mirrorservice.org/sites/distfiles.gentoo.org/releases/amd64/autobuilds/current-stage3-amd64-hardened/

echo Extracting Stage 3..
tar xvjpf stage3*

echo
echo Download initial config files
wget https://github.com/koahv/001/archive/master.zip
unzip 001-master.zip 

cp make.conf /mnt/gentoo/etc/portage/make.conf



cd















