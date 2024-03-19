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
    write('Aqui2'), nl,
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
        append(OldList, [ludens], NewList);
        EnemyType == adc, UserType == tank ->
        append(OldList, [egide_de_fogo], NewList);
        EnemyType == adc, UserType == assassin ->
        append(OldList, [cicloespada], NewList);
        EnemyType == adc, UserType == bruiser ->
        append(OldList, [trindade], NewList);
        % Bruiser
        EnemyType == bruiser, UserType == mage ->
        append(OldList, [zhonyas], NewList);
        EnemyType == bruiser, UserType == adc ->
        append(OldList, [arco_escudo], NewList);
        EnemyType == bruiser, UserType == adc ->
        append(OldList, [eclipse], NewList);
        % Assassin
        EnemyType == assassin, UserType == mage ->
        append(OldList, [zhonyas], NewList);
        EnemyType == assassin, UserType == adc ->
        append(OldList, [arco_escudo], NewList);
        EnemyType == assassin, UserType == bruiser ->
        append(OldList, [sterak], NewList);
        % Mage
        EnemyType == mage, UserType == tank ->
        append(OldList, [rookern], NewList);
        EnemyType == mage, UserType == mage ->
        append(OldList, [banshee], NewList);
        EnemyType == mage, UserType == assassin ->
        append(OldList, [malmortius], NewList);
        EnemyType == mage, UserType == bruiser ->
        append(OldList, [malmortius], TempList),
        healing_matchup(TempList, NewList, UserType);
        % Tank
        EnemyType == tank ->
        tank_matchup(OldList, TempList, UserType),
        healing_matchup(TempList, NewList, UserType);
        % healing_matchup(OldList, NewList, UserType);
        NewList = OldList).
    % Healing Choice
    % healing_matchup(OldList, NewList, UserType).
    % write('O inimigo tem CC (Controle de Grupo)? sim/nao'), nl,
    % read(EnemyHasCC),
    % (EnemyHasCC == 'sim' ->
    %     cc_matchup(OldList, NewList, UserType);
    %     NewList = OldList).
    

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

    

