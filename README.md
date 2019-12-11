Mastermind

By I. Mahle

A project of The Odin Project: https://www.theodinproject.com/courses/ruby-programming/lessons/oop

Instructions

1. Run ./mastermind.rb
2. Follow the instructions

Discussion
I used the following technologies: Ruby with classes and methods.
This is a command line mastermind game where you have 12 turns to guess the secret code. The computer will evaluate your guess: "-" means that the color is not included in the code, "x" means that color and position are correct, "o" means that only the color is correct, the position is wrong. Repetition of colors are possible.
The game includes the option of the computer guessing your secret code. The computer has some intelligence: If the computer has guessed the right color but the wrong position, its next guess will need to include that color somewhere.

Requirements
Ruby
