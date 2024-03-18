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
champion_class(caster).
champion_class(tank).
champion_class(support).

% Recommendations
recommend_item(antihealing) :-
    item_class(healing).

start :- nl, write("Especialista de Lendas"), nl,
    write("Selecione o item do campeão inimigo: "),
    read(A), nl,
    recommend_item(A),
    write('O aconselhamento é: '),
    write(A), nl.