#! /bin/sh

. ../../testenv.sh

for t in slice01 slice02 slice03; do
    synth_tb $t
done

echo "Test successful"
