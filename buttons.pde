boolean CtrlPressed = false;
boolean ShiftPressed = false;

void keyPressed() {  
  
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = true;}
  if (key == CODED && keyCode == SHIFT) {ShiftPressed = true;}
  
  if (key == '0') {
    currentTool = 0; //Selection tool (click)
  }
  
  if (key == '1' && !CtrlPressed) {
    currentTool = 1;
  }
  
  if (key == '2' && !CtrlPressed) {
    currentTool = 2;
  }
  
  if (key == '3' && !CtrlPressed) {
    currentTool = 3;
  }
  
  if (key == '4' && !CtrlPressed) {
    currentTool = 4;
  }
  
  if (key == 'i') {
    if (selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "and" || selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "or") {
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(0));
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(1));
      println("CONNECTED");
    }
    
    else if (selectedID.size() > 1 && grid.gates.get(selectedID.get(1)).Type == "not" || selectedID.size() > 1 && grid.gates.get(selectedID.get(1)).Type == "out") {
      grid.gates.get(selectedID.get(1)).Inputs.add(selectedID.get(0));
      println("CONNECTED");
    }
  }
  
  if (key == 't' && grid.gates.size() > 0) {
    for (int Gate = 0; Gate < grid.gates.size(); Gate++) {
      if (grid.gates.get(Gate).selected == false) {continue;}
      
      grid.gates.get(Gate).Output = !grid.gates.get(Gate).Output;
      grid.gates.get(Gate).toggled = !grid.gates.get(Gate).toggled;
    }
  }
  
  if (key == 'd' && selectedID.size() > 0) {
    for (int id = selectedID.size()-1; id >= 0; id--) {
      grid.gates.get(selectedID.get(id)).selected = false;
      selectedID.remove(id);
    }
  }
  
  if (key == 'm' && selectedID.size() > 0) {
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
}


void mouseClicked() {
  if (grid.gates.size() > 0 && currentTool == 0) {  //Select gate
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
  
  if (currentTool == 1) {  //Create AND gate
    grid.createGate(0);
  }
  
  if (currentTool == 2) {  //Create OR gate
    grid.createGate(1); 
  }
  
  if (currentTool == 3) {  //Create NOT gate
    grid.createGate(2);
  }
  
  if (currentTool == 4) {  //Create OUT gate
    grid.createGate(3);
  }
}

void keyReleased() {
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = false;}
  if (key == CODED && keyCode == SHIFT) {ShiftPressed = false;}
}
