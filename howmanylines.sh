#! /bin/bash

spath=$2
ftype=$1

echo "type: $ftype"
echo "path: $spath"
find $2 -name "$ftype" | xargs awk 'BEGIN{x=0} $0 !~ /^$/{x=x+1} END{print "sum:" " " x " " "lines"}'
