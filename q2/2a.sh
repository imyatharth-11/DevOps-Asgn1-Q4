#!/bin/bash

main() {
	declare -A matrix
	local directory=( $PWD ) 
	local row=0
	for dir in ${directory[@]}; do
		for i in $dir/*; do
			matrix[$row,0]=$i
			flag=0
			length=${#i}
			file_type=""
			for (( j=0; j<$length; j++ )); do
				character=${i:j:1}
				if [ $character == "." ]
				then
					flag=1
					ext=length-j
					file_type=${i:j:ext}
				fi
			done
		
			current_size=`ls -l $i | tr -s " " | cut -f5 -d " "`
		
			if (( flag == 0 )); then
				matrix[$row,1]=.dir
	       		else
				matrix[$row,1]=$file_type
			fi
		
			matrix[$row,2]=$current_size
			row=$(($row+1))	
		done
	done
	file_name="machine_info.txt"
	>$file_name
	for (( i=0; i<row; i++ )); do
		mat=()
		for (( j=0; j<3; j++ )); do
			mat[$j]=${matrix[$i,$j]}
		done
		echo ${mat[@]} >> $file_name
	done
	
}

main
