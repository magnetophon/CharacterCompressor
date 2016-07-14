#!/bin/bash

if [ $BUILD_DEPS == 1 ];
then
    sudo apt-get -qq update
    mkdir -p $HOME/local/{bin,include,lib,share}
    echo "install faust"
    sudo apt-get build-dep -yy faust
    git clone git://git.code.sf.net/p/faudiostream/code /tmp/faust
    pushd  /tmp/faust
    make
    sudo make PREFIX=$HOME/local install
    popd
    echo "install plugin-torture"
    sudo apt-get install -yy  libboost-all-dev ladspa-sdk liblilv-dev lv2-dev libserd-dev libsord-dev libsratom-dev
    git clone https://github.com/cth103/plugin-torture.git /tmp/plugin-torture
    pushd /tmp/plugin-torture
    make
    cp plugin-torture $HOME/local/bin/
    popd
    echo "install lv2bm"
    wget https://github.com/moddevices/caps-lv2/raw/master/.create_lv2_env.sh
    bash .create_lv2_env.sh
    git clone https://github.com/moddevices/lv2bm
    cd lv2bm && make && sudo make PREFIX=$HOME/local install && cd ..
else
    sudo rsync -avzh $HOME/local/ /usr/local/
fi
