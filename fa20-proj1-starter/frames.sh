#!/bin/bash

indir="testInputs"
outdir="studentOutputs"
life="./gameOfLife"

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <rootname> <rule> <frames>"
    echo "Example: frames.sh glider 0x1808 10"
    exit 0
fi

name=$1
rule=$2
frames=$3

if [ ! -e "$indir" ]; then
    echo "$indir input directory doesn't exist, exiting..."
    exit 1
fi

if [ ! -e "$indir/$name.ppm" ]; then
    echo "$indir/$name.ppm initial PPM file doesn't exist, exiting..."
    exit 1
fi

if [ ! -e "$outdir" ]; then
    echo "$outdir output directory doesn't exist, creating..."
    mkdir "$outdir"
fi

if [ ! -e "$outdir/$name" ]; then
    echo "$name directory doesn't exist, creating..."
    mkdir "$outdir/$name"
else
    echo "$name directory already exists; existing files will not be recomputed"
fi

cp "$indir/$name.ppm" "$outdir/$name/${name}_${rule}_10000.ppm"

n=10000
max=$((10000 + frames))

while [ "$n" -lt "$max" ]; do
    np=$((n + 1))
    report=$((np - 10000))

    if [ -e "$outdir/$name/${name}_${rule}_${np}.ppm" ]; then
        echo -n "[$report] "
    else
        echo -n "$report "
        "$life" "$outdir/$name/${name}_${rule}_${n}.ppm" "$rule" > "$outdir/$name/${name}_${rule}_${np}.ppm"
    fi

    n=$((n + 1))
done

echo ""
echo "Making gif in $name.gif"

convert -delay 20 -loop 0 -scale 400% "$outdir/$name/"*.ppm ""$outdir/$name.gif""

echo ""
