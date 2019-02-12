#!/bin/bash

export DEBEMAIL=james@openastroproject.org
export DEBFULLNAME="James Fidell"

version=`cat version`

srcdir=libuvc-$version
debdir=debian
debsrc=$debdir/source
quiltconf=$HOME/.quiltrc-dpkg

tar zxf libuvc-$version.tar.gz
cd $srcdir
YFLAG=-y
dh_make -v | fgrep -q '1998-2011'
if [ $? -eq 0 ]
then
  YFLAG=''
fi
dh_make $YFLAG -l -f ../libuvc-$version.tar.gz

cp ../debfiles/control $debdir
cp ../debfiles/copyright $debdir
cp ../debfiles/changelog $debdir
cp ../debfiles/watch $debdir
cp ../debfiles/libuvc.dirs $debdir
#cp ../debfiles/libuvc.links $debdir
cp ../debfiles/libuvc.install $debdir
cp ../debfiles/libuvc-dev.dirs $debdir
cp ../debfiles/libuvc-dev.install $debdir
#cp ../debfiles/libuvc-dev.links $debdir
cp ../debfiles/libuvc.symbols $debdir

echo 10 > $debdir/compat

echo "3.0 (quilt)" > $debsrc/format

cp $debdir/rules $debdir/rules.ex
sed -e '/^DEB_BUILD_MAINT_OPTIONS =/s/^#//' \
  -e '/^DEB_BUILD_MAINT_OPTIONS =/s/+all/+bindnow/' < $debdir/rules.ex > $debdir/rules
sed -e "s/VERSION/$version/g" < ../debfiles/rules.overrides >> $debdir/rules

rm -f $debdir/README.Debian
rm -f $debdir/README.source
rm -f $debdir/libuvc-docs.docs
rm -f $debdir/libuvc1.*
rm -f $debdir/*.[Ee][Xx]

export QUILT_PATCHES="debian/patches"
export QUILT_PATCH_OPTS="--reject-format=unified"
export QUILT_DIFF_ARGS="-p ab --no-timestamps --no-index --color=auto"
export QUILT_REFRESH_ARGS="-p ab --no-timestamps --no-index"
mkdir -p $QUILT_PATCHES

for p in `ls -1 ../debfiles/patches`
do
  quilt --quiltrc=$quiltconf new $p
  for f in `egrep '^\+\+\+' ../debfiles/patches/$p | awk '{ print $2; }'`
  do
    n=`echo $f | sed 's!^libuvc-[0-9]\.[0-9]\.[0-9]/!!'`
    quilt --quiltrc=$quiltconf add $n
  done
pwd
  patch -p1 < ../debfiles/patches/$p
  quilt --quiltrc=$quiltconf refresh
done

dpkg-buildpackage -us -uc

echo "Now run:"
echo
echo "    lintian -i -I --show-overrides libuvc_$version-1openastro2_amd64.changes"
