#!/bin/bash
# Lunaris OS Bringup + Build Script for Crave

set -e

echo "======== Cleaning old manifests and prebuilts ========"
rm -rf .repo/local_manifests
rm -rf packages/resources/devicesettings
rm -rf prebuilts/clang/host/linux-x86

echo "======== Initializing repo ========"
repo init -u https://github.com/Lunaris-AOSP/android -b 16 --git-lfs

echo "======== Adding local manifests ========"
git clone https://github.com/cordbase/SM6225_manifests --depth 1 .repo/local_manifests

echo "======== Syncing sources (Crave optimized) ========"
/opt/crave/resync.sh
echo "======== Synced Successfully ========"

# ──────────────────────────────
# Build flags
# ──────────────────────────────
export WITH_BCR=true
export WITH_GMS=true
export TARGET_USES_CORE_GAPPS=true
export TARGET_USE_LOWRAM_PROFILE=true

# ──────────────────────────────
# Bringup properties (for Settings > About > Bringup)
# These go into build.prop at compile time
# ──────────────────────────────
export LUNARIS_MAINTAINER="Himanshu"
export LUNARIS_DEVICE="rhode"
export LUNARIS_SOURCE="cordbase"

# Add props to system.prop overlay so they get picked up
mkdir -p vendor/lunaris/overlay
cat <<EOF > vendor/lunaris/overlay/bringup.prop
ro.lunaris.maintainer=${LUNARIS_MAINTAINER}
ro.lunaris.device=${LUNARIS_DEVICE}
ro.lunaris.source=${LUNARIS_SOURCE}
EOF

echo "======== Environment setup ========"
. build/envsetup.sh

# ──────────────────────────────
# Lunch & Build
# ──────────────────────────────
echo "======== Lunching target ========"
lunch lineage_rhode-bp2a-user

echo "======== Starting build ========"
m lunaris

echo "✅ Build finished! Check out/target/product/rhode/ for output zip."
