/*
Bounce assignment: make a circle bounce around the screen
 */

/*
variables:
 the following four lines declare four floats
 */
float xVel;
float xPos;
float yVel;
float yPos;
Paddle paddle;
boolean started;
int numBricks = 6 * 12;
Brick[] bricks = new Brick[numBricks];

int perRow = 6;
int perColumn = numBricks / perRow;
int brickCount;
int size = 16;
float baseSpeed = 3f;

int gameState;
int timestamp;
/*
void setup() gets called once when the program starts
 set the size of the window to width 600 height 800
 set xPos to width / 2 
 set yPos to height / 2
 set xVel to 12
 set yVel to 12
 */
void setup() {
  ellipseMode(CENTER);
  paddle = new Paddle(new PVector(width / 2, height - 30), new PVector(150, 10));
  size(600, 800);
  //bricks = new Brick[numBricks];
  PVector brickSize = new PVector(50, 20);
  PVector upperRightCorner = new PVector(50, 50);
  for (int i = 0; i < perRow; ++i) {
    for (int j = 0; j < perColumn; ++j) {
      PVector origin = new PVector (brickSize.x * j, brickSize.y * i);
      origin.add(upperRightCorner);
      bricks[i * perColumn + j] = new Brick(origin, brickSize);
      brickCount++;
    }
  }
}

/*
void draw() method:
 draw an ellipse at position: xPos, yPos and size: 12, 12
 make xPos be equal to xPos + xVel
 make yPos be equal to yPos + yVel
 if xPos is greater than width or less than zero:
 make xVel be equal to xVel * -1
 if yPos is greater than height or less than zero:
 make yVel be equal to yVel * -1
 */
void draw() {
  if (!started) {
    gameState = 0;
    startScreen();
    return;
  } else if (gameState > 0) {
    if (gameState == 1) {
      loseScreen();
    } else if (gameState == 2) {
      winScreen();
    }
    if (frameCount - timestamp > 60) {
      started = false;
    }
    return;
  }
  background(122, 166, 0);
  paddle.drawMe();
  ellipse(xPos, yPos, size, size);
  xPos += xVel;
  yPos += yVel;
  if (xPos > width || xPos < 0) {
    xVel *= -1;
  }
  if (yPos < 0) {
    yVel *= -1;
  }
  if (paddle.hit(xPos, yPos)) {
    yVel *= -1;
  } else if (yPos > height) {
    //lose();
    yVel *= -1;
  }

  if (keyPressed == true) {
    int slidePaddle = 0;
    if (key == 'd') {
      slidePaddle = 1;
    } else if (key == 'a') {
      slidePaddle = -1;
    }
    paddle.slide(slidePaddle);
  }

  int hitBricks = 0;
  for (Brick b : bricks) {
    if (b.hasBeenHit) {
      if (++hitBricks >= 2) { // brickCount * .05) {
        win();
        break;
      }
      continue;
    }
    for (PVector side : getSides() ) {
      if (b.hit(side)) {
        xVel *= -1;
        b.hasBeenHit = true;
        break;
      }
    }
    for (PVector tb : getTopBot() ) {
      if (b.hit(tb)) {
        yVel *= -1;
        b.hasBeenHit = true;
        break;
      }
    }
    b.drawMyself();
  }
}

private void winScreen() {
  background(255, 122, 122);
  msg("Level Complete");
}

private void loseScreen() {
  background(122, 12, 12);
  msg("You Lost");
}

private void startScreen() {
  background(12, 200, 33);
  msg("Press 'p' to start");
}

private void msg(String s) {
  textSize(32);
  text(s, 10, 45);
}

float r = size / 2.0;
private PVector[] sides = new PVector[] {
  new PVector(-r, 0), 
  new PVector(r, 0), 
  new PVector(0, -r), 
  new PVector(0, r)
};

private PVector[] getSides() {
  PVector[] result = new PVector[2];
  for (int i = 0; i < 2; ++i) {
    result[i] = PVector.add(sides[i], new PVector(xPos, yPos));
  }
  return result;
}

private PVector[] getTopBot() {
  PVector[] result = new PVector[2];
  for (int i = 2; i < 4; ++i) {
    result[i - 2] = PVector.add(sides[i], new PVector(xPos, yPos));
  }
  return result;
}

private void lose() {
  gameState = 1;
  timestamp = frameCount;
}

private void win() {
  gameState = 2;
  timestamp = frameCount;  
}

private void playAgain() {
  if (started) return;
  print("starting");
  resetBricks();
  started = true;
  gameState = 0;
  xPos = width / 2;
  yPos = height / 2;
  xVel = 12;
  yVel = 12;
}

private void resetBricks() {
 for (Brick b : bricks) {
  b.hasBeenHit = false; 
 }
}

void keyPressed() {
  if (key == 'p') {
    playAgain();
  }
}

private void circle(float x, float y) {
  ellipse(x, y, 12, 12);
}