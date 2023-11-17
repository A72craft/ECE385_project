#ifndef GAME_H
#define GAME_H

#include "player.h"  // Assuming player.h contains the definition of Pacman class
#include "enemies.h"

class Game {
private:
    Pacman pacman;
    blinky red;
    pinky pink;
    inky blue;
    clyde orange;
    int health;
    int points;
    int power;

public:
    Game();
    ~Game();

    void update();  // Function to update game state
    void ifEaten();
    void semiReset(); //used when one health is lost
};
#endif