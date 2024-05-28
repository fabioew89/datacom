#!/usr/bin/env bash

name="TEXT"

hastag(){
    for _ in {1..5}; do 
        echo -n " ##### "
    done
}
hastag_count=$(( hast=$( hastag | wc -c ) * 2 ))

for _ in $hastag_count; do
    test
done

echo "$hastag_count"
