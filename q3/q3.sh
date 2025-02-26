#!/bin/bash

main() {
	var=0
	itr_count=0 # itr_count will store the total rounds
	matrix=(0 0 0) # It will store the result
	while (( $var != 1 )); do # Before the next round user will be asked whether to continue or not
		echo PRESS 1 TO STOP ELSE SOMETHING ELSE TO CONTINUE
		input=0
		read -p "" input # Takes the user input
	       	if (( input == 1 )); then # If the user presses 1 the game will be ended
			break
		fi	# Else the game continues on
		maxi=1 # It stores the maximum range to which we will go
		mini=0 # It store the minimum range to which we will go
		action_1=$(($RANDOM%($maxi-$mini+1)+$mini)) # Generates a random number in range [0,1] for user 1
		action_2=$(($RANDOM%($maxi-$mini+1)+$mini)) # Generates a random number in range [0,1] for user 2
		# Now there are 4 possible cases which are (0,0), (0,1), (1,0), (1,1)
		# First state is not a stable stable state refered to as accident state
		# Second and Third states are optimal and safe state,
		# Fourth is a stable one but not optimal
		# We can observe that sum of 1st state is 0, sum of 2nd and 3rd is 1 and that of 4th is 2
		# We will use the above observation
		index=$(($action_1 + $action_2)) # Finding the sum of state which will be the index of the matrix
		matrix[$index]=$((${matrix[$index]} + 1)) # Incrementing value of of matrix at that index
		itr_count=$(($itr_count + 1)) # Increment that counter indicating the rounds played
	done
	echo Total Rounds: $itr_count # Printing total rounds that were played
	echo Total Accidents: ${matrix[0]} # Printing the total number of accidents that took place
	echo Total Optimal and Safe States: ${matrix[1]} # Printing the number of times there was safa and optimal state
	echo Total Non Optimal and Safe States: ${matrix[2]} # Printing the number of times there was a safe state but not an optimal state
}

main
