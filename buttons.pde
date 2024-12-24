boolean CtrlPressed = false;

void keyPressed() {  
  
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = true; println("ctrl");}
  
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
  
  if (key == 'i') {
    if (selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "and" || selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "or") {
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(0));
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(1));
      println("CONNECTED");
    }
    
    else if (selectedID.size() > 1 && grid.gates.get(selectedID.get(1)).Type == "not") {
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
  
  if (key == 'd' && selectedID.size() > 0 || key == 'D' && selectedID.size() > 0) {
    for (int id = 0; id < selectedID.size(); id++) {
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
    int numberOfDeleted = 0;
    
    /*for (int id = 0; id < selectedID.size(); id++) {
      if (id < selectedID.size()-1 && grid.gates.get(id).selected) {
        int nextID = selectedID.get(id);
        grid.gates.remove(selectedID.get(id));
        numberOfDeleted++;
      }
    }*/
    
    for (int idToDel = 0; idToDel < selectedID.size(); idToDel++) {
      println("del2");
      grid.gates.remove(int(selectedID.get(idToDel)));
      numberOfDeleted++;
    }
    
    while (selectedID.size() > 0) {
      selectedID.remove(0);
    }
    
    grid.lastID -= numberOfDeleted;
  }
  
  if (key == '-' && Scale > 1) {
    Scale--;
  }
  
  if (key == '+' && Scale < 10) {
    Scale++;
  }
  
  
  if (key == '1' && CtrlPressed == true) {
    grid.createGate(0);
  }
  if (key == '2' && CtrlPressed == true) {
    grid.createGate(1);
  }
  if (key == '3' && CtrlPressed == true) {
    grid.createGate(2);
  }
}


void mouseClicked() {
  if (grid.gates.size() > 0 && currentTool == 0) {  //Select gate
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
}

void keyReleased() {
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = false;}
}
