import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Create initial game state
  var gameState = GameState.standard();

  // Create game controller
  var gameController = GameController(gameState: gameState);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GameWidget(gameController: gameController),
      ),
    ),
  );
}

class GameObject {
  double xPos;
  double yPos;
  double size;
  double speed;
  double direction; // angle in radians

  GameObject({required this.xPos, required this.yPos, required this.size, required this.speed, required this.direction});
  
  void update(double time, Size screenSize) {
    // Update x and y position based on speed, direction and time
    xPos += cos(direction) * speed * time;
    yPos += sin(direction) * speed * time;
    
    // Wrap around screen edges
    if (xPos < 0) xPos = screenSize.width;
    if (xPos > screenSize.width) xPos = 0;
    if (yPos < 0) yPos = screenSize.height;
    if (yPos > screenSize.height) yPos = 0;
  }
  
  void rotate(double angle) {
    // Add the given angle to the current direction
    direction += angle;
  }

  void changeSpeed(double amount) {
    // Add the given amount to the current speed
    speed += amount;
  }
  
  bool collidesWith(GameObject other) {
    // Calculate distance between objects
    double distance = sqrt(pow(xPos - other.xPos, 2) + pow(yPos - other.yPos, 2));

    // Check if distance is less than the combined size of both objects
    return distance < size + other.size;
  }
}

class Spaceship extends GameObject {
  // You might want to add additional properties or methods here
  Spaceship(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);
  
  Bullet shoot() {
    // Create a new bullet facing the same direction as the spaceship, with increased speed
    return Bullet(xPos, yPos, 1.0, 150.0, direction);  // Increase bullet speed to 20
  }
  
  void draw(Canvas canvas, Size size) {
    // Draw spaceship with gradient
    final Gradient gradient = LinearGradient(
      colors: <Color>[Colors.white, Colors.grey],
    );
    final Rect rect = Rect.fromLTWH(xPos - 10, yPos, 20, 20);
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    
    final path = Path();
    path.moveTo(
      xPos + cos(direction) * this.size,
      yPos + sin(direction) * this.size
    );
    path.lineTo(
      xPos + cos(direction + 2 * pi / 3) * this.size,
      yPos + sin(direction + 2 * pi / 3) * this.size
    );
    path.lineTo(
      xPos + cos(direction - 2 * pi / 3) * this.size,
      yPos + sin(direction - 2 * pi / 3) * this.size
    );    
    canvas.drawPath(path, paint);
  }
}

class Asteroid extends GameObject {
  // You might want to add additional properties or methods here
  Asteroid(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);
  
  void draw(Canvas canvas, Size size) {
    // Draw asteroid with gradient
    final Gradient gradient = LinearGradient(
      colors: <Color>[Colors.grey[200]!, Colors.grey[800]!],
    );
    final Rect rect = Rect.fromLTWH(xPos - this.size, yPos - this.size, 2 * this.size, 2 * this.size);
    final Paint paint = Paint()..shader = gradient.createShader(rect);

    canvas.drawCircle(Offset(xPos, yPos), this.size, paint);
  }
}

class Bullet extends GameObject {
  final DateTime _createTime = DateTime.now();

  // You might want to add additional properties or methods here
  Bullet(double xPos, double yPos, double size, double speed, double direction)
    : super(xPos: xPos, yPos: yPos, size: size, speed: speed, direction: direction);

  // Check if the bullet should be removed
  bool get shouldRemove => DateTime.now().difference(_createTime) > Duration(seconds: 3);
}

class GameState {
  Spaceship spaceship;
  List<Asteroid> asteroids;
  List<Bullet> bullets;

  GameState({required this.spaceship, required this.asteroids, required this.bullets});
  
  factory GameState.standard() => GameState(
      spaceship: Spaceship(150, 150, 10, 10, 0),
      asteroids: [Asteroid(50, 50, 20, 20, pi / 4), Asteroid(250, 250, 20, 20, pi * 3 / 4)],
      bullets: [],
    );
}

class GameController {
  GameState gameState;
  int score = 0;
  
  bool isGameOver = false;
  String gameOverMessage = '';
  
  GameController({required this.gameState});

  void update(double time, Size screenSize) {
    // Update all game objects
    gameState.spaceship.update(time, screenSize);
    gameState.asteroids.forEach((asteroid) => asteroid.update(time, screenSize));
    gameState.bullets.forEach((bullet) => bullet.update(time, screenSize));

    // Check for collisions between bullets and asteroids
    gameState.bullets.removeWhere((bullet) {
      for (Asteroid asteroid in gameState.asteroids) {
        if (bullet.collidesWith(asteroid)) {
          gameState.asteroids.remove(asteroid);
          score += 1;
          return true;
        }
      }
      return bullet.shouldRemove;
    });
    
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
    gameState = GameState.standard();
    score = 0;
    isGameOver = false;
    gameOverMessage = '';
  }
}

class GamePainter extends CustomPainter {
  final GameState gameState;

  GamePainter({required this.gameState});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Draw spaceship
    gameState.spaceship.draw(canvas, size);

    // Draw asteroids
    paint.color = Colors.brown;
    for (var asteroid in gameState.asteroids) {
      asteroid.draw(canvas, size);
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

class GameWidget extends StatefulWidget {
  final GameController gameController;

  GameWidget({required this.gameController});

  @override
  State<StatefulWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to update the game state every 20ms
    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      final screenSize = MediaQuery.of(context).size;
      setState(() {
        widget.gameController.update(0.02, screenSize);
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
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Image.network(
          'https://prototyingstorage.blob.core.windows.net/files/space-background.png',
          width: screenSize.width,
          height: screenSize.height,
          fit: BoxFit.cover,
        ),
        _buildScreen(context), 
      ],
    );
  }
  
  Widget _buildScreen(BuildContext context) {
    if (widget.gameController.isGameOver) {
      return Center(child: 
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.gameController.gameOverMessage,
              style: TextStyle(fontSize: 32, color: widget.gameController.gameOverMessage == 'You Crashed!' ? Colors.red : Colors.green),
            ),
            Text(
              'Score: ${widget.gameController.score}',
              style: TextStyle(fontSize: 24, color: Colors.white),
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
        ), 
      );
    } else {
      return _buildGame(context);
    }
  }
  
  Widget _keyBoardListener(BuildContext context, Widget child) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
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
              widget.gameController.gameState.spaceship.changeSpeed(5);
            });
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            setState(() {
              widget.gameController.gameState.spaceship.changeSpeed(-5);
            });
          } else if (event.logicalKey == LogicalKeyboardKey.space) {
            setState(() {
              widget.gameController.gameState.bullets.add(widget.gameController.gameState.spaceship.shoot());
            });
          }
        }
      },
      child: child, 
    );      
  }
  
  Widget _buildGame(BuildContext context) {
    return _keyBoardListener(context, Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.grey[900]!, // background
                  ),
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.rotate(-pi / 18);
                    });
                  },
                  child: Text('Left'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.grey[900]!, // background
                  ),
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.rotate(pi / 18);
                    });
                  },
                  child: Text('Right'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.grey[900]!, // background
                  ),
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.changeSpeed(-5);
                    });
                  },
                  child: Text('-'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.grey[900]!, // background
                  ),
                  onPressed: () {
                    setState(() {
                      widget.gameController.gameState.spaceship.changeSpeed(5);
                    });
                  },
                  child: Text('+'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    // ignore: deprecated_member_use
                    primary: Colors.grey[900]!, // background
                  ),
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
