final int RIPPLE_COLOR_LAYER_NUM =1;

int[] STON_LEN_TABLE = {
  120,
  120,
  120,
  120,
  120,
  120,
  120
};

float[] RIPPLE_X = new float[RIPPLE_NUM];
float RIPPLE_DIST_MAX = 550*SCALE;
float RIPPLE_DIST_DECREAMENT = 50*SCALE;
float STAR_END = 1000*SCALE;


float rippleWidth = 60*SCALE;
float SKIP_DIST = 400*SCALE;
float SKIP_HEIGHT = 60*SCALE;

color[][] rippleColor = new color[RIPPLE_NUM][RIPPLE_COLOR_LAYER_NUM];
int[] rippleColorIndex = new int[RIPPLE_NUM];
float[][] rippleSinR = new float[RIPPLE_NUM][RIPPLE_COLOR_LAYER_NUM];
float[][] rippleSinAngle = new float[RIPPLE_NUM][RIPPLE_COLOR_LAYER_NUM];

void initRipple(){
  for(int i=0;i<RIPPLE_NUM;i++){
    rippleColorIndex[i]=0;
    rippleColor[i][0] = color(0);
    //rippleColor[i][1] = color(0);
    //rippleColor[i][2] = color(0);
    RIPPLE_X[i]=STAR_END+(RIPPLE_DIST_MAX+(RIPPLE_DIST_MAX-RIPPLE_DIST_DECREAMENT*i))*(i+1)/2;
    println(i+" : "+RIPPLE_X[i]);
  }
}


void drawStonskip(){
  //draw ripples
  noFill();
  strokeWeight(3);//2);
  //colorMode(RGB, 255);
  for(int s=0;s<RIPPLE_NUM;s++){
    float lerpR=0,lerpG=0,lerpB=0;
    for(int r=0;r<RIPPLE_COLOR_LAYER_NUM;r++){
      if(rippleSinR[s][r]>0){
        //print("("+s+" "+r+")");
        //color tempColor = color(rippleColor[s][r],int(map(cos(rippleSinAngle[s][r]),-1,1,0,rippleSinR[s][r]*255)));
        float rippleRatio = map(cos(rippleSinAngle[s][r]),-1,1,0,0.8)*rippleSinR[s][r]+rippleSinR[s][r]*0.2;
        //print("("+s+" "+r+" "+tempColor+")");
        colorMode(RGB, 255);
        if(rippleColor[s][r]==color(255,255,255)){
          colorMode(HSB, 360, 100, 100);
          color tempRainBow = color((frameCount*10)%360,rippleSinR[s][r]>0.9?0:(0.9-rippleSinR[s][r])*(100/0.9),100);
          colorMode(RGB, 255);
          lerpR=min(lerpR+red(tempRainBow)*rippleRatio,255);
          lerpG=min(lerpG+green(tempRainBow)*rippleRatio,255);
          lerpB=min(lerpB+blue(tempRainBow)*rippleRatio,255);
          rippleSinAngle[s][r]+=0.1;
          rippleSinR[s][r]-=0.001;
        }
        else{
          
          lerpR=min(lerpR+red(rippleColor[s][r])*rippleRatio,255);
          lerpG=min(lerpG+green(rippleColor[s][r])*rippleRatio,255);
          lerpB=min(lerpB+blue(rippleColor[s][r])*rippleRatio,255);
          rippleSinAngle[s][r]+=0.1;
          rippleSinR[s][r]-=0.003;
        }
        //print("~"+int(map(cos(rippleSinAngle[s][r]),-1,1,0,rippleSinR[s][r]*255))+" "+rippleSinAngle[s][r]+"~");
        //print("!"+red(tempColor)+" "+green(tempColor)+" "+blue(tempColor)+"!");
        //print("("+lerpR+" "+lerpG+" "+lerpB+")");
      }
    }
    colorMode(RGB, 255);
    stroke(int(lerpR),int(lerpG),int(lerpB));
    if(SHOW_PATH)stroke(255);
    ellipse(RIPPLE_X[s],550+SKIP_HEIGHT,rippleWidth,10);
  }
  
  noStroke();
  for(int s=0;s<RIPPLE_NUM;s++){
    for(int i=0;i<BOUNCE_LED_NUM;i++){
      //int target = int(STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST + s*(120+VIRTUAL_LED_SKIP_DIST))+i;
      fill(bounceLED[s][i]);
      if(SHOW_PATH)fill(255);
      float yShiftRatio = 1-abs(i-STON_LEN_TABLE[s]/2)/float(STON_LEN_TABLE[s]);

      if(i-STON_LEN_TABLE[s]/2>0){
          ellipse(RIPPLE_X[s]+(i-STON_LEN_TABLE[s]/2)*LED_DIST,
                  550+SKIP_HEIGHT*yShiftRatio*yShiftRatio,2,3);
      }
      else{
        if(s==0)
          ellipse(RIPPLE_X[s]+(i-STON_LEN_TABLE[s]/2)*LED_DIST*1.2,
                  550+SKIP_HEIGHT*yShiftRatio,2,3);
        else
          ellipse(RIPPLE_X[s]+(i-STON_LEN_TABLE[s]/2)*LED_DIST*0.6,
                  550+SKIP_HEIGHT*yShiftRatio,2,3);
      }
    }
  }
}
