#include "game.h"

/**
 * @brief Construct a new Game:: Game object
 * 
 */
Game::Game(){
    health = 2;
    points = 0;
    Pacman pacman(PACMAN_X,PACMAN_Y); //temp value, change the macros
    blinky red(BLINKY_X,BLINKY_Y);
    pinky pink(PINKY_X,PINKY_Y);
    inky blue(INKY_X,INKY_Y);
    clyde orange(CLYDE_X,CLYDE_Y);

}

/**
 * @brief check if an enemie/player got eaten. The logic to handle the eaten
 *        is inside this function
 * 
 */
void Game::ifEaten(){

}

/**
 * @brief 
 * 
 */
void Game::update(){
    //check if a player or enemie is eaten
    ifEaten();
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