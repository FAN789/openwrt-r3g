#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/openwrt"
CONFIG_FILE="${SRC_DIR}/.config"
INCLUDE_PASSWALL="${INCLUDE_PASSWALL:-true}"

if [ ! -f "${CONFIG_FILE}" ]; then
  echo "OpenWrt config file not found: ${CONFIG_FILE}"
  exit 1
fi

require_config() {
  local key="$1"
  if ! grep -Eq "^${key}=y$" "${CONFIG_FILE}"; then
    echo "Missing required config: ${key}=y"
    exit 1
  fi
}

require_config "CONFIG_TARGET_ramips"
require_config "CONFIG_TARGET_ramips_mt7621"
require_config "CONFIG_TARGET_ramips_mt7621_DEVICE_xiaomi_mi-router-3g"
require_config "CONFIG_PACKAGE_luci"

if [ "${INCLUDE_PASSWALL}" = "true" ]; then
  require_config "CONFIG_PACKAGE_luci-app-passwall"
  require_config "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Geoview"
  require_config "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client"
  require_config "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs"
  require_config "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox"
  require_config "CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray"
  require_config "CONFIG_PACKAGE_chinadns-ng"
  require_config "CONFIG_PACKAGE_coreutils"
  require_config "CONFIG_PACKAGE_coreutils-base64"
  require_config "CONFIG_PACKAGE_coreutils-nohup"
  require_config "CONFIG_PACKAGE_curl"
  require_config "CONFIG_PACKAGE_dns2socks"
  require_config "CONFIG_PACKAGE_dnsmasq-full"
  require_config "CONFIG_PACKAGE_geoview"
  require_config "CONFIG_PACKAGE_ip-full"
  require_config "CONFIG_PACKAGE_ipt2socks"
  require_config "CONFIG_PACKAGE_luci-compat"
  require_config "CONFIG_PACKAGE_luci-lib-jsonc"
  require_config "CONFIG_PACKAGE_lyaml"
  require_config "CONFIG_PACKAGE_microsocks"
  require_config "CONFIG_PACKAGE_resolveip"
  require_config "CONFIG_PACKAGE_shadowsocksr-libev-ssr-local"
  require_config "CONFIG_PACKAGE_shadowsocksr-libev-ssr-redir"
  require_config "CONFIG_PACKAGE_simple-obfs-client"
  require_config "CONFIG_PACKAGE_sing-box"
  require_config "CONFIG_PACKAGE_tcping"
  require_config "CONFIG_PACKAGE_unzip"
  require_config "CONFIG_PACKAGE_xray-core"
fi

echo "R3G package options verified."
