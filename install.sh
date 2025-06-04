#!/usr/bin/env bash
set -e

DISK="/dev/sda"           # CHANGE if your disk is different
HOST_DIR="/mnt/etc/nixos" # Target for your flake
USER="user"           # Your username

# 1. Partition disk (MBR, one root partition)
parted --script $DISK \
  mklabel msdos \
  mkpart primary ext4 1MiB 100%

# 2. Format partition
mkfs.ext4 "${DISK}1"

# 3. Mount root
mount "${DISK}1" /mnt

# 4. Optional: Set up swap
# fallocate -l 2G /mnt/swapfile
# chmod 600 /mnt/swapfile
# mkswap /mnt/swapfile
# swapon /mnt/swapfile

# 5. Clone or copy your flake
mkdir -p $HOST_DIR
cd $HOST_DIR

# Clone from GitHub:
git clone https://github.com/superbusinesstools/nix-test.git $HOST_DIR

# 6. Install NixOS using flake
nixos-install --flake $HOST_DIR#default

# 7. Done
echo "Install complete. Reboot when ready."