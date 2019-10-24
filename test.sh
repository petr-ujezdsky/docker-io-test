#!/bin/sh

if [[ "$INSIDE" != "true" ]]; then
  docker run --rm -it -e INSIDE=true -v "$(pwd)/:/test/" --workdir /test alpine ./test.sh $@
  exit
fi

parse() {
  while IFS= read -r line
  do
    if [ "$1" == "--verbose" ]; then
      echo $line
    else
      if echo "$line" | grep "real" > /dev/null; then
        echo "$line" | sed -e 's/real //' -e 's/\./,/' -e 's/\\n//' | tr '\n' '\t'
      fi
    fi
  done < "/dev/stdin"
}

for i in $(seq $1)
do
  mkdir tmp 2> /dev/null

  (
    echo
    echo "TEST - write 100 MiB file"
    time -p dd if=/dev/zero of=./tmp/test.dat bs=1024 count=100000
    echo

    echo "TEST - read 100 MiB file"
    time -p cat ./tmp/test.dat > /dev/null
    echo

    echo "TEST - copy 100 MiB file"
    time -p cp ./tmp/test.dat ./tmp/test2.dat
    echo

    echo "TEST - write 1000 small files"
    time -p ./manyFiles.sh
    echo

    echo "TEST - delete all tmp files"
    time -p rm -rf ./tmp
    echo
  ) 2>&1 | parse $2
  echo
done
