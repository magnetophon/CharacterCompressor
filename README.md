# CharacterCompressor

[![Build Status](https://travis-ci.org/magnetophon/CharacterCompressor.svg?branch=master)](https://travis-ci.org/magnetophon/CharacterCompressor)

A compressor with character.

A bit experimental: It works and sounds wonderfull, but has too many parameters, so is a bit fiddly to use.
Also; I have no idea what to name the parameters, or how to explain a lot of them.

## dependencies for jack standalone and lv2 plugin:
- [faust](http://faust.grame.fr/download/)
- [jack](http://jackaudio.org/downloads/)
- [lv2](http://lv2plug.in/)

## build:
```
git clone https://github.com/magnetophon/CharacterCompressor
cd CharacterCompressor
faust2jaqt -vec -time -t 99999 CharacterCompressor.dsp
faust2jaqt -vec -time -t 99999 CharacterCompressorMono.dsp
faust2lv2 -vec -time -gui -t 99999 CharacterCompressor.dsp
faust2lv2 -vec -time -gui -t 99999 CharacterCompressorMono.dsp
```

## install:
```
mkdir -p $out/bin
cp CharacterCompressor $out/bin/
cp CharacterCompressorMono $out/bin/
mkdir -p $out/lib/lv2
cp -r CharacterCompressor.lv2/ $out/lib/lv2
cp -r CharacterCompressorMono.lv2/ $out/lib/lv2
```
In a similar way, faust can compile to [76 different architectures](https://github.com/grame-cncm/faust/tree/master-dev/tools/faust2appls), for example:
- faust2alsa
- faust2faustvst
- faust2supercollider
- faust2webaudio

## audio clips:

Here is a short excerpt from a song, [with](https://github.com/magnetophon/CharacterCompressor/raw/master/withDrmComp.wav) and [without](https://github.com/magnetophon/CharacterCompressor/raw/master/noDrmComp.wav) CharacterCompressor on the drum bus.
