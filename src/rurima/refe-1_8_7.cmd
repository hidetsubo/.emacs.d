@echo off
pushd "%~dp0"
ruby -Ke -I bitclust/lib bitclust/bin/refe -d db-1_8_7 -e sjis %*
popd
