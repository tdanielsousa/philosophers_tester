## Tester for Philosophers project at 42 School 

It allows you to test:  
 0 - Run both tests  
 1 - Run tests where should die, eat X times, check args  
 2 - Run timed tests where it shouldn't die  
 3 - Helgrind syntax to copy paste  

![Screenshot of the tester](https://i.imgur.com/cOCqfjZ.png)

## Installation
Clone the tester to the directory of ./philo 
```bash
https://github.com/MichelleJiam/LazyPhilosophersTester.git
```

## Usage

If you haven't already, run ```make``` in your philo directory to create your ```./philo``` executable.  
Then from within the LazyPhilosophersTester directory, run ```./test.sh``` to start the tester.  
Tester takes an optional 2nd argument of the path to your ```philo``` executable.  

Example:  
```bash
./test.sh ../philo
```
If not provided, the tester assumes the path is ```../philo``` - i.e. in same directory as tester directory.

### Adding tests
If you wish to add your own tests, open either:
Inside the .sh there is>
no_die_tests=(
		"5 800 200 200"
		"5 600 150 150"
		"4 410 200 200"
		"100 800 200 200"
		"105 800 200 200"
		"200 800 200 200"
	)



## Credits
Timed-checker Python script ```PhilosophersChecker.py``` [(link)](https://gist.github.com/jkctech/367fad4aa01c820ffb1b8d29d1ecaa4d) was written by [JKCTech](https://gist.github.com/jkctech) and modified slightly by me to take an optional timer duration.  
[Progress bar function](https://stackoverflow.com/a/52581824) written by Vagiz Duseev, found on StackOverflow.
