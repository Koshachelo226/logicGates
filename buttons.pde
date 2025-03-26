boolean CtrlPressed = false;
boolean ShiftPressed = false;
boolean middleMousePressed = false;

char[] lettersListRU = {'й','ц','у','к','е','н','г','ш','щ','з','х','ъ','ф','ы','в','а','п','р','о','л','д','ж','э','я','ч','с','м','и','т','ь','б','ю'};
char[] lettersListEN = {'q','w','e','r','t','y','u','i','o','p','[',']','a','s','d','f','g','h','j','k','l',';','\'','z','x','c','v','b','n','m',',','.'};

void keyPressed() {  
  
  char pressedKey = Character.toLowerCase(key);
  
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = true;}
  if (key == CODED && keyCode == SHIFT) {ShiftPressed = true;}
  
  if (pressedKey == '0') {
    currentTool = 0; //Selection tool (click)
  }
  
  if (pressedKey == '1' && !CtrlPressed) {
    currentTool = 1;
  }
  
  if (pressedKey == '2' && !CtrlPressed) {
    currentTool = 2;
  }
  
  if (pressedKey == '3' && !CtrlPressed) {
    currentTool = 3;
  }
  
  if (pressedKey == '4' && !CtrlPressed) {
    currentTool = 4;
  }
  if (pressedKey == '5' && !CtrlPressed) {
    currentTool = 5;
  }
  
  if (pressedKey(key) == 'i' && !CtrlPressed) {
    if (selectedID.size() == 2 && grid.gates.get(selectedID.get(1)).Inputs.size() < 2 && grid.gates.get(selectedID.get(1)).Type == "and") {
      grid.gates.get(selectedID.get(1)).Inputs.add(selectedID.get(0));
    }
    
    if (selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "and" || selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "or" || selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "xor") {
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(0));
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(1));
      println("CONNECTED");
    }
    
    if (selectedID.size() == 2 && grid.gates.get(selectedID.get(1)).Type == "not" || selectedID.size() == 2 && grid.gates.get(selectedID.get(1)).Type == "out") {
      grid.gates.get(selectedID.get(1)).Inputs.add(selectedID.get(0));
      println("CONNECTED");
    }
  }
  
  if (key == 9 && selectedID.size() > 0) {  //Ctrl+I = 9... Stupid Ctrl keys and ASCII...
    println("Cleared");
    for (int gate = 0; gate < selectedID.size(); gate++) {
      grid.gates.get(selectedID.get(gate)).Inputs.clear();
    }
  }
  
  if (pressedKey(key) == 't' && grid.gates.size() > 0) {
    for (int Gate = 0; Gate < grid.gates.size(); Gate++) {
      if (grid.gates.get(Gate).selected == false) {continue;}
      
      grid.gates.get(Gate).Output = !grid.gates.get(Gate).Output;
      grid.gates.get(Gate).toggled = !grid.gates.get(Gate).toggled;
    }
  }
  
  if (pressedKey(key) == 'd' && selectedID.size() > 0) {
    for (int id = selectedID.size()-1; id >= 0; id--) {
      grid.gates.get(selectedID.get(id)).selected = false;
      selectedID.remove(id);
    }
  }
  
  if (pressedKey(key) == 'm' && selectedID.size() > 0) {
    prevMouseX = mouseX;
    prevMouseY = mouseY;
    
    for (int id = 0; id < selectedID.size(); id++) {
      grid.gates.get(selectedID.get(id)).moving = !grid.gates.get(selectedID.get(id)).moving;
      
      grid.gates.get(selectedID.get(id)).prevPosX = grid.gates.get(selectedID.get(id)).posX;
      grid.gates.get(selectedID.get(id)).prevPosY = grid.gates.get(selectedID.get(id)).posY;
    }
  }
  
  if (key == DELETE && selectedID.size() > 0) {
    ArrayList<circuitGrid.gate> tempGates = new ArrayList<circuitGrid.gate>();
    
    for (int gate = 0; gate < grid.gates.size(); gate++) {
      if (grid.gates.get(gate).Inputs.size() > 0) {
        for (int input = grid.gates.get(gate).Inputs.size()-1; input >= 0; input--) {
          if (grid.gates.get(grid.gates.get(gate).Inputs.get(input)).selected) {
            grid.gates.get(gate).Inputs.remove(input);
          }
        }
      }
    }
    
    for (int nextGate = 0; nextGate < grid.gates.size(); nextGate++) {
      if (!grid.gates.get(nextGate).selected) {
        tempGates.add(grid.gates.get(nextGate));
      }  else {
        continue;
      }
    }

    grid.gates.clear();
    
    for (int gateAdd = 0; gateAdd < tempGates.size(); gateAdd++) {
      grid.gates.add(tempGates.get(gateAdd));
    }

    for (int id = grid.gates.size()-1; id >= 0; id--) {
      grid.gates.get(id).ID = id;
    }

    grid.lastID = grid.gates.size();
    selectedID.clear();
  }
  
  if (key == '-' && Scale > 1) {
    Scale--;
  }
  
  if (key == '+' && Scale < 10) {
    Scale++;
  }
  
  if (pressedKey(key) == 's' && grid.gates.size() > 0) {
    saveGrid("save/grid.csv");
  }
  
  if (pressedKey(key) == 'l') {
    grid.gates.clear();
    selectedID.clear();
    loadGrid("save/grid.csv");
  }
  
  
  if (key == '1' && CtrlPressed == true) { //Create AND gate
    grid.createGate(0);
  }
  if (key == '2' && CtrlPressed == true) { //Create OR gate
    grid.createGate(1);
  }
  if (key == '3' && CtrlPressed == true) { //Create NOT gate
    grid.createGate(2);
  }
  if (key == '4' && CtrlPressed == true) { //Create OUT gate
    grid.createGate(3);
  }
  if (key == '5' && CtrlPressed == true) { //Create OUT gate
    grid.createGate(4);
  }
}


