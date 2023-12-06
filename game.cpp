#include "game.h"

/**
 * @brief Construct a new Game:: Game object
 * 
 */
Game::Game(){
    health = 2;
    points = 0;
    power = 200;
    Pacman pacman(PACMAN_X,PACMAN_Y); //temp value, change the macros
    blinky red(BLINKY_X,BLINKY_Y,1);
    pinky pink(PINKY_X,PINKY_Y,0);
    inky blue(INKY_X,INKY_Y,0);
    clyde orange(CLYDE_X,CLYDE_Y,0);
}

/**
 * @brief semi resets the game. That is, all players and enemies return to their original position
 * 
 */
void Game::semiReset(){
    power = 200;
    pacman.resetPosition();
    pink.resetPosition();
    red.resetPosition();
    blue.resetPosition();
    orange.resetPosition();
}
/**
 * @brief check if an enemie/player got eaten. The logic to handle the eaten
 *        is inside this function
 * 
 */

void Game::ifEaten(){
    if(pacman.getX() == red.getX() && pacman.getY() == red.getY()){
        if(red.getMode() == 2){ //frightened
            points += power;
            power += 100;

        }else{
            health -= 1;
            semiReset();
        }
    }else if(pacman.getX() == pink.getX() && pacman.getY() == pink.getY()){

    }else if(pacman.getX() == blue.getX() && pacman.getY() == blue.getY()){

    }else if(pacman.getX() == orange.getX() && pacman.getY() == orange.getY()){

    }
}

/**
 * @brief 
 * 
 */
void Game::update(){
    //check if a player or enemie is eaten
    ifEaten();
    ifPoints();
    
}

void Game::ifPoints(){
    
}
/**
 * @brief the main enterance of the program
 * 
 * @return int (nothing)
 */
int main() {
    Game game;
    return 0;
}