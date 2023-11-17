/**
 *https://gameinternals.com/understanding-pac-man-ghost-behavior
*/
#ifndef ENEMIE_H
#define ENEMIE_H

#include "macros.h"


class enemie {
private:
    int x;
    int y;
    bool isActive;
    int modes; //Chase, Scatter, or Frightened for 0,1,2
public:
    enemie() : x(0), y(0), isActive(false), modes(0) {}
    enemie(int x, int y) : x(x), y(y), isActive(false), modes(0) {}

    int getX() const { return x; }
    int getY() const { return y; }
    bool getIsActive() const { return isActive; }
    int getMode() const { return modes; }   

    virtual void move() = 0;
    virtual void switchMode() = 0;
    virtual void update() = 0;
};

class blinky: public enemie{
public:
    blinky();
    blinky(int x, int y);

    void move() override;
    void switchMode() override;
    void update() override;
};

class pinky: public enemie{
public:
    pinky();
    pinky(int x, int y);

    void move() override;
    void switchMode() override;
    void update() override;
};

class inky: public enemie{
public:
    inky();
    inky(int x, int y);

    void move() override;
    void switchMode() override;
    void update() override;
};

class clyde: public enemie{
public:
    clyde();
    clyde(int x, int y);

    void move() override;
    void switchMode() override;
    void update() override;
};

#endif
