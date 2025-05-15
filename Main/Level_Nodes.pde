class LevelNode {
  PVector pos; // Location of each node
  ArrayList<LevelNode> children; //Used to connect nodes to eachother
  String state; //State tha all nodes can have = "locked", "unlocked", "cleared"
  float radius = 20; //Radius/ size of each node cirlce

  color currentColor; // Used for smooth transitioning of color based on (target color)
  color targetColor; //Color based on state of the node
  
  //Creates new levelnodes based on an x position, y position, and a initial state
  LevelNode(float x, float y, String state) {
    this.pos = new PVector(x, y);
    this.state = state;
    children = new ArrayList<LevelNode>();
    currentColor = getColorForState(state); // Sets the intial color based on the nodes state
    targetColor = currentColor;
  }
  // Adds a connection to a different level node with the use of a child
  void addChild(LevelNode child) {
    children.add(child);
  }
  //Determines the color of node based on the node's current state
  color getColorForState(String s) {
    if (s.equals("Spawn")) return color(0, 255, 0);// Green for the Spawn Node of the Map Screen
    if (s.equals("Locked")) return color(0, 0, 0); // Black for locked
    if (s.equals("Unlocked")) return color(255, 0, 0); // Red for unlocked/New
    if (s.equals("Completed")) return color(0, 200, 255);// Blue for cleared/Done
    return color(0); // will default to color (Black) for unknown states
  }
  //Transition the nodes current color towards it target color smoothly
  void updateColor() {
    currentColor = lerpColor(currentColor, targetColor, 0.1);
  }
  //Draw both the node and its state label 
  void display() {
    updateColor();
    fill(currentColor); // Draw out the Node for the Level(Circle)
    noStroke();
    ellipse(pos.x, pos.y, radius * 2, radius * 2);

    pushStyle(); // Saves text before pressing map button
    //Draws the text above each node while being cnetered
    fill(0);
    textAlign(CENTER, CENTER);
    text(state, pos.x, pos.y - radius - 10);
    //Restores the saved text from before pressing the map button to avoid text conflicts with other UI elements
    popStyle();
  }
  //Checks if a node was clicked
  void checkClick() {
    if (isMouseOver()) {
      //If a Level has the state of "Unlocked" and is clicked on, it checks and loads a level based on its index number.  
      //EX. (If Level one has the "Unlocked" state and the index number equals 1 then it loads level one only)
     if (state.equals("Unlocked")) {
      int index = nodes.indexOf(this);

      
      // Set level flags
      Level1 = Level2 = Level3 = false;
      if (index == 1) Level1 = true;
      else if (index == 2) Level2 = true;
      else if (index == 3) Level3 = true;

      lvlSetup();   
      screen = "game";   // Switch to game screen
      mousePressed = false;
    }

      //Updates target color for transition
      targetColor = getColorForState(state);
    }
  }
  //Checks if the mouse is hovering over a level node
  boolean isMouseOver() {
    return dist(mouseX, mouseY, pos.x, pos.y) < radius;
  }
  //Draw the lines that connect each node
  void drawConnections() {
    stroke(0);
    for (LevelNode child : children) {
      line(pos.x, pos.y, child.pos.x, child.pos.y);
    }
  }
}
