rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
export VERSION=v1.0.1
export COMPNAME=docker
echo $VERSION
echo $COMPNAME
rm content/${COMPNAME}_${VERSION}.ign
cp metadata/${COMPNAME}_${VERSION}.metadata wip/bin/metadata
cp files/$COMPNAME_$VERSION/bin/*.ps1 wip/bin
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/${COMPNAME}_${VERSION}.ign bin)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/${COMPNAME}_${VERSION}.ign bin/metadata/$COMPNAME_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/${COMPNAME}_${VERSION}.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/${COMPNAME}_${VERSION}.ign
cat wip/bin/metadata/${COMPNAME}_${VERSION}.metadata
#rm -r -f wip/*


