#!/bin/bash

group_by_file_type() {
	new_file="clubbed_machine_info.txt"
	>$new_file
	declare -A matrix
	local file_names=($@)
	for i in ${file_names[@]}; do
		while read -ra line; do
			local ext=""
			local size=0
			for word in ${line[@]}; do
				word_length=${#word}
				first_char=${word:0:1}
				if [ $first_char == "." ]; then
					ext=$word
				fi
				if ( [[ $ext != "" ]] && [[ $first_char == [0-9] ]] ); then
					size=$word
				fi		
			done
			if [[ -v matrix[$ext] ]]; then
				matrix[$ext]=$((${matrix[$ext]} + $size))
			else
				matrix[$ext]=$size
			fi
		done < $i
	done

	for i in ${!matrix[@]}; do
		echo $i ${matrix[$i]} >> $new_file
	done
	echo $new_file
}


plot_graph() {

	DATA_FILE="$1"
	OUTPUT_FILE_NAME=$2

	gnuplot -persist <<-EOFMarker
    	set terminal pngcairo enhanced font 'Arial,12' size 800,600
	set output "$OUTPUT_FILE_NAME"

    	set style data histograms
    	set style fill solid 1.0 border -1
    	set boxwidth 0.5

    	set xtics rotate by -45
	set ylabel "Size(KB)"
	set xlabel "File Type"
	set title "File Type vs Size(KB)"

	plot "$DATA_FILE" using 2:xtic(1) title 'Size(KB)' linecolor rgb "purple"
	EOFMarker

	echo 

}

main() {	
	file_names=("machine_info.txt")
	echo ${file_names[@]}
	data_file=$(group_by_file_type ${file_names[@]})
	output_file_name="bg1.png"
	plot_graph $data_file $output_file_name
	`xdg-open $output_file_name`	
}

main
