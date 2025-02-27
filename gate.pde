class circuitGrid {
  ArrayList<gate> gates = new ArrayList<gate>();
  int lastID = 0;
  
  void createGate(int type) {
    gate newGate = new gate();
    
    newGate.ID = lastID;
    
    lastID = gates.size() + 1;
    
    if (type == 0) {
      newGate.Type = "and";
    }
    
    if (type == 1) {
      newGate.Type = "or";
    }
    
    if (type == 2) {
      newGate.Type = "not";
    }
    
    if (type == 3) {
      newGate.Type = "out";
    }
    
    newGate.posX = mouseX;
    newGate.posY = mouseY;
    
    gates.add(newGate);
  }
  
  void createNewGate(int id, String type, ArrayList inputs, String output, float posX, float posY, String toggled) {
    gate newGate = new gate();
    lastID = gates.size() + 1;
    newGate.ID = id;
    
    switch(type) {
      case "and" :
        newGate.Type = "and";
        break;
      case "or" :
        newGate.Type = "or";
        break;
      case "not" :
        newGate.Type = "not";
        break;
      case "out" :
        newGate.Type = "out";
      default :
        println("Incorrect Type in: " + id);
    }
    
    newGate.Inputs = inputs;
    newGate.Output = boolean(output);
    newGate.posX = posX;
    newGate.posY = posY;
    newGate.toggled = boolean(toggled);
    gates.add(newGate);
  }
  
  class gate {
    String Type = "";
    int ID;
    ArrayList<Integer> Inputs = new ArrayList<Integer>();
    boolean Output = false;
    
    float posX;
    float posY;
    
    float prevPosX;
    float prevPosY;
    boolean selected = false;
    boolean toggled = false;
    boolean moving = false;
    
    void drawGate(float scale) {
      strokeWeight(3);
      stroke(255);
      
      switch (Type) {
        case "and" :
          if (selected) {
            strokeWeight(5);
            stroke(0, 255, 0);
            fill(255);
            
            pushMatrix();
            translate(posX, posY);
            text(str(ID), 10, 10);
            line(-10 * scale, -5 * scale, -10 * scale, 5 * scale);
            line(-10 * scale, 5 * scale, scale, 5 * scale);
            line(scale, 5 * scale, 5 * scale, 0.75 * scale);
            line(5 * scale, 0.75 * scale, scale, -5 * scale);
            line(scale, -5 * scale, -10 * scale, -5 * scale);
            popMatrix();
          }
          
          strokeWeight(3);
          if (Output) {
            stroke(255, 0 , 0);
          }
          
          else if (!Output) {
            stroke(255);
          }
          pushMatrix();
          translate(posX, posY);
          fill(255);
          text(str(ID), 10, 10);
          line(-10 * scale, -5 * scale, -10 * scale, 5 * scale);
          line(-10 * scale, 5 * scale, scale, 5 * scale);
          line(scale, 5 * scale, 5 * scale, 0.75 * scale);
          line(5 * scale, 0.75 * scale, scale, -5 * scale);
          line(scale, -5 * scale, -10 * scale, -5 * scale);
          popMatrix();
          break;
        
        case "or" :   
          if (selected) {
            strokeWeight(5);
            stroke(0, 255, 0);
            
            pushMatrix();
            translate(posX, posY);
            fill(255);
            text(str(ID), 10, 10);
            line(-10 * scale, -5 * scale, -5 * scale, 0.75 * scale);
            line(-5 * scale, 0.75 * scale, -10 * scale, 5 * scale);
            line(-10 * scale, 5 * scale, scale, 5 * scale);
            line(scale, 5 * scale, 5 * scale, scale);
            line(5 * scale, scale, scale, -5 * scale);
            line(scale, -5 * scale, -10 * scale, -5 * scale);
            popMatrix();
          }
          
          strokeWeight(3);
          if (Output) {
            stroke(255, 0 , 0);
          }
          
          else if (!Output) {
            stroke(255);
          }
          
          pushMatrix();
          translate(posX, posY);
          fill(255);
          text(str(ID), 10, 10);
          line(-10 * scale, -5 * scale, -5 * scale, 0.75 * scale);
          line(-5 * scale, 0.75 * scale, -10 * scale, 5 * scale);
          line(-10 * scale, 5 * scale, scale, 5 * scale);
          line(scale, 5 * scale, 5 * scale, scale);
          line(5 * scale, scale, scale, -5 * scale);
          line(scale, -5 * scale, -10 * scale, -5 * scale);
          popMatrix();
          break;
      
        case "not" :     
          if (selected) {
            stroke(0, 255, 0);
            strokeWeight(5);
            
            pushMatrix();
            translate(posX, posY);
            fill(255);
            text(str(ID), 10, 10);
            line(-10 * scale, -5 * scale, -10 * scale, 5 * scale);
            line(-10 * scale, -5 * scale, scale, 0.75 * scale);
            line(-10 * scale, 5 * scale, scale, 0.75 * scale);
            popMatrix();
          }
          
          strokeWeight(3);
          if (Output) {
            stroke(255, 0 , 0);
          }
          
          else if (!Output) {
            stroke(255);
          }
          
          pushMatrix();
          translate(posX, posY);
          text(str(ID), 10, 10);
          line(-10 * scale, -5 * scale, -10 * scale, 5 * scale);
          line(-10 * scale, -5 * scale, scale, 0.75 * scale);
          line(-10 * scale, 5 * scale, scale, 0.75 * scale);
          popMatrix();
          break;
          
        case "out" :
          if (selected) {
            stroke(0, 255, 0);
            strokeWeight(5);
            
            pushMatrix();
            translate(posX, posY);
            noFill();
            circle(0, 0, 12 * scale);
            fill(255);
            text(str(ID), 10, 10);
            popMatrix();
          }
          
          strokeWeight(3);
          if (Output) {
            stroke(255);
          }
          
          else if (!Output) {
            stroke(255);
          }
          
          pushMatrix();
          translate(posX, posY);
          if (Output) {fill(200, 0, 0);}
          else {noFill();}
          circle(0, 0, 12 * scale);
          fill(255);
          text(str(ID), 10, 10);
          popMatrix();
          break;
      }
    }
    
    void drawConnections() {
      if (Inputs.size() > 0) {
        for (int prevGate = Inputs.size()-1; prevGate >= 0; prevGate--) {
          if (gates.get(Inputs.get(prevGate)).Output) {stroke(255, 0, 0);}
          else if (gates.get(Inputs.get(prevGate)).selected) {stroke(0, 255, 0);}
          else {stroke(255);}
          
          switch(Type) {
          
            case "and" :
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 10 * Scale, posY);
              }
              
              break;
          
            case "not" :
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 10 * Scale, posY);
              }
              
              break;
            
            case "or" :
              if (gates.get(Inputs.get(prevGate)).Type == "or" || gates.get(Inputs.get(prevGate)).Type == "and") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 5.5 * Scale, posY + 0.5 * Scale);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 5.5 * Scale, posY + 0.5 * Scale);
              }
              
              break;
              
            case "out" :
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7 * Scale, posX - 6 * Scale, posY);
              }
          }
        }
      }
    }
    
    void calcGate() {
      if (toggled == false) {
        Output = output();
      }
      
      if (moving == true) {
        posX += mouseX - pmouseX;
        posY += mouseY - pmouseY;
        
        if (mousePressed) {
          moving = false;
        }
      }
    }
    
    void drawRect() {
      for (float Y = -5 * Scale + posY; Y <= 10 * Scale + posY - Scale*Scale; Y++) {
        for (float X = -10 * Scale + posX; X <= Scale * 15  + posX - Scale*Scale*2; X++) {
          noStroke();
          fill(255, 255, 255, 50);
          rect(X, Y, 1, 1);
        }
      }
    }
    
    void checkClick() {
      int prevMillis = 0;
      
      if (currentTool == 0 && mouseY > -5 * Scale + posY && mouseY < 10 * Scale + posY - Scale*Scale) {
        if (mouseX > -10 * Scale + posX && mouseX <= Scale * 15 + posX - Scale*Scale*2) {
          
          if (selected == false && millis() - prevMillis > 100) {
            selected = true; 
            prevMillis = millis(); 
            selectedID.add(ID);
          }
          
          if (selected == true && millis() - prevMillis > 100) {
            selected = false; prevMillis = millis();
            
            for (int id = 0; id < selectedID.size(); id++) {
              if (selectedID.get(id) == ID) {selectedID.remove(id);}
            }
          }
        }
      }
    } 
    
    boolean output() {
      if (Type == "and" && Inputs.size() > 1) {
        if (gates.get(Inputs.get(0)).Output && gates.get(Inputs.get(1)).Output && Inputs.get(0) != 228 && Inputs.get(1) != 228) {
          return true;
        }  else {return false;}
      }
      
      if (Type == "not" && Inputs.size() > 0) {
        if (!gates.get(Inputs.get(0)).Output && Inputs.get(0) != 228) {
          return true;
        }  else {return false;}
      }
      
      if (Type == "or" && Inputs.size() > 1) {
        if (gates.get(Inputs.get(0)).Output || gates.get(Inputs.get(1)).Output && Inputs.get(0) != 228 && Inputs.get(1) != 228) {
          return true;
        }  else {return false;}
      }
      
      if (Type == "out" && Inputs.size() > 0) {
        return grid.gates.get(Inputs.get(0)).Output;
      }
      
      else {return false;}
    }
  }  
}
