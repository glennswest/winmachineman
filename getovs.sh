export VERSION=2.70beta
rm -r -f wip
mkdir wip
mkdir wip/bin
mkdir wip/bin/metadata
rm content/ovs_$VERSION.ign
wget https://cloudbase.it/downloads/openvswitch-hyperv-installer-beta.msi -O wip/bin/openvswitch-hyperv-installer-beta.msi
cp -a files/ovs_$VERSION/* wip
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovs_$VERSION.ign .)
cp metadata/ovs_$VERSION.metadata wip/bin/metadata/ovs_$VERSION.metadata
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool um ../content/ovs_$VERSION.ign bin/metadata/ovs_$VERSION.metadata)
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovs_$VERSION.ign bin/metadata)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovs_$VERSION.ign
cat wip/bin/metadata/ovs_$VERSION.metadata
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovs_$VERSION.ign
#rm -r -f wip/bin

