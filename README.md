# flutter_ai_asteroids

![Background image for the game generated by DreamStudio](https://raw.githubusercontent.com/tolo/flutter_ai_asteroids/257d96bc08ca154946a2ee4fa8016c94f94dc1fe/space-background.png)

A Flutter Asteroids game built using ChatGPT (GPT-4). 

The prompts used to generate the code for the application are included below. I've only included the first (moste interesting) part of the conversation, as the last bit was more of nitpicking and debugging related. There are however some debugging at the end of the conversation, and it's interesting to se how well ChatGPT can be helpful with that kind of tasks.

At the end of the conversation, I add a background image to the game. This image was generated using [DreamStudio](https://dreamstudio.ai) from stability.ai. This was the prompt (using the style "Digital art"): 

```
An image of outer space, including mostly lots of distant stars and some small galaxies and colourful nebulae. Viewed from the surface of an alien moon.
```

Below follows the ChatGPT conversation. 



## User:
**Hello. Can you help me with building an Asteroids game app using Flutter?**

---


Sure, I'd be glad to help you get started with building an Asteroids game app in Flutter. Here's a high-level outline of the steps you would need to follow:

1. **Set Up Flutter:**
Make sure you have Flutter SDK and Dart installed on your machine. Also, ensure you have a code editor such as Visual Studio Code installed.

2. **Create a new Flutter project:**
   Use the command `flutter create asteroids_game` in your terminal/command prompt.

3. **Designing the Game Objects (Asteroids, Spaceship, Bullets):**
   You need to create objects for your game. This includes asteroids, the spaceship, and bullets. For each of these objects, you will need to define the following:

   - Position
   - Size
   - Speed
   - Direction

   Also, consider how each object will be drawn on the screen. You might want to use `CustomPainter` to draw your game objects.

4. **Game Logic:**
    - **Movement:** Define how the spaceship and asteroids move. The spaceship's movement might be controlled by the user (e.g., using on-screen buttons), while the asteroids could move randomly.
    - **Shooting:** Implement functionality for the spaceship to shoot bullets. When a bullet is fired, it should move in the direction that the spaceship was facing at the time of firing.
    - **Collisions:** Implement collision detection. You'll need to detect collisions between the spaceship and asteroids, and between bullets and asteroids.
    - **Scoring:** Define how the player will score points (e.g., by hitting asteroids).
    - **Game Over:** Define conditions for ending the game (e.g., when the spaceship collides with an asteroid).

5. **Implementing User Interface:**
    - Use Flutter's widget tree to implement game UI, which might include start and end game screens, score display, and on-screen controls.
    - Consider how to handle user input. For a mobile game, you might use `GestureDetector` to handle taps on the screen.

6. **Testing:**
    - Always test your app. Flutter has a robust testing framework that allows for unit tests, widget tests, and integration tests.

7. **Building and Publishing Your App:**
    - Once your game is functioning correctly and you're happy with it, you can build it for iOS and Android using `flutter build ios` or `flutter build apk` respectively.
    - After that, you can publish it on app stores.

For your game, consider using a game engine built on top of Flutter, like Flame. It can simplify game development by providing useful features like a game loop, sprite and animation handling, collision detection, and more.

This is a high-level guide. Each step can be broken down further, and you'll likely encounter specific problems or have more detailed questions at each step. Feel free to ask for more information or clarification as needed! 


---
## User:

**Could you start by helping me to create the needed classes and data structures as mentioned in step 3? Make them as simple as possible, to be able to implement a basic version of the game.**

---

Sure! I'll outline some simple Dart classes for your Asteroids game in Flutter.

First, let's define a basic `GameObject` class. This will serve as the base class for all our game objects (Spaceship, Asteroid, Bullet).

```dart
class GameObject {
  double xPos;
  double yPos;
  double size;
  double speed;
  double direction; // angle in radians

  GameObject({required this.xPos, required this.yPos, required this.size, required this.speed, required this.direction});
}
```
The `GameObject` class has properties for the position (`xPos` and `yPos`), `size`, `speed`, and `direction`.

Now, let's extend `GameObject` to create specific classes for the Spaceship, Asteroid, and Bullet.

```dart
class Spaceship extends GameObject {
  // You might want to add additional properties or methods here
  Spaceship(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);
}

class Asteroid extends GameObject {
  // You might want to add additional properties or methods here
  Asteroid(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);
}

class Bullet extends GameObject {
  // You might want to add additional properties or methods here
  Bullet(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);
}
```

Now, we need to create a class for managing the game state. This will keep track of all game objects and can handle creating and removing objects as needed.

```dart
class GameState {
  Spaceship spaceship;
  List<Asteroid> asteroids;
  List<Bullet> bullets;

  GameState({required this.spaceship, required this.asteroids, required this.bullets});
}
```
In `GameState`, we have the `Spaceship` object, and lists of `Asteroid` and `Bullet` objects.

This is a very basic starting point and you will probably need to add additional methods and properties to these classes as you implement more game functionality. For example, you might add a `move()` method to the `GameObject` class to handle updating an object's position based on its speed and direction.

---
## User:

**Great! In the same manner, could you help me create the game logic mentioned in step 4?** 

---


Sure, I can provide some guidelines on how to add game logic. Let's take it one step at a time.

**1. Movement:**

Each game object will have its own way of moving. A common method is to update the position based on the object's speed and direction. Let's add a `move` method to the `GameObject` class to update the object's position.

```dart
void move(double time) {
  // Update x and y position based on speed, direction and time
  xPos += cos(direction) * speed * time;
  yPos += sin(direction) * speed * time;
}
```

**2. Shooting:**

When the spaceship shoots a bullet, we need to create a new `Bullet` instance at the spaceship's position and facing the same direction as the spaceship. We'll add a `shoot` method to the `Spaceship` class.

```dart
Bullet shoot() {
  // Create a new bullet facing the same direction as the spaceship
  return Bullet(xPos, yPos, 1.0, 10.0, direction);
}
```

**3. Collisions:**

You need to detect when game objects collide. A simple way is to check if the distance between objects is less than their combined sizes (i.e., if their "circles" overlap). We'll add a `collidesWith` method to the `GameObject` class.

```dart
bool collidesWith(GameObject other) {
  // Calculate distance between objects
  double distance = sqrt(pow(xPos - other.xPos, 2) + pow(yPos - other.yPos, 2));
  
  // Check if distance is less than the combined size of both objects
  return distance < size + other.size;
}
```

**4. Scoring and Game Over:**

For a simple scoring system, you might increase the score by one every time a bullet hits an asteroid. To check this, iterate over all bullets and asteroids and check if they collide. If they do, remove the bullet and the asteroid, and increase the score.

To check if the game is over, iterate over all asteroids and check if they collide with the spaceship. If they do, then the game is over.

You could add this logic to a `GameController` class, which handles updating the game state.

```dart
class GameController {
  GameState gameState;
  int score = 0;

  GameController({required this.gameState});

  void update(double time) {
    // Update all game objects
    gameState.spaceship.move(time);
    gameState.asteroids.forEach((asteroid) => asteroid.move(time));
    gameState.bullets.forEach((bullet) => bullet.move(time));

    // Check for collisions between bullets and asteroids
    gameState.bullets.removeWhere((bullet) {
      for (Asteroid asteroid in gameState.asteroids) {
        if (bullet.collidesWith(asteroid)) {
          gameState.asteroids.remove(asteroid);
          score += 1;
          return true;
        }
      }
      return false;
    });

    // Check for collisions between the spaceship and asteroids
    for (Asteroid asteroid in gameState.asteroids) {
      if (gameState.spaceship.collidesWith(asteroid)) {
        // Game over
        // You might want to throw an exception or set a flag here
      }
    }
  }
}
```

Remember, these are simple implementations. In a real game, you'd probably want more complex behavior. For example, asteroids might split into smaller asteroids when hit by a bullet, or the spaceship might have lives and only game over when no lives are left. You could add these features by adding more properties and methods to your classes.


---
## User:

**Fantastic! Now, can you help me write the UI code for this, as outlined in step 5?** 

---

Sure! Let's use Flutter's custom painting to draw the game objects on a canvas, and then place that canvas in the app UI.

First, let's create a `GamePainter` widget that will take the `GameState` and draw everything on a canvas.

```dart
class GamePainter extends CustomPainter {
  final GameState gameState;

  GamePainter({required this.gameState});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw spaceship
    paint.color = Colors.blue;
    canvas.drawCircle(
        Offset(gameState.spaceship.xPos, gameState.spaceship.yPos),
        gameState.spaceship.size,
        paint,
    );

    // Draw asteroids
    paint.color = Colors.brown;
    for (var asteroid in gameState.asteroids) {
      canvas.drawCircle(
          Offset(asteroid.xPos, asteroid.yPos),
          asteroid.size,
          paint,
      );
    }

    // Draw bullets
    paint.color = Colors.red;
    for (var bullet in gameState.bullets) {
      canvas.drawCircle(
          Offset(bullet.xPos, bullet.yPos),
          bullet.size,
          paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
```

Then, let's create a `GameWidget` to include the `GamePainter` inside a `CustomPaint` widget. We'll also include a score display and a button to shoot bullets. For simplicity, we'll control the spaceship's direction by rotating it in place every frame.

```dart
class GameWidget extends StatefulWidget {
  final GameController gameController;

  GameWidget({required this.gameController});

  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to update the game state every 20ms
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        widget.gameController.update(0.02);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: GamePainter(gameState: widget.gameController.gameState),
          size: Size(300, 300),  // for simplicity, we are using a fixed size
        ),
        Text('Score: ${widget.gameController.score}'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
            });
          },
          child: Text('Shoot'),
        ),
      ],
    );
  }
}
```

And finally, use `GameWidget` as the main widget of your app:

```dart
void main() {
  // Create initial game state
  var gameState = GameState(
    spaceship: Spaceship(150, 150, 10, 5, 0),
    asteroids: [Asteroid(50, 50, 20, 1, pi / 4), Asteroid(250, 250, 20, 1, pi * 3 / 4)],
    bullets: [],
  );

  // Create game controller
  var gameController = GameController(gameState: gameState);

  runApp(
    MaterialApp(
      home: Scaffold(
        body: GameWidget(gameController: gameController),
      ),
    ),
  );
}
```

In the above code, the game

 runs in a fixed-size area, the spaceship rotates in place, and you shoot by pressing a button. You'll need to replace these simplifications with real game controls for a complete game.

Please note that you would usually want to manage game state using a more advanced state management solution (like `Provider`, `Riverpod`, `Bloc`, etc.) instead of updating state directly from timers and button presses. Also, be sure to handle edge cases such as objects moving off the screen or game over condition.


---
## User:

**Great! Could you also add logic and buttons in the UI for the following actions:**
- "Right" - Rotates the spaceship right
- "Left" - Rotates the spaceship left
- "+" - Increases speed of the spaceship
- "-" - Decreases speed of the spaceship

Please also use a triangle as the shape for the spaceship.

---


Sure! I can certainly help you with that. 

First, let's add a `rotate` and `changeSpeed` method to the `Spaceship` class to handle the desired operations:

```dart
class Spaceship extends GameObject {
  // ...

  void rotate(double angle) {
    // Add the given angle to the current direction
    direction += angle;
  }

  void changeSpeed(double amount) {
    // Add the given amount to the current speed
    speed += amount;
  }
}
```

Next, let's modify the `GamePainter` class to draw the spaceship as a triangle instead of a circle:

```dart
// Draw spaceship
paint.color = Colors.blue;
var path = Path();
path.moveTo(
  gameState.spaceship.xPos + cos(gameState.spaceship.direction) * gameState.spaceship.size,
  gameState.spaceship.yPos + sin(gameState.spaceship.direction) * gameState.spaceship.size
);
path.lineTo(
  gameState.spaceship.xPos + cos(gameState.spaceship.direction + 2 * pi / 3) * gameState.spaceship.size,
  gameState.spaceship.yPos + sin(gameState.spaceship.direction + 2 * pi / 3) * gameState.spaceship.size
);
path.lineTo(
  gameState.spaceship.xPos + cos(gameState.spaceship.direction - 2 * pi / 3) * gameState.spaceship.size,
  gameState.spaceship.yPos + sin(gameState.spaceship.direction - 2 * pi / 3) * gameState.spaceship.size
);
path.close();
canvas.drawPath(path, paint);
```

Finally, let's add the buttons for rotating and changing the speed of the spaceship in the `GameWidget`:

```dart
class GameWidget extends StatefulWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: GamePainter(gameState: widget.gameController.gameState),
          size: Size(300, 300),  // for simplicity, we are using a fixed size
        ),
        Text('Score: ${widget.gameController.score}'),
        ElevatedButton(
          onPressed: () {
            setState(() {
              widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
            });
          },
          child: Text('Shoot'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.gameController.gameState.spaceship.rotate(-pi / 18);  // Rotate 10 degrees to the left
                });
              },
              child: Text('Left'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.gameController.gameState.spaceship.rotate(pi / 18);  // Rotate 10 degrees to the right
                });
              },
              child: Text('Right'),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.gameController.gameState.spaceship.changeSpeed(-1);  // Decrease speed by 1
                });
              },
              child: Text('-'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.gameController.gameState.spaceship.changeSpeed(1);  // Increase speed by 1
                });
              },
              child: Text('+'),
            ),
          ],
        ),
      ],
    );
  }
}
```

In the above code, the "Left" button rotates the spaceship 10 degrees to the left, the "Right" button rotates the spaceship 10 degrees to

 the right, the "-" button decreases the speed of the spaceship by 1, and the "+" button increases the speed of the spaceship by 1. Adjust the rotation angle and speed change as per your requirements.


---
## User:

Great! Could you also help me write the game over logic? 
- When all asteroids have been destroyed - write a large green text saying "Game Over" along with the total points. 
- If colliding with an asteroid, instead write a large red text saying "You Crashed!" along with the total points. 

For both these scenarios, first remove or hide the game UI, and also include a button saying "Play again", which restarts the game.

---


Sure! For this, we'll need to modify the `GameController` and `GameWidget` classes.

First, let's add an `isGameOver` flag to the `GameController` class to indicate whether the game is over, and a `gameOverMessage` string to store the game over message.

```dart
class GameController {
  // ...

  bool isGameOver = false;
  String gameOverMessage = '';

  // ...

  void update(double time) {
    // Do not update game state if game is over
    if (isGameOver) return;

    // Update all game objects
    // ...

    // Check for collisions between bullets and asteroids
    // ...

    // Check for collisions between the spaceship and asteroids
    for (Asteroid asteroid in gameState.asteroids) {
      if (gameState.spaceship.collidesWith(asteroid)) {
        // Game over
        isGameOver = true;
        gameOverMessage = 'You Crashed!';
        return;
      }
    }

    // Check if all asteroids have been destroyed
    if (gameState.asteroids.isEmpty) {
      // Game over
      isGameOver = true;
      gameOverMessage = 'Game Over';
    }
  }

  void restart() {
    // Reset game state
    gameState = GameState(
      spaceship: Spaceship(150, 150, 10, 5, 0),
      asteroids: [Asteroid(50, 50, 20, 2, pi / 4), Asteroid(250, 250, 20, 2, pi * 3 / 4)],
      bullets: [],
    );
    score = 0;
    isGameOver = false;
    gameOverMessage = '';
  }
}
```

Then, in the `GameWidget` class, we can check the `isGameOver` flag to display the game over screen instead of the game UI:

```dart
class GameWidget extends StatefulWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    if (widget.gameController.isGameOver) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.gameController.gameOverMessage,
            style: TextStyle(fontSize: 32, color: widget.gameController.gameOverMessage == 'You Crashed!' ? Colors.red : Colors.green),
          ),
          Text(
            'Score: ${widget.gameController.score}',
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.gameController.restart();
              });
            },
            child: Text('Play again'),
          ),
        ],
      );
    } else {
      return Column(
        // Game UI
        // ...
      );
    }
  }
}
```

This code displays a screen with the game over message and score in large text, and a "Play again" button when the game is over. The game over message is red if the player crashed into an asteroid, and green if they destroyed all asteroids. The "Play again" button resets the game state and starts a new game.


---
## User:

Could you make the game UI full screen? Also place the buttons in a single row at the bottom, with spacing in-between. Could you also hook up keyboard key events for the buttons, for instance use the arrow keys for turning a speed control, and spacebar for shooting?

---

Certainly! To make the game UI fullscreen, you should let the `CustomPaint` widget take all available space by wrapping it with an `Expanded` widget.

For the buttons, you can use a `Row` widget with `MainAxisAlignment.spaceBetween` to place them in a single row with spacing in between. Then, wrap this `Row` in a `Padding` or `Container` widget to add some space at the bottom.

Regarding keyboard events, Flutter has a `RawKeyboardListener` widget that can be used to listen for key events. You can wrap your game widget with this to listen for key presses and call the corresponding methods in your game controller.

Here's how you can modify the `GameWidget` class to incorporate these changes:

```dart
class GameWidget extends StatefulWidget {
  // ...

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          switch (event.logicalKey.keyId) {
            case 0x10007004d:  // Arrow left key ID
              setState(() {
                widget.gameController.gameState.spaceship.rotate(-pi / 18);
              });
              break;
            case 0x10007004e:  // Arrow right key ID
              setState(() {
                widget.gameController.gameState.spaceship.rotate(pi / 18);
              });
              break;
            case 0x100070052:  // Arrow up key ID
              setState(() {
                widget.gameController.gameState.spaceship.changeSpeed(1);
              });
              break;
            case 0x100070051:  // Arrow down key ID
              setState(() {
                widget.gameController.gameState.spaceship.changeSpeed(-1);
              });
              break;
            case 0x00000020:  // Space key ID
              setState(() {
                widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
              });
              break;
          }
        }
      },
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              painter: GamePainter(gameState: widget.gameController.gameState),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.rotate(-pi / 18);
                    });
                  },
                  child: Text('Left'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.rotate(pi / 18);
                    });
                  },
                  child: Text('Right'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.changeSpeed(-1);
                    });
                  },
                  child: Text('-'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.changeSpeed(1);
                    });
                  },
                  child: Text('+'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
                    });
                  },
                  child: Text('Shoot'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

In this code, the `RawKeyboardListener` listens for key down events and calls the appropriate method in the game controller when the arrow keys or space bar are pressed. The left arrow key rotates the spaceship left, the right arrow



---
## User:

I get an error for RawKeyDownEvent. What are the imports needed for this app?

---

My apologies for any confusion. The `RawKeyDownEvent` class is part of the `flutter/services.dart` package. Here's a list of the main import statements you might need for this Flutter application:

```dart
import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
```

Let me know if you need further assistance.


---
## User:

The key events doesn't seem to work. Are the key codes correct?

---

My apologies for the confusion. The key codes for Arrow keys and Spacebar key were incorrect in my previous response. 

Please use the `LogicalKeyboardKey` constants for these keys. The revised `onKey` event listener code would look like this:

```dart
onKey: (RawKeyEvent event) {
  if (event is RawKeyDownEvent) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      setState(() {
        widget.gameController.gameState.spaceship.rotate(-pi / 18);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      setState(() {
        widget.gameController.gameState.spaceship.rotate(pi / 18);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(() {
        widget.gameController.gameState.spaceship.changeSpeed(1);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(() {
        widget.gameController.gameState.spaceship.changeSpeed(-1);
      });
    } else if (event.logicalKey == LogicalKeyboardKey.space) {
      setState(() {
        widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
      });
    }
  }
},
```

This revised code uses the `LogicalKeyboardKey` constants to compare the keys, which is a more reliable and clear method than comparing raw key codes. Let me know if you face any more issues.


---
## User:

Great, thanks! Could you also make it so that when game objects leave the screen, they re-appear on the opposite side?

---


Certainly, we can update the `update` methods in the `Spaceship`, `Asteroid`, and `Bullet` classes to check if the objects are off-screen and, if so, to wrap them around to the other side. For this, we need to know the size of the screen, which we can get using `MediaQuery`.

In your `GameController`, you need to capture the size of the screen during the initialization. Then, we can use this in the game objects to adjust their positions when they move off-screen.

Here's how you can modify your `GameController`:

```dart
class GameController {
  // Add a Size property for the screen size
  Size screenSize;

  // Update constructor to take screenSize
  GameController(this.screenSize) {
    // ... existing initialization code ...
  }

  // ... existing methods ...
}
```

When you create your `GameController` instance in `GameWidget`, get the screen size using `MediaQuery`:

```dart
final screenSize = MediaQuery.of(context).size;
final gameController = GameController(screenSize);
```

Then, in your `GameObject` subclasses, you can adjust the `update` method to wrap the object's position around the screen edges:

```dart
class Spaceship extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time) {
    xPos += cos(direction) * speed;
    yPos += sin(direction) * speed;

    // Wrap around screen edges
    if (xPos < 0) xPos = screenSize.width;
    if (xPos > screenSize.width) xPos = 0;
    if (yPos < 0) yPos = screenSize.height;
    if (yPos > screenSize.height) yPos = 0;
  }
}

class Asteroid extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time) {
    xPos += cos(direction) * speed;
    yPos += sin(direction) * speed;

    // Wrap around screen edges
    if (xPos < 0) xPos = screenSize.width;
    if (xPos > screenSize.width) xPos = 0;
    if (yPos < 0) yPos = screenSize.height;
    if (yPos > screenSize.height) yPos = 0;
  }
}

class Bullet extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time) {
    xPos += cos(direction) * speed;
    yPos += sin(direction) * speed;

    // Wrap around screen edges
    if (xPos < 0) xPos = screenSize.width;
    if (xPos > screenSize.width) xPos = 0;
    if (yPos < 0) yPos = screenSize.height;
    if (yPos > screenSize.height) yPos = 0;
  }
}
```

This code adjusts the x and y positions of the objects so that when they go off one edge of the screen, they reappear on the opposite edge.



---
## User:

I'm not sure this works, should perhaps the screen size instead be passed to the update method of GameController? And would it perhaps suffice to implement the logic for wrapping around screen edges in the GameObject base class? And pass screen size as a parameter to the move method?

---


My apologies for any confusion. You're correct, passing the screen size to the update method of `GameController` and implementing the logic for wrapping around screen edges in the `GameObject` base class would be a more efficient and elegant solution. 

First, let's modify the `GameController`'s `update` method to accept screen size:

```dart
void update(double time, Size screenSize) {
  // ...

  // Update all game objects
  gameState.spaceship.update(time, screenSize);
  for (Asteroid asteroid in gameState.asteroids) {
    asteroid.update(time, screenSize);
  }
  for (Bullet bullet in gameState.bullets) {
    bullet.update(time, screenSize);
  }

  // ...
}
```

Then, we should modify the `GameObject`'s `move` method to accept screen size:

```dart
void move(Size screenSize) {
  xPos += cos(direction) * speed;
  yPos += sin(direction) * speed;

  // Wrap around screen edges
  if (xPos < 0) xPos = screenSize.width;
  if (xPos > screenSize.width) xPos = 0;
  if (yPos < 0) yPos = screenSize.height;
  if (yPos > screenSize.height) yPos = 0;
}
```

And finally, you need to pass the screen size to the `update` method of `GameController` in your `GameWidget`:

```dart
final screenSize = MediaQuery.of(context).size;

