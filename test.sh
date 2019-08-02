#!/bin/sh

if [[ "$INSIDE" != "true" ]]; then
  docker run --rm -it -e INSIDE=true -v "$(pwd)/:/test/" --workdir /test alpine ./test.sh
  exit
fi

mkdir tmp

echo
echo "TEST - write 100 MiB file"
time dd if=/dev/zero of=./tmp/test.dat bs=1024 count=100000
echo

echo "TEST - read 100 MiB file"
time cat ./tmp/test.dat > /dev/null
echo

echo "TEST - copy 100 MiB file"
time cp ./tmp/test.dat ./tmp/test2.dat
echo

echo "TEST - write 1000 small files"
# manyFiles
# time { for i in $(seq 10); do echo "I am very small";  done }
time ./manyFiles.sh
echo

echo "TEST - delete all tmp files"
time rm -rf ./tmp
echo
