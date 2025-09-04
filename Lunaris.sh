# Clean old manifests
rm -rf .repo/local_manifests
rm -rf hardware/motorola
rm -rf packages/resources/devicesettings
rm -rf prebuilts/clang/host/linux-x86

# repo init
repo init -u https://github.com/Lunaris-AOSP/android -b 16 --git-lfs

# manifest
git clone https://github.com/A-cord/SM6225_manifests/devicetrees.xml.git

# Use Crave's sync method
/opt/crave/resync.sh
echo "======== Synced Successfully ========"

# Export
export ro.paranoid.maintainer=Himanshu
export WITH_BCR := true
export WITH_GMS := true
export TARGET_USES_CORE_GAPPS := true
export TARGET_USE_LOWRAM_PROFILE := true

# Grep
grep -r "/dev/cpuset/" .

# Environment setup
. build/envsetup.sh
echo "======== Environment setup done ========"

# Lunch
lunch lineage_rhode-bp2a-user && m lunaris