// ...

gameController.update(t, screenSize);

// ...
```

This way, you're maintaining the screen boundary logic in a single place, and it's much easier to manage.


---
## User:

Thanks, but there seem to be a discrepancy between the naming of the move and update methods.

---


I apologize for the confusion. It seems there was a misunderstanding in my previous message. We should use `update` method in `GameObject` and its subclasses, not `move`. Let's correct this:

In `GameObject` class:

```dart
void update(double time, Size screenSize) {
  xPos += cos(direction) * speed * time;
  yPos += sin(direction) * speed * time;

  // Wrap around screen edges
  if (xPos < 0) xPos = screenSize.width;
  if (xPos > screenSize.width) xPos = 0;
  if (yPos < 0) yPos = screenSize.height;
  if (yPos > screenSize.height) yPos = 0;
}
```

Then in your `Spaceship`, `Asteroid`, and `Bullet` classes, you would call the super's `update` method.

Here's an example for the `Spaceship` class:

```dart
class Spaceship extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time, Size screenSize) {
    super.update(time, screenSize);

    // any additional spaceship-specific updates here
  }
}
```

Same goes for `Asteroid` and `Bullet` classes:

```dart
class Asteroid extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time, Size screenSize) {
    super.update(time, screenSize);

    // any additional asteroid-specific updates here
  }
}

