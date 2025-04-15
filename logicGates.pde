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

circuitGrid tempGrid = new circuitGrid();
ArrayList<Integer> copiedNewIDs = new ArrayList<Integer>();
ArrayList<Integer> copiedOldIDs = new ArrayList<Integer>();

String[] toolsEN = {"Selection", "AND", "OR", "NOT", "OUT", "XOR"};
String[] tipsGates = {"0 - Selection tool", "1 - AND gate", "2 - OR gate", "3 - NOT gate", "4 - OUT gate", "5 - XOR gate"};
String[] tipsKeys = {"MMB/Ctrl+D - Move grid", "S/L - Save/load grid", "+/- - Change scale", "Ctrl+I - clear inputs", "Delete - Remove gates", "M - Move gates", "D - Deselect gates", "T - Toggle gate", "I - Connect gates"};

boolean drawGrid = true;

void setup() {
  background = loadImage("background.png");
  cp5 = new ControlP5(this);
  
  size(700, 700);
  surface.setResizable(true);
  //fullScreen();
  mainFont = loadFont("Arial-Black-36.vlw");
  frameRate(3000);
  
  cp5.addTextfield("SaveName")
     .setPosition((width/2)-100,height/2)
     .setSize(200,40)
     .setFont(mainFont)
     .setFocus(true)
     .setColor(color(255))
     .setText("Test")
     .setVisible(false);
     ;
  cp5.addButton("Save")
    .setValue(0)
    .setPosition((width/2)+110, height/2)
    .setSize(40, 40)
    .setVisible(false)
    ;
  cp5.addButton("Load")
    .setValue(0)
    .setPosition((width/2)+110, height/2)
    .setSize(40, 40)
    .setVisible(false)
    ;
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
  cp5.addButton("SaveUI")
    .setLabel("Save")
    .setValue(0)
    .setPosition(width-115, 5)
    .setSize(50, 50);
  cp5.addButton("LoadUI")
    .setLabel("Load")
    .setValue(0)
    .setPosition(width-60, 5)
    .setSize(50, 50);
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
  
  cp5.draw();
  
  for (int gate = 0; gate < grid.gates.size(); gate++) {
    
    if (middleMousePressed) {
      grid.gates.get(gate).posX += mouseX - pmouseX;
      grid.gates.get(gate).posY += mouseY - pmouseY;
    }
    
    grid.gates.get(gate).drawGate(Scale);
    grid.gates.get(gate).drawConnections();
    
    grid.gates.get(gate).calcGate();
  }
  
  for (int gate = 0; gate < tempGrid.gates.size(); gate++) {
    //println(tempGrid.gates.get(gate).ID);
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
  drawTips();
}

boolean isIntArray(ArrayList<Integer> array, int number) {
  boolean output = false;
  if (array.size() > 0) {
    for (int i = 0; i < array.size(); i++) {
      output = (number == array.get(i));
      if (output) {break;}
    }
  }
  return output;
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
  selectedID.clear();
  for (int rowNumb = 1; rowNumb < loadSave.getRowCount(); rowNumb++) {
    int newID = loadSave.getRow(rowNumb).getInt(0);
    String newType = loadSave.getRow(rowNumb).getString(1);
    
    ArrayList<Integer> newInputs = new ArrayList<Integer>();
    if (!loadSave.getRow(rowNumb).getString(2).equals("empty")) {
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

void drawTips() {
  textFont(mainFont, 12);
  for (int y = 0; y < tipsGates.length; y++) {
    text(tipsGates[y], width-120, height - (5 + 10*y));
  }
  
  for (int y = 0; y < tipsKeys.length; y++) {
    text(tipsKeys[y], 5, height - (5 + 10*y));
  }
}

void copyGates() {
  //ArrayList<circuitGrid.gate> copyGates = new ArrayList<circuitGrid.gate>();
  tempGrid.gates.clear();
  
  if (selectedID.size() > 0) {
    
    for (int ID = 0; ID < selectedID.size(); ID++) {
      copiedOldIDs.add(selectedID.get(ID));
      copiedNewIDs.add(grid.lastID);
      grid.lastID++;
    } 
    
    
    
    for (int ID = 0; ID < selectedID.size(); ID++) {
      //copyGates.add(grid.gates.get(selectedID.get(ID)));
      //circuitGrid.gate newGate = tempGrid.new gate();
      int newID = selectedID.get(ID);
      String newType = grid.gates.get(selectedID.get(ID)).Type;
      ArrayList<Integer> newInputs = grid.gates.get(selectedID.get(ID)).Inputs;
      String newOutput = str(grid.gates.get(selectedID.get(ID)).Output);
      float newPosX = grid.gates.get(selectedID.get(ID)).posX;
      float newPosY = grid.gates.get(selectedID.get(ID)).posY;
      String newToggled = str(grid.gates.get(selectedID.get(ID)).toggled);
      tempGrid.createNewGate(newID, newType, newInputs, newOutput, newPosX, newPosY, newToggled);
    }
  }
}

void pasteGates() {
  ArrayList<circuitGrid.gate> newGates = new ArrayList<circuitGrid.gate>();
  for (int gate = 0; gate < tempGrid.gates.size(); gate++) {
    circuitGrid newGrid = new circuitGrid();
    circuitGrid.gate newGate = newGrid.new gate();
    
    newGate.ID = tempGrid.gates.get(gate).ID;
    newGate.Type = tempGrid.gates.get(gate).Type;
    newGate.Inputs = tempGrid.gates.get(gate).Inputs;
    newGate.Output = tempGrid.gates.get(gate).Output;
    newGate.posX = tempGrid.gates.get(gate).posX;
    newGate.posY = tempGrid.gates.get(gate).posY;
    newGate.toggled = tempGrid.gates.get(gate).toggled;
    
    newGates.add(tempGrid.gates.get(gate) /*newGate*/);
  }
  
  for (int gate = 0; gate < newGates.size(); gate++) {
    for (int input = 0; input < newGates.get(gate).Inputs.size(); input++) {
      //copyGates.get(gate).ID = newIDs.get(gate);
    
      if (isIntArray(selectedID, input)) {
        println("Changed");
        for (int oldID = 0; oldID < newGates.size(); oldID++) {
          if (newGates.get(gate).Inputs.get(input) == copiedOldIDs.get(gate)) {
            newGates.get(gate).Inputs.set(input, copiedNewIDs.get(gate));
          }
        }
      }
    }
      
    newGates.get(gate).ID = copiedNewIDs.get(gate);
      
    //newGates.get(gate).posX += mouseX/4;
    //newGates.get(gate).posY += mouseY/4;
  }
   for (int id = selectedID.size()-1; id >= 0; id--) {
    grid.gates.get(selectedID.get(id)).selected = false;
    selectedID.remove(id);
   } 
  for (int gate = 0; gate < newGates.size(); gate++) {
    newGates.get(gate).selected = true;
    selectedID.add(newGates.get(gate).ID);
    
    int newID = newGates.get(gate).ID;
    String newType = newGates.get(gate).Type; println(newGates.get(gate).Inputs);
    ArrayList<Integer> newInputs = newGates.get(gate).Inputs; println(newInputs);
    String newOutput = str(newGates.get(gate).Output);
    float newPosX = newGates.get(gate).posX;
    float newPosY = newGates.get(gate).posY;
    String newToggled = str(newGates.get(gate).toggled);
    //grid.createNewGate(newID, newType, newInputs, newOutput, newPosX, newPosY, newToggled);
    //grid.gates.get(grid.gates.size()-1).selected = true;
    grid.gates.add(newGates.get(gate));
  }
}
