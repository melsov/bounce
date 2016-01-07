public class Paddle {
 PVector origin;
 PVector size;
 color c;
 public float speed = 10;

 public Paddle(PVector _origin, PVector _size) {
 	c = color(0, 122, 111);
 	origin = _origin;
	size = _size;
 }

 public void drawMe() {
 	fill(c);
 	rect(origin.x, origin.y, size.x, size.y);
 }

 public void slide(int leftRight) {
 	origin.x += speed * leftRight;
	origin.x = min(origin.x, width - size.x);
	origin.x = max(origin.x, 0.0);

 }

 public boolean hit(float x, float y) {
 	return x > origin.x && x < origin.x + size.x && y > origin.y && y < origin.y + size.y;
 }
}