class Bullet extends GameObject {
  // ... existing properties and methods ...

  @override
  void update(double time, Size screenSize) {
    super.update(time, screenSize);

    // any additional bullet-specific updates here
  }
}
```

I hope this clears up the confusion. Let me know if you need further clarification.


---
## User:

There seem to be a problem with the size of the CustomPaint.

---


The issue might be due to the fact that the `CustomPainter` doesn't know its size until the layout phase, but we're trying to get the size in the build phase which occurs before layout. To solve this, we could use a `LayoutBuilder` to get the constraints and thus the size of the widget.

Here's how you can modify your `GameWidget`:

```dart
class GameWidget extends StatefulWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: //... your key handling logic
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final screenSize = Size(constraints.maxWidth, constraints.maxHeight);
                return CustomPaint(
                  size: screenSize,
                  painter: GamePainter(gameState: widget.gameController.gameState),
                );
              },
            ),
          ),
          //... your bottom row with buttons
        ],
      ),
    );
  }
}
```

In the `builder` method of `LayoutBuilder`, we are given the `constraints` from which we can derive the size of the widget. We use these values to create our `screenSize`, and pass it to the `CustomPaint`.

Please remember to update your game loop to pass the `screenSize` to the `GameController`'s `update` method:

```dart
gameController.update(t, screenSize);
```

I hope this helps, and let me know if you face any more issues!


---
## User:

Please use this background image for the whole application: https://prototyingstorage.blob.core.windows.net/files/space-background.png

---


To use a background image, you can add an `Image.network` as the first child of your `Stack` widget:

```dart
Stack(
  children: <Widget>[
    Image.network(
      'https://prototyingstorage.blob.core.windows.net/files/space-background.png',
      width: screenSize.width,
      height: screenSize.height,
      fit: BoxFit.cover,
    ),
    //...
  ],
);
```
