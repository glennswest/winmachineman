rm -r -f wip/bin
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=1.0.1
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/node_$VERSION.ign bin)
cp metadata/node_$VERSION.metadata wip/bin/metadata/node_$VERSION.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/node_$VERSION.ign bin/metadata/node_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/node_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/node_$VERSION.ign
pwd
#rm -r -f wip/bin

