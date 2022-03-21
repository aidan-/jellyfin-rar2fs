FROM linuxserver/jellyfin

ENV v_rar2fs=${RAR2FS_VERSION:-1.29.5}
ENV v_unrar=${UNRAR_VERSION:-6.0.7}

RUN WORKDIR=`mktemp -d` && \
    cd $WORKDIR && \
    # Get deps
    apt-get update && \
    apt-get -y install \
    fuse \
    g++ \
    libfuse-dev \
    make \
    wget && \
    # Get, make and install unrar
    wget http://www.rarlab.com/rar/unrarsrc-${v_unrar}.tar.gz && \
    tar zxvf unrarsrc-${v_unrar}.tar.gz && \
    cd unrar && \
    make && \
    make install && \
    make lib && \
    make install-lib && \
    cd .. && \
    # Get, make and install rar2fs
    wget https://github.com/hasse69/rar2fs/releases/download/v${v_rar2fs}/rar2fs-${v_rar2fs}.tar.gz -O rar2fs-${v_rar2fs}.tar.gz && \
    tar zxvf rar2fs-${v_rar2fs}.tar.gz && \
    cd rar2fs-${v_rar2fs} && \
    ./configure --with-unrar=../unrar --with-unrar-lib=/usr/lib/ && \
    make && \
    make install && \
    # Cleanup
    rm -rf $WORKDIR

COPY root/ /
