# The Superclass may include PRODUCT_COPY_FILES directives that this subclass
# may want to override.  For PRODUCT_COPY_FILES directives the Android Build
# System ignores subsequent copies that lead to the same destination.  So for
# subclass PRODUCT_COPY_FILES to override properly, the right thing to do is to
# prepend them instead of appending them as usual.  This is done using the
# pattern:
#
# OVERRIDE_COPIES := <the list>
# PRODUCT_COPY_FILES := $(OVERRIDE_COPIES) $(PRODUCT_COPY_FILES)

# Superclass
$(call inherit-product, build/target/product/full_base_telephony.mk)
# Include Dalvik Heap Size Configuration
$(call inherit-product, $(COMMON_PATH)/dalvik/tablet-xhdpi-2048-dalvik-heap.mk)

# Overrides
PRODUCT_DEVICE := byt_m_crb
PRODUCT_MODEL := byt_m_crb
TARGET_BOARD_PLATFORM := baytrail

PRODUCT_CHARACTERISTICS := nosdcard,tablet

# Copy fstab
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab:fstab.$(PRODUCT_DEVICE) \
    $(LOCAL_PATH)/fstab:root/fstab.$(PRODUCT_DEVICE) \
    $(DEVICE_CONF_PATH)/recovery.init.byt_m_crb.rc:root/init.recovery.byt_m_crb.rc

# Verified boot support
ifeq ($(TARGET_USE_KERNELFLINGER),true)
include build/target/product/verity.mk
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/by-name/android_system
endif

# Setup fs packages
PRODUCT_PACKAGES += \
	setup_fs \
	pstore-clean

# common overlays for Intel resources
ifneq ($(BUILD_VANILLA_AOSP), true)
DEVICE_PACKAGE_OVERLAYS := $(COMMON_PATH)/overlays_extensions
endif
# common overlays for Vanilla AOSP resources
DEVICE_PACKAGE_OVERLAYS += $(COMMON_PATH)/overlays_aosp

OVERRIDE_COPIES := \
    $(DEVICE_CONF_PATH)/asound.conf:system/etc/asound.conf \
    $(DEVICE_CONF_PATH)/init.baytrail.sh:root/init.baytrail.sh \
    $(DEVICE_CONF_PATH)/egl.cfg:system/lib/egl/egl.cfg \
    $(DEVICE_CONF_PATH)/init.net.eth0.sh:system/etc/init.net.eth0.sh

ifeq ($(BOARD_HAS_WILKINS_PEAK_CHIP),true)
OVERRIDE_COPIES += \
    $(DEVICE_CONF_PATH)/init_wp.bt.rc:root/init.bt.rc
endif

