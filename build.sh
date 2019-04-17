export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
echo $GIT_COMMIT > commit.id
#eval $(minishift docker-env)
rm content/winnodeman.exe
cp ../winnodeman.exe content
docker build --no-cache -t glennswest/winmachineman:$GIT_COMMIT .
docker tag glennswest/winmachineman:$GIT_COMMIT  docker.io/glennswest/winmachineman:$GIT_COMMIT
docker push docker.io/glennswest/winmachineman:$GIT_COMMIT
rm commit.id
