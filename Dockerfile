FROM debian:stretch-slim

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
	&& apt-get update \
	&& apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu \
     git build-essential libtool autotools-dev automake pkg-config libssl-dev \
     libevent-dev bsdmainutils python3 libdb-dev libdb++-dev \
     libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev \
	&& rm -rf /var/lib/apt/lists/*
  
ARG VERSION=v0.16.0
  
RUN set -ex \
    && git clone https://github.com/bitcoin/bitcoin.git \
    && cd bitcoin \
    && git checkout $VERSION
    
RUN set -ex && cd bitcoin \
    && ./autogen.sh \
    && ./configure --disable-bench --disable-tests --with-miniupnpc=no --with-incompatible-bdb --without-gui

RUN set -ex && cd bitcoin \
    && make

RUN set -ex && cd bitcoin \
    && make install    

RUN rm -rf bitcoin

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin
VOLUME /data

# create a blocks directory (ignored before v0.16.1)
ENV BITCOIN_BLOCKS /blocks
RUN mkdir "$BITCOIN_BLOCKS" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_BLOCKS"
VOLUME /blocks
  
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]  
  
EXPOSE 8332 8333 18332 18333 18443 18444
CMD ["bitcoind"]
