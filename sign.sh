SIGNER=meshcollider
VERSION=0.17.1rc1


pushd ./gitian-builder
./bin/gbuild -i --commit signature=v${VERSION} ../bitcoin/contrib/gitian-descri$
./bin/gsign --signer $SIGNER --release ${VERSION}-osx-signed --destination ../g$
./bin/gverify -v -d ../gitian.sigs/ -r ${VERSION}-osx-signed ../bitcoin/contrib$
mv build/out/bitcoin-osx-signed.dmg ../bitcoin-${VERSION}-osx.dmg

./bin/gbuild -i --commit signature=v${VERSION} ../bitcoin/contrib/gitian-descri$
./bin/gsign --signer $SIGNER --release ${VERSION}-win-signed --destination ../g$
./bin/gverify -v -d ../gitian.sigs/ -r ${VERSION}-win-signed ../bitcoin/contrib$
mv build/out/bitcoin-*win64-setup.exe ../bitcoin-${VERSION}-win64-setup.exe
mv build/out/bitcoin-*win32-setup.exe ../bitcoin-${VERSION}-win32-setup.exe
popd

