//Initialize player coordinates
float playerx;
float playery;

//Initialize the collision points around the player; 16 points seems fair enough to avoid getting stuck
PVector[] validloc = new PVector[16];
float[] pointX = new float[16];
float[] pointY = new float[16];
boolean[] ignorecollision = new boolean[16];

//timer that counts frames that have passed
int timer;

//my game ends after 50 seconds; timeleft measures time remaining
int timeleft;

//player coordinate values to be tested if they cause collision or not
float playerxtrue;
float playerytrue;

// wsad booleans
boolean dPressed;
boolean sPressed;
boolean aPressed;
boolean wPressed;

//ArrayList for the bullets that are fired
ArrayList<Bullet> osbullets;

//the state variable determines what state the game is in; 1=title, 2=playing the game, 3 = win screen, 4 = lose screen, and 5,6,7 are difficulty levels
int state = 1;
int difficulty = 10;
PImage title;
PImage winscreen;
PImage losescreen;
PImage easy;
PImage medium;
PImage hard;


//ArrayList for targets instead of array
ArrayList<PVector> targets;

//ArrayList for the cleared away spots on the targets
ArrayList<PVector> cleared;

//int targetcounter=0;

//camera to autoscroll the game
float cameraY;

//8bit text font used
PFont bit8; 

void setup() { //load images into the states and initialize the arraylists
  size(1280, 720);
  frameRate(60);
  textAlign(CENTER);
  noStroke();
  rectMode(CENTER);
  targets=new ArrayList<PVector>();
  osbullets=new ArrayList<Bullet>();
  cleared=new ArrayList<PVector>();
  bit8=createFont("8bit.TTF", 24);
  textFont(bit8);
  //different screens
  title = loadImage("title.png");
  winscreen = loadImage("win.png");
  losescreen = loadImage("lose.png");
  easy = loadImage("easy.png");
  medium = loadImage("medium.png");
  hard = loadImage("hard.png");

  //making the 16 points spaced properly around the player
  for (int i = 0; i < 16; i++) {
    float angle = (float(i)/16)*2*PI;
    float xOffset = cos(angle)*25;
    float yOffset = sin(angle)*25;
    validloc[i]  = new PVector(xOffset, yOffset);
  }
}


void draw() {

  //decide what happens next and what to draw depending on what state you're currently in
  if (state==1) {
    background(title);
  }

  if (state==5) {
    background(easy);
  }
  if (state==6) {
    background(medium);
  }
  if (state==7) {
    background(hard);
  }
  
  //draw rectangles around the difficulty you're hovering over to let the player know that they're clickable
  if (state==5||state==6||state==7) {
    noFill();
    stroke(199, 239, 254);
    strokeWeight(4);
    if (mouseX>500 && mouseX < 660 && mouseY > 520 && mouseY < 550) {
      rect(580, 533, 160, 30);
    } else if (mouseX>500 && mouseX < 660 && mouseY > 551 && mouseY < 589) {
      rect(580, 568, 160, 30);
    } else if (mouseX>500 && mouseX < 660 && mouseY > 590 && mouseY < 620) {
      rect(580, 604, 160, 30);
    }
    noStroke();
  }
  //where the game occurs
  if (state == 2) {
    shooter(); //prints everything for the game

    //draws the time left and the difficulty you're on
    timeleft = 50-timer/60;
    fill(255);
    textSize(20);
    text(timeleft, 40, 35);    
    timer++;
    if (difficulty==10) {
      text("MEDIUM", 1200, 35);
    } else if (difficulty==5) {
      text("EASY", 1225, 35);
    } else if (difficulty==15) {
      text("HARD", 1225, 35);
    }

    //camera's initial speed
    cameraY-=2;

    //camera gets faster every 10 seconds
    if (timer > 600) {
      cameraY-=.5;
    }
    if (timer > 1200) {
      cameraY-=.5;
    }
    if (timer > 1800) {
      cameraY-=.5;
    }
    if (timer > 2400) {
      cameraY-=.5;
    }
    if (timer > 3000) {
      state=3;
    }
  }

  //you lose if you go off the bottom of the screen (sent to state 4)
  if (playerytrue-cameraY>760) {
    state=4;
  }


  if (state==3) {
    background(winscreen);
  }

  if (state==4) {
    background(losescreen);
    fill(0);
    textSize(32); 
    text(timeleft + " SECONDS LEFT", 655, 550);
  }
}

