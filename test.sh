#!/bin/bash

# Colours
RED="\033[0;31m"
CYAN="\033[0;36m"
PURP="\033[0;35m"
GREEN="\033[0;32m"
BLUEBG="\033[44m"
WHITE="\033[1;97m"
RESET="\033[0m"

# Counters
PASS=0
FAIL=0
TESTS=0
TESTS1=0

# Check parameters. If none given, assumes philo executable is in ../philo
if [ "$#" -gt 1 ]; then
	printf "Too many parameters. Please only provide path to philo executable.\n"
	exit
elif [ "$#" -lt 1 ]; then
	set -- ./philo
fi

# Check if given executable path and file is valid.
if [ ! -f "$1" ]; then
	printf "$1 not found or invalid file. Please (re)make philo executable first.\n"
	exit
fi

PROGRESS_BAR_WIDTH=50  # progress bar length in characters

draw_progress_bar() {
	# Arguments: current value, max value, unit of measurement (optional)
	local __value=$1
	local __max=$2
	local __unit=${3:-""}

	if (( $__max < 1 )); then __max=1; fi
	local __percentage=$(( 100 * __value / __max ))
	local __num_bar=$(( __percentage * PROGRESS_BAR_WIDTH / 100 ))

	# Draw progress bar
	printf "["
	for _ in $(seq 1 $__num_bar); do printf "#"; done
	for _ in $(seq 1 $(( PROGRESS_BAR_WIDTH - __num_bar ))); do printf " "; done
	printf "] %3s%% (%s / %s %s)\r" "$__percentage" "$__value" "$__max" "$__unit"
}

die_test () {
	printf "\n${CYAN}=== Tests where should die, eat X times, check args ===\n${RESET}"

	# Embedded test inputs and expected results
	die_tests=(
		"1 800 200 200"
		"4 310 200 100"
		"4 200 205 200"
		"5 800 200 200 7"
		"4 410 200 200 10"
		"-5 600 200 200"
		"4 -5 200 200"
		"4 600 -5 200"
		"4 600 200 -5"
		"4 600 200 200 -5"
	)
	die_results=(
		"a philo should die"
		"a philo should die"
		"a philo should die"
		"no one should die, simulation should stop after 7 eats"
		"no one should die, simulation should stop after 10 eats"
		"should error and not run (no crashing)"
		"should error and not run (no crashing)"
		"should error and not run (no crashing)"
		"should error and not run (no crashing)"
		"should error and not run (no crashing)"
	)

	for i in "${!die_tests[@]}"; do
		input="${die_tests[$i]}"
		result="${die_results[$i]}"
		printf "\nTest: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n\n"
		read -rs -n 1 -p $'Press ENTER to start, press any other key to exit.\n' key
		if [[ "$key" != "" ]]; then
			printf "\n${GREEN}PASSED${RESET}: $PASS/$TESTS1 | ${RED}FAILED${RESET}: $FAIL/$TESTS1\n"
			exit 0
		fi

		printf "\n"
		$1 $input
		status=$?

		(( TESTS1++ ))

		if [[ $status -eq 0 ]]; then
			(( PASS++ ))
		else
			(( FAIL++ ))
		fi
	done
	printf "\n${GREEN}PASSED${RESET}: $PASS/$TESTS1 | ${RED}FAILED${RESET}: $FAIL/$TESTS1\n"
	printf "5 Are supposed to pass, and 5 are supposed to fail due to invalid ARGS\n\n"
}


no_die_test () {
	printf "\n${CYAN}*** Timed tests where it shouldn't die ***\n${RESET}"
	printf "${PURP}Enter time for tests (INT) or blank = default is 10 seconds:${RESET}\n"
	read -r timeout
	printf "\n"
	if [[ $timeout != *[[:digit:]]* ]]; then
		timeout=10
	fi

	# Embedded test inputs and expected results
	no_die_tests=(
		"5 800 200 200"
		"5 600 150 150"
		"4 410 200 200"
		"100 800 200 200"
		"105 800 200 200"
		"200 800 200 200"
	)
	no_die_results=(
		"no one should die"
		"no one should die"
		"no one should die"
		"no one should die"
		"no one should die"
		"no one should die"
	)

	for i in "${!no_die_tests[@]}"; do
		input="${no_die_tests[$i]}"
		result="${no_die_results[$i]}"
		printf "Test: ${BLUEBG}${WHITE}[$input]${RESET} | ${PURP}$result${RESET}\n"
		read -rs -n 1 -p $'Press ENTER to start, any other key to exit.\n' key
		if [[ "$key" != "" ]]; then
			printf "\n${GREEN}PASSED${RESET}: $PASS/$TESTS | ${RED}FAILED${RESET}: $FAIL/$TESTS\n"
			exit 0
		fi

		printf "\n"
		$1 $input > /dev/null &
		pid=$!
		sleep 1

		if ! kill -0 "$pid" 2>/dev/null; then
			printf "${RED}Never started...${RESET}\n"
			(( FAIL++ ))
			(( TESTS++ ))
			continue
		fi

		for ((elapsed = 0; elapsed < timeout; elapsed++)); do
			draw_progress_bar "$((elapsed + 1))" "$timeout" "seconds"
			if ! kill -0 "$pid" 2>/dev/null; then
				printf "\n\n${RED}KO${RESET} - process died at ${elapsed}s\n"
				(( FAIL++ ))
				(( TESTS++ ))
				break
			fi
			sleep 1
		done

		# If we finished the countdown and process still alive
		if kill -0 "$pid" 2>/dev/null; then
			kill "$pid" 2>/dev/null
			wait "$pid" 2>/dev/null
			printf "\n${CYAN}******************************************${RESET}"
			printf "\n${GREEN}OK${RESET} ${PURP} - Survived ${timeout}s ${RESET}\n"
			printf "${CYAN}******************************************${RESET}\n"
			(( PASS++ ))
			(( TESTS++ ))
		fi
	done
	TESTS=$(( TESTS + TESTS1 ))
	printf "\nNo-Die Tests: ${GREEN}PASSED${RESET}: $PASS/$TESTS | ${RED}FAILED${RESET}: $FAIL/$TESTS\n"
	printf "${CYAN}*** End result should be 11 pass, 5 fail if both tests are ran! ***${RESET}\n\n"
}


choose_test() {
	printf "${CYAN} Choose test to run: ${RESET}\n"
	printf "${PURP}************************************************************ ${RESET}"
	printf "\n${PURP} 0 - Run both tests ${RESET}"
	printf "\n${PURP} 1 - Run tests where should die, eat X times, check args ${RESET}"
	printf "\n${PURP} 2 - Run timed tests where it shouldn't die ${RESET}"
	printf "\n${PURP} 3 - Helgrind syntax to copy paste ${RESET}"
	printf "\n${PURP}************************************************************ \n${RESET}"
	read -rn1 choice
	printf "\n"
	case $choice in
		0) die_test "$1" && no_die_test "$1" ;;
		1) die_test "$1" ;;
		2) no_die_test "$1" ;;
		3) echo valgrind --tool=helgrind ./philo 8 800 200 200 3 ;;
		$'\e') exit 0 ;;
		*) printf "${RED}Invalid choice\n${RESET}"; choose_test "$1" ;;
	esac
}
printf "${CYAN}  ***********************${RESET}\n"
printf "${CYAN}  * Philosophers Tester *${RESET}\n"
printf "${CYAN}  ***********************${RESET}\n"

choose_test "$1"
