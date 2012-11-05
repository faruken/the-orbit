/*

The solar system where all the magic happens. Basically, we fill the solar
system with bunch of planets. The number of planets equals to the level player
is currently playing.

*/

class SolarSystem extends Universe {
  private ArrayList<Planet> planets;
  private int level;
  
  /*
    Initialize a planets list and the level. ArrayList is more efficient than
    plain arrays. We don't have to recreate the array from scratch. We just
    simply append a new planet. However, since we reset the solar system,
    actually, our current implementation mimics plain arrays.
  */
  SolarSystem(int level) {
    this.planets = new ArrayList<Planet>();
    this.level = level;
  }
  
  int setLevel(int level) {
    this.level = level;
  }
  
  /*
    Initializes a new planet and adds to the current planets list. X, Y, mass
    and radius are all set to random values.
  */
  Planet addPlanet(float p_x, float p_y, float p_m, float p_r, float p_rr) {
    Planet p = new Planet(p_x, p_y, p_m, p_r, p_rr);
    planets.add(p);
    return p;
  }
  
  /*
    Return all the planets.
  */
  ArrayList<Planet> getPlanets() {
    return this.planets;
  }
  
  /*
    Get the coordinates of all planets in the level that player is currently
    playing. The second loop is unnecesary for now. I'm planning to do some
    more.
  */
  int[] getPlanetCoord() {
    int[][] a = new int[level][1];
    for(int i = 0; i < level; i++) {
      Planet p = planets.get(i);
      a[i][0] = int(p.getX());
      a[i][1] = int(p.getY());
      a[i][2] = int(p.getRadius());
      a[i][3] = int(p.getMass());
    }
    return a;
  }
  
  /*
    Before beginning to a new level, first we reset the entire solar system.
  */
  void resetSystem() {
    for(int i = 0; i < level; i++) planets.remove(i);
  }
  
  /*
    Load planets to specific coordinates.
  */
  void loadPlanets(int newlevel, int[][] coordinates) {
    for(int i = 0; i < newlevel; i++) {
      int p_rr = newlevel;
      addPlanet(coordinates[i][0], coordinates[i][1], coordinates[i][3],
        coordinates[i][2], p_rr);
    }
  }
  
  /*
    Add new planets to the current level player plays.
  */
  void fillPlanets(int newLevel) {
    for(int i = 0; i < newLevel; i++) {
      float p_x = random(8, width);
      float p_y = random(8, height);
      float p_m = random(16, 64) * 1000;
      float p_r = random(16, 64);
      // int p_rr = round(random(0, 2)*1);
      int p_rr = level;
      addPlanet(p_x, p_y, p_m, p_r, p_rr);
    }
  }
  
  /*
    Draw the solar system!
  */
  void draw() {
    // Basically planet.size() and level are the same.
    for(int i = 0; i < level; i++) {
      Planet p = planets.get(i);
      p.draw();
    }
  }
}