void mouseClicked() {
  if (grid.gates.size() > 0 && currentTool == 0 && mouseButton == LEFT) {  //Select gate
    if (!CtrlPressed) {
      for (int gate = 0; gate < grid.gates.size(); gate++) {
        if (grid.gates.get(gate).selected) {grid.gates.get(gate).selected = false;}
      }
      
      selectedID.clear();
    }
    for (int Gate = 0; Gate <= grid.gates.size() - 1; Gate++) {
      grid.gates.get(Gate).checkClick();
    }
  }
  
  if (currentTool == 1  && mouseButton == LEFT && mouseY > 65) {  //Create AND gate
    grid.createGate(0);
  }
  
  if (currentTool == 2  && mouseButton == LEFT && mouseY > 65) {  //Create OR gate
    grid.createGate(1); 
  }
  
  if (currentTool == 5  && mouseButton == LEFT && mouseY > 65) {  //Create XOR gate
    grid.createGate(4); 
  }
  
  if (currentTool == 3  && mouseButton == LEFT && mouseY > 65) {  //Create NOT gate
    grid.createGate(2);
  }
  
  if (currentTool == 4  && mouseButton == LEFT && mouseY > 65) {  //Create OUT gate
    grid.createGate(3);
  }
  
  if (mouseButton == CENTER) {
    middleMousePressed = !middleMousePressed;
  }
}

/*void mouseReleased() {
  if (mouseButton == CENTER) {
    println("middle unclick");
    middleMousePressed = false;
  }
}*/

void keyReleased() {
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = false;}
  if (key == CODED && keyCode == SHIFT) {ShiftPressed = false;}
}

char pressedKey(char keey) {
  char out = 'q';
  
  for (int i = 0; i < lettersListRU.length; i++) {
    if (Character.toLowerCase(keey) == lettersListRU[i]) {
      out = lettersListEN[i];
      break;
    }
    
    if (Character.toLowerCase(keey) == lettersListEN[i]) {
      out = lettersListEN[i];
      break;
    }
  }
  
  return out;
}

public void Select() {
  currentTool = 0;
}
public void AND() {
  currentTool = 1;
}
public void OR() {
  currentTool = 2;
}
public void NOT() {
  currentTool = 3;
}
public void XOR() {
  currentTool = 5;
}
public void OUT(){
  currentTool = 4;
}
