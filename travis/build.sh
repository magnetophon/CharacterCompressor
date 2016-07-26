#!/usr/bin/env bash

DSPs=(
    CharacterCompressor
    CharacterCompressorMono
)

function buildPlugins {
    echo "building lv2 $1"
    time bash -x faust2lv2 -vec  -t 9999999 -time "$1.dsp"
    cp -r "$1.lv2" "$HOME/.lv2/"
    echo "building ladspa $1"
    time bash -x faust2ladspa -vec  -t 9999999 -time "$1.dsp"
}

if [[ $BUILD_DEPS == 0 ]];
then
    faust -v
    export LV2_PATH="$HOME/.lv2/"

    mkdir -p "$HOME/.lv2"
    for i in "${DSPs[@]}"
    do
        buildPlugins "$i"
    done
    echo "benchmark all LV2s"
    for i in "${DSPs[@]}"
    do
        lv2bm "http://faustlv2.bitbucket.org/$i"
    done
    echo "torture ladspas"
    for i in "${DSPs[@]}"
    do
        plugin-torture --evil -d --lv2 --plugin "$i.lv2/manifest.ttl"
        # plugin-torture --evil -d --ladspa --plugin "$i.so"
    done
else
    exit 0
fi
