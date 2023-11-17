/*
Get a screen displaying - this is highly visual
Get a Pacman responding to user input
Get Pacman constrained to within the walls
Get a ghost responding to secondary user input - you can chase each other
Figure out some collision detection
Get the dots and power pills rendering so you can score and eat ghost
Render some more ghosts and figure out AI
Work out the code for finding when the level is complete
Make the map change and state reset when on a new level
*/
#include "macros.h"

class Pacman {
private:
    int grid_x;
    int grid_y;
    int curr_dir;
    int health;
public:
    Pacman();
    Pacman(int x,int y,int health);

    int getX();
    int getY();
    int getCurrDir();
    int getHealth();

    void setDirection(int direction);
};