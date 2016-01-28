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
int size = 16;
float baseSpeed = .1;
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
  if (!started) return;
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

  for (Brick b : bricks) {
    if (b.hasBeenHit) { 
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


  //  yVel = (abs(yVel) + .1) * abs(yVel) / yVel;
  //  xVel = (abs(xVel) + .1) * abs(xVel) / xVel;
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

private boolean changeCourseWithHit(Brick brick) {
  if (brick.hasBeenHit) {
    return false;
  }
  // get corner in question
  //PVector corner = brick.origin.copy();
  //if (xVel < 0) {
  //  corner.x = brick.extent().x;
  //}
  //if (yVel < 0) {
  //  corner.y = brick.extent().y;
  //}

  PVector left = new PVector(xPos, yPos + size / 2);
  PVector top = new PVector(xPos + size / 2, yPos);
  PVector right = new PVector(xPos + size, yPos + size / 2);
  PVector bot = new PVector(xPos + size / 2, yPos + size);

  if (xVel > 0 && brick.hit(left)) {
    xVel = -baseSpeed;
    yVel = baseSpeed * abs(yVel) / yVel;
    brick.hasBeenHit = true;
  } else if (brick.hit(right)) {
    xVel = baseSpeed;
    yVel = baseSpeed * abs(yVel) / yVel;
    brick.hasBeenHit = true;
  }

  if (yVel < 0 && brick.hit(bot)) {
    yVel = -baseSpeed;
    xVel = baseSpeed * abs(xVel) / xVel;
    brick.hasBeenHit = true;
  } else if (brick.hit(top)) {
    yVel = baseSpeed;
    xVel = baseSpeed * abs(xVel) / xVel;
    brick.hasBeenHit = true;
  }

  //PVector cornerToPos = PVector.sub(pos, corner);
  //float cornerSlope = cornerToPos.y / cornerToPos.x;
  //float velSlope = yVel / xVel;
  //if (abs(cornerSlope) > abs(velSlope)) {
  //  xVel *= -1;
  //  xVel += random(-.2, .2);
  //} else {
  //  yVel *= -1;
  //}
  // get slope corner to pos
  // slope gr than vel slope? : horizontal hit else: vertical
  return brick.hasBeenHit;
}

private void lose() {
  print("they lost");
  started = false;
}

private void playAgain() {
  if (started) return;
  print("starting");
  started = true;
  xPos = width / 2;
  yPos = height / 2;
  xVel = 4;
  yVel = 4;
}

void keyPressed() {
  if (key == 'p') {
    playAgain();
  }
}

private void circle(float x, float y) {
  ellipse(x, y, 12, 12);
}