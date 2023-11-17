/**
 *https://gameinternals.com/understanding-pac-man-ghost-behavior
*/
#ifndef ENEMIE_H
#define ENEMIE_H

#include "macros.h"


class Enemie {
private:
    //the game board size is 28*36, and the x and y below is referring to that
    int grid_x;
    int grid_y;
    bool isActive;
    int modes; //Chase, Scatter, or Frightened for 0,1,2
public:
    Enemie() : grid_x(0), grid_y(0), isActive(false), modes(0) {}
    Enemie(int x, int y) : grid_x(x), grid_y(y), isActive(false), modes(0) {}

    int getX() const { return grid_x; }
    int getY() const { return grid_y; }
    bool getIsActive() const { return isActive; }
    int getMode() const { return modes; }   

    virtual void move() = 0;
    virtual void switchMode() = 0;
    virtual void update() = 0;
};

class blinky: public Enemie{
public:
    blinky();
    blinky(int x, int y);

    void move() override;
    void switchMode() override;
    void update() override;
};

class pinky: public Enemie{
public:
    pinky();
    pinky(int x, int y);
};

class inky: public Enemie{
public:
    inky();
    inky(int x, int y);
};

class clyde: public Enemie{
public:
    clyde();
    clyde(int x, int y);
};

#endif
