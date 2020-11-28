# CS 431 - Assignment 3 : Haskell

## Question 1

Use the functions **myEmpty, myUnion, myIntersect, mySubtract** and **myAddition** along with the sets as a list to run.

```bash
Prelude> :load "question1.hs"
[1 of 1] Compiling Main             ( question1.hs, interpreted )
Ok, modules loaded: Main.
*Main> myIntersect [1, 2, 3, 3, 4] [1, 3, 5, 7]
[1, 3]
```

## Question 2

Use the functions **fixture** and **nextMatch** to run the corresponding fnuction. The fixture function can be run with "all" or "<teamName>" as argument. 

```bash
Prelude> :load "question2.hs"
[1 of 1] Compiling Main             ( question2.hs, interpreted )
Ok, modules loaded: Main.
**Main> fixture "all"
CS   vs.  CV    1-12-2020  9:30 AM
BS   vs.  CM    1-12-2020  7:30 PM
CH   vs.  DS    2-12-2O2O  9:30 AM
EE   vs.  HU    2-12-2020  7:30 PM
MA   vs.  ME    3-12-2020  9:30 AM
PH   vs.  ST    3-12-2020  7:30 PM
```

## Question 1

Use the function **design**  with the total area, number of bedrooms and halls as arguments.

```bash
Prelude> :load "question3.hs"
[1 of 1] Compiling Main             ( question3.hs, interpreted )
Ok, modules loaded: Main.
*Main> design 1000 3 2

Bedroom: 3(10,10)
Hall: 2(15,10)
Kitchen: 1(7,5)
Bathroom: 4(4,5)
Garden: 1(12,17)
Balcony: 1(9,9)
Unused Space: 0

```
The code is well-commented, making the code easy to understand and use.

## Created by
Devaishi Tiwari (Roll no. **170101021**)