//bullet class that contains xy coordinates and the vector to fire the bullet
class Bullet {
  float bxstart, bystart;
  float bxdir, bydir, bangle;

  //how to move the bullets once they're fired; also removes offscreen bullets
  void moveBullet(int z) {
    bxstart+=bxdir/bangle*8;
    bystart+=bydir/bangle*8;
    fill(255, 255, 0);
    rect(bxstart, bystart-cameraY, 6, 6);
    if (bxstart<0 || bxstart > 1280 || bystart-cameraY < 0 || bystart-cameraY > 720) {
      osbullets.remove(z);
    }
  }
}

//all of the keys that change the game when pressed; wasd and 1,2,3,4 to change states
void keyPressed() {
  if (key =='d') {
    dPressed=true;
  }
  if (key =='s') {
    sPressed=true;
  }
  if (key =='a') {
    aPressed=true;
  }
  if (key =='w') {
    wPressed=true;
  }
  if (key =='1') {
    state=1;
  }
  if (key =='2') {
    resetObjects();
    state=2;
  }
  if (key =='3') {
    state=3;
  }
  if (key =='4') {
    state=4;
  }

  //space key does different things depending on which screen you're on; generally moves you towards the actual game or back to the title screen
  if (key ==' ') {
    if (state==1) {
      difficulty=10;
      state = 6;
    } else if (state==5||state==6||state==7) {
      resetObjects();
      state=2;
    } else if (state==4||state==3) {
      resetObjects();
      state=1;
    }
  }
}


//wasd keys when released; also helps you navigate the difficulty screens
void keyReleased() {
  if (key =='d') {
    dPressed=false;
  }
  if (key =='s') {
    sPressed=false;
    if (state==6) {
      difficulty=15;
      state=7;
    } else if (state==5) {
      difficulty = 10;
      state = 6;
    }
  }
  if (key =='a') {
    aPressed=false;
  }
  if (key =='w') {
    wPressed=false;
    if (state==6) {
      difficulty=5;
      state=5;
    } else if (state==7) {
      difficulty = 10;
      state = 6;
    }
  }
}

//whenever the mouse is pressed, add a bullet to the bullet arraylist
void mousePressed() {
  Bullet newbullet = new Bullet();
  newbullet.bxstart=playerx;
  newbullet.bystart=playery;
  newbullet.bxdir=mouseX-playerx;
  newbullet.bydir=mouseY+cameraY-playery;
  newbullet.bangle=sqrt((newbullet.bydir*newbullet.bydir)+(newbullet.bxdir*newbullet.bxdir));
  osbullets.add(newbullet);
}

//helps you progress through different game states; also lets you select difficulty via clicking
void mouseReleased() {
  if (state==1) {
    state=6;
  } else if (state==5||state==6||state==7) {
    resetObjects();
    if (mouseX>500 && mouseX < 660 && mouseY > 520 && mouseY < 550) {
      difficulty=5;
    } else if (mouseX>500 && mouseX < 660 && mouseY > 551 && mouseY < 589) {
      difficulty=10;
    } else if (mouseX>500 && mouseX < 660 && mouseY > 590 && mouseY < 620) {
      difficulty=15;
    }

    state=2;
  }
}

//function for returning key objects and variables to a neutral state
void resetObjects() {
  targetSpawn();
  targetSpawnLine();
  targetSpawn2();
  targetSpawn3();
  timer=0;
  cameraY=-780;
  playerx=615;
  playery=-325;
  osbullets=new ArrayList<Bullet>();
  cleared=new ArrayList<PVector>();
}

