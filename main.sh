#!/bin/bash

#################################################################################
# Downloads the specified Word files and moves them to the appropriate location #
#################################################################################

# Semicolon delimited string arr_iday of ids
ids="13WV4Z0S4V8joogYVSpNUXqRfynuF0LIy;17sBoebcRnQyyiBfXuRwg_xVOrH5tcf2z"
# Filenames
fnames="chap2;chap6"
# Languages
fext="en;en"


# Create arrays and get length
arr_id=($(echo $ids | tr ";" "\n"))
arr_names=($(echo $fnames | tr ";" "\n"))
arr_exts=($(echo $fext | tr ";" "\n"))
length=${#arr_id[@]}

for (( i=0; i<${length}; i++ ));
do
  # Download word file
  `wget https://docs.google.com/uc\?export=download\&id=${arr_id[$i]}\&confirm=t -O ${arr_names[$i]}.docx` || { echo 'Download failed' ; exit 1; }

  # For some reason execution does not wait for wget to finish
  wait

  # TODO Use tmp=`md5sum <file>` to save hash and then use it again to check if file is already updated

  # Convert to md (file1.docx -> file1.en.md)
  pandoc -s ${arr_names[$i]}.docx -f docx --extract-media=. -t gfm -o ${arr_names[$i]}.${arr_exts[$i]}.md

  # Make clean image directories
  rm -rf docs/${arr_names[$i]}
  mkdir media
  mkdir media/${arr_names[$i]}

  # Fix superscripts. ^n^ -> [^n]
  # sed -ri "s/\^([0-9]+)\^/\[\^\1\]/g" ${arr_names[$i]}.${arr_exts[$i]}.md
  sed -ri "s/<sup>([0-9]+)<\/sup>/\[\^\1\]/g" ${arr_names[$i]}.${arr_exts[$i]}.md
  # Fix footnote n . -> [^1]: 
  sed -ri "s/^([0-9]+)\. /\[\^\1\]: /g" ${arr_names[$i]}.${arr_exts[$i]}.md
  # Fix multiple references
  perl tmp.pl ${arr_names[$i]}.${arr_exts[$i]}.md

  # Move images to folder that has the same name as the file
  ls media -p | grep -v / | sed "s/\([a-zA-Z0-9-]*\)\(\.[a-z]*\)/mv media\/\1\2 media\/${arr_names[$i]}\/\1\2/" | sh
  # Fix image references
  sed -ri "s/!\[\]\(\.\/(media)\//!\[\]\(\.\/${arr_names[$i]}\//g" ${arr_names[$i]}.${arr_exts[$i]}.md

  # Move to docs folder
  mv ${arr_names[$i]}.${arr_exts[$i]}.md docs/
  mv media/* docs/
  rm media -rf
  
  # Remove doc file
  rm ${arr_names[$i]}.docx
done
