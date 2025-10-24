#!/usr/bin/env bash
# fs-diff.sh
# sudo mkdir $(mktemp)=tempdir ; sudo mount -o subvol=/ /dev/mapper/nvme-crypt ${tempdir} ; ./fs-diff.sh
# sudo mkdir $(mktemp)=tempdir ; sudo mount -o subvol=/@HOME /dev/mapper/nvme-crypt ${tempdir} ; ./fs-diff.sh
set -euo pipefail

if [ --root ] || [ -r ]; then
  TARGET="@ROOT"
elif [ --home ] || [ -h ]; then
  TARGET="@HOME"
else:
  echo "goodbye.."
fi

# === 1 ===
TEMPDIR=`mktemp -d`
#mktemp -d > $TEMPDIR
#sudo mkdir $tempdir

# === 2 ===
sudo mount -o subvol=/ /dev/mapper/nvme-crypt $TEMPDIR

# === 3 ===
OLD_TRANSID=$(sudo btrfs subvolume find-new /${TEMPDIR}/${TARGET}-BLANK 9999999)
OLD_TRANSID=${OLD_TRANSID#transid marker was }
sudo btrfs subvolume find-new "/${TEMPDIR}/${TARGET}" "$OLD_TRANSID" |
sed '$d' |
cut -f17- -d' ' |
sort |
uniq |
while read path; do
  path="/$path"
  if [ -L "$path" ]; then
    : # The path is a symbolic link, so is probably handled by NixOS already
  elif [ -d "$path" ]; then
    : # The path is a directory, ignore
  else
    echo "$path"
  fi
done
