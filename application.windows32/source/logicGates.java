import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class logicGates extends PApplet {

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

public void setup() {
  mainFont = loadFont("Arial-Black-36.vlw");
  
}

public void draw() {
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

public void box(float x1, float y1, float x2, float y2) {
  quad(x1, y1, x2, y1, x2, y2, x1, y2);
}
boolean CtrlPressed = false;
boolean ShiftPressed = false;

public void keyPressed() {  
  
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


public void mouseClicked() {
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

public void keyReleased() {
  if (key == CODED && keyCode == CONTROL) {CtrlPressed = false;}
  if (key == CODED && keyCode == SHIFT) {ShiftPressed = false;}
}
class circuitGrid {
  ArrayList<gate> gates = new ArrayList<gate>();
  int lastID = 0;
  
  public void createGate(int type) {
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
    
    public void drawGate(float scale) {
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
            line(scale, 5 * scale, 5 * scale, 0.75f * scale);
            line(5 * scale, 0.75f * scale, scale, -5 * scale);
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
          line(scale, 5 * scale, 5 * scale, 0.75f * scale);
          line(5 * scale, 0.75f * scale, scale, -5 * scale);
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
            line(-10 * scale, -5 * scale, -5 * scale, 0.75f * scale);
            line(-5 * scale, 0.75f * scale, -10 * scale, 5 * scale);
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
          line(-10 * scale, -5 * scale, -5 * scale, 0.75f * scale);
          line(-5 * scale, 0.75f * scale, -10 * scale, 5 * scale);
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
            line(-10 * scale, -5 * scale, scale, 0.75f * scale);
            line(-10 * scale, 5 * scale, scale, 0.75f * scale);
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
          line(-10 * scale, -5 * scale, scale, 0.75f * scale);
          line(-10 * scale, 5 * scale, scale, 0.75f * scale);
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
    
    public void drawConnections() {
      if (Inputs.size() > 0) {
        for (int prevGate = Inputs.size()-1; prevGate >= 0; prevGate--) {
          if (gates.get(Inputs.get(prevGate)).Output) {stroke(255, 0, 0);}
          else if (gates.get(Inputs.get(prevGate)).selected) {stroke(0, 255, 0);}
          else {stroke(255);}
          
          switch(Type) {
          
            case "and" :
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 10 * Scale, posY);
              }
              
              break;
          
            case "not" :
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 10 * Scale, posY);
              }
              
              break;
            
            case "or" :
              if (gates.get(Inputs.get(prevGate)).Type == "or" || gates.get(Inputs.get(prevGate)).Type == "and") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 5.5f * Scale, posY + 0.5f * Scale);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 5.5f * Scale, posY + 0.5f * Scale);
              }
              
              break;
              
            case "out" :
              if (gates.get(Inputs.get(prevGate)).Type == "not") {
                line(gates.get(Inputs.get(prevGate)).posX + Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 10 * Scale, posY);
              }
              
              if (gates.get(Inputs.get(prevGate)).Type == "and" || gates.get(Inputs.get(prevGate)).Type == "or") {
                line(gates.get(Inputs.get(prevGate)).posX + 5 * Scale, gates.get(Inputs.get(prevGate)).posY + 0.7f * Scale, posX - 6 * Scale, posY);
              }
          }
        }
      }
    }
    
    public void calcGate() {
      if (toggled == false) {
        Output = output();
      }
      
      if (moving == true) {
        posX = mouseX-prevMouseX+prevPosX;
        posY = mouseY-prevMouseY+prevPosX;
      }
    }
    
    public void drawRect() {
      for (float Y = -5 * Scale + posY; Y <= 10 * Scale + posY - Scale*Scale; Y++) {
        for (float X = -10 * Scale + posX; X <= Scale * 15  + posX - Scale*Scale*2; X++) {
          noStroke();
          fill(255, 255, 255, 50);
          rect(X, Y, 1, 1);
        }
      }
    }
    
    public void checkClick() {
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
    
    public boolean output() {
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
  public void settings() {  size(700, 700); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "logicGates" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
