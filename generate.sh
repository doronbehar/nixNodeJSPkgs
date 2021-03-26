#!/usr/bin/env nix-shell
#! nix-shell -p nodePackages.node2nix
set -eu -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd ${DIR}
rm -f ./node-env.nix
# for nodejsVer in 8 10 12 14; do
	node2nix \
		--input node-packages.json \
		--output node-packages.nix \
		--composition composition.nix \
		--nodejs-$nodejsVer
# done
