/*

Constant variables to be used throughout the game.

*/

final int START_LEVEL = 1;
final int MAXLIVES = 4;
final int MAXLEVEL = 8;
final int FRAME_COUNT = 32;
// final int GAME_X = $(window).width();
// final int GAME_Y = $(window).height();
final int GAME_X = $("#game").width();
final int GAME_Y = $("#game").height();
final int CENTER_X = GAME_X >> 1;
final int CENTER_Y = GAME_Y >> 1;
final float ORBIT_MASS = 16.0;
final float ORBIT_RADIUS = 4.0;
final float G = 6.693; // http://en.wikipedia.org/wiki/Gravitational_constant
final float R = 9.8 * 10;
final int FUTURE = 30;

final String URL = "https://127.0.0.1:5984";
