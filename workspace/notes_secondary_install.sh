# after successful main_install
# create user
useradd -m -G users,wheel,audio -s /bin/bash yournick
passwd yournick

# clean
rm /stage3-*.tar.bz2
rm /portage-*.tar.bz2