//function to spawn the player, move them with wasd, and to fire bullets
void shooter() {
  background(17, 2, 55);
  playerxtrue=playerx;
  playerytrue=playery;
  if (dPressed==true) {
    playerxtrue=playerx+7;
  }
  if (aPressed==true) {
    playerxtrue=playerx-7;
  }
  if (sPressed==true) {
    playerytrue=playery+7;
  }
  if (wPressed==true) {
    playerytrue=playery-7;
  }

  //only commit movement changes if collision comes up false
  if (targetCollision()) {
    if (!targetCollisionX()) {//check to see if just the x axis movements will avoid collision; avoids "sticky" collision
      playerx=playerxtrue;
    } else if (!targetCollisionY()) {//check to see if just the y axis movements will avoid collision; avoids "sticky" collision
      playery=playerytrue;
    }
  } 

  //if there's no collision, move as normal
  else {
    playerx=playerxtrue;
    playery=playerytrue;
  }

  //draw the targets if they haven't gone offscreen
  for (int i=0; i<targets.size(); i++) {
    if (targets.get(i).y-cameraY>780||targets.get(i).y-cameraY<-50) {
      continue;
    }

    fill(199, 239, 254);
    ellipse(targets.get(i).x, targets.get(i).y-cameraY, 100, 100);


    //check if the bullets collide with the targets
    for (int r=0; r<osbullets.size(); r++) {
      if (safeCheck(osbullets.get(r).bxstart, osbullets.get(r).bystart)==false) {
        if (dist(osbullets.get(r).bxstart, osbullets.get(r).bystart, targets.get(i).x, targets.get(i).y)<65) {

          //if the bullets did collide, create a cleared zone and rmeove the bullet
          clearMass(osbullets.get(r).bxstart, osbullets.get(r).bystart);
          osbullets.remove(r);
        }
      }
    }
  }

  //draw the cleared mass spots; they're the background color
  fill(17, 2, 55);
  for (int i=0; i<cleared.size(); i++) {
    ellipse(cleared.get(i).x, cleared.get(i).y-cameraY, 50, 50);
  }

  //draw the player
  fill(255, 0, 0);
  ellipse(playerx, playery-cameraY, 50, 50);

  //remove offscreen bullets from the array, as well as give them velocity
  for (int i=0; i<osbullets.size(); i++) {
    osbullets.get(i).moveBullet(i);
  }
  //removes offscreen cleared spots
  for (int i=0; i<cleared.size(); i++) {
    if (cleared.get(i).y-cameraY>780) {
      cleared.remove(i);
    }
  }
}

//spawn targets; multiple different methods for difficulty purposes
void targetSpawnLine() {//a line of circles to start with so the player can learn to shoot
  for (int i=0; i<11; i++) {
    PVector temptarget=new PVector();
    temptarget.x=(i*1280/10);
    temptarget.y=(-600);
    targets.add(temptarget);
  }
}
void targetSpawn() {//1st wave of targets; not very dense
  targets=new ArrayList<PVector>();
  for (int i=0; i<5*difficulty; i++) {
    PVector temptarget=new PVector();
    temptarget.x=(random(0, 1280));
    temptarget.y=(random(-2000, -800));
    targets.add(temptarget);
    //target[i]=true;
  }
}
void targetSpawn2() {//second wave of targets; slightly more dense
  for (int i=0; i<18*difficulty; i++) {
    PVector temptarget=new PVector();
    temptarget.x=(random(0, 1280));
    temptarget.y=(random(-5000, -2000));
    targets.add(temptarget);
  }
}
void targetSpawn3() {//3rd wave; more dense and has extra targets in the back half
  for (int i=0; i<20*difficulty; i++) {
    PVector temptarget=new PVector();
    temptarget.x=(random(0, 1280));
    temptarget.y=(random(-9000, -5000));
    targets.add(temptarget);
  }
  for (int i=0; i<4*difficulty; i++) {
    PVector temptarget=new PVector();
    temptarget.x=(random(0, 1280));
    temptarget.y=(random(-9000, -7000));
    targets.add(temptarget);
  }
}

