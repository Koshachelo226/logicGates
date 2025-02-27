circuitGrid grid = new circuitGrid();
PFont mainFont;

int currentTool = 0;
float Scale = 5;
ArrayList<Integer> selectedID = new ArrayList<Integer>();
float prevMouseX;
float prevMouseY;
int prevXmouse;
int prevYmouse;

String[] toolsEN = {"Selection", "AND", "OR", "NOT", "OUT"};

void setup() {
  mainFont = loadFont("Arial-Black-36.vlw");
  size(700, 700);
}

void draw() {
  background(50);
  
  for (int gate = 0; gate < grid.gates.size(); gate++) {
    grid.gates.get(gate).drawGate(Scale);
    grid.gates.get(gate).drawConnections();
    grid.gates.get(gate).calcGate();
  }
  
  if (grid.gates.size() > 0) {
    print("Selected: " + selectedID + " ");
    println(selectedID.size());
    println("Existing: " + grid.gates.size());
    println("Next ID: " + grid.lastID);
    
    for (int gate = 0; gate < grid.gates.size(); gate++) {
      println(grid.gates.get(gate).ID + ": " + grid.gates.get(gate).Inputs);
    }
  }
  
  if (!mousePressed) {
    prevXmouse = mouseX;
    prevYmouse = mouseY;
  }  
  else if (mousePressed && currentTool == 0) {
    float x;
    float y;
    stroke(0, 100, 0, 200);
    fill(0, 100, 0, 120);
    box(prevXmouse, prevYmouse, mouseX, mouseY);
      
    for (int id = 0; id < grid.gates.size(); id++) {
      x = grid.gates.get(id).posX;
      y = grid.gates.get(id).posY;
      if (x < prevXmouse && x > mouseX && y < prevYmouse && y > mouseY && !grid.gates.get(id).selected) {
        grid.gates.get(id).selected = true;
        selectedID.add(grid.gates.get(id).ID);
      }
      if (x < prevXmouse && x > mouseX && y > prevYmouse && y < mouseY && !grid.gates.get(id).selected) {
        grid.gates.get(id).selected = true;
        selectedID.add(grid.gates.get(id).ID);
      }
      if (x > prevXmouse && x < mouseX && y < prevYmouse && y > mouseY && !grid.gates.get(id).selected) {
        grid.gates.get(id).selected = true;
        selectedID.add(grid.gates.get(id).ID);
      }
      if (x > prevXmouse && x < mouseX && y > prevYmouse && y < mouseY && !grid.gates.get(id).selected) {
        grid.gates.get(id).selected = true;
        selectedID.add(grid.gates.get(id).ID);
      }
    }
  }
  
  fill(255);
  textFont(mainFont, 24);
  text(toolsEN[currentTool], 5, 20);

}

void box(float x1, float y1, float x2, float y2) {
  quad(x1, y1, x2, y1, x2, y2, x1, y2);
}
