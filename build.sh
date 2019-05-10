rm commit.id
cp ../winnodemanager/winnodeman.version content
git add -f content/winnodeman.version
git commit -a -m "winnodeman version change - rebuild container"
git push origin master
md5sum content/* > content/ignition.md5
git add content/ignition/md5
git commit -a -m "content has changed - rebuild container"
git push origin master
export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
echo $GIT_COMMIT > commit.id
#eval $(minishift docker-env)
rm content/winnodeman.exe
cp ../winnodemanager/winnodeman.exe content
docker build --no-cache -t glennswest/winmachineman:$GIT_COMMIT .
docker tag glennswest/winmachineman:$GIT_COMMIT  docker.io/glennswest/winmachineman:$GIT_COMMIT
docker push docker.io/glennswest/winmachineman:$GIT_COMMIT
rm commit.id
