/*

  Draws the orbit and applies its physical rules.

*/

class Orbit extends Universe {
  private float x, y, mass, r;
  private float xVel, yVel;
  private float bdifx, bdify;
  private boolean locked, gameOver;
  
  /*
    Initialize orbit values.
  */
  Orbit(float x, float y, float mass, float r) {
    this.x = x;
    this.y = y;
    this.xVel = 0.0;
    this.yVel = 0.0;
    this.mass = mass;
    this.r = r;
    this.bdifx = 0.0;
    this.bdify = 0.0;
    this.locked = false;
    this.gameOver = false;
  }
  
  float getX() {
    return this.x;
  }
  
  float getY() {
    return this.y;
  }
  
  void setGameOver(boolean val) {
    this.gameOver = val;
  }
  
  void setLocked(boolean val) {
    this.locked = val;
  }
  
  boolean isGameOver() {
    return this.gameOver;
  }
  
  boolean getLocked() {
    return this.locked;
  }
  
  /*
    If life reduces or a new level starts then we reset orbit's current values.
  */
  void resetOrbit() {
    this.x = 0.0;
    this.y = 0.0;
    this.bdifx = 0.0;
    this.bdify = 0.0;
    this.xVel = 0.0;
    this.yVel = 0.0;
    this.locked = false;
    this.gameOver = false;
  }
  
  /*
    Draw the orbit!
  */
  void draw() {
    fill(255, 255, 100);
    noStroke();
    translate(x, y, 0);
    sphere(r << 1);
  }
  
  /*
    When mouse is pressed then we calculate the diff between mouse value and
    orbit's x value.
  */
  void mousePressed() {
    bdifx = mouseX - x;
    bdify = mouseY - y;
  }
  
  /*
    When mouse is moved on the universe, we set orbit.x to diff. between
    mouse.x and bdif(x|y) values. If the orbit is locked then mouse movement
    won't effect the orbit.
  */
  void mouseMoved() {
    if(!locked) {
      x = mouseX - bdifx;
      y = mouseY - bdify;
    }
  }
  
  /*
    When mouse button is released we lock the orbit so mouse movements won't
    effect the orbit's movements.
  */
  void mouseReleased() {
    locked = true;
  }
  
  void mouseDragged() {
    if(locked) {
      x = mouseX - bdifx;
      y = mouseY - bdify;
    }
  }
  
  /*
    Check if we hit borders of the screen. We dont' want orbit to go beyond
    the screen size.
  */
  void checkWalls() {
    float diffY = height - r;
    float diffX = width - r;
    //bottom
    if(y > diffY) {
      y = diffY;
      yVel *= -1;
    }
    //right
    if(x > diffX) {
      x = diffX;
      xVel *= -1;
    }
    //left
    if(x < r) {
      x = r;
      xVel *= -1;
    }
    //top
    if(y < r) {
      y = r;
      yVel *= -1;
    }
  }
  
  
  /*
    Move the orbit throughout the solar system. If it becomes near a planet
    then it gets effected by planet's mass.
  */
  void move(SolarSystem system) {
    ArrayList<Planet> planets = system.getPlanets();
    final int length = planets.size();
    
    for(int i = 0; i < length; i++) {
      Planet p =  planets.get(i);
      float dx = p.getX() - x;
      float dy = p.getY() - y;
      float dist = sqrt(sq(dx) + sq(dy));
      float grav = R * (G * this.mass / sq(dist));
      float minDist = (p.getRadius() / 2) + (r / 2);
      if(dist < minDist) {
        // Orbit hits to planet :(
        // Now it just an orbit that I used to know...
        gameOver = true;
        break;
      }
      xVel += dx / dist * grav;
      yVel += dy / dist * grav;
      x += xVel;
      y += yVel;
    }
  }
}
