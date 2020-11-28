import Data.List
import System.IO

-- Checking whether the set is empty or not.
myEmpty :: [Int] -> Bool
myEmpty inputSet = null inputSet


-- Performing union over the 2 given sets: (A or B)
{- 
	1. remove all duplicate elements from the first and second set. (using nub)
	2. filter the elements of second set that don't belong in first set. (using filter)
	3. concatenate these elements onto the first set. (using ++)
-}
myUnion :: [Int] -> [Int] -> [Int]
myUnion set1 set2 = nub set1 ++ filter (`notElem` set1) (nub set2)


-- Performing intersection over the 2 given sets: (A and B)
{- 
	1. remove all duplicate elements from the first and second set. (using nub)
	2. filter the elements of first set that belong in second set as well. (using filter)
-}
myIntersect :: [Int] -> [Int] -> [Int]
myIntersect set1 set2 = filter (`elem` nub set2) (nub set1)


-- Performing subtraction over the 2 given sets: (A - B)
{- 
	1. remove all duplicate elements from the first and second set. (using nub)
	2. filter the elements of first set that don't belong in second set. (using filter)
-}
mySubtract :: [Int] -> [Int] -> [Int]
mySubtract set1 set2 = filter (`notElem` nub set2) (nub set1)


-- Performing addition over the 2 given sets: (A + B)
{- 
	1. add an element of set2 to all the elements of set1 and create a list.
	2. repeat this for all elements in set2 and concatenate the results. (using concat)
	3. remove all duplicate elements from the resulting set. (using nub)
-}
myAddition :: [Int] -> [Int] -> [Int]
myAddition set1 set2 = nub (concat [[a + b | a <- set1] | b <- set2])

