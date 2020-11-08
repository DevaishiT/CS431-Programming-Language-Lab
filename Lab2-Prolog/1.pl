% ----------------------------------------------------------------------
%                HOW TO RUN THE PROGRAM:
% Part 1: 
% 	Syntax: uncle(A, B).
% 	
% Part 2: 
% 	Syntax: halfsister(A, B).
%-----------------------------------------------------------------------

male(katappa).
% male(kattappa).
male(jolly).
male(bahubali).

female(shivkami).
female(avantika).

parent(jatin,avantika).
parent(jolly,jatin).
parent(jolly,katappa).
% parent(jolly,kattappa).
parent(manisha,avantika).
parent(manisha,shivkami).
parent(bahubali,shivkami).

% checks if A is the uncle of B
uncle(X, Y):- male(X), parent(Z, Y), parent(A, Z), parent(A, X), not(X = Z).

% checks if A is the half_sister of B
halfsister(X, Y):- female(X), parent(Z, X), parent(Z, Y), parent(A, X), parent(B, Y), not(A = B), not(B = Z), not(A = Z).

