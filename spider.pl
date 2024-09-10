/* SPIDER -- a sample adventure game, by David Matuszek.
https://gist.github.com/JosephLenton/3191695
Consult this file and issue the command: start. */

:- dynamic at/2, i_am_at/1, alive/1. /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(i_am_at(_)), retractall(alive(_)).

/* This defines my current location. */

i_am_at(meadow).


/* These facts describe how the rooms are connected. */

/* Spider */
path(spider, d, cave).

/* Cave */
path(cave, u, spider).
path(cave, w, cave_entrance).

/* Cave_entrance */
path(cave_entrance, e, cave).
path(cave_entrance, s, meadow).
path(cave_entrance, w, ruins).
path(cave_entrance, n, massive_door) :- at(magic_stone, in_hand).
path(cave_entrance, n, massive_door) :-
    language(english),
    write('The door is massive and seems to be locked.'), nl,
    write('...'), nl,
    write('Perhaps there is a way to unlock it.'), nl,
    !, fail.
path(cave_entrance, n, massive_door) :-
    language(italian),
    write('La porta e'' massiccia e sembra essere chiusa a chiave.'), nl,
    write('...'), nl,
    write('Forse c'' e'' un modo per sbloccarla.'), nl,
    !, fail.
    

/* Massive door */
path(massive_door, s, cave_entrance).

/* Ruins */
path(ruins, e, cave_entrance).

/* Meadow */
path(meadow, n, cave_entrance) :- at(flashlight, in_hand).
path(meadow, n, cave_entrance) :-
    language(english),
    write('Go into that dark cave without a light? Are you crazy?'), nl,
    !, fail.

path(meadow, n, cave_entrance) :-
    language(italian),
    write('Entrare in quella caverna buia senza una luce? Sei pazzo?'), nl,
    !, fail.
    
path(meadow, s, building).

/* Building */
path(building, n, meadow).
path(building, w, cage).
path(building, s, courtyard).
path(building, e, closet) :- at(key, in_hand).
path(building, e, closet) :-
    language(english),
    write('The door appears to be locked.'), nl,
    fail.

path(building, e, closet) :-
    language(italian),
    write('La porta sembra essere chiusa a chiave.'), nl,
    fail.

/* Cage */
path(cage, e, building).

/* Closet */
path(closet, w, building).

/* Courtyard */
path(courtyard, n, building).


/* These facts tell where the various objects in the game
are located. */

at(ruby, spider).
at(emerald, massive_door).
at(key, cave_entrance).
at(flashlight, building).
at(sword, closet).
at(torch, courtyard).

/* This fact specifies that the spider, the slime and the lion are alive. */

alive(spider).
alive(slime).
alive(lion).

/* These rules describe how to pick up an object. */

take(X) :-
    language(english),
    at(X, in_hand),
    write('You''re already holding it!'),
    nl, !.

take(X) :-
    language(italian),
    at(X, in_hand),
    write('Lo stai già tenendo!'),
    nl, !.

take(X) :-
    i_am_at(Place),
    at(X, Place),
    retract(at(X, Place)),
    assert(at(X, in_hand)),
    write('OK.'),
    nl, !.

take(_) :-
    language(english),
    write('I don''t see it here.'),
    nl.

take(_) :-
    language(italian),
    write('Non lo vedo qui.'),
    nl.


/* These rules describe how to put down an object. */

drop(X) :-
    at(X, in_hand),
    i_am_at(Place),
    retract(at(X, in_hand)),
    assert(at(X, Place)),
    write('OK.'),
    nl, !.

drop(_) :-
    language(english),
    write('You aren''t holding it!'),
    nl.

drop(_) :-
    language(italian),
    write('Non lo stai tenendo!'),
    nl.


/* These rules define the six direction letters as calls to go/1. */

n :- go(n).

s :- go(s).

e :- go(e).

w :- go(w).

u :- go(u).

d :- go(d).


/* This rule tells how to move in a given direction. */

go(Direction) :-
    i_am_at(Here),
    path(Here, Direction, There),
    retract(i_am_at(Here)),
    assert(i_am_at(There)),
    look, !.

go(_) :-
    language(english),
    write('You can''t go that way.').

go(_) :-
    language(italian),
    write('Non puoi andare in quella direzione.').

/* This rule tells how to look about you. */

look :-
    i_am_at(Place),
    describe(Place),
    nl,
    notice_objects_at(Place),
    nl, !.


