#!/bin/sh

set -e

# This script generates u-boot patch between for odyssey-stm32mp157c
#
# reference is below,
# https://forum.digikey.com/t/debian-getting-started-with-the-odyssey-stm32mp157c/12838#bootloader-u-boot

update_u_boot_patch() {
  # Work in a temporary directory
  rm -fr work
  mkdir -p work
  cd work

  # create a
  echo "git clone repositories ..."
  git clone -b v2018.11 https://github.com/u-boot/u-boot --depth=1 a

  # create b
  cp -r a b
  cd b
  git pull --no-edit https://github.com/Seeed-Studio/u-boot v2018.11-stm32mp-s
  cd ..

  rm -fr a/.git
  rm -fr a/.gitignore
  rm -fr b/.git
  rm -fr b/.gitignore

  # Now create a regular "diff" patch
  echo "Creating patch..."
  PATCH_NAME=seeed-u-boot.patch
  diff -Naur --no-dereference a b > ../0001-$PATCH_NAME || :

  # Clean up
  echo "Cleaning up..."
  cd ..
  rm -fr work

  # get rcn patch
  PATCH_NAME=stm32mp15_basic-disable-CONFIG_STM32MP_WATCHDOG.patch
  wget -c https://github.com/eewiki/u-boot-patches/raw/master/stm32mp-s-v2018.11/0001-$PATCH_NAME \
       -O 0002-$PATCH_NAME

  return 0
}

update_u_boot_patch

echo "Created patches."
