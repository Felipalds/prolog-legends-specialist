% Item Classes
item_class(antihealing).
item_class(armor).
item_class(magic_resist).
item_class(lethality).
item_class(utility).
item_class(shield).
item_class(attack_speed).
item_class(life_steal).
item_class(healing).
item_class(ad_damage).
item_class(ap_damage).

% Champion Classes
champion_class(bruiser).
champion_class(assassin).
champion_class(mage).
champion_class(hyper_carry).
champion_class(tank).

% Recommendation
get_class(Champion) :-
    read(Class),
    assertz(champion_class(Champion, Class)),
    write("So the class is "), write(Class), nl.

healing_matchup(OldList, NewList, UserType) :-
    write('O inimigo se cura? sim/nao'), nl,
    read(EnemyHeals),
    (UserType == mage, EnemyHeals == 'sim' ->
        append(OldList, [morellonomicon], TempList);
    UserType == adc, EnemyHeals == 'sim' ->
        append(OldList, [lembrete_mortal], TempList);
    UserType == bruiser, EnemyHeals == 'sim' ->
        append(OldList, [quimiopunk], TempList);
    UserType == tank, EnemyHeals == 'sim' ->
        append(OldList, [espinhos], TempList);
    UserType == assassin, EnemyHeals == 'sim' ->
        append(OldList, [quimiopunk], TempList);
    % Default case
    TempList = OldList),
    % No additional condition, so directly unify NewList with TempList
    NewList = TempList.


tank_matchup(OldList, NewList, UserType) :-
    write('O inimigo builda vida ou resistência? (vida/resistencia) '), nl,
    read(BuildType),
    (UserType == mage, BuildType == vida ->
        append(OldList, [liandry], NewList);
        UserType == mage, BuildType == resistencia ->    
        append(OldList, [cajado_vazio], NewList);
        UserType == adc, BuildType == vida ->
        append(OldList, [rei_destruido], NewList);
        UserType == adc, BuildType == resistencia ->
        append(OldList, [dominik], NewList);
        UserType == assassin, BuildType == resistencia ->
        append(OldList, [serylda], NewList);
        NewList = OldList).


cc_matchup(OldList, NewList, UserType) :-
    write('O inimigo tem cc? sim/nao'), nl,
    read(EnemyCC),
    (UserType == mage, EnemyCC == 'sim' ->
        append(OldList, [banshee], TempList);
        UserType == adc, EnemyCC == 'sim' ->
        append(OldList, [botas_mr], TempList);
        UserType == bruiser, EnemyCC == 'sim' ->
        append(OldList, [forca_da_natureza], TempList);
        UserType == tank, EnemyCC == 'sim' ->
        append(OldList, [forca_da_natureza], TempList);
        UserType == assassin, EnemyCC == 'sim' ->
        append(OldList, [botas_mr], TempList);
        TempList = OldList),
    NewList = TempList.

add_item_on_list(OldList, NewList) :-
    champion_class(enemy, EnemyType),
    champion_class(user, UserType),
    cc_matchup(OldList, CCList, UserType),
    healing_matchup(CCList, HealedList, UserType),
    % ADC Match-ups
    (EnemyType == adc, UserType == mage ->
        append(HealedList, [ludens], TempList1);
        EnemyType == adc, UserType == tank ->
        append(HealedList, [egide_de_fogo], TempList1);
        EnemyType == adc, UserType == assassin ->
        append(HealedList, [cicloespada], TempList1);
        EnemyType == adc, UserType == bruiser ->
        append(HealedList, [trindade], TempList1);
        % Bruiser
        EnemyType == bruiser, UserType == mage ->
        append(HealedList, [zhonyas], TempList1);
        EnemyType == bruiser, UserType == adc ->
        append(HealedList, [arco_escudo], TempList1);
        EnemyType == bruiser, UserType == assassin ->
        append(HealedList, [eclipse], TempList1);
        % Assassin
        EnemyType == assassin, UserType == mage ->
        append(HealedList, [zhonyas], TempList1);
        EnemyType == assassin, UserType == adc ->
        append(HealedList, [arco_escudo], TempList1);
        EnemyType == assassin, UserType == bruiser ->
        append(HealedList, [sterak], TempList1);
        % Mage
        EnemyType == mage, UserType == tank ->
        append(HealedList, [rookern], TempList1);
        EnemyType == mage, UserType == mage ->
        append(HealedList, [banshee], TempList1);
        EnemyType == mage, UserType == assassin ->
        append(HealedList, [malmortius], TempList1);
        EnemyType == mage, UserType == bruiser ->
        append(HealedList, [malmortius], TempList1);
        % Tank
        EnemyType == tank ->
        tank_matchup(HealedList, TempList1, UserType);
        TempList1 = HealedList),
    NewList = TempList1.
    
save_list([]) :- !.
save_list(List) :-
    retractall(saved_list(_)),
    assertz(saved_list(List)).


start :- nl, write("Especialista de Lendas"), nl,
    retractall(champion_class(enemy, _)), % Clear EnemyType
    retractall(champion_class(user, _)),
    save_list([]),
    write("Selecione a sua classe: (bruiser, assassin, mage, hyper_carry, caster, tank, peel, engage)"), nl,
    get_class(user),
    write("Selecione o tipo do inimigo: (bruiser, assassin, mage, hyper_carry, caster, tank, peel, engage)"), nl,
    get_class(enemy),
    add_item_on_list([], NewList),
    save_list(NewList),
    saved_list(List),
    write(List). 

    

