/*
  Draws fancy 3D planets to the solar system.
*/

class Planet extends Universe {
  private float x, y, mass, r, rr;

  /*
    These are all random parameters.
  */
  Planet(float x, float y, float mass, float r, int rr) {
    this.x = x;
    this.y = y;
    this.mass = mass;
    this.r = r;
    this.rr = rr;
  }
  
  float getRadius() {
    return this.r;
  }
  
  float getX() {
    return this.x;
  }
  
  float getY() {
    return this.y;
  }
  
  float getMass() {
    return this.mass;
  }
  
  void draw() {
    fill(255);
    /*
      If we don't stroke, then planets don't look like they're rotating.
      so, we draw borders. Actually this can be fixed by playing with lights
      though but debugging processing.js is just too painful :(
    */
    
    stroke(0);
    
    /*
      If we don't pushMatrix/popMatrix then planets rotate throughout the
      entire solar system.
    */
    pushMatrix();
    translate(x, y, r);
    /*
      Normally, the light reflects from -x. However, when x is very near to
      GAME_X, then planet looks too dark therefore we set it to 1. In that case
      planet looks shiny.
    */
    int t_x = -1;
    int res = abs(GAME_X - x);
    if(res < 200) t_x = 1;
    
    int c_r = 50;
    int c_g = 100;
    int c_b = 150;
    if(rr == 3) {
      c_r = random(0, 100);
      c_g = random(100,200);
      c_b = random(200, 255);
    }
    // Lights! - I feel like Alfred Hitchcock.
    directionalLight(c_r, c_g, c_b, t_x, 0, 0);
    rotateY(frameCount / FRAME_COUNT); // orbit the planet around itself.
    sphere(r); // draw the planet.
    popMatrix();
  }
}
