#!/bin/sh

for i in $(seq 1000)
do
  echo "I am very small" > "./tmp/small-$i"
done
