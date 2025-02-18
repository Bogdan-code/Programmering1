GOLF 2P

GOLF 2P is a two-player golf simulation game built with Ruby2D. This game challenges you and a friend to take turns shooting a ball into a randomly placed hole while competing for the best score over multiple rounds. Enjoy the mix of strategy, precision, and fun graphics!
Table of Contents

    Features
    Installation
    How to Play
    Code Structure
    Contributing
    License

Features

    Two-Player Gameplay: Take turns as Player 1 and Player 2.
    Multiple Rounds: Compete over a set number of rounds to determine the winner.
    Dynamic Scoring: Score is based on the number of shots taken to complete the hole, with special messages like "HOLE IN ONE!!!" and "DOUBLE BIRDIE!!!" depending on your performance.
    Randomized Hole Placement: Each round features a new hole location to keep the game fresh.
    User-Friendly Controls: Click on your ball to set it in motion; adjust the angle by moving your mouse.
    Visual Feedback: On-screen text and images keep you updated on turns, hits, rounds, and final scores.

Installation
Prerequisites

    Ruby: Ensure you have Ruby installed on your system. You can download it from ruby-lang.org.
    Ruby2D: Install the Ruby2D gem, which handles graphics and user input. To install, run:

    gem install ruby2d

Running the Game

    Clone or download the repository containing the game code.
    Open a terminal in the game’s directory.
    Run the game with:
    cd into ruby_2d_lall
    ruby golf_2p.rb


How to Play

    Starting the Game:
        The game window will open with a background image and two balls representing each player.
        Player 1 starts the game. A message ("PLAYER 1 TURN") is displayed on-screen.

    Taking a Shot:
        Click on your ball (it’s highlighted with its own image) to activate it.
        Once activated, move your mouse to adjust the angle of your shot.
        When ready, click again (or release the mouse button) to shoot the ball.
        The ball’s velocity is determined by the distance between your click and the ball's current position.

    Scoring:
        The game counts each shot as a “hit”. Special messages (e.g., "HOLE IN ONE!!!") appear based on the number of hits.
        When the ball goes out of bounds, it resets and a hit is recorded.
        When the ball collides with the hole, the current turn ends and the score is recorded.

    Rounds and End Game:
        After both players have taken their shots for a round, the hole changes location, and the next round begins.
        The game is played for a set number of rounds (by default, 2 rounds).
        Once all rounds are completed, a final score screen displays the scores for both players and declares the winner.

Code Structure

    Player Class:
    Handles the properties and behavior of the players’ balls, including movement, drawing, shooting, angle updates, and resetting after a hit or scoring.

    Hole Class:
    Manages the hole’s position, drawing, collision detection, and location changes between rounds.

    Game Class:
    Tracks game statistics such as hits, rounds, and displays on-screen text for scores and messages. It also determines when a player wins a round or the game.

    Main Update Loop:
    Uses Ruby2D’s update loop to refresh the game window, check collisions, manage turns, and update scores in real time.

    Mouse Event Handlers:
    Capture mouse movements and clicks to manage ball selection, angle adjustments, and shooting.

Contributing

Contributions to improve the game are welcome! If you have ideas or bug fixes, please fork the repository, make your changes, and submit a pull request.
License


Enjoy playing GOLF 2P and have fun competing with your friends!
