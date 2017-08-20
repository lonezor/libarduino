#!/bin/sh

################################################################################################################
# Script for automatically generating debug information to be shown on the LCD to indicate the software version
################################################################################################################

echo "generating header file 'autogen_libarduino_build_info.h'"

pwd=`pwd`
module_lowercase=`basename $pwd`
module_uppercase=`echo $module_lowercase | tr "[:lower:]" "[:upper:]"`
output_file=`echo "autogen_"$module_lowercase"_build_info.h"`

echo "#ifndef _AUTOGEN_"$module_uppercase"_BUILD_INFO_H_" > $output_file
echo "#define _AUTOGEN_"$module_uppercase"_BUILD_INFO_H_" >> $output_file
echo >> $output_file

# User name making the build
username=`whoami`
echo "static const char* "$module_lowercase"_binfo_username_p = \"$username\"; " >> $output_file

# YYYY-MM-DD timestamp
date=`date +%Y-%m-%d`
echo "static const char* "$module_lowercase"_binfo_yyyy_mm_dd_p = \"$date\";" >> $output_file

# HH:MM:SS timestamp
time=`date +%T`
echo "static const char* "$module_lowercase"_binfo_hh_mm_ss_p = \"$time\";" >> $output_file

# Latest commit on master branch
head=`cat .git/HEAD | awk '{print $2}'`
git_commit=`cat .git/$head | cut -c 1-8`
git_branch=`basename $head`
echo "static const char* "$module_lowercase"_binfo_git_commit_p = \"$git_commit\";" >> $output_file
echo "static const char* "$module_lowercase"_binfo_git_branch_p = \"$git_branch\";" >> $output_file

# Code size
lines_of_code=`cloc . | grep SUM | awk '{print $5}'`
echo "static const char* "$module_lowercase"_binfo_lines_of_code_p = \"$lines_of_code\";" >> $output_file

echo >> $output_file
echo "#endif /* _AUTOGEN_"$module_uppercase"_BUILD_INFO_H_ */" >> $output_file

