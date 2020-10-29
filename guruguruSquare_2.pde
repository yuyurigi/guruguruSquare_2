import java.util.Calendar;

PImage source;

float radius = 10;     // 最初の四角の(直径/2)
float addRadius = 3.0; //線と線の間隔（数字が小さいと狭い）
PVector[] vertex = {};
int vc = 0;
float SCALE = 2.0; 
boolean b = true;
float thickness = 1.5;  // 線の太さの最小値
float thickMax = 7;   // 線の太さの最大値
PVector Pos, Ac;

void setup() {
  frameRate(240);
  size(800, 800);
  background(239, 255, 141); //背景色
  fill(143, 161, 255); //線の色
  noStroke();

  source = loadImage("image.png"); // 画像をロード
  source.resize(width, height);
  source.loadPixels();

  int centx = width/2;
  int centy = height/2;
  float d = dist(width/2, height/2, 50, 50);
  float lastRadius = d; // 最後の四角の(直径/2)
  float rot = ((lastRadius) / addRadius ) * 90;
  
  Ac = new PVector();

  //四角形の頂点を配列に代入
  float lastx = -999;
    for (float ang = 45; ang <= 45+rot; ang += 90) {
    radius += addRadius;
    float rad = radians(ang);
    float x0 =  centx + (radius*cos(rad));
    float y0 = centy + (radius* sin(rad));
    if ( lastx > -999) {
      vertex = (PVector[]) append(vertex, new PVector(x0, y0));
    }
    lastx = x0;
  }
}

void draw() {
  if (b) {
    Pos = vertex[vc];
  }
  
  b = false;
  
  //Posと次の頂点との距離
  float dist = PVector.dist(Pos, vertex[vc+1]);
  Ac = PVector.sub(vertex[vc+1], Pos); //次の頂点に向かうベクトルを計算
  Ac.normalize(); //単位ベクトル化
  
  int cpos = (int(Pos.y) * source.width) + int(Pos.x); // 画像の色を取得
  color c = source.pixels[cpos]; // 暗い色を太い線に、明るい色を細い線にする
  float dim = map(brightness(c), 0, 255, thickMax, thickness);
  ellipse(Pos.x, Pos.y, dim, dim); //線を描く
  
  if (dist>1) {
    Pos.add(Ac.x*SCALE, Ac.y*SCALE);
    } else {
      PVector m = new PVector();
      m = PVector.sub(vertex[vc+1], Pos);
      Pos.add(m.x, m.y);
    }
  
  if (dist<=0) { //線が角まで来たら
  if (vc == vertex.length-2){
    noLoop();
  }
    b = true;
    vc += 1;
  }
}

void keyPressed() {
  if (key == 's' || key == 'S')saveFrame(timestamp()+"_####.png");
}


String timestamp() {
  Calendar now = Calendar.getInstance();
  return String.format("%1$ty%1$tm%1$td_%1$tH%1$tM%1$tS", now);
}
