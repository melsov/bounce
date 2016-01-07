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
/*
void setup() gets called once when the program starts
 set the size of the window to width 600 height 800
 set xPos to width / 2 
 set yPos to height / 2
 set xVel to 12
 set yVel to 12
 */
void setup() {
  paddle = new Paddle(new PVector(width / 2, height - 30), new PVector(150, 10));
  size(600, 800);
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
  ellipse(xPos, yPos, 12, 12);
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
    lose();
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
  xVel = 12;
  yVel = 12;
}

void keyPressed() {
  if (key == 'p') {
    playAgain();
  }
}

private void circle(float x, float y) {
  ellipse(x, y, 12, 12);
}