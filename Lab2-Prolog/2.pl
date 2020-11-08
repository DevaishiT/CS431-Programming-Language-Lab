% ----------------------------------------------------------------------
%                HOW TO RUN THE PROGRAM:
%  
% 	Syntax: Route(LocationA, LocationB).
% 	 press ; to get optimal cost path
%-----------------------------------------------------------------------

% Added the data for running
bus(1, temp, temp, 0, 0, 0, 0).

bus(101, vijaynagar, palasia, 8, 8.5, 5, 100).
bus(102, vijaynagar, palasia, 9.5, 10, 5.2, 150).
bus(103, vijaynagar, palasia, 11, 11.5, 4.9, 120).
bus(104, vijaynagar, palasia, 12.5, 13, 5, 120).
bus(105, vijaynagar, palasia, 16, 16.5, 5.5, 100).
bus(106, vijaynagar, palasia, 15.5, 16, 5.1, 150).
bus(107, vijaynagar, palasia, 14, 14.5, 5, 120).

bus(201, rajvada, palasia, 9, 10, 10, 300).
bus(202, rajvada, palasia, 13, 14, 9.8, 280).
bus(203, rajvada, palasia, 17, 18, 10.1, 330).

bus(301, vijaynagar, tukoganj, 8.5, 9, 7, 200).
bus(302, vijaynagar, tukoganj, 10, 10.5, 6.7, 250).
bus(303, vijaynagar, tukoganj, 12.5, 13, 7.2, 180).
bus(304, vijaynagar, tukoganj, 15, 15.5, 7, 300).
bus(305, vijaynagar, tukoganj, 16.5, 17, 7.1, 150).

bus(401, tukoganj, rajvada, 8, 8.5, 3.5, 150).
bus(402, tukoganj, rajvada, 10, 10.5, 3, 100).
bus(403, tukoganj, rajvada, 13, 13.5, 3.2, 150).
bus(404, tukoganj, rajvada, 15.5, 16, 3, 200).
bus(405, tukoganj, rajvada, 18, 18.5, 3.3, 150).
bus(406, tukoganj, rajvada, 12, 12.5, 3, 150).

bus(501, rajvada, tukoganj, 10.5, 11, 3, 200).
bus(502, rajvada, tukoganj, 13, 13.5, 3.4, 150).
bus(503, rajvada, tukoganj, 15, 15.5, 3.2, 150).
bus(504, rajvada, tukoganj, 16, 16.5, 3, 150).

bus(601, tukoganj, vijaynagar, 10, 10.5, 7.1, 150).
bus(602, tukoganj, vijaynagar, 11.5, 12, 6.9, 200).
bus(603, tukoganj, vijaynagar, 13, 13.5, 7, 150).
bus(604, tukoganj, vijaynagar, 14.5, 15, 7.1, 150).

% ----------------------------------------------------------------------
%                    DISTANCE BASED

% Gets the distance covered by bus
distance(X, Y, Length, BusNumber):- bus(BusNumber, X, Y, _, _, Length, _).

traversePathsDist(X, Y, Path, Length):-
       	traverseDistHelper(X, Y, [[X, 001]], RevPath, Length), 
       	reverse(RevPath, Path).

traverseDistHelper(X, Y, Visited, [[Y, BusNumber] | Visited], Length):- 
       	distance(X, Y, Length, BusNumber).
       
traverseDistHelper(X, Y, Visited, RevPath, Length) :-
       	distance(X, Z, Dist, BusNumber),       
       	Z \== Y,
       	\+ member([Z, _], Visited),
       	traverseDistHelper(Z, Y, [[Z, BusNumber] | Visited], RevPath, Length1),
       	Length is Dist + Length1.  

shortestDistance(X, Y, Path, Length) :-
   	setof([P, L], traversePathsDist(X, Y, P, L), PathSetDist),
   	PathSetDist = [_|_],
   	optimalPath(PathSetDist, [Path, Length]).
   
% ----------------------------------------------------------------------
%                        COST BASED

% Gets the cost of the bus ticket.
cost(X, Y, Length, BusNumber) :- bus(BusNumber, X, Y, _, _, _, Length).

traversePathsCost(X, Y, Path, Length):-
       	traverseCostHelper(X, Y, [[X, 001]], RevPath, Length), 
       	reverse(RevPath, Path).

traverseCostHelper(X, Y, Visited, [[Y, BusNumber] | Visited], Length):- 
       	cost(X, Y, Length, BusNumber).
       
traverseCostHelper(X, Y, Visited, RevPath, Length):-
       	cost(X, Z, Cost, BusNumber),           
       	Z \== Y,
       	\+ member([Z, _], Visited),
       	traverseCostHelper(Z, Y, [[Z, BusNumber] | Visited], RevPath, Length1),
      	Length is Cost + Length1.  

shortestCost(X, Y, Path, Length):-
	setof([P, L], traversePathsCost(X, Y, P, L), PathSetCost),
   	PathSetCost = [_|_],
   	optimalPath(PathSetCost,[Path,Length]).


% ----------------------------------------------------------------------

% Find the most optimal path using minimum length value.
optimalPath([H|Tail], Minimum):- minVal(Tail, H, Minimum).

minVal([], Minimum, Minimum).

minVal([[P, L] | Tail], [_, Val], Minimum):- 
	L < Val,
	!,
	minVal(Tail, [P, L], Minimum). 
	
minVal([_|R], M, Minimum):- minVal(R, M, Minimum).

% Prints the minimum path in both the cases.
printPath([[H, B] | []]):- 
	format('~w~w', [H, B]).
	
printPath([[H, B]|T]):- 
	format('~w~w', [H, B]),
	write(' -> '),
	printPath(T).

% Callled by the user, prints optimal routes based on distance and cost.
route(X, Y):- 
	write('Optimal Distance:'),
	nl,
	shortestDistance(X, Y, Path, Length),
	printPath(Path),
	nl, 
	format('Minimum Distance = ~w', Length),
	nl.

route(X, Y):-
	write('Optimal Cost:'),
	nl,
	shortestCost(X, Y, Path, Length),
	printPath(Path),
	nl,
	format('Minimum Cost = ~w', Length),
	nl.


