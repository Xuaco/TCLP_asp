pr_rule(make_schedule,[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),schedule(asp_coding_1,_V4),schedule(asp_coding_2,_V5),schedule(homework,_V6),schedule(homework_discussion,_V7),schedule(snack,_V9)]).
pr_rule(constraint(breakfast,T),[T>=6,T<10]).
pr_rule(constraint(lunch,T),[T>=11,T<13]).
pr_rule(constraint(dinner,T),[T>=17,T<19]).
pr_rule(constraint(snack,T),[schedule(lunch,T1),schedule(dinner,T2),T>T1,T<T2]).
pr_rule(constraint(homework_discussion,T),[schedule(homework,T1),T>T1]).
pr_rule(constraint(asp_coding_1,_V1),[]).
pr_rule(constraint(asp_coding_2,_V1),[]).
pr_rule(constraint(homework,_V1),[]).
pr_rule(time_slot(X),[X>=0,X<24]).
pr_rule(schedule(Task,Time),[time_slot(Time),constraint(Task,Time),not(not_schedule(Task,Time))]).
pr_rule(not_schedule(Task,Time),[not(schedule(Task,Time))]).
pr_rule(not(o_not_schedule1(Task,Time)),[schedule(Task,Time)]).
pr_rule(not(not_schedule(_X0,_X1)),[not(o_not_schedule1(_X0,_X1))]).
pr_rule(not(o_time_slot1(X)),[X<0]).
pr_rule(not(o_time_slot1(X)),[X>=0,X>=24]).
pr_rule(not(time_slot(_X0)),[not(o_time_slot1(_X0))]).
pr_rule(not(o_constraint1(_X0,T)),[_X0\=breakfast]).
pr_rule(not(o_constraint1(_X0,T)),[_X0=breakfast,T<6]).
pr_rule(not(o_constraint1(_X0,T)),[_X0=breakfast,T>=6,T>=10]).
pr_rule(not(o_constraint2(_X0,T)),[_X0\=lunch]).
pr_rule(not(o_constraint2(_X0,T)),[_X0=lunch,T<11]).
pr_rule(not(o_constraint2(_X0,T)),[_X0=lunch,T>=11,T>=13]).
pr_rule(not(o_constraint3(_X0,T)),[_X0\=dinner]).
pr_rule(not(o_constraint3(_X0,T)),[_X0=dinner,T<17]).
pr_rule(not(o_constraint3(_X0,T)),[_X0=dinner,T>=17,T>=19]).
pr_rule(not(o_constraint4(_X0,T,T1,T2)),[_X0\=snack]).
pr_rule(not(o_constraint4(_X0,T,T1,T2)),[_X0=snack,not(schedule(lunch,T1))]).
pr_rule(not(o_constraint4(_X0,T,T1,T2)),[_X0=snack,schedule(lunch,T1),not(schedule(dinner,T2))]).
pr_rule(not(o_constraint4(_X0,T,T1,T2)),[_X0=snack,schedule(lunch,T1),schedule(dinner,T2),T=<T1]).
pr_rule(not(o_constraint4(_X0,T,T1,T2)),[_X0=snack,schedule(lunch,T1),schedule(dinner,T2),T>T1,T>=T2]).
pr_rule(not(o_constraint4(_X0,T)),[forall(T1,forall(T2,not(o_constraint4(_X0,T,T1,T2))))]).
pr_rule(not(o_constraint5(_X0,T,T1)),[_X0\=homework_discussion]).
pr_rule(not(o_constraint5(_X0,T,T1)),[_X0=homework_discussion,not(schedule(homework,T1))]).
pr_rule(not(o_constraint5(_X0,T,T1)),[_X0=homework_discussion,schedule(homework,T1),T=<T1]).
pr_rule(not(o_constraint5(_X0,T)),[forall(T1,not(o_constraint5(_X0,T,T1)))]).
pr_rule(not(o_constraint6(_X0,_V1)),[_X0\=asp_coding_1]).
pr_rule(not(o_constraint7(_X0,_V1)),[_X0\=asp_coding_2]).
pr_rule(not(o_constraint8(_X0,_V1)),[_X0\=homework]).
pr_rule(not(constraint(_X0,_X1)),[not(o_constraint1(_X0,_X1)),not(o_constraint2(_X0,_X1)),not(o_constraint3(_X0,_X1)),not(o_constraint4(_X0,_X1)),not(o_constraint5(_X0,_X1)),not(o_constraint6(_X0,_X1)),not(o_constraint7(_X0,_X1)),not(o_constraint8(_X0,_X1))]).
pr_rule(not(o_schedule1(Task,Time)),[not(time_slot(Time))]).
pr_rule(not(o_schedule1(Task,Time)),[time_slot(Time),not(constraint(Task,Time))]).
pr_rule(not(o_schedule1(Task,Time)),[time_slot(Time),constraint(Task,Time),not_schedule(Task,Time)]).
pr_rule(not(schedule(_X0,_X1)),[not(o_schedule1(_X0,_X1))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[not(schedule(breakfast,_V1))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),not(schedule(lunch,_V2))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),not(schedule(dinner,_V3))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),not(schedule(asp_coding_1,_V4))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),schedule(asp_coding_1,_V4),not(schedule(asp_coding_2,_V5))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),schedule(asp_coding_1,_V4),schedule(asp_coding_2,_V5),not(schedule(homework,_V6))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),schedule(asp_coding_1,_V4),schedule(asp_coding_2,_V5),schedule(homework,_V6),not(schedule(homework_discussion,_V7))]).
pr_rule(not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9)),[schedule(breakfast,_V1),schedule(lunch,_V2),schedule(dinner,_V3),schedule(asp_coding_1,_V4),schedule(asp_coding_2,_V5),schedule(homework,_V6),schedule(homework_discussion,_V7),not(schedule(snack,_V9))]).
pr_rule(not(o_make_schedule1),[forall(_V1,forall(_V2,forall(_V3,forall(_V4,forall(_V5,forall(_V6,forall(_V7,forall(_V9,not(o_make_schedule1(_V1,_V2,_V3,_V4,_V5,_V6,_V7,_V9))))))))))]).
pr_rule(not(make_schedule),[not(o_make_schedule1)]).
pr_rule(not(o_false),[]).
pr_rule(not(o_false),[]).
pr_rule(o_nmr_check,[]).
pr_rule(add_to_query,[o_nmr_check]).
