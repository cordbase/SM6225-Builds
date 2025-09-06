#!/bin/bash
# Lunaris OS Bringup + Build Script for Crave

set -e

echo "======== Cleaning old prebuilts ========"
rm -rf .repo/local_manifests
rm -rf packages/resources/devicesettings
rm -rf prebuilts/clang/host/linux-x86

rm -rf device/motorola/devon
rm -rf device/motorola/hawao
rm -rf device/motorola/rhode
rm -rf device/motorola/sm6225-common

rm -rf vendor/motorola/devon
rm -rf vendor/motorola/hawao
rm -rf vendor/motorola/rhode
rm -rf vendor/motorola/sm6225-common

rm -rf kernel/motorola/sm6225
rm -rf hardware/motorola

rm -rf vendor/motorola/MotoSignatureApp
rm -rf vendor/motorola/MotorolaSettingsProvider
rm -rf vendor/motorola/MotoPhotoEditor
rm -rf vendor/motorola/MotCamera-common
rm -rf vendor/motorola/MotCamera4-bengal
rm -rf vendor/motorola/MotCameraAI-common
rm -rf vendor/motorola/MotCamera3AI-bengal

echo "======== Initializing repo ========"
repo init -u https://github.com/Lunaris-AOSP/android -b 16 --git-lfs

echo "======== Adding Trees ========"

# ---- Device trees ----
git clone -b lineage-22.2 https://github.com/LineageOS/android_device_motorola_devon.git device/motorola/devon
git clone -b lineage-22.2 https://github.com/LineageOS/android_device_motorola_hawao.git device/motorola/hawao
git clone https://github.com/cordbase/android_device_motorola_rhode.git device/motorola/rhode
git clone https://github.com/cordbase/android_device_motorola_sm6225-common.git device/motorola/sm6225-common

# ---- Vendor trees ----
git clone -b lineage-22.2 https://github.com/TheMuppets/proprietary_vendor_motorola_devon.git vendor/motorola/devon
git clone -b lineage-22.2 https://github.com/TheMuppets/proprietary_vendor_motorola_hawao.git vendor/motorola/hawao
git clone -b lineage-22.2 https://github.com/TheMuppets/proprietary_vendor_motorola_rhode.git vendor/motorola/rhode
git clone -b lineage-22.2 https://github.com/TheMuppets/proprietary_vendor_motorola_sm6225-common.git vendor/motorola/sm6225-common

# ---- Kernel source ----
git clone https://github.com/cordbase/android_kernel_motorola_sm6225.git kernel/motorola/sm6225

# ---- Hardware ----
git clone https://github.com/cordbase/hardware_motorola.git hardware/motorola

# ---- MotoCamera repos (GitLab) ----
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotoSignatureApp.git vendor/motorola/MotoSignatureApp
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotorolaSettingsProvider.git vendor/motorola/MotorolaSettingsProvider
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotoPhotoEditor.git vendor/motorola/MotoPhotoEditor
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera-common.git vendor/motorola/MotCamera-common
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera4-bengal.git vendor/motorola/MotCamera4-bengal
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCameraAI-common.git vendor/motorola/MotCameraAI-common
git clone -b android-15 https://gitlab.com/Deivid21/proprietary_vendor_motorola_MotCamera3AI-bengal.git vendor/motorola/MotCamera3AI-bengal

echo "===========All repositories cloned successfully!==========="

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
