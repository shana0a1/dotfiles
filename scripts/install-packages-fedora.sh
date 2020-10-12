#!/bin/bash
echo "Configuring dnf..."
cat fedora/etc/dnf/dnf.conf > /etc/dnf/dnf.conf
echo "Enabling rpmfusion..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
echo "Enabling repository for vscode..."
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
echo "Enabling repository for VirtIO drivers..."
sudo wget https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo \
  -O /etc/yum.repos.d/virtio-win.repo

# Update and install everything
sudo dnf update -y
sudo dnf groupupdate core -y
sudo dnf install -y $(cat packages/dnf)
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y $(cat packages/flatpak)

# Installing package groups
sudo dnf group install -y --with-optional virtualization
sudo dnf groupinstall -y "Development Tools"

while true
do
read -r -p "[Y/n] " input
case $input in
    [yY][eE][sS]|[yY])
    echo "Do you want to install GNOME tweaks? (answer no if not on GNOME)"
    sudo dnf install gnome-tweaks
    ;;
    [nN][oO]|[nN])
    echo "Skipping..."
    break
    ;;
    *)
    echo "Invalid input..."
    ;;
esac
done

