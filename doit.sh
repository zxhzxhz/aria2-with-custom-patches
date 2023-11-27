#!/bin/sh

arch=x86_64
export HOST=$arch-w64-mingw32
export PREFIX=$PWD/forARIA2/$HOST

tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --enable-fat --disable-cxx
make -j$(nproc)
make install
cd ..

tar -xf expat-2.5.0.tar.xz
cd expat-2.5.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --without-examples CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf sqlite-autoconf-3440100.tar.gz
cd sqlite-autoconf-3440100
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX CFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf c-ares-1.22.1.tar.gz
cd c-ares-1.22.1
#speedup "configure" for mingw-w64
patch -p1 < ../paczykcaresconf.patch
#if above patch doesn't apply, use those below
#export curl_cv_func_getnameinfo_args='const struct sockaddr *,socklen_t,DWORD,int'
#export curl_cv_func_recv_args='SOCKET,char *,int,int,int'
#export curl_cv_func_recvfrom_args='SOCKET,char *,int,int,struct sockaddr *,int *,int'
#export curl_cv_func_send_args='SOCKET,const char *,int,int,int'
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --without-random --disable-tests CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf zlib-1.3.tar.xz
cd zlib-1.3
export CHOST=$HOST
./configure --static --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

tar -xf libssh2-1.11.0.tar.xz
cd libssh2-1.11.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --disable-examples-build CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

mkdir -p binaries/$arch
tar -xf aria2-1.37.0.tar.xz
cd aria2-1.37.0
patch -p1 < ../paczykaria2.patch
./mingw-config
make -j$(nproc)
${HOST}-strip src/aria2c.exe
cp src/aria2c.exe ../binaries/$arch/aria2c-$arch.exe
cd ..

rm -r aria2-1.37.0
rm -r c-ares-1.22.1
rm -r expat-2.5.0
rm -r gmp-6.3.0
rm -r libssh2-1.11.0
rm -r sqlite-autoconf-3440100
rm -r zlib-1.3

arch=i686
export HOST=$arch-w64-mingw32
export PREFIX=$PWD/forARIA2/$HOST

tar -xf gmp-6.3.0.tar.xz
cd gmp-6.3.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --enable-fat --disable-cxx
make -j$(nproc)
make install
cd ..

tar -xf expat-2.5.0.tar.xz
cd expat-2.5.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --without-examples CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf sqlite-autoconf-3440100.tar.gz
cd sqlite-autoconf-3440100
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX CFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf c-ares-1.22.1.tar.gz
cd c-ares-1.22.1
#speedup "configure" for mingw-w64
patch -p1 < ../paczykcaresconf.patch
#if above patch doesn't apply, use those below
#export curl_cv_func_getnameinfo_args='const struct sockaddr *,socklen_t,DWORD,int'
#export curl_cv_func_recv_args='SOCKET,char *,int,int,int'
#export curl_cv_func_recvfrom_args='SOCKET,char *,int,int,struct sockaddr *,int *,int'
#export curl_cv_func_send_args='SOCKET,const char *,int,int,int'
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --without-random --disable-tests CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

tar -xf zlib-1.3.tar.xz
cd zlib-1.3
export CHOST=$HOST
./configure --static --prefix=$PREFIX
make -j$(nproc)
make install
cd ..

tar -xf libssh2-1.11.0.tar.xz
cd libssh2-1.11.0
./configure --enable-shared=no --enable-static=yes --host=$HOST --prefix=$PREFIX --disable-examples-build CFLAGS='-g0 -O3' CXXFLAGS='-g0 -O3'
make -j$(nproc)
make install
cd ..

mkdir -p binaries/$arch
tar -xf aria2-1.37.0.tar.xz
cd aria2-1.37.0
patch -p1 < ../paczykaria2.patch
./mingw-config
make -j$(nproc)
${HOST}-strip src/aria2c.exe
cp src/aria2c.exe ../binaries/$arch/aria2c-$arch.exe
cd ..

sha256sum *.tar.* > sha256sums.txt
echo creating binaries.tar.xz file
tar -cJf binaries.tar.xz binaries sha256sums.txt *.patch
sha1sumhash=$(sha1sum binaries.tar.xz | cut -d' ' -f1)
echo creating binaries.tar.xz.$sha1sumhash.SHA1 file
echo $sha1sumhash > binaries.tar.xz.$sha1sumhash.SHA1
echo "sha1sumhash=$sha1sumhash" >> "$GITHUB_OUTPUT"
echo DONE
