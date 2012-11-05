/*

  The game itself.

*/
class Game {
  private Player player;
  private Orbit orbit;
  private SolarSystem system;
  private int level;
  private int life;
  private boolean gameOver;
  private int startTime;
  private int futureTime;
  private int startLevelTime;
  private int endLevelTime;
  private String uuid;
  
  /*
    Initializes game variables.
  */
  Game(Player player, Orbit orbit, SolarSystem system, int level, int life) {
    this.player = player;
    this.orbit = orbit;
    this.system = system;
    this.level = level;
    // this.life = MAXLIVES - 1;
    this.life = life;
    this.gameOver = false;
    this.startLevelTime = millis();
    this.startTime = millis();
    this.endLevelTime = startLevelTime + FUTURE * 10;
    this.futureTime = startTime + FUTURE;
    this.uuid = this.setUUID();
  }
  
  /*
    If orbit hits to a planet then the game is over.
  */
  boolean isGameOver() {
    return orbit.isGameOver();
  }
  
  int getLevel() {
    return this.level;
  }
  
  /*
    Game session is basically UUID4. As far as I know, Javascript/Processing.js
    doesn't have a built-in UUID library. Game session is used to identify each
    unique plays of a player.
  */
  private String setUUID() {
    String[] list = new String[36];
    final String DIGITS = "0123456789abcdef";
    for(int i = 0; i < 36; i++) {
      list[i] = DIGITS.substr(floor(random() * 0x10), 1);
    }
    list[14] = "4";
    list[8] = list[13] = list[18] = list[23] = "-";
    list[19] = DIGITS.substr((list[19] & 0x03) | 0x08, 1);
    return join(list, "");
  }
  
  /*
    When player releases the mouse, then we start counting the millis time,
    if this starter time equals to endLevelTime, then it means the time is up
    and player is eligible enough to continue to next level.
  */
  boolean isLevelUp() {
    return startLevelTime == endLevelTime;
  }
  
  /*
    If player reaches to `MAXLEVEL`, then they win the game.
  */
  boolean isWon() {
    return level == MAXLEVEL;
  }
    
  /*
    Here we display either game over or the number of lives left message for a
    couple of seconds.
  */
  void displayGameOverMSG() {
    textAlign(CENTER);
    textMode(SCREEN);
    textFont(font, 42);
    int temp = life;
    if(temp < 1) {
      text("Game Over!", CENTER_X, CENTER_Y, 0);
      this.gameOver = true;
    } else if(temp == 1) {
      text("You have 1 life left",  CENTER_X, CENTER_Y, 0);
    } else {
      text("You have " + temp + " lives left", CENTER_X, CENTER_Y, 0); 
    }
  }
  
  /*
    Here we display the level up message and the next level so if player is
    going to play level 4 then we say `Level up! 4`.
  */
  void displayLevelUPMSG(String s, int fontSize) {
    textAlign(CENTER);
    textMode(SCREEN);
    textFont(font, fontSize);
    text(s, CENTER_X, CENTER_Y, 0);
  }
  
  /*
    If player reaches to `MAXLEVEL` then we display the win message.
  */
  void displayWonMSG() {
    background(0);
    fill(255, 255, 255);
    // image(gp, 0, 0);
    textAlign(CENTER);
    textMode(SCREEN);
    textFont(font, 64);
    text("You have won", GAME_X / 1.4, CENTER_Y, 0);
    fill(102, 102, 102);
  }
  
  /*
    Displays the game itself by rendering planets, solar system and the orbit.
    Once player releases the mouse then we lock the orbit and start moving the
    orbit and checking if it ever hits to walls.
  */
  void displayGame() {
    image(background_img, 0, 0);
    system.draw();
    orbit.draw();
    if(orbit.getLocked()) {
      orbit.checkWalls();
      orbit.move(system);
    }
  }
    
  /*
    Whenever player goes one level up, we save the level.
  */
  boolean doSaveGame(int levelTime) {
    boolean flag = false;
    String username = encodeURIComponent(player.getUsername());
    String country = encodeURIComponent(player.getCountry());
    if(username == "null" || username === undefined || username === null) {
      return false;
    } else {
      int playerLevel = this.level;
      int playerScore = round(log(playerLevel * levelTime));
      $.ajax({
        type: 'POST',
        url: 'http://127.0.0.1:5984/gwyneth/',
        data: JSON.stringify({
          'username': username, 'country': country, 'level': playerLevel,
          'score': playerScore, 'created': new Date().valueOf(),
          'life': this.life,
          'orbit_coord': '[' + orbit.getX() + ', ' +orbit.getY() + ']',
          'planet_coord': system.getPlanetCoord(),
          'game_session': uuid}
        ),
        dataType: 'json',
        processData:'json',
        async: true,
        contentType: 'application/json',
        success: function(data) {
          return data.ok; // won't do anything for obvious reasons.
        }
      });
      return flag;
    }
  }
  
  /*
    Displays the game over image to the user. First `displayGameOverMSG` is
    displayed, then if the game is over (instead of life is reduced).
  */
  void displayGameOver() {
    fill(255, 255, 255);
    st.resize(GAME_X, GAME_Y);
    // image(st, 0, 0);
    noLoop();
  }
  
  /*
    In order to display `displayGameOverMSG` and `displayLevelUPMSG` nicely
    for the next time we need to reset the timer.
  */
  void resetTime() {
    startTime = millis();
    futureTime = startTime + FUTURE;
  }
  
  /*
    Once user starts to play the next level, we reset the level time. Otherwise
    it won't work properly.
  */
  void resetGameTime() {
    startLevelTime = millis();
    endLevelTime = startLevelTime + FUTURE * 10;
  }
  
  /*
    Game over logic. We start counting the `startTime` until it reaches to
    `futureTime`. When they match, then we reset everything and reduce the life
    of the player.
  */
  void doGameOver() {
    background(0);
    displayGameOverMSG();
    startTime++;
    if(startTime == futureTime) {
      resetTime();
      resetGameTime();
      orbit.resetOrbit();
      life -= 1;
      if(life < 0) displayGameOver();
    }
  }
  
  /*
    Level up logic. This is very similar to `doGameOver`. Once the level is
    over, we reset everything.
  */
  void doLevelUp() {
    int tempStartTime = startTime;
    background(0);
    level++;
    displayLevelUPMSG("Level Up! " + level, 42);
    startTime++;
    if(startTime == futureTime) {
      resetTime();
    }
    // Reset the entire game whenever a new level starts.
    orbit.resetOrbit();
    system.resetSystem();
    system.setLevel(level);
    system.fillPlanets(level);
    resetGameTime();
    doSaveGame(tempStartTime);  // Game is automatically saved on level up.
  }
  
  /*
    Draw the game.
  */
  void draw() {
    if(orbit.getLocked()) startLevelTime++;
    if(isGameOver()) doGameOver();
    else if(isWon()) displayWonMSG();
    else if(isLevelUp()) doLevelUp();
    else displayGame();
  }
}
