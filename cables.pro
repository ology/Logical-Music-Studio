 /*----------------------------------------------------------------*\

|  Program: Prolog Music studio cable definitions
|  Author: "Gene Boggs" <gene+music@ology.net>

 \*----------------------------------------------------------------*/

/* half_cable(EndA, Gender, Size) */
/* TODO Use DBI to declare facts, instead of hardcoding. */

/* MIDI */
half_cable(midi, male, normal).

/* RCA */
half_cable(rca, male,   normal).
half_cable(rca, female, normal).

/* TRS */
half_cable(trs, male,   quarter).
half_cable(trs, female, quarter).
half_cable(trs, male,   mini).
half_cable(trs, female, mini).

/* Raw! */
half_cable(raw, male, wire).

/* XLR */
half_cable(xlr, male,   normal).
half_cable(xlr, female, normal).

/* full_cable(EndA, EndB) */

/* Exclude bogus cables like rca<=>usb etc. */
full_cable(midi, X) :- \+( X == midi ), !, fail.
full_cable(X, midi) :- \+( X == midi ), !, fail.
full_cable(raw, X)  :- \+( X == raw ),  !, fail.
full_cable(X, raw)  :- \+( X == raw ),  !, fail.
full_cable(usb, X)  :- \+( X == usb ),  !, fail.
full_cable(X, usb)  :- \+( X == usb ),  !, fail.

/* A full-cable is two halves. */
full_cable(EndA, EndB) :-
    half_cable(EndA, _, _), half_cable(EndB, _, _).
/* A full-cable can also be called with properties specified */
full_cable(EndA, Gender, Size, EndB) :-
    half_cable(EndA, Gender, Size),
    half_cable(EndB, _, _).

/* Exclude bogus cables like rca+rca<=>usb+usb etc. */
cable_pair(midi, X) :- \+( X == midi ), !, fail.
cable_pair(X, midi) :- \+( X == midi ), !, fail.
cable_pair(raw, X)  :- \+( X == raw ),  !, fail.
cable_pair(X, raw)  :- \+( X == raw ),  !, fail.
cable_pair(usb, X)  :- \+( X == usb ),  !, fail.
cable_pair(X, usb)  :- \+( X == usb ),  !, fail.

/* A cable end pair */
cable_pair(EndA, male) :-
    half_cable(EndA, male, _), half_cable(EndA, male, _).
cable_pair(EndA, female) :-
    half_cable(EndA, female, _), half_cable(EndA, female, _).

/* y_cable(EndA, EndB) */

/* Exclude bogus cables like rca+rca<=>usb etc. */
y_cable(midi, X) :- \+( X == midi ), !, fail.
y_cable(X, midi) :- \+( X == midi ), !, fail.
y_cable(raw, X)  :- \+( X == raw ),  !, fail.
y_cable(X, raw)  :- \+( X == raw ),  !, fail.

/* A Y-cable is three halves (usually a small adapter). */
y_cable(EndA, EndB) :-
    cable_pair(EndA, male),
    half_cable(EndB, male, _).
y_cable(EndA, EndB) :-
    cable_pair(EndA, male),
    half_cable(EndB, female, _).
y_cable(EndA, EndB) :-
    cable_pair(EndA, female),
    half_cable(EndB, female, _).
y_cable(EndA, EndB) :-
    cable_pair(EndA, female),
    half_cable(EndB, male, _).

/* x_cable(EndA, EndB) */

/* An X-cable is four halves (usually a stereo pair). */
x_cable(EndA, EndB) :-
    cable_pair(EndA, male),
    cable_pair(EndB, male).
x_cable(EndA, EndB) :-
    cable_pair(EndA, male),
    cable_pair(EndB, female).
x_cable(EndA, EndB) :-
    cable_pair(EndA, female),
    cable_pair(EndB, female).

/* Example queries:
?- set_prolog_flag(toplevel_print_options, [quoted(true)]).
?- findall(X0, half_cable(X0, male, _), X).
X = [...
*/
