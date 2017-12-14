:- module(tclp_asp_io, _).


%% ------------------------------------------------------------- %%
:- use_package(assertions).
:- doc(title, "Module for input / output predicates").
:- doc(author, "Joaquin Arias").
:- doc(filetype, module).

:- doc(module, "

This module contains the code used to load, parser, translate and
print the program and results of the evaluation. It uses the
implementation of s(ASP) by @em{Marple} ported to CIAO by @em{Joaquin
Arias} in the folder @file{./src/casp/}.

").

%% ------------------------------------------------------------- %%

:- use_module('casp/output').
:- reexport('casp/output', [
	pr_rule/2,
	pr_query/1,
	pr_user_predicate/1,
	pr_table_predicate/1
			    ]).
:- use_module('casp/main').

%% ------------------------------------------------------------- %%

:- dynamic loaded_file/1.
load_program(X) :-
	retractall(loaded_file(_)),
	(
	    list(X) ->
	    Files = X
	;
	    Files = [X]
	),
	main(['-g'| Files]),
	assert(loaded_file(Files)).

write_program :-
	loaded_file(Files),
	main(['-d0'|Files]).

:- dynamic cont/0.

process_query(A,Query) :-
	(
	    list(A) -> As = A ; As = [A]
	),
	retractall(cont),
	(
	    ground(As) -> assert(cont) ; true
	),
	append(As, [add_to_query], Query).

ask_for_more_models :-
	(
	    cont, print('next ? '), get_char(R),true, R \= '\n' ->
	    get_char(_),
	    fail
	;
	    true
	).

allways_ask_for_more_models :-
	(
	    print(' ? '), get_char(R),true, R \= '\n' ->
	    get_char(_),
	    nl,
	    fail
	;
	    true
	).

:- dynamic answer_counter/1.
init_counter :-
	retractall(answer_counter(_)),
	assert(answer_counter(0)).
increase_counter :-
	answer_counter(N),
	N1 is N + 1,
	retractall(answer_counter(N)),
	assert(answer_counter(N1)).


%% Print output predicates to presaent the results of the query
print_output(StackOut, _Model) :-
	print_stack(StackOut), nl,
%	print_j(Model, 3), nl,
	true.

%% The model is obtained from the justification tree.
print_model([F|J]) :-
	nl,
	print('{ '),
	print(F),
	print_model_(J),
	print(' }'), nl.

print_model_([]) :- !.
print_model_([X|Xs]) :-
	print_model_(X), !,
	print_model_(Xs).
print_model_([X]) :- !,
	( X \= proved(_) ->
	  print(X)
	; true
	).
print_model_([X, Y|Xs]) :-
	( X \= proved(_) ->
	  print(' , '),
	  print(X)
	; true
	),
	print_model_([Y|Xs]).


print_j(Justification,I) :-
	print_model(Justification),
	nl,
	print_j_(Justification,I).
print_j_([],_).
print_j_([A,[]],I):- !,
	tab(I), print(A), print('.'), nl.
print_j_([A,[]|B],I):- !,
	tab(I), print(A), print(','), nl,
	print_j_(B,I).
print_j_([A,ProofA|B],I):-
	tab(I), print(A), print(' :-'), nl,
	I1 is I + 4, print_j_(ProofA,I1),
	print_j_(B,I).

%% The stack is generated adding the last calls in the head (to avoid
%% the use of append/3). To print the stack, it is reversed.

%% NOTE that a model could be generated during the search with some
%% calls in the stack which are not present in the model (e.g. the
%% model of path(1,4) for the path/2 program - more details in the
%% file README)
print_stack(Stack) :-
	reverse(Stack, RStack),
	nl,
	print_s(RStack).
	% print('{ '),
	% print(RStack),
	% print(' }'), nl.




%% Initial interpreters...
query2([]).
query2([X|Xs]) :-
	query2(Xs),
	query2(X).
query2(X) :-
	pr_rule(X, Body),
	query2(Body).


%:- table query3/3.
query3([X|Xs], I, O) :-
	format('Calling ~w \t with stack = ~w', [X, I]), nl,
	query3(X,  [X|I], O1),
	query3(Xs, O1,    O).
query3([], I, I) :- !.
query3(X,  I, O) :-
	pr_rule(X, Body),
	query3(Body, I, O).




print_check_calls_calling(Goal,I) :-
	reverse([('¿'+Goal+'?')|I],RI),
	format('\n---------------------Calling ~p-------------',[Goal]),
	print_s(RI).
print_s(Stack) :-
	print_s_(Stack,5,5).
print_s_([],_,_) :- display('.'),nl.
print_s_([[]|As],I,I0) :- !,
	I1 is I - 4,
	print_s_(As,I1,I0).
print_s_([A|As],I,I0) :- !,
	(
	    I0 > I ->
	    print('.')
	;
	    I0 < I ->
	    print(' :-')
	;
	    (
		I0 \= 5 ->
		print(',')
	    ;
		true
	    )
	),
	nl,tab(I),print(A),	
	I1 is I + 4,
	print_s_(As,I1,I).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set options
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic current_option/2, counter/2.

set_options(Options) :-
	set_default_options,
	set_user_options(Options).

set_default_options :-
	set(answers,-1),
	set(verbose,0).

set_user_options([]).
set_user_options([O | Os]) :-
	(
	    set_user_option(O) ->
	    set_user_options(Os)
	;
	    format('Error: the option ~w is not supported!\n\n',[O]),
	    fail
	).

set_user_option('-h') :- help.
set_user_option('-?') :- help.
set_user_option('--help') :- help.
set_user_option('-i') :- set(interactive, on).
set_user_option('--interactive') :- set(interactive, on).
set_user_option('-a').
set_user_option('--auto').
set_user_option(Option) :- atom_chars(Option,['-','s'|Ns]),number_chars(N,Ns),set(answers,N).
set_user_option(Option) :- atom_chars(Option,['-','n'|Ns]),number_chars(N,Ns),set(answers,N).
set_user_option('-v') :- set(check_calls, on).
set_user_option('--verbose') :- set(check_calls, on).
set_user_option('-j') :- set(print, on).
set_user_option('--justification') :- set(print, on).
set_user_option('-d0') :- set(write_program, on).



if_user_option(Name,Then) :-
	(
	    current_option(Name,on) ->
	    call(Then)
	;
	    true
	).

set(Option, Value) :-
	retractall(current_option(Option, _)),
	assert(current_option(Option,Value)).

help :-
        display('Usage: TCLP(asp) [options] InputFile(s)\n\n'),
        display('TCLP(asp) computes stable models of ungrounded normal logic programs.\n'),
        display('Command-line switches are case-sensitive!\n\n'),
        display(' General Options:\n\n'),
        display('  -h, -?, --help        Print this help message and terminate.\n'),
        display('  -i, --interactive     Run in user / interactive mode.\n'),
        display('  -a, --auto            Run in automatic mode (no user interaction).\n'),
        display('  -sN, -nN              Compute N answer sets, where N >= 0. 0 for all.\n'),
        display('  -v, --verbose         Enable verbose progress messages.\n'),
        display('  -j, --justification   Print proof tree for each solution.\n'),
        display('  -d0                   Print the program translated (with duals and nmr_check).\n'),
	display('\n'),
	abort.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parse arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parse_args([],[],[]).
parse_args([O | Args], [O | Os], Ss) :-
	atom_concat('-',_,O),!,
	parse_args(Args, Os, Ss).
parse_args([S | Args], Os, [S | Ss]) :-
	parse_args(Args, Os, Ss).
