#!/usr/bin/env bash

echo "TARGETARCH: $TARGETARCH";

baidunetdisk_url_amd64="$( \
  curl --silent --fail 'https://pan.baidu.com/disk/cmsdata?do=client' \
  | jq --raw-output '.linux | to_entries[] | select(.value|endswith("_amd64.deb")) | .value' \
  )";
baidunetdisk_url_arm64="${baidunetdisk_url_amd64::-10}_arm64.deb";

if [ "$TARGETARCH" = "amd64" ]; then
  baidunetdisk_url="$baidunetdisk_url_amd64";
elif [ "$TARGETARCH" = "arm64" ]; then
  baidunetdisk_url="$baidunetdisk_url_arm64";
else
  echo "Unsupported architecture: ${TARGETARCH}"
  exit 1
fi

echo "Downloading Baidu Netdisk from $baidunetdisk_url";
aria2c --file-allocation=none --continue=true --max-connection-per-server=16 --max-concurrent-downloads=16 --max-tries=0 --min-split-size=1M --out=baidunetdisk.deb --split=16 "$baidunetdisk_url";
echo "Downloaded Baidu Netdisk to baidunetdisk.deb";
