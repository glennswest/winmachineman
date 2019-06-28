git pull
export GIT_COMMIT=$(git rev-parse --short HEAD)
echo $GIT_COMMIT
export pname=winmachineman
oc delete dc $pname
oc delete is $pname
oc delete sa $pname
oc delete project $pname
sleep 20
oc new-project $pname
oc import-image $pname --from=docker.io/glennswest/$pname:$GIT_COMMIT --confirm
#oc create sa $pname
#oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:$pname:default
#oc policy add-role-to-user admin  system:serviceaccount:$pname:default
oc delete  istag/$pname:latest
oc new-app glennswest/$pname:$GIT_COMMIT --token=$(oc sa get-token $pname) 
export defaultdomain=$(oc describe --namespace=openshift-ingress-operator ingresscontroller/default | grep "Domain:" | cut -d ":" -f 2 | cut -d "." -f 1-)
oc expose svc/winmachineman --hostname=winmachineman.$defaultdomain
sleep 20
#oc set env dc/winmachineman  MYURL=https://media.githubusercontent.com/media/glennswest/wcontent/master
oc set env dc/winmachineman MYURL=winoperatordata.$defaultdomain
