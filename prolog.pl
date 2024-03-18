% Facts: champion(Name, Build)
champion(ashe, [berserkers_greaves, infinity_edge, runaans_hurricane, guardian_angel, rapid_firecannon, bloodthirster]).
champion(jinx, [berserkers_greaves, infinity_edge, runaans_hurricane, guardian_angel, rapid_firecannon, bloodthirster]).
champion(yasuo, [berserkers_greaves, infinity_edge, phantom_dancer, guardian_angel, bloodthirster, steraks_gage]).

% Rules
% Define a predicate to get the build for a champion
get_build(Champion, Build) :-
    champion(Champion, Build).

% Define a predicate to recommend a build for a champion
recommend_build(Champion) :-
    get_build(Champion, Build),
    write('Recommended build for '), write(Champion), write(': '), write(Build), nl.
