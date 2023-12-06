#include "player.h"

/**
 * @brief Construct a new Pacman:: Pacman object
 * 
 */
Pacman::Pacman() :x(0),y(0),curr_dir(LEFT){}

/**
 * @brief Construct a new Pacman:: Pacman object(with customized inputs)
 * 
 * @param x the x grid location
 * @param y the y grid location
 * @param health the amount of health to start with
 */
Pacman::Pacman(int x,int y) :x(x),y(y),curr_dir(LEFT){}

int Pacman::getX(){return x;}
int Pacman::getY(){return y;}
int Pacman::getCurrDir(){return curr_dir;}

void Pacman::setDirection(int direction){curr_dir = direction;}

void Pacman::move(int distance){
}
void Pacman::resetPosition(){
    x = PACMAN_X;
    y = PACMAN_Y;
    curr_dir = LEFT;
}