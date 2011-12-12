#!/bin/bash

set -u

generate() {
    for i in `seq 2 10000`; do
        echo "$i"
    done
}

filter() {
    while read n; do
        if [ $(($n % $1)) -ne 0 ]; then
            echo "$n"
        fi
    done
}

dir=$(mktemp -d)
ch=0
mkfifo "$dir/$ch"
generate > "$dir/$ch" &
while true; do
    exec 3<"$dir/$ch"
    read p <&3 || break
    echo "$p"
    let ch++
    mkfifo "$dir/$ch"
    filter "$p" <&3 > "$dir"/$ch &
done
