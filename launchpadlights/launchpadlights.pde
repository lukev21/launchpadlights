import arb.soundcipher.*;
import themidibus.*;

//Declarations
SCScore score;
String savelocation;
ArrayList<byte[][]> timeline;
int index;
PImage logo;
PImage arrow;
PImage arrowalt;
PImage down;
MidiBus launchpad;

byte[][] lookup = 
{
  {
    121, 121, 121, 121, 121, 121, 121, 121, 121
  }
  , 
  { 
    0, 1, 2, 3, 4, 5, 6, 7, 8
  }
  , 
  {
    16, 17, 18, 19, 20, 21, 22, 23, 24
  }
  , 
  {
    32, 33, 34, 35, 36, 37, 38, 39, 40
  }
  , 
  {
    48, 49, 50, 51, 52, 53, 54, 55, 56
  }
  , 
  {
    64, 65, 66, 67, 68, 69, 70, 71, 72
  }
  , 
  {
    80, 81, 82, 83, 84, 85, 86, 87, 88
  }
  , 
  {
    96, 97, 98, 99, 100, 101, 102, 103, 104
  }
  , 
  {
    112, 113, 114, 115, 116, 117, 118, 119, 120
  }
};//Probably should have done the math here, oh well

//First time inits
void setup()
{
  MidiBus.list();
  launchpad = new MidiBus(this, "Launchpad S", "Launchpad S");
  timeline = new ArrayList<byte[][]>();
  timeline.add(new byte[9][9]);
  index = 0;
  noStroke();
  size(450, 500);
  background(0);
  smooth(8);
  logo = loadImage("live-logo.png");
  arrow = loadImage("arrow.png");
  arrowalt = loadImage("arrowalt.png");
  down = loadImage("down.png");
  score = new SCScore();
  allOff();
}

void draw()
{
  clear();
  drawLaunchpad();
}

//Draws the launchpad and interface buttons
void drawLaunchpad()
{
  image(logo, 406, 6, 38, 38);
  pushMatrix();
    scale(-1, 1);
    image(arrow, -48, 452);//left arrow
  popMatrix();
  image(arrow, 102, 452);//right arrow
  image(arrowalt, 152, 452);//copy to next
  image(down, 352, 452);//down arrow (save)
  textSize(32);
  fill(255);
  text(index+1, 65, 486);
  for (int x = 0; x < timeline.get(index).length; x++)
  {
    for (int y = 0; y < timeline.get(index)[x].length;y++)
    {
      fill(getColor(timeline.get(index)[x][y]));
      if (y == 0)
      {
        if (x < 8)
          ellipse(x*50 + 25, y * 50 + 25, 46, 46);
      }
      else if (x == 8)
      {
        ellipse(x*50 + 25, y * 50 + 25, 46, 46);
      }
      else
      {
        rect(x*50 + 2, y * 50 + 2, 46, 46, 7);
      }
    }
  }
}

//Returns the color that corresponds to any midi velocity
color getColor(byte b)
{
  color c;
  switch(b)
  {
  case 13:
    c = color(255, 150, 150);
    break;
  case 14:
    c = color(255, 85, 85);
    break;
  case 15:
    c = color(244, 0, 0);
    break;
  case 29:
    c = color(255, 240, 150);
    break;
  case 46:
    c = color(255, 220, 85);;
    break;
  case 63:
    c = color(255, 200, 0);
    break;
  case 62:
    c = color(200, 255, 0);
    break;
  case 28:
    c = color(150, 255, 150);
    break;
  case 44:
    c = color(85, 255, 85);
    break;
  case 60:
    c = color(0, 255, 0);
    break;
  case 47:
    c = color(255, 163, 67);
    break;
  default:
    c = color(200);
    break;
  }
  return(c);
}

//Handles mouse click actions (any button)
void mouseClicked()
{
  if(mouseButton == LEFT)
  {
    if (mouseX < 450 && mouseX > 0 && mouseY > 50 && mouseY < 450)//Squares
    {
      toggleSquare(mouseX/50, mouseY/50);
    }
    else if (mouseY > 450 && mouseY < 500 && mouseX > 0 && mouseX < 50)//Timeline Back
    {
      allOff();
      index = max(0, index - 1);
      allOn();
    }
    else if (mouseY > 450 && mouseY < 500 && mouseX > 100 && mouseX < 150)//Timeline Forward
    {
      allOff();
      if (index < timeline.size() - 1)
      {
        index++;
      }
      else
      {
        timeline.add(new byte[9][9]);
        index++;
      }
      allOn();
    }
    else if (mouseY > 450 && mouseY < 500 && mouseX > 150 && mouseX < 200)//Copy current
    {
      copyToNext();
    }
    else if (mouseY > 450 && mouseY < 500 && mouseX > 350 && mouseX < 400)//Save
    {
      selectOutput("Select a save location: ", "saveLocation");
    }
  }
  else if(mouseButton == RIGHT)
  {
     if (mouseX < 450 && mouseX > 0 && mouseY > 50 && mouseY < 450)//Squares
    {
      for(int i = 0; i < 11; i++) toggleSquare(mouseX/50, mouseY/50);//Because I'm to lazy to make it go backwards, I just toggle it back around (This is bad, I know)
    }
  }
}

//Handles keyboard input
void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == RIGHT)
    {
      moveRight();
    }
    if(keyCode == LEFT)
    {
      moveLeft();
    }
    if(keyCode == UP)
    {
      moveUp();
    }
    if(keyCode == DOWN)
    {
      moveDown();
    }
  }
  else if(key == DELETE || key == 
}

