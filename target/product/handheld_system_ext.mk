#
# Copyright (C) 2019 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This makefile contains the system_ext partition contents for
# a generic phone or tablet device. Only add something here if
# it definitely doesn't belong on other types of devices (if it
# does, use base_system_ext.mk).
$(call inherit-product, $(SRC_TARGET_DIR)/product/media_system_ext.mk)

# /system_ext packages
PRODUCT_PACKAGES += \
    AccessibilityMenu \
    Launcher3QuickStep \
    Provision \
    Settings \
    StorageManager \
    SystemUI \
    WallpaperCropper

# --- AAOSP system_ext additions -----------------------------------------------
# Apps
PRODUCT_PACKAGES += \
    AgenticLauncher \
    ContactsMcp

# AgenticLauncher needs SUBMIT_LLM_REQUEST + QUERY_ALL_PACKAGES on a
# privileged install — install the allowlist xml.
PRODUCT_COPY_FILES += \
    packages/apps/AgenticLauncher/privapp-permissions-agenticlauncher.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-agenticlauncher.xml

# JNI bridge to llama.cpp — installs libllm_jni.so to /system/lib64.
# LlmManagerService loads it via System.loadLibrary("llm_jni").
PRODUCT_PACKAGES += libllm_jni

# Bake the Qwen 2.5 0.5B GGUF into /product/etc/llm so the LLM is
# available on first boot with no adb push. LlmManagerService.findModel()
# looks there before the /data/local/llm/ dev fallback.
PRODUCT_COPY_FILES += \
    external/llama.cpp/models/qwen2.5-0.5b-instruct-q8_0.gguf:$(TARGET_COPY_OUT_PRODUCT)/etc/llm/qwen2.5-0.5b-instruct-q8_0.gguf

# Auto-grant runtime permissions for AAOSP MCP-providing apps so the
# user doesn't see a permission prompt mid-tool-call. The consent
# contract lives at the LLM layer (HITL), not the per-Android-permission
# prompt. Installed to /system_ext/etc/default-permissions/, picked up
# by PMS on first scan.
PRODUCT_COPY_FILES += \
    packages/apps/ContactsMcp/default-permissions-aaosp.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/default-permissions/default-permissions-aaosp.xml
# --- end AAOSP additions ------------------------------------------------------
