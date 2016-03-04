#!/bin/bash
# Gets text from a bin Photoshop file
# This script takes two arguments at runtime the input PSD and output txt
# example:
# ./psdtotxt.sh input.psd output.txt

# Set INLINE FIELD SEPERATOR to prevent parsing errors caused by spaces in PSD
IFS=$'\n'

# Set command line arguments to variables
inputfile=$1
outputfile=$2

### SANITY CHECKS ###

# Check that the input file has been passed as an argument when the script is called
if [[ $inputfile == '' ]]
    then
        echo "No input file selected! Please use the following syntax:";
        echo "./psdtotxt.sh input.psd output.txt";
        exit;
fi

# Check that the output file has been passed as an argument when the script is called
if [[ $outputfile == '' ]]
    then
        echo "No output file selected! Please use the following syntax:";
        echo "./psdtotxt.sh input.psd output.txt";
        exit;
fi

# Check that input file is not the output file
if [[ $inputfile == $outputfile ]]
    then
        echo "Input File and Output File cannot be the same!";
        exit;
fi
# Check that the Input file exists!
if [ ! -f $inputfile ]
    then
        echo "Input file not found";
        exit;
fi

# Check if output file exists - if it does determine if it should be overwritten
if [ -f $outputfile ]
    then
        echo "Output file alredy exists - Overwrite Existing? [y/N]";
        read overwrite;
        if [[ $overwrite =~ ^([yY][eE][sS]|[yY])$ ]]
            then
                rm $outputfile;
            else
                exit;
        fi
fi

### DO WORK ###

# Parse the input txt and update any lines containing coordinates - print results to outfile
function parse_txt {
    sed -n "/<photoshop:TextLayers>/,/<\/photoshop:TextLayers>/p" $inputfile > $outputfile
}

parse_txt $inputfile $outputfile;

echo "Created new txt file $outputfile";
exit;