# 2022-006-StateLab

## Chess clock with fewer clicks.
No more increment and decrement. 
Click on the numbers and add together.
Only white buttons are clickable.
Three minutes = 1 + 2

## Unique handicap system.
Default is no handicap.
The handicap is stated in sixtieths, 1/60.
The total time is constant.

### Example:
You have decided on a game using 10m + 5s.
Using handicap 30, you will move half (30/60) of your time to the second player.

The times will be 15m + 7.5s and 5m + 2.5s

### How to enter numbers
```
1
2
3 = 1 + 2
4
5 = 1 + 4
6 = 2 + 4
7 = 1 + 2 + 4
8
9 = 1 + 8
10 = 2 + 8
11 = 1 + 2 + 8
12 = 4 + 8
13 = 1 + 4 + 8
14 = 2 + 4 + 8
15
```

### The QR code
Contains the URL for the application.
Use your camera or QR reader app.

### Definitions
* reflection = the time you thinking
* bonus = time that will be added for every move. (Fischer System)
* hcp = handicap. Expressed in parts of sixty.
* swap. When using handicap, swaps the times for the players.
* h = hour 0 .. 59
* m = minute 0 .. 59
* s = second 0 .. 59
* t = handicap 0 .. 59

### Repeat Game
* Click pause
* Click new
* Click ok
* Click play
* Click one of the player times.

### Handicap based on ELO

* round(ELODifference / 20)
* Maximum 50.
####
Example table
```
 ELO hcp
   0   0 60m-60m will be 60m-60m
 100   5
 200  10
 300  15
 400  20
 500  25 60m-60m will be 35m-85m
 600  30
 700  35
 800  40
 900  45
1000  50 60m-60m will be 10m-110m
1100  50 
```