echo Available Installation Media:
echo
lsscsi
echo
df -h
#echo Run \"fdisk /dev/...\"
echo
read -p "Enter Filesystem Idendifier - /dev/.. : " fsid
read -p "Is $fsid correct?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
fdisk $fsid
fi