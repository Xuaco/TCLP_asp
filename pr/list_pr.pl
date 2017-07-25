pr_rule(p([]),[]).
pr_rule(p([X|T]),[q(X),p(T)]).
pr_rule(q(1),[]).
pr_rule(not(o_q1(_X0)),[_X0\=1]).
pr_rule(not(q(_X0)),[not(o_q1(_X0))]).
pr_rule(not(o_p1(_X0)),[_X0\=[]]).
pr_rule(not(o_p2(_Z0,X,T)),[_Z0\=[X|T]]).
pr_rule(not(o_p2(_Z0,X,T)),[_Z0=[X|T],not(q(X))]).
pr_rule(not(o_p2(_Z0,X,T)),[_Z0=[X|T],q(X),not(p(T))]).
pr_rule(not(o_p2(_Z0)),[forall(X,forall(T,not(o_p2(_Z0,X,T))))]).
pr_rule(not(p(_X0)),[not(o_p1(_X0)),not(o_p2(_X0))]).
pr_rule(not(o_false),[]).
pr_rule(not(o_false),[]).
pr_rule(o_nmr_check,[]).
pr_rule(add_to_query,[o_nmr_check]).