/* These rules set up a loop to mention all the objects
in your vicinity. */

notice_objects_at(Place) :-
    language(english),
    at(X, Place),
    write('\e[33m'),
    write('There is a '), write(X), write(' here.'), nl,
    write('\e[0m'),
    fail.

notice_objects_at(Place) :-
    language(italian),
    at(X, Place),
    write('\e[33m'),
    write('C'' e'' una '), write(X), write(' qui.'), nl,
    write('\e[0m'),
    fail.

notice_objects_at(_).


/* These rules tell how to handle killing the lion and the spider. */

kill :-
    language(english),
    i_am_at(cage),
    at(torch, in_hand),
    retract(alive(lion)),
    assert(at(sapphire, in_hand)),
    write('You shine the torch at the lion. It roars in agony as it burns and collapses,'), nl,
    write('revealing a shiny sapphire in its ashes.'),
    write('\e[36m'), 
    write(' You take the shappire.'), 
    write('\e[0m'),
    !, nl.

kill:-
    language(italian),
    i_am_at(cage),
    at(torch, in_hand),
    retract(alive(lion)),
    assert(at(sapphire, in_hand)),
    write('Squoti la torcia sul leone. Urla di dolore mentre brucia e collassa,'), nl,
    write('rivelando uno splendido zaffiro tra le sue ceneri.'), 
    write('\e[36m'), 
    write(' Prendi lo zaffiro.'), 
    write('\e[0m'),
    !, nl.

kill :-
    language(english),
    i_am_at(cage),
    write('Oh, bad idea! You have just been eaten by a lion.'), nl,
    !, die.

kill:-
    language(italian),
    i_am_at(cage),
    write('Oh, brutta idea! Sei appena stato mangiato da un leone.'), nl,
    !, die.

kill :-
    language(english),
    i_am_at(cave),
    write('This isn''t working. The spider leg is about as tough'), nl,
    write('as a telephone pole, too.'),
    !, nl.

kill:-
    language(italian),
    i_am_at(cave),
    write('Non sta funzionando. La zampa del ragno e'' dura'), nl,
    write('come un palo telefonico.'),
    !, nl.

kill :-
    language(english),
    i_am_at(spider),
    at(sword, in_hand),
    retract(alive(spider)),
    write('You hack repeatedly at the spider''s back. Slimy ichor'), nl,
    write('gushes out of the spider''s back, and gets all over you.'), nl,
    write('I think you have killed it, despite the continued twitching.'),
    nl, !.

kill:-
    language(italian),
    i_am_at(spider),
    at(sword, in_hand),
    retract(alive(spider)),
    write('Colpisci ripetutamente la schiena del ragno. Ichor viscido'), nl,
    write('sgorga dalla schiena del ragno e ti si appiccica addosso.'), nl,
    write('Penso che l''abbia ucciso, nonostante il continuo tremolio.'),
    nl, !.

kill :-
    language(english),
    i_am_at(spider),
    write('Beating on the spider''s back with your fists has no'), nl,
    write('effect. This is probably just as well.'), !, nl.

kill:-
    language(italian),
    i_am_at(spider),
    write('Picchiare sulla schiena del ragno con i pugni non ha'), nl,
    write('effetto. Probabilmente e'' meglio così.'), !, nl.

kill :-
    language(english),
    i_am_at(ruins),
    at(torch, in_hand),
    retract(alive(slime)),
    assert(at(magic_stone, in_hand)),
    write('You light the slime with the torch and it shrieks as it melts away,'), nl,
    write('leaving behind a shiny stone.'), 
    write('\e[36m'), 
    write(' You take the stone. It looks magical.'),
    write('\e[0m'),
    !, nl. 

kill:-
    language(italian),
    i_am_at(ruins),
    at(torch, in_hand),
    retract(alive(slime)),
    assert(at(magic_stone, in_hand)),
    write('Bruci lo slime con la torcia e urla mentre si scioglie,'), nl,
    write('lasciando dietro di sé una pietra lucente.'),
    write('\e[36m'), 
    write(' Prendi la pietra. Sembra magica.'),
    write('\e[0m'),
    !, nl. 

kill :-
    language(english),
    i_am_at(ruins),
    write('Nothing you can do against this slimy opponent. You need something else!'), !, nl.

kill:-
    language(italian),
    i_am_at(ruins),
    write('Non puoi fare nulla contro questo avversario viscido. Hai bisogno di qualcos''altro!'), !, nl.

