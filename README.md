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
https://github.com/tdanielsousa/philosophers_tester.git
```

## Usage

If you haven't already, run ```make``` in your philo directory to create your ```./philo``` executable.  
With the tester on the same directory just run ```./test.sh```.  
Tester takes an optional 2nd argument of the path to your ```philo``` executable.  

Example:  
```bash
./test.sh ./philo
```
If not provided, the tester assumes the path is ```./philo``` - i.e. in same directory as tester directory.

### Adding tests
If you wish to add your own tests, open .sh file and look for:  
no_die_tests=(  
		"5 800 200 200"  
		"5 600 150 150"  
		"4 410 200 200"  
		"100 800 200 200"  
		"105 800 200 200"  
		"200 800 200 200"  
	)



## Credits
This is inspired on the LazyPhilosophers Tester made by MichelleJiam  
```
https://github.com/MichelleJiam/LazyPhilosophersTester
```
It's however completely different, it's only one single .sh file, uses no py.

