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

% Recommendations
recommend_item(antihealing) :-
    item_class(healing).

get_class(Champion) :-
    read(Class),
    assertz(champion_class(Champion, Class)),
    write("So the class is "), write(Class), nl.

tank_matchup(OldList, NewList, UserType) :-
    write('O inimigo builda vida ou resistência? (vida/resistencia) '), nl,
    read(BuildType),
    (UserType == mage, BuildType == vida ->
        NewList = [liandry | OldList];
        NewList = OldList),
    (UserType == mage, BuildType == resistencia ->
        NewList = [vazio | OldList];
        NewList = OldList),
    (UserType == adc, BuildType == vida ->
        NewList = [rei_destruido | OldList];
        NewList = OldList),
    (UserType == adc, BuildType == resistencia ->
        NewList = [dominik | OldList];
        NewList = OldList),
    (UserType == assassin, BuildType == resistencia ->
        NewList = [serylda | OldList];
        NewList = OldList).

healing_matchup(OldList, NewList, UserType) :-
    (UserType == mage ->
        NewList = [morellonomicon | OldList];
        NewList = OldList),
    (UserType == adc ->
        NewList = [lembrete_mortal | OldList];
        NewList = OldList),
    (UserType == bruiser ->
        NewList = [quimiopunk | OldList];
        NewList = OldList),
    (UserType == tank ->
        NewList = [espinhos | OldList];
        NewList = OldList),
    (UserType == assassin ->
        NewList = [quimiopunk | OldList];
        NewList = OldList).


cc_matchup(OldList, NewList, UserType) :-
    (UserType == mage ->
        NewList = [banshee | OldList];
        NewList = OldList),
    (UserType == adc ->
        NewList = [botas_mr | OldList];
        NewList = OldList),
    (UserType == bruiser ->
        NewList = [forca_da_natureza | OldList];
        NewList = OldList),
    (UserType == tank ->
        NewList = [forca_da_natureza | OldList];
        NewList = OldList),
    (UserType == assassin ->
        NewList = [botas_mr | OldList];
        NewList = OldList).

add_item_on_list(OldList, NewList) :-
    champion_class(enemy, EnemyType),
    champion_class(user, UserType),
    % ADC Match-ups
    (EnemyType == adc, UserType == mage ->
        NewList = [ludens | OldList];
        NewList = OldList),
    (EnemyType == adc, UserType == tank ->
        NewList = [egide_de_fogo | OldList];
        NewList = OldList),
    (EnemyType == adc, UserType == assassin ->
        NewList = [cicloespada | OldList];
        NewList = OldList),
    (EnemyType == adc, UserType == bruiser ->
        NewList = [trindade | OldList];
        NewList = OldList),
    % Bruiser Match-ups
    (EnemyType == bruiser, UserType == mage ->
        NewList = [zhonyas | OldList];
        NewList = OldList),
    (EnemyType == bruiser, UserType == adc ->
        NewList = [arco_escudo | OldList];
        NewList = OldList),
    (EnemyType == bruiser, UserType == assassin ->
        NewList = [eclipse | OldList];
        NewList = OldList),
    % Assassin Match-ups
    (EnemyType == assassin, UserType == mage ->
        NewList = [zhonyas | OldList];
        NewList = OldList),
    (EnemyType == assassin, UserType == adc ->
        NewList = [arco_escudo | OldList];
        NewList = OldList),
    (EnemyType == assassin, UserType == bruiser ->
        NewList = [sterak | OldList];
        NewList = OldList),
    % Tank Match-ups
    (EnemyType == tank ->
        tank_matchup(OldList, NewList, UserType);
        NewList = OldList),
    % Healing Choice
    write('O inimigo se cura? sim/nao')
    read(EnemyHeals)
    (EnemyHeals == 'sim' ->
        healing_matchup(OldList, NewList, UserType);
        NewList = OldList),
    write('O inimigo tem CC (Crowd Control)? sim/nao')
    read(EnemyHasCC)
    (EnemyHasCC == 'sim' ->
        cc_matchup(OldList, NewList, UserType);
        NewList = OldList).
    

save_list(List) :-
    retractall(saved_list(_)),
    assertz(saved_list(List)).


start :- nl, write("Especialista de Lendas"), nl,
    write("Selecione a sua classe: (bruiser, assassin, mage, hyper_carry, caster, tank, peel, engage)"), nl,
    get_class(user),
    write("Selecione o tipo do inimigo: (bruiser, assassin, mage, hyper_carry, caster, tank, peel, engage)"), nl,
    get_class(enemy),
    add_item_on_list([], NewList),
    save_list(NewList),
    saved_list(List),
    write(List).

    