kill :-
    language(english),
    write('I see nothing inimical here.'), !, nl.

kill:-
    language(italian),
    write('Non vedo nulla di inimico qui.'), !, nl.


/* This rule tells how to die. */

die :-
    halt.

/* Under UNIX, the halt. command quits Prolog but does not
remove the output window. On a PC, however, the window
disappears before the final output can be seen. Hence this
routine requests the user to perform the final halt. */

finish :-
    language(english),
    nl,
    write('The game is over. Please enter the halt. command.'),
    nl, !.

finish:-
    language(italian),
    nl,
    write('Il gioco e'' finito. Per favore inserisci il comando halt.'),
    nl, !.

/* ASCII art representing "SPIDER". */

title :-
    write('\e[31m'),
    write('  _________       __     ___    __________ '), nl,
    write(' /   _____/_____ |__| __| _/____\\______   \\'), nl,
    write(' \\_____  \\\\____ \\|  |/ __ |/ __ \\|       _/'), nl,
    write(' /        \\  |_> >  / /_/ \\  ___/|    |   \\'), nl,
    write('/_______  /   __/|__\\____ |\\___  >____|_  /'), nl,
    write('        \\/|__|           \\/    \\/       \\/'), nl,
    write('\e[0m').
    


/* This rule just writes out game instructions. */

instructions :-
    language(english),
    nl,
    write('Enter commands using standard Prolog syntax.'), nl,
    write('Available commands are:'), nl,
    write('start. -- to start the game.'), nl,
    write('n. s. e. w. u. d. -- to go in that direction.'), nl,
    write('take(Object). -- to pick up an object.'), nl,
    write('drop(Object). -- to put down an object.'), nl,
    write('change_language(english). -- to change the language to English.'), nl,
    write('change_language(italian). -- to change the language to Italian.'), nl,
    write('kill. -- to attack an enemy.'), nl,
    write('look. -- to look around yourself again.'), nl,
    write('instructions. -- to see this message again.'), nl,
    write('halt. -- to end the game and quit.'), nl,
    nl.

instructions :-
    language(italian),
    nl,
    write('Inserisci i comandi utilizzando la sintassi standard di Prolog.'), nl,
    write('I comandi disponibili sono:'), nl,
    write('start. -- per avviare il gioco.'), nl,
    write('n. s. e. w. u. d. -- per andare in quella direzione.'), nl,
    write('take(Oggetto). -- per raccogliere un oggetto.'), nl,
    write('drop(Oggetto). -- per posare un oggetto.'), nl,
    write('change_language(english). -- per cambiare la lingua in inglese.'), nl,
    write('change_language(italian). -- per cambiare la lingua in italiano.'), nl,
    write('kill. -- per attaccare un nemico.'), nl,
    write('look. -- per guardarti intorno nuovamente.'), nl,
    write('instructions. -- per vedere di nuovo questo messaggio.'), nl,
    write('halt. -- per terminare il gioco e uscire.'), nl,
    nl.

/* This rule prints out instructions and tells where you are. */

start :-
    title,
    instructions,
    look.


/* These rules describe the various rooms. Depending on
circumstances, a room may have more than one description. */

:-discontiguous describe/1.

describe(meadow) :-
    language(english),
    at(ruby, in_hand),
    at(emerald, in_hand),
    at(sapphire, in_hand),
    write('Congratulations! You have recovered the '), write('\e[31m'),
    write('ruby'), write('\e[0m'), write(', the '),
    write('\e[34m'),
    write('shappire'),  write('\e[0m'), write(' and the '),
    write('\e[32m'),
    write('emerald'), write('\e[0m'), write('.'), nl,
    write('You won the game!'), nl,
    finish, !.

describe(meadow) :-
    language(italian),
    at(ruby, in_hand),
    at(emerald, in_hand),
    at(sapphire, in_hand),
    write('Congratulazioni! Hai recuperato il '), write('\e[31m'),
    write('rubino'), write('\e[0m'), write(', lo '),
    write('\e[34m'),
    write('zaffiro'),  write('\e[0m'), write(' e lo '),
    write('\e[32m'),
    write('smeraldo'), write('\e[0m'), write('.'), nl,
    write('Hai vinto il gioco!'), nl,
    finish, !.

