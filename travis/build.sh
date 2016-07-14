#!/bin/bash

if [ $BUILD_DEPS == 0 ];
then
    faust -v
    echo "building lv2"
    time faust2lv2  -t 9999999 -time CharacterCompressor.dsp
    mkdir $HOME/.lv2
    cp -r CharacterCompressor.lv2 $HOME/.lv2/
    echo "building ladspa"
    time faust2ladspa  -t 9999999 -time CharacterCompressor.dsp
    echo "starting tests"
    lv2bm --full-test `lv2ls`
    plugin-torture --evil -d --ladspa --plugin CharacterCompressor.so
else
    exit 0
fi
