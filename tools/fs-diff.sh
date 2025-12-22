#!/usr/bin/env bash
# fs-diff.sh
# sudo mkdir $(mktemp)=tempdir ; sudo mount -o subvol=/ /dev/mapper/nvme-crypt ${tempdir} ; ./fs-diff.sh
# sudo mkdir $(mktemp)=tempdir ; sudo mount -o subvol=/@HOME /dev/mapper/nvme-crypt ${tempdir} ; ./fs-diff.sh
set -euo pipefail

TARGET="0"

if [ "$1" = -r ]; then
  TARGET="@ROOT"
  echo $TARGET
elif  [ "$1" = -h ]; then
  TARGET="@HOME"
  echo $TARGET
else
  echo "goodbye.."
  exit 1
fi

# === 1 ===
TEMPDIR=$(mktemp -d)
echo "tempdir set..."

#mktemp -d > $TEMPDIR
#sudo mkdir $tempdir

# === 2 ===
sudo mount -o subvol=/ /dev/mapper/nvme-crypt "$TEMPDIR"
echo "mount the whole disk..."
# === 3 ===
OLD_TRANSID=$(sudo btrfs subvolume find-new /"${TEMPDIR}"/${TARGET}-BLANK 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }
sudo btrfs subvolume find-new "/${TEMPDIR}/${TARGET}" "$OLD_TRANSID" |
sed '$d' |
cut -f17- -d' ' |
cut -f2- -d'/' |
sort |
uniq |
while read path; do
  #if [ $1 = -r ]; then
  #  path="/$path"
  #elif [ $1 = -h ]
  #  path="$path"
  if [$1 = -r]; then
    command ...
  fi
  path="/$path"

  if [ -L "$path" ]; then
    : # The path is a symbolic link, so is probably handled by NixOS already
  elif [ -d "$path" ]; then
    : # The path is a directory, ignore
  else
    echo "$path"
  fi
done
