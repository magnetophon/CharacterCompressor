# CharacterCompressor

A compressor with character.

A bit experimental: It works and sounds wonderfull, but has too many parameters, so is a bit fiddly to use.
Also; I have no idea what to name the parameters, or how to explain a lot of them.

## dependencies for jack standalone and lv2 plugin:
- [faust](http://faust.grame.fr/download/)
- [jack](http://jackaudio.org/downloads/)
- [lv2](http://lv2plug.in/)

## building and installing:
```
git clone https://github.com/magnetophon/CharacterCompressor
cd CharacterCompressor
make
sudo make install
```

## audio clips:

Here is a short excerpt from a song, [with](https://github.com/magnetophon/CharacterCompressor/raw/master/withDrmComp.wav) and [without](https://github.com/magnetophon/CharacterCompressor/raw/master/noDrmComp.wav) CharacterCompressor on the drum bus.
