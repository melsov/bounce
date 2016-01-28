
public class Brick 
{
  public PVector origin;
  public PVector size;
  public boolean hasBeenHit;
  private color c;
  
  public Brick(PVector _or, PVector _size) {
    origin = _or; 
    size = _size;
    c = color(random(122, 255), 12, 12);
  }
  
  public void drawMyself() {
    if (hasBeenHit) {
     return; 
    }
    fill(c);
    rect(origin.x, origin.y, size.x, size.y);
  }
  
  public PVector extent() {
    return PVector.add(origin, size);
  }
  
  public boolean hit(PVector point) {
    //if (!hasBeenHit) {
     return origin.x < point.x && origin.y < point.y && point.x < extent().x && point.y < extent().y; 
    //}
   //return false;
  }
  
}