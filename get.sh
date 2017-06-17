#!/bin/sh
set -e

TAR_FILE="/tmp/sh.tar.gz"
DOWNLOAD_URL="https://github.com/caarlos0/sh/releases/download"

last_version() {
	header=""
	# shellcheck disable=SC2089
	test -z "$GITHUB_TOKEN" || header="-H 'Authorization: token $GITHUB_TOKEN'"
	# shellcheck disable=SC2090,SC2086
	curl -s $header https://api.github.com/repos/caarlos0/sh/releases/latest |
		grep tag_name |
		cut -f4 -d'"'
}

download() {
	test -z "$VERSION" && VERSION="$(last_version)"
	test -z "$VERSION" && {
		echo "Unable to get caarlos0/sh version." >&2
		exit 1
	}
	rm -f "$TAR_FILE"
	curl -s -L -o "$TAR_FILE" \
		"$DOWNLOAD_URL/$VERSION/sh_$(uname -s)_$(uname -m).tar.gz"
}

download
tar -xf "$TAR_FILE" -C /tmp
