#!/bin/sh

set -e

# Run this script to update the RCN's kernel patches. See the bottom
# of the script for setting the versions.

update_kernel_patch() {
  local PATCH_VERSION=$1
  local KERNEL_VERSION=$2
  local OUTPUT_PATCH=$3

  local ORIGINAL_DIFF=patch-$PATCH_VERSION.diff
  local ORIGINAL_DIFF_XZ=$ORIGINAL_DIFF.xz
  local KERNEL_TARBALL=linux-$KERNEL_VERSION.tar.xz

  # Work in a temporary directory
  rm -fr work
  mkdir -p work
  cd work

  echo "Downloading files..."

  local RCN_PATCH_URL
  local KERNEL_URL

  case $KERNEL_VERSION in
      5*)
          RCN_PATCH_URL=https://rcn-ee.net/deb/bookworm-armhf/v$PATCH_VERSION/$ORIGINAL_DIFF_XZ
          KERNEL_URL=https://www.kernel.org/pub/linux/kernel/v5.x/$KERNEL_TARBALL
          ;;
      4*)
          RCN_PATCH_URL=https://rcn-ee.net/deb/bullseye-armhf/v$PATCH_VERSION/$ORIGINAL_DIFF_XZ
          KERNEL_URL=https://www.kernel.org/pub/linux/kernel/v4.x/$KERNEL_TARBALL
          ;;
      *)
          echo "Unexpected kernel version: $KERNEL_VERSION"
          exit 1
  esac

  # Download the master patch file for the RCN kernel
  wget $RCN_PATCH_URL

  # Download the kernel that it will patch
  wget $KERNEL_URL

  # Extract the kernel twice so that the patch can be compared
  echo "Extracting..."
  tar -x -f $KERNEL_TARBALL && mv linux-$KERNEL_VERSION a
  tar -x -f $KERNEL_TARBALL && mv linux-$KERNEL_VERSION b

  # Expand the "git" style patch
  unxz $ORIGINAL_DIFF_XZ

  # Make a git repo and apply the "git" style patch
  echo "Creating temporary git repo to extract RCN patch..."
  cd b # at work/b
  git init
  git config user.email you@example.com
  git config user.name "Your Name"
  git config gc.auto 0
  git add .
  git commit -q -m "Initial commit"
  git apply ../$ORIGINAL_DIFF
  rm -fr .git

  # Now create a regular "diff" patch
  echo "Creating RCN patch..."
  cd .. # at work
  diff -Naur --no-dereference a b > ../$OUTPUT_PATCH || :

  echo "Creating stm32mp157c-seeed-npi-dts patch..."
  cp -r b c
  cp -r ../dts c/arch/arm/boot/
  diff -Naur --no-dereference b c > ../0002-stm32mp157c-seeed-npi-dts.patch || :

  # Clean up
  echo "Cleaning up..."
  cd ..
  rm -fr work

  return 0
}

update_kernel_patch 5.10.83-armv7-lpae-x58 5.10.83 0001-rcn-linux-5.10.83-armv7-lpae-x58.patch

echo "Updated patches. Now rebuild the linux kernel."
