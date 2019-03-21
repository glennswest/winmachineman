export VERSION=2.70beta
rm -r -f wip
mkdir wip
mkdir wip/bin
rm content/ovs_$VERSION.ign
wget https://cloudbase.it/downloads/openvswitch-hyperv-installer-beta.msi -O wip/bin/openvswitch-hyperv-installer-beta.msi
cp -a files/ovs_$VERSION/* wip
(cd wip;$GOPATH/src/github.com/glennswest/libignition/igntool/igntool a ../content/ovs_$VERSION.ign .)
$GOPATH/src/github.com/glennswest/libignition/igntool/igntool ls content/ovs_$VERSION.ign
#rm -r -f wip/bin



