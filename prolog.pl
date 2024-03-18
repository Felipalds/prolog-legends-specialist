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

add_item_on_list(OldList, NewList) :-
    champion_class(enemy, EnemyType),
    champion_class(user, UserType),
    (EnemyType == adc, UserType == mage ->
        NewList = [ludens | OldList];
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

    

