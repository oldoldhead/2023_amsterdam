final int STAR_LED_NUM = 1000;
final int MAX_STAR_NUM = 8;
final float SCALE = 0.45;
final int VIRTUAL_LED_SKIP_DIST = 100;
final int RIPPLE_NUM = 7;
final int BOUNCE_LED_NUM = 120;
final int VIRTUAL_LED_TOTAL_LEN = STAR_LED_NUM + (BOUNCE_LED_NUM+VIRTUAL_LED_SKIP_DIST)*RIPPLE_NUM +400 ;

boolean SHOW_PATH = false;

color[] virtualLED = new color[VIRTUAL_LED_TOTAL_LEN];
color[] shootingStarLED = new color[STAR_LED_NUM];
color[][] bounceLED = new color[RIPPLE_NUM][BOUNCE_LED_NUM];
float[] starHead = new float[MAX_STAR_NUM];
color[] starColor = new color[MAX_STAR_NUM];
float[] starSpeed = new float[MAX_STAR_NUM];
int[] starWaitTime = new int[MAX_STAR_NUM]; //in millis
int[] bouncePath = new int[MAX_STAR_NUM];

int curMillis;
int[][] BOUNCE_TABLE = {
  {11},
  {1,2,13},
  {1,3,14},
  {1,3,15},
  {1,2,3,14},
  {1,3,14},
  {1,3,15},
  {1,4,16},
  {1,2,3,14},
  {1,3,4,15},
  {1,3,5,16},
  {1,5,6,17},
  {1,2,3,4,15},
  {1,3,5,6,17},
  {1,3,4,5,6,17},
  {1,2,3,4,5,6,17} //16 kinds of motion
};

void setup(){
  size(1920,768);
  initStar();
  initRipple();
  smooth();
}

void draw(){
  background(0);
  curMillis=millis();
  updateStar();
  drawStar();
  drawStonskip();
}
