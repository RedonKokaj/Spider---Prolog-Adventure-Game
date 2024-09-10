# SPIDER: A Prolog-Based Adventure Game

## Project Overview

SPIDER is a text-based adventure game developed in Prolog. We started from a sample adventure game created by David Matuszek (https://rextester.com/ARMEK68152) and we modified it for a university project. In this enhanced version, your mission is to retrieve three precious gems — the ruby, sapphire, and emerald — while navigating dangerous environments, battling enemies, and solving puzzles. This version builds on the original by introducing new areas, items, and enemies, raising the challenge and complexity of the game.

## Game Description

### Story
In a world full of danger and mystery, you must recover three legendary gems: the ruby, sapphire, and emerald. During your quest, you will explore treacherous areas, encounter deadly enemies, and collect items that will help you overcome challenges. You need to use your inventory wisely and defeat enemies to complete the journey and return the gems to the meadow where you started.

## Game Features

### Commands

| Command                   | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `start.`                   | Start the game and display basic instructions.                              |
| `n. s. e. w. u. d.`        | Move north, south, east, west, up, or down.                                 |
| `take(Object).`             | Pick up an object from your current location.                               |
| `drop(Object).`             | Drop an object from your inventory at your current location.                |
| `kill.`                     | Attack an enemy.                                                           |
| `look.`                     | Examine your surroundings and see what’s around.                           |
| `instructions.`             | Display the instructions again.                                            |
| `halt.`                     | End the game and close the program.                                        |
| `change_language(Language).`| Change the language of the game to either `english` or `italian`.            |

### Game Areas

- **Meadow (Prato):** The starting point of the game. The goal is to return here with all three gems to win.
- **Building (Edificio):** Located south of the meadow, it contains the flashlight and connects to other areas.
- **Cave Entrance (Ingresso della Caverna):** North of the meadow, this area connects several key locations. It also holds a mysterious key.
- **Cave (Caverna):** East of the cave entrance, this dangerous area is home to a giant spider that guards the ruby.
- **Cage (Gabbia):** West of the building, this is where the lion is found.
- **Closet (Armadio):** East of the building, the closet holds a sword.
- **Ruins (Rovine):** West of the cave entrance, this area is home to a slime guarding a magic stone.
- **Massive Door (Porta Gigante):** North of the cave entrance, this door hides the emerald required to win the game.
- **Courtyard (Cortile):** South of the building, the courtyard contains the torch, which is essential for defeating specific enemies.

### Items and Enemies

#### Items
- **Ruby (Rubino):** Located in the cave, guarded by the spider. One of the three gems required to win the game.
- **Sapphire (Zaffiro):** Guarded by the lion in the cage. Another essential gem for victory.
- **Emerald (Smeraldo):** Found behind the massive door. The final gem required to win.
- **Magic Stone (Pietra Magica):** Held by the slime in the ruins, this stone is required to open the massive door.
- **Sword (Spada):** Located in the closet, it is required to defeat certain enemies.
- **Key (Chiave):** Found at the cave entrance, necessary for unlocking certain paths.
- **Flashlight (Torcia):** Located in the building, needed to navigate the dark cave.
- **Torch (Fiaccola):** A new item that is required to defeat the lion and the slime.

#### Enemies
- **Spider (Ragno):** Found in the cave, guarding the ruby. The player must use specific strategies to defeat the spider.
- **Lion (Leone):** Found in the cage. In the modified version, the lion is no longer invincible and can be defeated. It guards the sapphire.
- **Slime:** Found in the ruins, guarding the magic stone.
- 
### Winning Condition

In this version of SPIDER, the player must:
1. Collect the **ruby**, **sapphire**, and **emerald**.
2. Return to the **meadow** with all three gems to win.

## Code Overview

The game is written in SWI-Prolog, making use of dynamic predicates and flexible game state management to handle player actions, item interactions, and enemy behavior.

### Key Components:
- **Dynamic Predicates:** 
  - Facts like `i_am_at/1`, `at/2`, and `alive/1` track the player’s location, item positions, and the status of enemies.
  
- **Movement Logic:**
  - Movement between areas is handled by the `go/1` predicate, which checks if the player can move in a specific direction based on the game state and available paths.

- **Item and Enemy Interaction:**
  - Players interact with items using the `take/1` and `drop/1` predicates, while combat is managed by the `kill/1` predicate, which checks if the player has the right items to defeat enemies.

- **Multi-Language Support:**
  - The game supports both English and Italian. Players can switch between languages at any time using the `change_language/1` predicate.

- **Enemy Combat:**
  Combat is dependent on the player having the correct item.

## How to Run

1. Install [SWI-Prolog](https://www.swi-prolog.org/).
2. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/spider.git
   cd spider
   ```
3. Start the game by running the Prolog file:
   ```bash
   swipl spider.pl
   ```
4. Start the game within the Prolog environment:
   ```prolog
   start.
   ```

## Contributing

Feel free to fork the project and improve it in any way you want! Be sure to read the original authors indications (http://matuszek.org/proglang/prolog-assignment.html).

### License
This project is licensed under the MIT License.

## Attribution

This project is a modified version of an original Prolog assignment created by David Matuszek.

The original code and assignment details can be found here:
- [Original Code on Rextester](https://rextester.com/ARMEK68152)
- [David Matuszek's Prolog Assignment](http://matuszek.org/proglang/prolog-assignment.html)

Our modified version expands on the original by adding new areas, enemies, items, and an enhanced gameplay experience.

