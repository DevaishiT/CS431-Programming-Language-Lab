% ----------------------------------------------------------------------
%                HOW TO RUN THE PROGRAM:
% Part 1: 
% 	Syntax: getAllPaths().
% 	
% Part 2: 
% 	Syntax: getMinPaths().
% 	
% Part 3: 
% 	Syntax: checkValidity(Path).
% 	Example: checkValidity([g1, g6, g8, g9, g8, g7, g10, g15, g13, 
%				g14, g18, g17]).
%-----------------------------------------------------------------------

% created two edges corresponding to each distance given in the question.
distance(g1,g5,4). 
distance(g5,g1,4).

distance(g2,g5,6). 
distance(g5,g2,6).

distance(g3,g5,8). 
distance(g5,g3,8).

distance(g4,g5,9). 
distance(g5,g4,9).

distance(g1,g6,10). 
distance(g6,g1,10).

distance(g2,g6,9). 
distance(g6,g2,9).

distance(g3,g6,3). 
distance(g6,g3,3).

distance(g4,g6,5). 
distance(g6,g4,5).

distance(g5,g7,3). 
distance(g7,g5,3).

distance(g5,g10,4). 
distance(g10,g5,4).

distance(g5,g11,6). 
distance(g11,g5,6).

distance(g5,g12,7). 
distance(g12,g5,7).

distance(g5,g6,7). 
distance(g6,g5,7).

distance(g5,g8,9). 
distance(g8,g5,9).

distance(g6,g8,2). 
distance(g8,g6,2).

distance(g6,g12,3). 
distance(g12,g6,3).

distance(g6,g11,5). 
distance(g11,g6,5).

distance(g6,g10,9). 
distance(g10,g6,9).

distance(g6,g7,10). 
distance(g7,g6,10).

distance(g7,g10,2). 
distance(g10,g7,2).

distance(g7,g11,5). 
distance(g11,g7,5).

distance(g7,g12,7). 
distance(g12,g7,7).

distance(g7,g8,10). 
distance(g8,g7,10).

distance(g8,g9,3). 
distance(g9,g8,3).

distance(g8,g12,3). 
distance(g12,g8,3).

distance(g8,g11,4). 
distance(g11,g8,4).

distance(g8,g10,8). 
distance(g10,g8,8).

distance(g10,g15,5). 
distance(g15,g10,5).

distance(g10,g11,2). 
distance(g11,g10,2).

distance(g10,g12,5). 
distance(g12,g10,5).

distance(g11,g15,4). 
distance(g15,g11,4).

distance(g11,g13,5). 
distance(g13,g11,5).

distance(g11,g12,4). 
distance(g12,g11,4).

distance(g12,g13,7). 
distance(g13,g12,7).

distance(g12,g14,8). 
distance(g14,g12,8).

distance(g15,g13,3). 
distance(g13,g15,3).

distance(g13,g14,4). 
distance(g14,g13,4).

distance(g14,g17,5). 
distance(g17,g14,5).

distance(g14,g18,4). 
distance(g18,g14,4).

distance(g17,g18,8). 
distance(g18,g17,8).

% Declaring the start gate and the target gate.
startGate(g1).
startGate(g2).
startGate(g3).
startGate(g4).

targetGate(g17).

% Checking if two gates gi and gj are connected.
isEdge(U, V):-
	distance(U, V, _).
	
% Getting the weight of the edge
getEdge(U, V, D):-
	distance(U, V, D).
	
% Prints a given path.
printPath([H | []]):-
	format("~w", H),
	nl.	

printPath([H | T]):-
	format("~w -> ", H),
	printPath(T).

% ----------------------------------------------------------------------
% Part1: All possible paths for escape
%-----------------------------------------------------------------------

% Utility function to list all the valid escape paths.
allPathsHelper(G, Path, _):-
	targetGate(G),
	append(Path, [G], UpdatedPath),
	printPath(UpdatedPath),
	fail.
	
allPathsHelper(G, Path, Visited):-
	\+ targetGate(G),
	append(Path, [G], UpdatedPath),
	isEdge(G, V),
	\+ member(V, Visited),
	allPathsHelper(V, UpdatedPath, [V | Visited]),
	fail.
	
% Called by the user, lists all the valid escape paths.
getAllPaths():-
	startGate(G),
	allPathsHelper(G, [], [G]),
	fail.

	
%-----------------------------------------------------------------------
% Part2: Best path(s) for escape
%-----------------------------------------------------------------------

% Declaring global variables for storing minimum distance and best path.
:-dynamic(minDist/1).
:-dynamic(bestPaths/1).
minDist(99999).
:-dynamic(visited/1).

updatePaths(Dist, Path):-
	minDist(Val),
	Val > Dist,
	retract(minDist(Val)),
	asserta(minDist(Dist)),
	retractall(bestPaths(_)),
	assertz(bestPaths(Path)).
	
updatePaths(Dist, Path):-
	minDist(Val),
	Val =:= Dist,
	assertz(bestPaths(Path)).

% Utility function to list all the valid escape paths.
optimalPathsHelper(_, Dist, _):-
	minDist(Val),
	Val =< Dist,
	fail.
	
optimalPathsHelper(G, Dist, Path):-
	targetGate(G),
	append(Path, [G], UpdatedPath),
	updatePaths(Dist, UpdatedPath),
	fail.
	
optimalPathsHelper(G, Dist, Path):-
	\+ targetGate(G),
	append(Path, [G], UpdatedPath),
	isEdge(G, V),
	getEdge(G, V, D),
	\+ visited(V),
	asserta(visited(V)),
	NewDist is Dist+D,
	\+ optimalPathsHelper(V, NewDist, UpdatedPath),
	retract(visited(V)),
	fail.

getOptimalPaths():-
	startGate(G),
	asserta(visited(G)),
	optimalPathsHelper(G, 0, []),
	retract(visited(G)),
	fail.
	
% Prints all of the mib paths.
printMinPaths():-
	bestPaths(Y),get
	printPath(Y),
	fail.
	
% Called by the user, lists all the optimal escape paths.
getMinPaths():-
	\+ getOptimalPaths(),
	\+ printMinPaths().

%-----------------------------------------------------------------------
% Part3: Checking validity of an escape path
%-----------------------------------------------------------------------

% Checking recursively that every 2 adjascent gates are connected.
isValidPath([U, V| Tail]):- 
	isEdge(U, V),
	isValidPath([V | Tail]).
	
% Checking that the last gate is the target gate.
isValidPath([U | []]):-
	targetGate(U).

% Called by the user, prints whether the path is valid or not.
checkValidity(Path):- 
	[S|_] = Path,
	startGate(S),
	isValidPath(Path),
	write("The path is VALID."), !.
	
checkValidity(_):-
	write("The path is INVALID.").

