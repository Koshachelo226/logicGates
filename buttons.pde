void keyPressed() {
  
  if (key == '0') {
    currentTool = 0;
  }
  
  if (key == '1') {
    currentTool = 1;
  }
  
  if (key == '2') {
    currentTool = 2;
  }
  
  if (key == '3') {
    currentTool = 3;
  }
  
  if (key == 'i') {
    if (selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "and" || selectedID.size() > 2 && grid.gates.get(selectedID.get(2)).Type == "or") {
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(0));
      grid.gates.get(selectedID.get(2)).Inputs.add(selectedID.get(1));
    }
    
    else if (selectedID.size() > 1 && grid.gates.get(selectedID.get(1)).Type == "not") {
      grid.gates.get(selectedID.get(1)).Inputs.add(selectedID.get(0));
    }
  }
  
  if (key == 't' && grid.gates.size() > 0) {
    for (int Gate = 0; Gate < grid.gates.size(); Gate++) {
      if (grid.gates.get(Gate).selected == false) {continue;}
      
      grid.gates.get(Gate).Output = !grid.gates.get(Gate).Output;
      grid.gates.get(Gate).toggled = !grid.gates.get(Gate).toggled;
    }
  }
  
  if (key == 'D' && selectedID.size() > 0) {
    for (int Gate = 0; Gate < selectedID.size(); Gate++) {
      for (int input = 0; input < grid.gates.get(selectedID.get(Gate)).Inputs.size(); input++) {
        grid.gates.get(selectedID.get(Gate)).Inputs.remove(input);
      }
    }
  }
  
  if (key == 'd' && selectedID.size() > 0) {
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
    
    for (int id = 0; id < selectedID.size(); id++) {
      if (id < selectedID.size() && grid.gates.get(id).selected) {
        int nextID = selectedID.get(id);
        grid.gates.remove(nextID);
        numberOfDeleted++;
      }
    }
    
    grid.lastID -= numberOfDeleted;
  }
  
  if (key == '-' && Scale > 1) {
    Scale--;
  }
  
  if (key == '+' && Scale < 10) {
    Scale++;
  }
}


void mouseClicked() {
  if (grid.gates.size() > 0 && currentTool == 0) {
    for (int Gate = 0; Gate <= grid.gates.size() - 1; Gate++) {
      grid.gates.get(Gate).checkClick();
    }
  }
  
  if (currentTool == 1) {
    grid.createGate(0);
  }
  
  if (currentTool == 2) {
    grid.createGate(1); 
  }
  
  if (currentTool == 3) {
    grid.createGate(2);
  }
}
