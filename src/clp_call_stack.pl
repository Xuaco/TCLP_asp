:- module(clp_call_stack, _).

%% ------------------------------------------------------------- %%
:- use_package(assertions).
:- doc(title, "Call stack constraint solver and TCLP interface.").
:- doc(author, "Joaquin Arias").
:- doc(filetype, module).

:- doc(module, "

This module contains the code to handle @var{StackIn}, @var{StackOut}
and @var{Model} as attributes in order to check entailment with the
TCLP framework of CIAO.

@pred{~>/2} is the predicate used to get the attribute from the
attributed variable.

@pred{<~/2} is the predicate used to put the term as an attribute.

").

%% ------------------------------------------------------------- %%
:- use_module(clp_disequality_rt).
:- op(700, xfx, [(.\=.), (.=.)]).

:- use_package(attr).

:- op(700, xfx, [(~>), (<~), (<~>)]).

%% ------------------------------------------------------------- %%
:- doc(section, "Main predicates").

A ~> Att :- get_attr_local(A, rules(Att)).
A <~ Att :- put_attr_local(A, rules(Att)).

dump_rules([],     [],     []).
dump_rules([X|Xs], [_|Ns], [D|Ds]) :-
	get_attr_local(X, rules(D)),
	dump_rules(Xs, Ns, Ds).
dump_rules([X|Xs], Ns, Ds) :-
	\+ get_attr_local(X, rules(_)),
	dump_rules(Xs, Ns, Ds).

%% Attributes predicates %%
:- multifile attr_unify_hook/2, attribute_goals/3, attr_portray_hook/2.
attr_unify_hook(rules(Att), B) :- get_attr_local(B, rules(AttB)), Att = AttB.
attr_unify_hook(neg(A), B) :- not_unify(B,A).
attribute_goals(X) --> [X ~> G], {get_attr_local(X, rules(G))}.
attribute_goals(X) --> [X .\=. G], {get_attr_local(X, neg(G))}.
attr_portray_hook(rules(Att), A) :- format(" ~w  .is ~w ", [A, Att]).
attr_portray_hook(neg(Att),   A) :- format(" ~w  .\\=. ~w ", [A, Att]).
%% Attributes predicates %%


%% ------------------------------------------------------------- %%
:- doc(section, "TCLP interface").

%% TCLP interface %%
call_domain_projection([],[]).
call_domain_projection([X|Xs], [D|Ds]) :- 
	call_domain_projection_(X, D),
	call_domain_projection(Xs,Ds).
call_entail(_, [], []).
call_entail(_, [D1|D1s], [D2|D2s]) :-
	call_entail_(_, D1,D2),
	call_entail(_, D1s,D2s).
call_store_projection(_, St, St).

answer_domain_projection([],     []). 
answer_domain_projection([X|Xs], [D|Ds]) :-
	answer_domain_projection_(X, D),
	answer_domain_projection(Xs, Ds).
answer_check_entail(_, [],       [],       _, _).
answer_check_entail(_, [D1|D1s], [D2|D2s], R, _) :-
	answer_check_entail_(_, D1, D2, R, _),
	answer_check_entail(_, D1s, D2s, R, _).
answer_store_projection(_, St, St).

apply_answer([],     []).
apply_answer([V|Vs], [A|Ans]) :-
	apply_answer_(V, A),
	apply_answer(Vs, Ans).
%% TCLP interface %%

:- discontiguous
	call_domain_projection_/2,
	call_entail_/3,
	answer_domain_projection_/2,
	answer_check_entail_/5,
	apply_answer_/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% call_stack TCLP interface %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

call_domain_projection_(X, D) :- X ~> D.
call_entail_(_, stack(D1), stack(D2)) :- sub_list(D2,D1).

answer_domain_projection_(X, D) :- X ~> D.
answer_check_entail_(_, stack(D1), stack(D2), 1,  _) :- sub_list(D2,D1).
answer_check_entail_(_, model(_), _, 1, _).

% apply_answer_(X, -(P, N)) :- \+ X ~> _, X <~ -(P, N).
% apply_answer_(X, -(_, _)) :- X ~> _.
apply_answer_(X, model(P)) :- X <~ model(P).
apply_answer_(X, stack(P)) :- \+ X ~> _, X <~ stack(P).
apply_answer_(X, stack(_)) :- X ~> _.
%apply_answer_(X, stack(P)) :- X <~ stack(P).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% disequality TCLP interface %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

call_domain_projection_(X, D) :- dump_neg_list(X, D).
call_entail_(_, neg(D1), neg(D1)).

answer_domain_projection_(X, D) :- dump_neg_list(X, D).
% answer_check_entail_(_, neg(List1), neg(List2), 1, _) :-
% 	entail_neg_list(List2, List1), !.
% answer_check_entail_(_, neg(List1), neg(List2), -1, _) :-
% 	entail_neg_list(List1, List2).
answer_check_entail_(_, neg(List1), neg(List1), 1, _).

apply_answer_(X, neg(List)) :- not_unify(X, List).

%% ------------------------------------------------------------- %%

:- use_module(library(terms_check)).
sub_list(D1,D2) :-
	append(_, X, D2), variant(X,D1).

	
