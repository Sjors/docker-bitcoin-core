# Docker for compiling Bitcoin Core from source

Only 1.7 GB! :-)

Heavily borrowing stuff from Nicolas Dorier's [docker-bitcoin](https://github.com/NicolasDorier/docker-bitcoin/tree/master/core/0.16.0). 

Builds the specified commit or tag, defaults to the latest tag.

Clone this repository and build an image:

```sh
export VERSION=v0.16.0 # Can also be a commit
docker build --build-arg VERSION=$VERSION . -t bitcoind:$VERSION
```

Create a directory on your local machine to host the blockchain, wallet, etc:

```sh
mkdir /home/you/bitcoin_data
```

Optionally create a directory to store blocks (ignored before v0.16.1):

```sh
mkdir /home/you/bitcoin_blocks
```

Launch the container as a background process:

```sh
docker run -d --rm --name bitcoind -v /home/you/bitcoin_data:/data -v /home/you/bitcoin/blocks:/blocks bitcoind:$VERSION
```

Monitor logs:

```sh
docker logs -f bitcoind
```

Interact:

```sh
docker run --rm --network container:bitcoind -v /home/you/bitcoin_data:/data bitcoind bitcoin-cli getinfo
```
