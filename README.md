# CLI Chess

<img width="300" alt="Screenshot 2023-10-11 at 10 36 50 PM" src="https://github.com/mandrewlewis/cli_chess/assets/81784056/64fa211c-498d-46eb-b514-dbc3bda63130">

## Overview

This Ruby project will allow two human players to battle each other in the world renown game of intellect, chess, right from the command line interface. This is a fully-operational game that accounts for all chess rules including proper "check" validations and even special moves like "castling" and "en passant." Tests were written in rspec to test critical features, but should not be considered comprehensive.

This project is intended to demonstrate all of the concepts I have learned from The Odin Project's Ruby course.

## How to run

1) Clone this repo
2) cd into the directory
3) Run `ruby main.rb`
4) Conquer

## How to play

After entering the two players' names, the game will begin! Each player must first select the piece they want to move and then the square they want to move that piece to. When inputting selections, players should use chess notation of file and rank (column letter + row number) such as "d2" or "f5". The game will end when a player is put into checkmate!
