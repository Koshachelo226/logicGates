import controlP5.*;
ControlP5 cp5;

circuitGrid grid = new circuitGrid();
PFont mainFont;
PImage background;

int currentTool = 0;
float Scale = 5;
ArrayList<Integer> selectedID = new ArrayList<Integer>();
float prevMouseX;
float prevMouseY;
int prevXmouse;
int prevYmouse;

String[] toolsEN = {"Selection", "AND", "OR", "NOT", "OUT", "XOR"};

boolean drawGrid = true;

void setup() {
  background = loadImage("background.png");
  cp5 = new ControlP5(this);
  
  size(700, 700);
  surface.setResizable(true);
  //fullScreen();
  mainFont = loadFont("Arial-Black-36.vlw");
  frameRate(3000);
  
  cp5.addButton("AND")
     .setValue(0)
     .setPosition(65, 5)
     .setSize(50,50)
     ;
  cp5.addButton("OR")
     .setValue(0)
     .setPosition(120, 5)
     .setSize(50,50)
     ;
  cp5.addButton("NOT")
     .setValue(0)
     .setPosition(175, 5)
     .setSize(50,50)
     ;
  cp5.addButton("XOR")
     .setValue(0)
     .setPosition(230, 5)
     .setSize(50,50)
     ;
  cp5.addButton("OUT")
     .setValue(0)
     .setPosition(285, 5)
     .setSize(50,50)
     ;
  cp5.addButton("Select")
     .setValue(0)
     .setPosition(10, 5)
     .setSize(50,50)
     ;
}

void draw() {
  if (!drawGrid) {
    background(50);
  }
  
  else {
    for (int imgX = 0; imgX <= width; imgX+= 100) {
      for (int imgY = 0; imgY <= height; imgY += 99) {
        image(background, imgX, imgY);
      }
    }
  }
  
  /*for (int lineX = width; lineX >= 0; lineX -= 30) {
    line (lineX, 0, lineX, height);
  }*/
  
  /*for (int lineY = 30; lineY <= height; lineY += 30) {
    line (0, lineY, width, lineY);
  }*/
  
  for (int gate = 0; gate < grid.gates.size(); gate++) {
    
    if (middleMousePressed) {
      grid.gates.get(gate).posX += mouseX - pmouseX;
      grid.gates.get(gate).posY += mouseY - pmouseY;
    }
    
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
  else if (mousePressed && currentTool == 0  && mouseButton == LEFT) {
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
  text(toolsEN[currentTool], (width/2)-30, height - 20);
  textFont(mainFont, 12);
  text("5 - XOR gate", width - 120, height - 5);
  text("4 - OUT gate", width - 120, height - 15);
  text("3 - NOT gate", width - 120, height - 25);
  text("2 - OR gate", width - 120, height - 35);
  text("1 - AND gate", width - 120, height - 45);
  text("0 - Selection tool", width - 120, height - 55);
  
  text("MMB - Move grid", 5, height - 5);
  text("S/L - Save/load grid", 5, height - 15);
  text("+/- - Change scale", 5, height - 25);
  text("Delete - Remove gates", 5, height - 35);
  text("M - Move gates", 5, height - 45);
  text("D - Deselect gates", 5, height - 55);
  text("T - Toggle gate", 5, height - 65);
  text("I - Connect gates", 5, height - 75);

  //println(frameRate);
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
