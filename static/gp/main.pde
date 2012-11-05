/*

This file executes everything.

*/

/* @pjs preload="/static/img/space.jpg"; */


SolarSystem system;
Orbit orbit;
Game game;
Player player;
PImage background_img;
PImage st;
PFont font;
PFont font1;

/*
  Setup a new game using OpenGL.
*/
void setup() {
  size(GAME_X, GAME_Y, OPENGL);
  frameRate(FRAME_COUNT);
  noStroke();
  font = loadFont("Audiowide");
  font1 = loadFont("Aldrich");
  background_img = loadImage("static/img/space.jpg");
  // st = requestImage("static/img/st.png");
  // gp = requestImage("static/img/gp.jpg");
  gameSetup();
  smooth();
}

/*
  Then faruken said: let there be light.
*/
void gameSetup() {
  orbitX = 0.0;
  orbitY = 0.0;
  life = MAXLIVES - 1;
  orbit = new Orbit(orbitX, orbitY, ORBIT_MASS, ORBIT_RADIUS);
  system = new SolarSystem(START_LEVEL);
  system.fillPlanets(START_LEVEL);
  player = playerSetup();
  game = new Game(player, orbit, system, START_LEVEL, life);
}

/*
  Planet details are stored in CouchDB as follows:
    Level: [X, Y, Mass, Radius]
    Level: [X, Y, Mass, Radius]
  
  However, when we get these details as JSON, javascript converts them back to
  one-dimensional array since it doesn't support multi-dimensional arrays nor
  arrays of arrays hence we need to convert planet details back to how they're
  stored in CouchDB.
  
  4 has a special meaning and is a fixed value. Each level stores 4 values of
  a planet which are x, y, mass, radius so that's where 4 comes from.
*/
int[][] coordinatesToArray(int start_level, int[] coordinates) {
  int[][] a = new int[start_level][4];
  int k = 0;
  for(int i = 0; i < start_level; i++) {
    for(int j = 0; j < 4; j++) {
      a[i][j] = coordinates[k++];
    }
  }
  return a;
}

/*
  
  If player is logged in then we store score details in database. This is to
  get username, password and country of a player from cookie.

*/
Player playerSetup() {
  String cookie = $.cookie('fa');
  if(cookie != null) {
    String[] vals = split(cookie, '|');
    String username = vals[0];
    String country = vals[1];
    player = new Player(1, 1, username, country, 0);
  } else {
    player = new Player(1, 1, null, null, 0);
  }
  return player;  
}


/*
  Draws the game layout with the orbit, solar system.
*/
void draw() {
  game.draw();
}

// Bind global mouse options to orbit's mouse options.
void mousePressed() {
  orbit.mousePressed();
}

void mouseMoved() {
  orbit.mouseMoved();
}

void mouseReleased() {
  orbit.mouseReleased();
}

void mouseDragged() {
  orbit.mouseDragged();
}

/*
  "If you wish to make an apple pie from scratch, you must first invent the
  universe" - Carl Sagan
*/
interface IUniverse {
  void draw();
}

/*
  All classes extend Universe abstract class. The universe extends so does my
  universe.
*/
abstract class Universe implements IUniverse {
  abstract void draw();
}
