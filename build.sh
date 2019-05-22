git push origin master
export GIT_COMMIT=$(git rev-parse --short HEAD)
rm -r -f tmp
mkdir tmp
docker build --no-cache -t glennswest/winmachineman:$GIT_COMMIT .
docker tag glennswest/winmachineman:$GIT_COMMIT  docker.io/glennswest/winmachineman:$GIT_COMMIT
docker push docker.io/glennswest/winmachineman:$GIT_COMMIT
