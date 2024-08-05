circuitGrid grid = new circuitGrid();

int currentTool = 0;
float Scale = 5;
ArrayList<Integer> selectedID = new ArrayList<Integer>();
float prevMouseX;
float prevMouseY;

void setup() {
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
    //println(grid.gates.get(0).moving);
    //grid.gates.get(0).posX = mouseX;
    //grid.gates.get(0).posY = mouseY;
  }
}
