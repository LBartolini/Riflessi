float time=0;
float score=0;
int back = 0;
boolean fine = false;
int diff = 3;
String dif = "Media";
boolean color_change = false;
boolean orol = false;
boolean infinity = false;
boolean paused = false;

Obbiettivo obb;
Rettangoli rett;
Orologio or;

void setup(){
  background(back);
  size(1080, 720);
  frameRate(60);
  rett = new Rettangoli();
  or = new Orologio();
  obb = new Obbiettivo();
  obb.initialize();
  or.initialize();
  textSize(20);
}

void draw(){
  background(back);
  getTime();
  fill(0, 255, 0);
  text("Tempo (s): " + time/2, 5, 25);
  text("Punteggio : " + score, (width/2)-50, 25);
  text("Difficoltà : " + dif, (width-220), 25);
  obb.show();
  rett.show();
  checktime();
  show_or();
  if(orol){
    or.show();
  }
}

void show_or(){
  if(frameCount%(60*7)==0){
    or.initialize();
    orol = true;
  }
}

void checktime(){
  if(((time/2)>=20 && !(infinity)) || paused){
    fill(0, 255, 0);
    text("Per ricominciare premere SPAZIO.", (width/2)-150, (height/2)-115);
    text("Per attivare la modalità 'senza limiti' premere V", (width/2)-150, (height/2)-95);
    text("Per attivare il cambio-colore premere C.", (width/2)-150, (height/2)-75);
    text("Per impostare la difficoltà premi:", (width/2)-150, (height/2)-55);
    text("    1 - Facile.", (width/2)-150, (height/2)-25);
    text("    2 - Media.", (width/2)-150, (height/2)-5);
    text("    3 - Difficile.", (width/2)-150, (height/2)+20);
    text("    4 - Impossibile.", (width/2)-150, (height/2)+40);
    text("Punteggio : " + int(score), (width/2)-150, (height/2)+70);
    text("Rateo al secondo: " + score/(time/2), (width/2)-150, (height/2)+95);
    noLoop();
    fine = true;
  }
  
  if((time - obb.init_time) >= diff){
    obb.initialize();
    rett.cond = 2;
  }
  
  if((time - or.init_time) >= 2+int(diff/2)){ 
    orol = false;
  }
  
  if(frameCount % 31 == 0){
    rett.cond = 0;
  }
  
  if(frameCount % 90 == 0){
    rett.got_time = false;
  }
  
  if((frameCount % (diff*20)==0) && color_change){
    if(back == 0){
      back = 255;
      obb.col = 0;
    }else{
      back = 0;
      obb.col = 255;
    }
  }
  
}

void hit(){
  boolean xhit = false;
  boolean yhit = false;
  
  if((obb.x - mouseX) <= obb.r && (obb.x - mouseX) >= -obb.r){
    xhit = true;
  }
  
  if((obb.y - mouseY) <= obb.r && (obb.y - mouseY) >= -obb.r){
    yhit = true;
  }
  
  
  if(xhit && yhit){
    score++;
    rett.cond = 1;
    obb.initialize();
  }
}

void or_hit(){
  boolean xhit = false;
  boolean yhit = false;
  
  if((or.x - mouseX) <= or.r && (or.x - mouseX) >= -or.r){
    xhit = true;
  }
  
  if((or.y - mouseY) <= or.r && (or.y - mouseY) >= -or.r){
    yhit = true;
  }
  
  
  if(xhit && yhit){
    time -= 6;
    obb.init_time -= 6;
    orol = false;
    rett.got_time = true;
}
}

void getTime(){
  if(frameCount % 30 == 0){
    time++;
  }
}

class Obbiettivo
{
  float x;
  float y;
  float init_time;
  int col=255;
  float r = 12*diff;
  
  void show(){
    fill(col);
    ellipse(x, y, r, r);
  }

  void initialize(){
    x = (random(width-105)+55);
    y = (random(height-95)+55);
    init_time = time;
  }
}

class Orologio
{
  float x;
  float y;
  float init_time;
  float r = 8*diff;
  
  void show(){
    fill(0, 255, 255);
    ellipse(x, y, r, r);
  }

  void initialize(){
    x = (random(width-105)+55);
    y = (random(height-95)+55);
    init_time = time;
  }
}

class Rettangoli
{
  int x1 = 15;
  int x2 = (width-15);
  int cond = 0; // 0 = standard, 1=hit, 2=miss
  boolean got_time = false;
  
  void show(){
    if(cond == 0){
      fill(51);
    }else if(cond == 1){
      fill(10, 255, 10);
    }else if(cond == 2){
      fill(255, 10, 10);
    }
    rect(0, 30, 10, height);
    rect(width-10, 30, 10, height);
    if(got_time){
      fill(0, 255, 255);
    }else{
      fill(51);
    }
    rect((width/2)-300, 5, 200, 25);
  }
}

void mousePressed(){
  hit();
  or_hit();
}

void keyPressed(){
  if(key == 'x' && !(fine)){
    paused = true;
    fine = true;
    checktime();
    noLoop();
  }else if(key=='x' && paused){
    fine = false;
    paused = false;
    loop();
  }
  if(key==' ' && fine){
    score = 0;
    time = 0;
    rett.cond = 0;
    obb.initialize();
    paused = false;
    fine = false;
    loop();
  }
  if(key=='c' && fine){
    if(color_change){
      color_change = false;
    } else{
      color_change = true;
    }
    back = 0;
    obb.col = 255;
  }
  if(key=='v' && fine){
    if(infinity){
      infinity = false;
    }else{
      infinity = true;
    }
  }
  if(key=='1' && fine){
    diff = 4;
    dif = "Facile";
  }
  if(key=='2' && fine){
    diff = 3;
    dif = "Media";
  }
  if(key=='3' && fine){
    diff = 2;
    dif = "Difficile";
  }
  if(key=='4' && fine){
    diff = 1;
    dif = "Impossibile";
  }
}
