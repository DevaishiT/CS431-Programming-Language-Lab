import Data.List
import System.IO

--Getting all tuples within a given range.
getDimensions tuple1 tuple2 = 
	if fst(tuple1) == fst(tuple2) then
		getDimensionsWidth tuple1 tuple2
	else getDimensionsWidth tuple1 tuple2 ++ getDimensions (fst(tuple1) + 1, snd(tuple1)) tuple2

-- helper function to get all the dimensions.
getDimensionsWidth tuple1 tuple2 = 
	if snd(tuple1) == snd(tuple2) then
		[tuple1]
	else tuple1 : (getDimensionsWidth (fst(tuple1), snd(tuple1) + 1) tuple2)

-- Performing cartesian products over the dimensions of rooms. 
-- Bedroom , Hall
make2Tuple tuple1 tuple2 = [(a, b) | a <- tuple1, b <- tuple2]

-- (Bedroom, Hall), Kitchen
make3Tuple tuple1 tuple2 = [(a1, a2, b) | 
				(a1, a2) <- tuple1, b <- tuple2]

-- (Bedroom, Hall, Kitchen), Bathroom
make4Tuple tuple1 tuple2 = [(a1, a2, a3, b) | 
				(a1, a2, a3) <- tuple1, b <- tuple2]

-- (Bedroom, Hall, Kitchen, Bathroom), Garden
make5Tuple tuple1 tuple2 = [(a1, a2, a3, a4, b) | 
				(a1, a2, a3, a4) <- tuple1, b <- tuple2]

-- (Bedroom, Hall, Kitchen, Bathroom, Garden),. Balcony
make6Tuple tuple1 tuple2 = [(a1, a2, a3, a4, a5, b) | 
				(a1, a2, a3, a4, a5) <- tuple1, b <- tuple2]

-- Removing duplicate area dimensions in the dimensions of rooms.
filterDimensions1 dimensions n1 n2 = helper1 dimensions [] n1 n2
filterDimensions2 dimensions n1 n2 n3 = helper2 dimensions [] n1 n2 n3
filterDimensions3 dimensions n1 n2 n3 n4 = helper3 dimensions [] n1 n2 n3 n4
filterDimensions4 dimensions n1 n2 n3 n4 n5 = helper4 dimensions [] n1 n2 n3 n4 n5
filterDimensions5 dimensions n1 n2 n3 n4 n5 n6 = helper5 dimensions [] n1 n2 n3 n4 n5 n6

-- helper function for removing duplicate area dimensions
helper1 [] _ _ _ = []
helper1 ((x, y) : dimensions) areaList n1 n2 = 
	if (fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2) `elem` areaList then 
		helper1 dimensions areaList n1 n2
	else 
		(x, y) : helper1 dimensions ((fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2): areaList) n1 n2

helper2 [] _ _ _ _ = []
helper2 ((x, y, z) : dimensions) areaList n1 n2 n3 = 
	if (fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3) `elem` areaList then 
		helper2 dimensions areaList n1 n2 n3
	else 
		(x, y, z) : helper2 dimensions ((fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3): areaList) n1 n2 n3

helper3 [] _ _ _ _ _ = []
helper3 ((x, y, z, a) : dimensions) areaList n1 n2 n3 n4 = 
	if (fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4) `elem` areaList then 
		helper3 dimensions areaList n1 n2 n3 n4
	else 
		(x, y, z, a) : helper3 dimensions ((fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4): areaList) n1 n2 n3 n4

helper4 [] _ _ _ _ _ _= []
helper4 ((x, y, z, a, b) : dimensions) areaList n1 n2 n3 n4 n5 = 
	if (fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4 + fst(b)*snd(b)*n5) `elem` areaList then 
		helper4 dimensions areaList n1 n2 n3 n4 n5
	else 
		(x, y, z, a, b) : helper4 dimensions ((fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4 + fst(b)*snd(b)*n5): areaList) n1 n2 n3 n4 n5

helper5 [] _ _ _ _ _ _ _= []
helper5 ((x, y, z, a, b, c) : dimensions) areaList n1 n2 n3 n4 n5 n6 = 
	if (fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4 + fst(b)*snd(b)*n5 + fst(c)*snd(c)*n6) `elem` areaList then 
		helper5 dimensions areaList n1 n2 n3 n4 n5 n6
	else 
		(x, y, z, a, b, c) : helper5 dimensions ((fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 + fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4 + fst(b)*snd(b)*n5 + fst(c)*snd(c)*n6): areaList) n1 n2 n3 n4 n5 n6


-- Recursive function that finds the maximum possible area occupied by rooms.
findMaximum [] _ _ _ _ _ _ = 0

findMaximum ((x, y, z, a, b, c):dimensions) n1 n2 n3 n4 n5 n6 = 
	maximum [(fst(x)*snd(x)*n1 + fst(y)*snd(y)*n2 +
		fst(z)*snd(z)*n3 + fst(a)*snd(a)*n4 +
		fst(b)*snd(b)*n5 + fst(c)*snd(c)*n6), 
		findMaximum dimensions n1 n2 n3 n4 n5 n6]