//Moves a square on the launchpad to the next color
void toggleSquare(int x, int y)
{
  launchpad.sendNoteOff(0, lookup[y][x], timeline.get(index)[x][y]);
  switch(timeline.get(index)[x][y])
  {
  case 13:
    timeline.get(index)[x][y] = 14;
    break;
  case 14:
    timeline.get(index)[x][y] = 15;
    break;
  case 15:
    timeline.get(index)[x][y] = 29;
    break;
  case 29:
    timeline.get(index)[x][y] = 46;
    break;
  case 46:
    timeline.get(index)[x][y] = 63;
    break;
  case 63:
    timeline.get(index)[x][y] = 28;
    break;
  case 62:
    timeline.get(index)[x][y] = 47;
    break;
  case 28:
    timeline.get(index)[x][y] = 44;
    break;
  case 44:
    timeline.get(index)[x][y] = 60;
    break;
  case 60:
    timeline.get(index)[x][y] = 62;
    break;
  case 47:
    timeline.get(index)[x][y] = 12;
    break;
  default:
    timeline.get(index)[x][y] = 13;
    break;
  }
  launchpad.sendNoteOn(0, lookup[y][x], timeline.get(index)[x][y]);
}

//Writes the lightshow to a midi file
void writeScore()
{
  for (int i = 0; i < timeline.size(); i++)
  {
    if(!isEmpty(timeline.get(i)))
    {
      for (int x = 0; x < 9; x++)
      {
        for (int y = 1; y < 9; y++)
        {
          if(!(timeline.get(i)[x][y] == 12 || timeline.get(i)[x][y] == 0))
          {
            score.addNote(.25 * i, lookup[y][x], timeline.get(i)[x][y], .25);//Regular Mode
            //score.addNote(.25 * i, (8-y) * 12 + x, timeline.get(i)[x][y], .25);//FL Mode, not fully implemented
          }
        }
      }
    }
  }
  try
  {
    score.writeMidiFile(savelocation);
  }
  catch(Exception e)
  {
    e.printStackTrace();
  }
}

//Called to save file
void saveLocation(File selection)
{
  savelocation = selection.getAbsolutePath();
  writeScore();
}

//reads midi input, toggles squares pressed on launchpad
void noteOn(int channel, int pitch, int velocity) 
{
  for (int y = 0; y < lookup.length; y++)
  {
    for (int x = 0; x < lookup[y].length; x++)
    {
      if (pitch == lookup[y][x]) 
      {
        toggleSquare(x, y);
        return;
      }
    }
  }
}

//turns all lights off, timeline remains the same
void allOff()
{
  for(int y = 1; y < lookup.length; y++)
  {
    for(int x = 0; x < lookup[y].length; x++)
    {
        launchpad.sendNoteOff(0, lookup[y][x], timeline.get(index)[x][y]);
    }
  }
}

//turns all lights on, timeline remains the same
void allOn()
{
  for (int x = 0; x < timeline.get(index).length; x++)
  {
    for (int y = 1; y < timeline.get(index)[x].length;y++)
    {
      if(timeline.get(index)[x][y] != 12 && timeline.get(index)[x][y] != 0)
        launchpad.sendNoteOn(0, lookup[y][x], timeline.get(index)[x][y]);
    } 
  }
}

void copyToNext()
{
  allOff();
  if(index == timeline.size() - 1)
    timeline.add(new byte[9][9]);
  index++;
  for(int x = 0; x < 9; x++)
  {
    for(int y = 0; y < 9; y++)
    {
      timeline.get(index)[x][y] = timeline.get(index-1)[x][y];
    }
  }
  allOn();
}

//shifts the grid right
void moveRight()
{
  allOff();
  for(int x = 8; x > 0; x--)
  {
    timeline.get(index)[x] = timeline.get(index)[x-1];
  }
  timeline.get(index)[0] = new byte[9];
  allOn();
}

//shifts the grid left
void moveLeft()
{
  allOff();
  for(int x = 0; x < 8; x++)
  {
    timeline.get(index)[x] = timeline.get(index)[x+1];
  }
  timeline.get(index)[8] = new byte[9];
  allOn();
}

//shifts the grid up
void moveUp()
{
  allOff();
  for(int x = 0; x < 9; x++)
  {
    for(int y = 1; y < 8; y++)
    {
      timeline.get(index)[x][y] = timeline.get(index)[x][y+1];
    }
  }
  for(int x = 0; x < 9; x++)
  {
    timeline.get(index)[x][8] = 12;
  }
  allOn();
}

//shifts the grid down
void moveDown()
{
  allOff();
  for(int x = 0; x < 9; x++)
  {
    for(int y = 8; y > 1; y--)
    {
      timeline.get(index)[x][y] = timeline.get(index)[x][y-1];
    }
  }
  for(int x = 0; x < 9; x++)
  {
    timeline.get(index)[x][1] = 12;
  }
  allOn();
}

//checks if a layer is empty (do I really need this?)
boolean isEmpty(byte[][] arr)
{
  for(int x = 0; x < arr.length; x++)
  {
    for(int y = 1; y < arr.length;y++)
    {
      if(timeline.get(index)[x][y] != 12 && timeline.get(index)[x][y] != 0)
        return false;
    }
  }
  return true;
}