# Make generic definetion of media components.
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/wrs_omxil_components.list:system/etc/wrs_omxil_components.list \
    $(DEVICE_CONF_PATH)/mfx_omxil_core.conf:system/etc/mfx_omxil_core.conf \
    $(DEVICE_CONF_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
    $(DEVICE_CONF_PATH)/sensors/sensor_hal_config_default.xml:system/etc/sensor_hal_config_default.xml

ifneq ($(DOLBY_UDC),true)
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/media_codecs.xml:system/etc/media_codecs.xml
endif

# Video ISV
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/video_isv_profile.xml:system/etc/video_isv_profile.xml

PRODUCT_COPY_FILES := $(OVERRIDE_COPIES) $(PRODUCT_COPY_FILES)
# keypad key mapping
PRODUCT_PACKAGES += \
    mrst_keypad.kcm \
    mxt224_key_0.kl \
    mrst_keypad.kl \
    gpio-keys.kl \
    KEYPAD.kl
#    intel_short_long_press.kl

# glib
PRODUCT_PACKAGES += \
    libglib-2.0 \
    array-test \
    array-test \
    mainloop-test \
    libgmodule-2.0 \
    libgobject-2.0 \
    libgthread-2.0

# libstagefrighthw
PRODUCT_PACKAGES += \
    libstagefrighthw

# Media SDK and OMX IL components
PRODUCT_PACKAGES += \
    libmfxhw32 \
    libmfxsw32 \
    libmfx_omx_core \
    libmfx_omx_components_hw \
    libmfx_omx_components_sw \
    libgabi++-mfx \
    libstlport-mfx

#enable Widevine drm
PRODUCT_PROPERTY_OVERRIDES += drm.service.enabled=true

PRODUCT_PACKAGES += com.google.widevine.software.drm.xml \
    com.google.widevine.software.drm \
    libdrmwvmplugin \
    libwvm \
    libdrmdecrypt \
    libWVStreamControlAPI_L1 \
    libwvdrm_L1

PRODUCT_PACKAGES_ENG += WidevineSamplePlayer
PRODUCT_PACKAGES_ENG += WidiReceiver

# WV Modular
PRODUCT_PACKAGES += libwvdrmengine

PRODUCT_PACKAGES_ENG += ExoPlayerDemo

# Intel Widevine components
PRODUCT_PACKAGES += liboemcrypto
PRODUCT_PACKAGES += libmeimm libsecmem

# omx components
PRODUCT_PACKAGES += \
    libwrs_omxil_core_pvwrapped \
    libOMXVideoDecoderAVC \
    libOMXVideoDecoderAVCSecure \
    libOMXVideoDecoderH263 \
    libOMXVideoDecoderMPEG4 \
    libOMXVideoDecoderWMV \
    libOMXVideoDecoderVP8 \
    libOMXVideoEncoderH263 \
    libOMXVideoEncoderMPEG4 \
    libOMXVideoEncoderAVC

# libmix
PRODUCT_PACKAGES += \
    libmixvbp_mpeg4 \
    libmixvbp_h264 \
    libmixvbp_vc1 \
    libmixvbp_vp8 \
    libmixvbp_h264secure \
    libmix_imagedecoder \
    libmix_imagedecoder_genx \
    libva_videodecoder \
    libva_videoencoder

# libva
PRODUCT_PACKAGES += \
    vainfo \
    pvr_drv_video

PRODUCT_PACKAGES += \
    msvdx_fw_mfld_DE2.0.bin

# video editor
#PRODUCT_PACKAGES += \
    libI420colorconvert

# hardware HAL
PRODUCT_PACKAGES += \
    audio_hal_configurable \
    route_criteria.common.conf \
    libaudioresample \
    audio.hsp.default \
    audio.usb.default

#A2DP audio HAL
PRODUCT_PACKAGES += \
    audio.a2dp.default

# sensors
PRODUCT_PACKAGES += \
    sensors.$(TARGET_BOARD_PLATFORM)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=196609 \
    ro.sf.lcd_density=240

# Version of mandatory blankphone
PRODUCT_PROPERTY_OVERRIDES += ro.blankphone_id=1

# Intel multiple display
PRODUCT_PACKAGES += \
    libmultidisplay \
    libmultidisplayjni \
    com.intel.multidisplay \
    com.intel.multidisplay.xml

# Add HdmiSettings app
PRODUCT_PACKAGES += \
    HdmiSettings

#hdmi audio HAL
PRODUCT_PACKAGES += \
   audio.hdmi.$(PRODUCT_DEVICE)

#usb dock audio
#PRODUCT_PACKAGES += \
    audio.hs_usb.$(PRODUCT_DEVICE)

#widi audio HAL
PRODUCT_PACKAGES += \
    audio.widi.$(PRODUCT_DEVICE)

#widi
PRODUCT_PACKAGES += widi

PRODUCT_PACKAGES_DEBUG += \
    WirelessDisplaySigmaCapiUI \
    com.intel.widi.sigmaapi \
    com.intel.widi.sigmaapi.xml \
    libwidisigmajni \
    libsigmacapi \
    shcli \
    shsrv

#OemTelephony for OEM HOOK API
#PRODUCT_PACKAGES += \
    com.intel.internal.telephony.OemTelephony \
     com.intel.internal.telephony.OemTelephony.xml

#PRODUCT_PACKAGES_DEBUG += \
    mmgr-debug

# MMGR CWS Client
#PRODUCT_PACKAGES += \
    CWS_SERVICE_MANAGER

# TelephonyEventsNotifier
#PRODUCT_PACKAGES_DEBUG += \
    TelephonyEventsNotifier

# Set default network type to LTE/GSM/WCDMA (9)
PRODUCT_PROPERTY_OVERRIDES += ro.telephony.default_network=9

# SIM Hot Swap Property
PRODUCT_PROPERTY_OVERRIDES += persist.tel.hot_swap.support=true

# busybox
ifneq (, $(findstring "$(TARGET_BUILD_VARIANT)", "eng" "userdebug"))
PRODUCT_PACKAGES += \
    busybox
endif

# hw_ssl
#PRODUCT_PACKAGES += \
    libdx-crys \
    start-sep

# IPV6
PRODUCT_PACKAGES += \
    rdnssd \
    dhcp6c

# libmfldadvci
PRODUCT_PACKAGES += \
    libmfldadvci \
    dummy.cpf \
    CGamma_DIS5MP.bin \
    noise.fpn \
    Preview_UserParameter_imx135.prm \
    Primary_UserParameter_imx135.prm \
    Video_UserParameter_imx135.prm \
    YGamma_DIS5MP.bin \
    Mor_8MP_8BQ.txt

# libcamera
PRODUCT_PACKAGES += \
    camera.$(PRODUCT_DEVICE)

# IntelCamera Parameters extensions
PRODUCT_PACKAGES += \
    libintelcamera_jni \
    com.intel.camera.extensions \
    com.intel.camera.extensions.xml

# camera sensor tuning parameter
#PRODUCT_PACKAGES += \
        libSh3aParamsimx135

# camera firmware
#PRODUCT_PACKAGES += \
        hdr_v2_fw_css21_2400b0 \
        shisp_2400b0_v21.bin

# video encoder and camera
#PRODUCT_PACKAGES += \
        libsharedbuffer

# board specific files
PRODUCT_COPY_FILES += \
        $(DEVICE_CONF_PATH)/media_profiles.xml:system/etc/media_profiles.xml \
        $(DEVICE_CONF_PATH)/camera_profiles.xml:system/etc/camera_profiles.xml

# audio policy file
PRODUCT_COPY_FILES += \
        $(DEVICE_CONF_PATH)/audio_policy.conf:system/etc/audio_policy.conf

# Camera app
PRODUCT_PACKAGES += \
	Camera

# Test Camera is for Test only
ifeq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_PACKAGES += \
    IntelCamera
endif

# Camera applications: LaunchCamera
PRODUCT_PACKAGES += \
    LaunchCamera

PRODUCT_PACKAGES += \
    SocialGallery

# WiDi app
PRODUCT_PACKAGES += \
    WirelessDisplayUtil

# Test Camera is for Test only
#PRODUCT_PACKAGES_ENG += \
   TestCamera

# Filesystem management tools
PRODUCT_PACKAGES += \
    e2fsck \
    setup_fs

# copy permission files
FRAMEWORK_ETC_PATH := frameworks/native/data/etc
PERMISSIONS_PATH := system/etc/permissions
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.touchscreen.multitouch.jazzhand.xml:$(PERMISSIONS_PATH)/android.hardware.touchscreen.multitouch.jazzhand.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.camera.front.xml:$(PERMISSIONS_PATH)/android.hardware.camera.front.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.accelerometer.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.accelerometer.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.compass.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.compass.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.gyroscope.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.gyroscope.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.sensor.light.xml:$(PERMISSIONS_PATH)/android.hardware.sensor.light.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.wifi.xml:$(PERMISSIONS_PATH)/android.hardware.wifi.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.usb.host.xml:$(PERMISSIONS_PATH)/android.hardware.usb.host.xml \
    $(FRAMEWORK_ETC_PATH)/android.hardware.usb.accessory.xml:$(PERMISSIONS_PATH)/android.hardware.usb.accessory.xml \
    $(FRAMEWORK_ETC_PATH)/tablet_core_hardware.xml:$(PERMISSIONS_PATH)/tablet_core_hardware.xml
#   $(PERMISSIONS_PATH)/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml

ifneq ($(BOARD_HAVE_BLUETOOTH),false)
PRODUCT_COPY_FILES += \
    $(FRAMEWORK_ETC_PATH)/android.hardware.bluetooth_le.xml:$(PERMISSIONS_PATH)/android.hardware.bluetooth_le.xml
endif

PRODUCT_COPY_FILES += \
    $(COMMON_PATH)/ueventd.common.rc:root/ueventd.$(PRODUCT_DEVICE).rc

# This device is hdpi. However the platform doesn't
# currently contain all of the bitmaps at hdpi density so
# we do this little trick to fall back to other density
# if the hdpi doesn't exist.
PRODUCT_AAPT_CONFIG := normal large xlarge ldpi mdpi hdpi xhdpi
PRODUCT_AAPT_PREF_CONFIG := hdpi

# usb accessory
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

#Enable MTP by default
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mtp

#NXP audio effects
#PRODUCT_PACKAGES += \
    libbundlewrapper.so \
    libreverbwrapper.so \
    libxmlparser.so \
    LvmDefaultControlParams.xml \
    LvmSessionConfigurationMinus1.xml \
    audio_effects.conf

#For Audio Offload support
#PRODUCT_PACKAGES += \
    audio.codec_offload.$(PRODUCT_DEVICE)

# Optional GMS applications
#-include vendor/google/PRIVATE/gms/products/gms_optional.mk


# Intel Corp Email certificate
#-include vendor/intel/PRIVATE/cert/IntelCorpEmailCert.mk

# Enable ALAC
PRODUCT_PACKAGES += \
    libstagefright_soft_alacdec

# build the OMX wrapper codecs
PRODUCT_PACKAGES += \
    libmdp_omx_core \
    libstagefright_soft_mp3dec_mdp \
    libstagefright_soft_aacdec_mdp \
    libstagefright_soft_amrdec_mdp \
    libstagefright_soft_vorbisdec_mdp \
    libstagefright_soft_aacenc_mdp \
    libstagefright_soft_amrenc_mdp

# Enable HOT SWAP
#PRODUCT_PROPERTY_OVERRIDES += persist.tel.hot_swap.support=true

# Intel VPP/FRC
PRODUCT_PACKAGES += \
    VppSettings

#audio firmware
#AUDIO_FW_PATH := vendor/intel/fw/sst/
#PRODUCT_COPY_FILES += \
    $(AUDIO_FW_PATH)/fw_sst_0f28.bin:system/etc/firmware/fw_sst_0f28.bin \
    $(AUDIO_FW_PATH)/mp3_dec_0f28.bin:system/etc/firmware/mp3_dec_0f28.bin \
    $(AUDIO_FW_PATH)/aac_dec_0f28.bin:system/etc/firmware/aac_dec_0f28.bin \

# Board initrc file
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/init.$(PRODUCT_DEVICE).rc:root/init.$(PRODUCT_DEVICE).rc \
    $(DEVICE_CONF_PATH)/init.avc.rc:root/init.avc.rc \
    $(DEVICE_CONF_PATH)/init.diag.rc:root/init.diag.rc \
    $(DEVICE_CONF_PATH)/init.sensors.rc:root/init.sensors.rc \
    $(DEVICE_CONF_PATH)/init.dptf.rc:root/init.dptf.rc \
    $(LOCAL_PATH)/init.utilitynet.sh:system/etc/init.utilitynet.sh \
    $(DEVICE_CONF_PATH)/init.debug.byt_m_crb.rc:root/init.debug.byt_m_crb.rc
#    $(DEVICE_CONF_PATH)/init.wireless.rc:root/init.wireless.rc

PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/vold.fstab:system/etc/vold.fstab

# specific management of CSM configuration
PRODUCT_COPY_FILES += \
    $(DEVICE_CONF_PATH)/CsmConfig.xml:system/vendor/etc/CsmConfig.xml

# intel-dptf executable
PRODUCT_PACKAGES += \
    esif_ufd \
    Dptf \
    DptfPolicyActive \
    DptfPolicyCritical \
    DptfPolicyPassive \
    esif.conf \
    dsp.dv \
    combined.xsl

#################################################"
# Include platform - do not inherit so that variables can be set before inclusion
include $(PLATFORM_PATH)/baytrail.mk

# Prebuilt HAL packages - Vibrator
#PRODUCT_PACKAGES += \
    vibrator.$(TARGET_BOARD_PLATFORM)
