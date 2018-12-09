
SIGNER=meshcollider
VERSION=0.17.1rc1

pushd ./bitcoin
git fetch
git checkout v${VERSION}
popd

pushd ./gitian.sigs
git checkout master
git pull
git branch meshcollider_v${VERSION}
git checkout meshcollider_v${VERSION}
popd

#mkdir build-v${VERSION}

BUILD_LINUX=false
BUILD_WINDOWS=false
BUILD_OSX=false

while getopts "lwoa" opt; do
  case $opt in
    l) BUILD_LINUX=true     ;;
    w) BUILD_WINDOWS=true   ;;
    o) BUILD_OSX=true       ;;
    a) BUILD_LINUX=true
       BUILD_WINDOWS=true
       BUILD_OSX=true       ;;
  esac
done

pushd ./gitian-builder
git pull

if [ "$BUILD_LINUX" = true ] ; then
    echo "Building for Linux"
    ./bin/gbuild --num-make 3 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-linux.yml
    ./bin/gsign --signer "$SIGNER" --release ${VERSION}-linux --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-linux.yml
    mv build/out/bitcoin-*.tar.gz build/out/src/bitcoin-*.tar.gz ../build-v${VERSION}/
else
    echo "Not building for Linux, use -l to enable"
fi

if [ "$BUILD_WINDOWS" = true ] ; then
    echo "Building for Windows"
    ./bin/gbuild --num-make 3 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-win.yml
    ./bin/gsign --signer "$SIGNER" --release ${VERSION}-win-unsigned --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-win.yml
    mv build/out/bitcoin-*-win-unsigned.tar.gz inputs/bitcoin-win-unsigned.tar.gz
    mv build/out/bitcoin-*.zip build/out/bitcoin-*.exe ../build-v${VERSION}
else
    echo "Not building for Windows, use -w to enable"
fi

if [ "$BUILD_OSX" = true ] ; then
    echo "Building for OSX"
    ./bin/gbuild --num-make 3 --memory 4000 --commit bitcoin=v${VERSION} ../bitcoin/contrib/gitian-descriptors/gitian-osx.yml
    ./bin/gsign --signer "$SIGNER" --release ${VERSION}-osx-unsigned --destination ../gitian.sigs/ ../bitcoin/contrib/gitian-descriptors/gitian-osx.yml
    mv build/out/bitcoin-*-osx-unsigned.tar.gz inputs/bitcoin-osx-unsigned.tar.gz
    mv build/out/bitcoin-*.tar.gz build/out/bitcoin-*.dmg ../build-v${VERSION}
else
    echo "Not building for OSX, use -o to enable"
fi
popd
