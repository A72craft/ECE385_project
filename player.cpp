#include "player.h"

/**
 * @brief Construct a new Pacman:: Pacman object
 * 
 */
Pacman::Pacman() :grid_x(0),grid_y(0),curr_dir(LEFT),health(2){}

/**
 * @brief Construct a new Pacman:: Pacman object(with customized inputs)
 * 
 * @param x the x grid location
 * @param y the y grid location
 * @param health the amount of health to start with
 */
Pacman::Pacman(int x,int y,int health) :grid_x(x),grid_y(y),curr_dir(LEFT),health(health){}

int Pacman::getX(){return grid_x;}
int Pacman::getY(){return grid_y;}
int Pacman::getCurrDir(){return curr_dir;}
int Pacman::getHealth(){return health;}

void Pacman::setDirection(int direction){curr_dir = direction;}