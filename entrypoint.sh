#!/bin/bash
set -e

if [[ "$1" == "bitcoin-cli" || "$1" == "bitcoin-tx" || "$1" == "bitcoind" ]]; then
	mkdir -p "$BITCOIN_DATA"

	cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
	printtoconsole=1
	rpcallowip=::/0
  blocksdir=$BITCOIN_BLOCKS
	${BITCOIN_EXTRA_ARGS}
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"

	# ensure correct ownership and linking of data directory
	# we do not update group ownership here, in case users want to mount
	# a host directory and still retain access to it
	chown -R bitcoin "$BITCOIN_DATA"
	chown -R bitcoin "$BITCOIN_BLOCKS"
	ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
	chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

	exec gosu bitcoin "$@"
else
	exec "$@"
fi