describe(meadow) :-
    language(english),
    write('You are in a meadow.'), nl,
    write('To the North is the dark mouth of a cave.'), nl,
    write('To the South is a small building.'), nl,
    write('Your assignment, should you decide to accept it, is to'), nl,
    write('\e[31m'),
    write('recover the famed Bar-Abzad ruby,'), nl,
    write('\e[34m'),
    write('the magical Gul-Saroth shappire,'), nl,
    write('\e[32m'),
    write('the brilliant Ar-Gamut emerald'), nl,
    write('\e[0m'),
    write('and return them to this meadow.'), nl.

describe(meadow) :-
    language(italian),
    write('Ti trovi in un prato.'), nl,
    write('A nord c''e'' la bocca oscura di una caverna.'), nl,
    write('A sud c''e'' un piccolo edificio.'), nl,
    write('Il tuo compito, se decidi di accettarlo, e'''), nl,
    write('\e[31m'),
    write('recuperare il famoso rubino Bar-Abzad,'), nl,
    write('\e[34m'),
    write('lo zaffiro magico Gul-Saroth,'), nl,
    write('\e[32m'),
    write('lo splendido smeraldo Ar-Gamut'), nl,
    write('\e[0m'),
    write('e riportarli in questo prato.'), nl.

describe(building) :-
    language(english),
    write('You are in a small building. The exit is to the north.'), nl,
    write('There is a barred door to the west, but it seems to be'), nl,
    write('unlocked. There is a smaller door to the east. To the'), nl,
    write('south there is the courtyard of the building.'), nl.

describe(building) :-
    language(italian),
    write('Ti trovi in un piccolo edificio. L''uscita e'' a nord.'), nl,
    write('C''e'' una porta sbarrata a ovest, ma sembra essere'), nl,
    write('sbloccata. C''e'' una porta più piccola a est. A sud c''e'''), nl,
    write('il cortile dell''edificio.'), nl.

describe(cage) :-
    language(english),
    alive(lion),
    write('You are in the den of a'), write('\e[35m'),write(' lion'), write('\e[0m'), write('. The'), 
    write('\e[35m'),write(' lion '), write('\e[0m'), write('has a lean and'), nl,
    write('hungry look. It looks a bit transparent, with a ghostly'), nl,
    write('green glow around it. Be careful!'), nl.

describe(cage) :-
    language(italian),
    alive(lion),
    write('Ti trovi nella tana di un'), write('\e[35m'), write(' leone'), write('\e[0m'), write('. Il'), 
    write('\e[35m'),write(' leone '), write('\e[0m'), write('ha uno sguardo'), nl,
    write('magro e affamato. Sembra un po'' trasparente, con un'), nl,
    write('bagliore verde spettrale intorno. Fai attenzione!'), nl.

describe(cage) :-
    language(english),
    write('You are in what was once the den of the lion. There is no'), nl,
    write('trace left of the ferocious beast.'), nl.

describe(cage):-
    language(italian), 
    write('Ti trovi in quello che una volta era la tana del leone. Non c e'''), nl,
    write('traccia della bestia feroce.'), nl.

describe(closet) :-
    language(english),
    write('This is nothing but an old storage closet.'), nl.

describe(closet) :-
    language(italian),
    write('Questo e'' solo un vecchio ripostiglio.'), nl.
    
describe(courtyard) :-
    language(english),
    write('You stand in the courtyard, once a meticulously groomed space,'), nl,
    write('now overtaken by wild vegetation. Vines coil around weathered'), nl,
    write('stone pillars, and shrubs push through cracks in the cobblestone'), nl,
    write('path. Nature seems to have reclaimed this area, rendering it'), nl,
    write('a jungle of sorts within the confines of civilization.'), nl.

describe(courtyard) :-
    language(italian),
    write('Ti trovi nel cortile, una volta uno spazio curato con cura,'), nl,
    write('ora invaso dalla vegetazione selvatica. Le viti si avvolgono'), nl,
    write('intorno a pilastri di pietra consumati, e cespugli spingono'), nl,
    write('attraverso le crepe nel selciato. La natura sembra aver'), nl,
    write('ripristinato questa area, rendendola una sorta di giungla'), nl.


describe(cave_entrance) :-
    language(english),
    write('You are in the mouth of a dank cave. The exit is to'), nl,
    write('the south. There is a large, dark, round passage to'), nl,
    write('the east. To the west, there are some ancient ruins.'), nl.

