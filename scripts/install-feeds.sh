#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="${ROOT_DIR}/openwrt"
INCLUDE_PASSWALL="${INCLUDE_PASSWALL:-true}"

if [ ! -d "${SRC_DIR}" ]; then
  echo "OpenWrt source directory not found: ${SRC_DIR}"
  exit 1
fi

cd "${SRC_DIR}"

feed_names() {
  awk '/^src-[a-z]+[[:space:]]+/ { print $2 }' feeds.conf.default
}

install_feed_all() {
  local feed="$1"
  echo "Installing all packages from feed: ${feed}"
  ./scripts/feeds install -a -p "${feed}"
}

install_packages() {
  local feed="$1"
  shift

  [ "$#" -gt 0 ] || return 0

  echo "Installing selected packages from feed: ${feed}: $*"
  ./scripts/feeds install -p "${feed}" "$@"
}

for feed in $(feed_names); do
  case "${feed}" in
    small_package)
      echo "Skipping full install for small_package; selected packages are installed below."
      ;;
    *)
      install_feed_all "${feed}"
      ;;
  esac
done

if [ "${INCLUDE_PASSWALL}" = "true" ]; then
  install_packages small_package \
    luci-app-passwall \
    chinadns-ng \
    dns2socks \
    geoview \
    ipt2socks \
    microsocks \
    shadowsocksr-libev \
    simple-obfs \
    sing-box \
    xray-core \
    tcping
fi

bash "${ROOT_DIR}/scripts/patch-feeds.sh"
