rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=v1.0
rm content/prewin1809_$VERSION.ign
cp metadata/prewin1809_$VERSION.metadata wip/bin/metadata
cp files/prewin1809_$VERSION/bin/*.ps wip/bin
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/prewin1809_$VERSION.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/prewin1809_$VERSION.ign bin/metadata/prewin1809_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/prewin1809_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/prewin1809_$VERSION.ign
cat wip/bin/metadata/prewin1809_$VERSION.metadata
#rm -r -f wip/*


