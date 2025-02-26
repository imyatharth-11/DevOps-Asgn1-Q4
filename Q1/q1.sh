#!/bin/bash

set -e #When error occurs it will stop the further execution of the code


number_to_array() {
	local number=$1
	local digit_array=()
	local iter_count=0
	while [ $number -ne 0 ]
	do
		digit_array[$iter_count]=$((number % 10))
		iter_count=$((iter_count + 1))
		number=$((number / 10))
	done
	iter_count=0
	echo ${digit_array[@]}
}

array_to_number() {
	local arr=($@)
	local num=0
	for i in ${arr[@]}
	do
		num=$((num*10 + $i))
	done
	echo $num
}

sort_asc() {
	array=($@)
	for (( i=0; i<4; i++ )); do
		for (( j=0; j<3; j++ )); do
			if (( array[j] >= array[j+1] )); then
				temp=${array[j]}
				array[j]=${array[j+1]}
				array[j+1]=$temp
			fi
		done
	done
	echo ${array[@]}
}

sort_desc() {
	array=($@)
	for (( i=0; i<4; i++ )); do
		for (( j=0; j<3; j++ )); do
			if (( array[j] <= array[j+1] )); then
				temp=${array[j]}
				array[j]=${array[j+1]}
				array[j+1]=$temp
			fi
		done
	done
	echo ${array[@]}
}

process() {
	local digit_array=($@)
	local num=$(array_to_number ${digit_array[@]})
	local itr_count=0
	if (( num != 6174 )); then
		echo NUMBERS:
	fi
	while (( $num != 6174 )); do
		asc_order=$(sort_asc ${digit_array[@]})	
		num1=$(array_to_number ${asc_order[@]})
		
		desc_order=$(sort_desc ${digit_array[@]})	
		num2=$(array_to_number ${desc_order[@]})
	
		num=$(($num2-$num1))
		
		echo $num

		digit_array=()
		digit_array=$(number_to_array $num) 
		length=0
		
		for i in ${digit_array[@]}
		do
			length=$(($length+1))
		done

		count=$((4-$length))
		
		while [ $count -ne 0 ]; do
			num=$(($num*10))
			count=$(($count-1))
		done
		digit_array=()
		digit_array=$(number_to_array $num)
		itr_count=$(($itr_count + 1))
	done
	echo TOTAL ITERATIONS: $itr_count
	echo
}


error_handling(){
	digit_array=($@)
	length=${#digit_array[*]}
	# Error handling 1, when the length of the number is != 4
	if [ $length -ne 4 ]
	then
		echo "The length of the input number is not equal to 4, exiting..."
		exit 1
	fi
	# Error handling 2, check that all digits should not be identical
	check=-1
	count=0
	for i in ${digit_array[@]}
	do
		if [ $check -eq -1 ]
		then
			check=$i
			count=1
		else
			if [ $check -ne $i ]
			then
				count=$((count+1))
			fi
		fi
	done
	if [ $count -eq 1 ]
	then
		echo "All digits are identical, exiting..."
		exit 1
	fi
}

format_correction() {
	array=($@)
	temp1=${array[0]}
	temp2=${array[1]}
	array[0]=${array[3]}
	array[3]=$temp1
	array[1]=${array[2]}
	array[2]=$temp2
	echo ${array[@]}
}

main () {
	read -p "Enter the number:" number
	digit_array=$(number_to_array $number)
	echo ERROR CHECKING...
	error_handling ${digit_array[@]}
	echo NO ERROR FOUND IN THE INPUT!!!
	array=$(format_correction ${digit_array[@]})
	echo PROCESSING...
	process ${array[@]}
}

main
