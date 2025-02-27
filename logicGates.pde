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
    //print("Selected: " + selectedID + " ");
    //println(selectedID.size());
    //println("Existing: " + grid.gates.size());
    //println("Next ID: " + grid.lastID);
    
    for (int gate = 0; gate < grid.gates.size(); gate++) {
      //println(grid.gates.get(gate).ID + ": " + grid.gates.get(gate).Inputs);
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

void saveGrid(String path) {
  Table saveFile = new Table();
  String saveArray = "";
  
  saveFile.addColumn("id");
  saveFile.addColumn("type");
  saveFile.addColumn("inputs");
  saveFile.addColumn("output");
  saveFile.addColumn("posX");
  saveFile.addColumn("posY");
  saveFile.addColumn("toggled");
  
  for (int gateID = 0; gateID < grid.gates.size(); gateID++) {
    saveFile.addRow();
    saveFile.getRow(gateID).setInt("id", grid.gates.get(gateID).ID);
    saveFile.getRow(gateID).setString("type", grid.gates.get(gateID).Type);
    
    if (grid.gates.get(gateID).Inputs.size() > 0) {
      for (int i = 0; i < grid.gates.get(gateID).Inputs.size(); i++) {
        if (saveArray == "") {
          saveArray = str(grid.gates.get(gateID).Inputs.get(i)); 
        }
        
        else {
          saveArray = saveArray + ":" + str(grid.gates.get(gateID).Inputs.get(i));
        }
      }
    }
    
    else {
      saveArray = "empty";
    }
    
    saveFile.getRow(gateID).setString("inputs", saveArray);
    saveArray = "";
    saveFile.getRow(gateID).setString("output", str(grid.gates.get(gateID).Output));
    saveFile.getRow(gateID).setFloat("posX", grid.gates.get(gateID).posX);
    saveFile.getRow(gateID).setFloat("posY", grid.gates.get(gateID).posY);
    saveFile.getRow(gateID).setString("toggled", str(grid.gates.get(gateID).toggled));
  }
  
  saveTable(saveFile, path);
}

void loadGrid(String path) {
  Table loadSave = loadTable(path);
  
  grid.gates.clear();
  for (int rowNumb = 1; rowNumb < loadSave.getRowCount(); rowNumb++) {
    int newID = loadSave.getRow(rowNumb).getInt(0);
    String newType = loadSave.getRow(rowNumb).getString(1);
    
    ArrayList<Integer> newInputs = new ArrayList<Integer>();
    if (!loadSave.getRow(rowNumb).getString(2).equals("empty")) {
      println(loadSave.getRow(rowNumb).getString(2));
      String[] newRawInputs = split(loadSave.getRow(rowNumb).getString(2), ':');
      for (int i = 0; i < newRawInputs.length; i++) {
        newInputs.add(int(newRawInputs[i]));
      }
    }
    
    else {
      newInputs.clear();
    }
    
    String newOutput = loadSave.getRow(rowNumb).getString(3);
    int newPosX = loadSave.getRow(rowNumb).getInt(4);
    int newPosY = loadSave.getRow(rowNumb).getInt(5);
    String newToggled = loadSave.getRow(rowNumb).getString(6);
    
    grid.createNewGate(newID, newType, newInputs, newOutput, newPosX, newPosY, newToggled);
    
  }
}