-- Main function, gives the optimal dimensions of rooms.
design :: Int -> Int -> Int -> IO()
design totalArea numBedroom numHall = do 
	-- Assume that we need exactly 1 kitchen per 3 bedrooms.
	let numKitchen = ceiling ((fromIntegral numBedroom)/ (fromIntegral 3))

	-- House should have 1 more bathroom than bedrooms.
	let numBathroom = numBedroom + 1

	-- Number of garden and balcony is fixed to 1 each.
	let numGarden = 1
	let numBalcony = 1

	-- Getting all allowed dimensions of each type of room.
	let bedroomSize = getDimensions (10, 10) (15, 15)
	let hallSize = getDimensions (15, 10) (20, 15)
	let kitchenSize = getDimensions (7, 5) (15, 13)
	let bathroomSize = getDimensions (4, 5) (8, 9)
	let gardenSize = getDimensions (10, 10) (20,20)
	let balconySize = getDimensions (5, 5) (10, 10)
	-- putStrLn $ show bedroomSize

	-- Going through all possible best dimensions.
	-- Bedroom , Hall
	let bestDimensions1 = filterDimensions1 (filter (\(x, y) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall <= totalArea))
		(make2Tuple bedroomSize hallSize))
		numBedroom numHall

	-- (Bedroom, Hall), Kitchen
	let bestDimensions2 = filterDimensions2 (filter (\(x, y, z) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall +
		fst(z)*snd(z)*numKitchen <= totalArea) &&
		-- Ensuring that the size of kitchen is less than size of bedroom and hall
		(fst(z) <= fst(x) && fst(z) <= fst(y) && 
		snd(z) <= snd(x) && snd(z) <= snd(y)))
		(make3Tuple bestDimensions1 kitchenSize))
		numBedroom numHall numKitchen

	-- (Bedroom, Hall, Kitchen), Bathroom
	let bestDimensions3 = filterDimensions3 (filter (\(x, y, z, a) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall +
		fst(z)*snd(z)*numKitchen +
		-- Ensuring that the size of bathroom is less than size of kitchen
		fst(a)*snd(a)*numBathroom <= totalArea) &&
		(fst(a) <= fst(z) && snd(a) <= snd(z)))
		(make4Tuple bestDimensions2 bathroomSize)) 
		numBedroom numHall numKitchen numBathroom

	-- (Bedroom, Hall, Kitchen, Bathroom), Garden
	let bestDimensions4 = filterDimensions4 (filter (\(x, y, z, a, b) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall +
		fst(z)*snd(z)*numKitchen +
		fst(a)*snd(a)*numBathroom +
		fst(b)*snd(b)*numGarden <= totalArea))
		(make5Tuple bestDimensions3 gardenSize))
		numBedroom numHall numKitchen numBathroom numGarden

	-- (Bedroom, Hall, Kitchen, Bathroom, Garden), Balcony
	let bestDimensions5 = filterDimensions5 (filter (\(x, y, z, a, b, c) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall +
		fst(z)*snd(z)*numKitchen +
		fst(a)*snd(a)*numBathroom +
		fst(b)*snd(b)*numGarden +
		fst(c)*snd(c)*numBalcony <= totalArea))
		(make6Tuple bestDimensions4 balconySize))
		numBedroom numHall numKitchen numBathroom numGarden numBalcony
	-- putStrLn $ show bestDimensions5
	
	-- Calling findMaximum to find the maximum area possible with the given constraints
	let maximumArea = findMaximum bestDimensions5 numBedroom numHall numKitchen numBathroom numGarden numBalcony
	-- putStrLn $ show(maximumArea)
		
	-- Filtering out the set of dimensions that result in the maximum area
	let bestDimensions = filter (\(x, y, z, a, b, c) -> (
		fst(x)*snd(x)*numBedroom + 
		fst(y)*snd(y)*numHall +
		fst(z)*snd(z)*numKitchen +
		fst(a)*snd(a)*numBathroom +
		fst(b)*snd(b)*numGarden +
		fst(c)*snd(c)*numBalcony == maximumArea))
		bestDimensions5
	-- putStrLn $ show bestDimensions

	-- Printing the dimensions of room that leads to least ununsed space. (if such dimensions exist)
	if length(bestDimensions) == 0 then 
		putStrLn("A house can not be designed with these constraints.")
	else do
		let (x, y, z, a, b, c) = bestDimensions!!0
		putStrLn("\n")
		putStrLn("Bedroom: " ++ show(numBedroom) ++ show x)
		putStrLn("Hall: " ++ show(numHall) ++ show y)
		putStrLn("Kitchen: " ++ show(numKitchen) ++ show z)
		putStrLn("Bathroom: " ++ show(numBathroom) ++ show a)
		putStrLn("Garden: " ++ show(numGarden) ++ show b)
		putStrLn("Balcony: " ++ show(numBalcony) ++ show c)
		putStrLn("Unused Space: " ++ show(totalArea - maximumArea))
		putStrLn("\n")