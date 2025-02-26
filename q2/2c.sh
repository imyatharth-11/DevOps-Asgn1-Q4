
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

    	set xtics rotate by -90
	set ylabel "Size(KB)"
	set xlabel "File Type"
	set title "File Type vs Size(KB)"

	plot "$DATA_FILE" using 2:xtic(1) title 'Size(KB)' linecolor rgb "purple"
	EOFMarker

	echo 

}

main() {
	declare -A matrix
	local directory=( $PWD "/etc/fonts/conf.avail/" "/etc" "/etc/profile.d" ) 
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
					ext=$(($length-j))
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
	
	file_names=("machine_info.txt")
	echo ${file_names[@]}
	data_file=$(group_by_file_type ${file_names[@]})
	output_file_name="bg2.png"
	plot_graph $data_file $output_file_name
	`xdg-open $output_file_name`	
}

main
