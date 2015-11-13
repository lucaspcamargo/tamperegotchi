ls -l
qtchooser -qt=5 -run-tool=qmake --version
rm -rf build
mkdir build
cd build
echo BUILD
ls -l
qtchooser -qt=5 -run-tool=qmake ../tamperegotchi
echo BUILD 2
ls -l
make