//function to add cleared spots to the arraylist
void clearMass(float x, float y) {
  PVector tmp = new PVector();
  tmp.x = x;
  tmp.y = y;
  cleared.add(tmp);
}

//code to check for collision; uses pointValid
boolean targetCollision() {
  boolean collide=false;
  if (playerxtrue<25||playerxtrue>1255||playerytrue-cameraY<25) {
    collide=true;
  }
  if (!pointValid()) {
    collide= true;
  }
  return collide;
}

//same code but just checks left/right movement to avoid "sticky" collision
boolean targetCollisionX() {
  boolean collide=false;
  if (playerxtrue<25||playerxtrue>1255) {
    collide=true;
  }
  if (!pointValidX()) {
    collide= true;
  }
  return collide;
}

//same code but for Y axis
boolean targetCollisionY() {
  boolean collide=false;
  if (playerytrue-cameraY<25) {
    collide=true;
  }
  if (!pointValidY()) {
    collide= true;
  }
  return collide;
}

//checks if the inputted variables are on top of cleared spots; if they are, return true
boolean safeCheck(float x, float y) {
  boolean issafe = false;
  for (int i=0; i<cleared.size(); i++) {
    if (dist(x, y, cleared.get(i).x, cleared.get(i).y)<25) {
      issafe= true;
    }
  }
  return issafe;
}

//code for testing if each collision point is correct or not out of the 16 points around the player
boolean pointValid() {
  for (int k = 0; k < 16; k++) {
    ignorecollision[k]=true;
    pointX[k] = validloc[k].x+playerxtrue;
    pointY[k] = validloc[k].y+playerytrue;
  }
  for (int i = 0; i < 16; i++) {
    for (int r=0; r<targets.size(); r++) {
      if (dist(pointX[i], pointY[i], targets.get(r).x, targets.get(r).y)<50) {
        if (!safeCheck(pointX[i], pointY[i]) ) {
          ignorecollision[i]=false;
        }
      }
    }
  }

  //if any of the points are false, return false
  for (int i = 0; i < 16; i++) {
    if (ignorecollision[i]==false) {
      return false;
    }
  }
  return true; //return true if none of the points are false
}

//same code but only checks X axis changes to avoid sticky collision
boolean pointValidX() {
  for (int k = 0; k < 16; k++) {
    ignorecollision[k]=true;
    pointX[k] = validloc[k].x+playerxtrue;
    pointY[k] = validloc[k].y+playery;
  }
  for (int i = 0; i < 16; i++) {
    for (int r=0; r<targets.size(); r++) {
      if (dist(pointX[i], pointY[i], targets.get(r).x, targets.get(r).y)<50) {
        if (!safeCheck(pointX[i], pointY[i]) ) {
          ignorecollision[i]=false;
        }
      }
    }
  }
  for (int i = 0; i < 16; i++) {
    if (ignorecollision[i]==false) {
      return false;
    }
  }
  return true;
}

//same code but for Y axis
boolean pointValidY() {
  for (int k = 0; k < 16; k++) {
    ignorecollision[k]=true;
    pointX[k] = validloc[k].x+playerx;
    pointY[k] = validloc[k].y+playerytrue;
  }
  for (int i = 0; i < 16; i++) {
    for (int r=0; r<targets.size(); r++) {
      if (dist(pointX[i], pointY[i], targets.get(r).x, targets.get(r).y)<50) {
        if (!safeCheck(pointX[i], pointY[i]) ) {
          ignorecollision[i]=false;
        }
      }
    }
  }
  for (int i = 0; i < 16; i++) {
    if (ignorecollision[i]==false) {
      return false;
    }
  }
  return true;
}