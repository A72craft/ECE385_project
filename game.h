#ifndef GAME_H
#define GAME_H

#include "player.h"  // Assuming player.h contains the definition of Pacman class
#include "enemies.h"

class Game {
private:
    Pacman player;

public:
    Game();
    void update();  // Function to update game state
};
#endif