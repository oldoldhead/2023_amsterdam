final int STAR_LED_NUM = 600;
final int MAX_STAR_NUM = 10;

color[] shootingStar = new color[STAR_LED_NUM];
float[] starHead = new float[MAX_STAR_NUM];
color[] starColor = new color[MAX_STAR_NUM];
float[] starSpeed = new float[MAX_STAR_NUM];
int[] starWaitTime = new int[MAX_STAR_NUM]; //in millis

int curMillis;



void setup(){
  size(1024,768);
  colorMode(HSB, 360, 100, 100);
  initStar();
}

void draw(){
  background(0);
  curMillis=millis();
  updateStar();
  drawStar();
}
