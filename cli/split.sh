#!/bin/bash

# Check if the input file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <input_video_file>"
    exit 1
fi

input_file="$1"
output_prefix="segment_"
segment_size="40k"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "Error: Input file '$input_file' not found."
    exit 1
fi

# Create a directory to store the segments
output_dir="video_segments"

# Check if the output directory already exists
if [ -d "$output_dir" ]; then
    read -p "The '$output_dir' folder already exists. Do you want to empty it? (y/n) " -n 1 -r
    echo    # Move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        rm -rf "$output_dir"/*
        echo "The '$output_dir' folder has been emptied."
    else
        echo "Operation cancelled. The existing segments will be overwritten."
    fi
fi

mkdir -p "$output_dir"

# Split the video file into 40KB segments
split -b "$segment_size" --suffix-length=4 "$input_file" "$output_dir/$output_prefix"

echo "Video file has been split into 40KB segments in the '$output_dir' directory."
