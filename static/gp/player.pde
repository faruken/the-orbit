/*

  Player class to store the player details when we get them from database.

*/
class Player {
  private int uid, level, score;
  private String username, country;
  
  Player(int uid, int level, String username, String country, int score) {
    this.uid = uid;
    this.level = level;
    this.username = username;
    this.country = country;
    this.score = score;
  }
    
  String getUsername() {
    return this.username;
  }
  
  String getCountry() {
    return this.country;
  }
  
  void setScore(int score) {
    this.score = score;
  }
  
  String getScore() {
    return this.score;
  }
  
  void setLevel(int level) {
    this.level = level;
  }
  
  String getLevel() {
    return this.level;
  }
}
