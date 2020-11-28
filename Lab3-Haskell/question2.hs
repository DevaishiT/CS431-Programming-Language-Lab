import Data.List 
import Data.Maybe

import System.IO
import System.Random

-- Setting up the initial teamList for the fixes.
seed = 100
teamList = permutations ["BS","CM","CH","CV","CS","DS","EE","HU","MA","ME","PH","ST"]!!seed

-- Generating initial fixes (in case fixture "DS" or nextMatch is called before fixture "all").
fixes = zip ([teamList !! i | i <- [0,2..length(teamList) - 1]]) ([teamList !! i | i <- [1,3..length(teamList) - 1]])

-- Declaring the list of match times and their corresponding descriptions.
matchTimes = [(1,9.5),(1,19.5),(2,9.5),(2,19.5),(3,9.5),(3,19.5)]
description = [("1-12-2020","9:30 AM"),("1-12-2020","7:30 PM"),("2-12-2O2O","9:30 AM"),
                ("2-12-2020","7:30 PM"),("3-12-2020","9:30 AM"),("3-12-2020","7:30 PM")]


-- Printing all the details of a particular match number (helper function for fixture and nextMatch)
printMatch :: Int -> IO ()
printMatch i = putStrLn ((fst (fixes!!i)) ++ "   vs.  " ++ (snd (fixes!!i)) ++ 
                "    " ++ (fst (description!!i)) ++ "  " ++ (snd (description!!i)))


-- 1. fixture "all" - generates and shows the schedule of all the matches fixed.
fixture :: String -> IO()

fixture "all" = do
    printMatch 0
    printMatch 1
    printMatch 2
    printMatch 3
    printMatch 4
    printMatch 5

-- 2. fixture "<teamName>" - shows the match involving the given team (in the last fixture). 
fixture teamName = do
    -- Checking if the team is participating.
    if teamName `elem` teamList then
        printMatch ( fromJust(teamName `elemIndex` teamList) `div` 2 )
    else 
        putStrLn ("Provided team is not participating in any match.")


-- 3. nextMatch <date> <time> - finds out the next match scheduled after given date and time.
nextMatch :: Int -> Float -> IO ()
nextMatch date time = do
    -- Finding all the matches that are left.
    let leftMatches = ([ i | i <- [0..5], (date, time) <= (matchTimes!!i)])

    -- Checking if date provided is valid
    if date < 1 || date > 31 then
        putStrLn ("Provided date should be between 1 to 31.")
    -- Checking if time provided is valid
    else if time < 0.0 || time >= 24.0 then
        putStrLn ("Provided time should be between 0.0 to 24.0 (24.0 not included).")
    -- Checking if any more matches are scheduled
    else if null leftMatches then
        putStrLn ("No more matches left")
    -- Printing the next match scheduled.
    else printMatch (leftMatches!!0)
