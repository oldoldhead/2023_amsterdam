

int[] STON_LEN_TABLE = {
  120,
  120,
  120,
  120,
  120,
  120,
  120
};

float rippleWidth = 80*SCALE;
float SKIP_DIST = 400*SCALE;
float SKIP_HEIGHT = 60*SCALE;

color[][] rippleColor = new color[RIPPLE_NUM][3];
int[] rippleColorIndex = new int[RIPPLE_NUM];
float[][] rippleSinR = new float[RIPPLE_NUM][3];
float[][] rippleSinAngle = new float[RIPPLE_NUM][3];

void initRipple(){
  for(int i=0;i<RIPPLE_NUM;i++){
    rippleColorIndex[i]=0;
    rippleColor[i][0] = color(0);
    rippleColor[i][1] = color(0);
    rippleColor[i][2] = color(0);
  }
}


void drawStonskip(){
  //draw ripples
  noFill();
  strokeWeight(2);
  colorMode(RGB, 255);
  for(int s=0;s<RIPPLE_NUM;s++){
    float lerpR=0,lerpG=0,lerpB=0;
    for(int r=0;r<3;r++){
      if(rippleSinR[s][r]>0){
        //print("("+s+" "+r+")");
        //color tempColor = color(rippleColor[s][r],int(map(cos(rippleSinAngle[s][r]),-1,1,0,rippleSinR[s][r]*255)));
        float rippleRatio = map(cos(rippleSinAngle[s][r]),-1,1,0,1)*rippleSinR[s][r];
        //print("("+s+" "+r+" "+tempColor+")");
        lerpR=min(lerpR+red(rippleColor[s][r])*rippleRatio,255);
        lerpG=min(lerpG+green(rippleColor[s][r])*rippleRatio,255);
        lerpB=min(lerpB+blue(rippleColor[s][r])*rippleRatio,255);
        rippleSinAngle[s][r]+=0.1;
        rippleSinR[s][r]-=0.003;
        print("~"+int(map(cos(rippleSinAngle[s][r]),-1,1,0,rippleSinR[s][r]*255))+" "+rippleSinAngle[s][r]+"~");
        //print("!"+red(tempColor)+" "+green(tempColor)+" "+blue(tempColor)+"!");
        print("("+lerpR+" "+lerpG+" "+lerpB+")");
      }
    }
    
    stroke(int(lerpR),int(lerpG),int(lerpB));
    ellipse(650+s*SKIP_DIST,550+SKIP_HEIGHT,rippleWidth,20);
  }
  
  noStroke();
  for(int s=0;s<RIPPLE_NUM;s++){
    for(int i=0;i<BOUNCE_LED_NUM;i++){
      //int target = int(STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST + s*(120+VIRTUAL_LED_SKIP_DIST))+i;
      fill(bounceLED[s][i]);
      float yShiftRatio = 1-abs(i-STON_LEN_TABLE[s]/2)/float(STON_LEN_TABLE[s]);
      ellipse(650+s*SKIP_DIST+(i-STON_LEN_TABLE[s]/2)*LED_DIST,550+SKIP_HEIGHT*yShiftRatio*yShiftRatio,2,3);
    }
  }
  

  
}
