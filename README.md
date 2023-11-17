# PacMan in SystemVerilog for ECE 385

## Table of Contents

+ [Overview](#overview)
+ [Version Updates](#version_updates)
+ [Setup Guide](#setup_guide)
+ [How to Use](#how_to_use)

## Overview <a name = "overview"></a>

This project is a SystemVerilog implementation of the classic game PacMan, adapted for use on a development board as part of the ECE 385 final project. 

## Version Updates <a name = "version_updates"></a>


+ v1.0 Phase one 11.17.2023
  + basic setup

## Setup Guide <a name = "setup_guide"></a>

Download files and run in Vivado with Urbana FPGA borad.

### Requirements

+ UIUC Urbana FPGA borad
+ HDMI cable and monitor
+ For Vivado use

## How to Use <a name = "how_to_use"></a>

You can program the board using precompiled binary files from the releases or by building the project in Vivado. To start, clone the repository and import the [project file](../pacman.xpr) located at the root as an existing project in Vivado. Then, generate the bitstream using your local copy. For precompiled versions, connect your board and use the Hardware Manager to program it.

### Playing the Game

Once the board is programmed, connect to the serial port of the board. Upon establishing a connection, use the keyborad WASD characters to move the player up, right, down, and left, respectively.