describe(cave_entrance) :-
    language(italian),
    write('Ti trovi nella bocca di una caverna umida. L''uscita e'' a'), nl,
    write('sud. C'' e'' un grande, scuro e rotondo passaggio a est.'), nl,
    write('A ovest ci sono delle antiche rovine.'), nl.

describe(cave) :-
    language(english),
    alive(spider),
    at(ruby, in_hand),
    write('The'), write('\e[35m'), write(' spider '), write('\e[0m'), write('sees you with the ruby and attacks!!!'), nl,
    write(' ...it is over in seconds...'), nl,
    die.

describe(cave):-
    language(italian),
    alive(spider),
    at(ruby, in_hand),
    write('Il'), write('\e[35m'), write(' ragno '), write('\e[0m'), write('ti vede con il rubino e attacca!!!'), nl,
    write(' ...e'' finita in pochi secondi...'), nl,
    die.

describe(cave) :-
    language(english),
    alive(spider),
    write('There is a giant'), write('\e[35m'), write(' spider '), write('\e[0m'), write('here! One hairy leg, about the'), nl,
    write('size of a telephone pole, is directly in front of you!'), nl,
    write('I would advise you to leave promptly and quietly...'), nl, !.

describe(cave):- 
    language(italian),
    alive(spider),
    write('C'' e'' un'), write('\e[35m'), write(' ragno '), write('\e[0m'), write('gigante qui! Una zampa pelosa, grande'), nl,
    write('quanto un palo telefonico, e'' direttamente di fronte a te!'), nl,
    write('Ti consiglierei di andartene prontamente e silenziosamente...'), nl, !.

describe(cave) :-
    language(english),
    write('Yecch! There is a giant spider here, twitching.'), nl.

describe(cave):- 
    language(italian),
    write('Yecch! C'' e'' un ragno gigante qui, che trema.'), nl.

describe(spider) :-
    language(english),
    alive(spider),
    write('You are on top of a giant'), write('\e[35m'), write(' spider'), write('\e[0m'), write(', standing in a rough'), nl,
    write('mat of coarse hair. The smell is awful.'), nl.

describe(spider):-
    language(italian),
    alive(spider),
    write('Sei sopra un'), write('\e[35m'), write(' ragno '), write('\e[0m'), write('gigante, in piedi su un tappeto'), nl,
    write('ruvido di peli grossolani. L''odore e'' terribile.'), nl.

describe(spider) :-
    language(english),
    write('Oh, gross! You''re on top of a giant dead spider!'), nl.

describe(spider):-
    language(italian),
    write('Oh, che schifo! Sei sopra un ragno gigante morto!'), nl.

describe(massive_door) :-
    language(english),
    at(magic_stone, in_hand),
    write('You open the massive door with the magical stone. Beyond it,'), nl,
    write('you find a small decorated chest.'), nl.

describe(massive_door) :-
    language(italian),
    at(magic_stone, in_hand),
    write('Apri la porta massiccia con la pietra magica. Oltre di essa,'), nl,
    write('trovi un piccolo scrigno decorato.'), nl.

describe(ruins) :-
    language(english),
    alive(slime),
    write('You find yourself in the middle of very ancient ruins. Among the'), nl,
    write('old constructions, there is a huge'), write('\e[35m'), write(' slime'), write('\e[0m'), 
    write('.'), 
    nl.

describe(ruins) :-
    language(italian),
    alive(slime),
    write('Ti trovi in mezzo a rovine molto antiche. Tra le vecchie'), nl,
    write('costruzioni c'' e'' un enorme'), write('\e[35m'), write(' slime'), write('\e[0m'), 
    write('.'), 
    nl.

describe(ruins) :-
    language(english),
    write('You find yourself in the middle of very ancient ruins. Where the'), nl,
    write('slime once stood, there is a green glowy stain.'), nl.

describe(ruins) :-
    language(italian),
    write('Ti trovi in mezzo a rovine molto antiche. Dove una volta c''era'), nl,
    write('lo slime, c''e'' una macchia verde luminosa.'), nl.


/* Predicato per la lingua */
:- dynamic language/1. % Dichiarazione del predicato language/1 come dinamico

language(italian).

/* Predicato per selezionare la lingua */
change_language(english) :-
    retract(language(_)),
    assert(language(english)),
    write('Lingua cambiata in inglese.'), nl.

change_language(italian) :-
    retract(language(_)),
    assert(language(italian)),
    write('Lingua cambiata in italiano.'), nl.

