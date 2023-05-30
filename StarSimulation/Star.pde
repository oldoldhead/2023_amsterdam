final int STAR_STATE_IDLE = -2;
final int STAR_STATE_WAIT = -1;
float LED_DIST = 1*SCALE;



int[] starRanking = {3,3,3,3,2,2,2,1,1,0};
int[][] starRanInterval={//min,max,sec
  {30,180},
  {10,60},
  {5,30},
  {2,10}
};

float[] starLenTable = {
  500*SCALE,
  300*SCALE,
  150*SCALE,
  20*SCALE
};

int[][] starColorTable = { //Hmin, Hman, S, B
  {0,360,70,100},
  {0,100,70,100},
  {210,360,50,80},
  {240,300,10,80},
};

float[][] starSpeedTable = {
  {5,5},
  {5,20},
  {20,60},
  {20,60}
};
float starSpeedSlow = 10;
float starSpeedFast = 100;

void initStar(){
  for(int i=0;i<MAX_STAR_NUM;i++){
    starHead[i]=STAR_STATE_IDLE;
    bouncePath[i]=-1;
  }
  
}

void updateStar(){
  //for(int i=0;i<VIRTUAL_LED_TOTAL_LEN;i++){
  //  virtualLED[i]=color(0);
  //}
  for(int i=0;i<STAR_LED_NUM;i++){
    shootingStarLED[i]=color(0);
  }
  for(int s=0;s<RIPPLE_NUM;s++){
    for(int i=0;i<BOUNCE_LED_NUM;i++){
      bounceLED[s][i]=color(0);
    }
  }
  for(int i=0;i<MAX_STAR_NUM;i++){
    colorMode(HSB, 360, 100, 100);
    if(starHead[i]==STAR_STATE_IDLE){
      int sRank = starRanking[i];
      starWaitTime[i]=curMillis+int(random(starRanInterval[sRank][0], starRanInterval[sRank][1])*1000);
      //println(starWaitTime[i]);
      starHead[i]=STAR_STATE_WAIT;
      starColor[i] = color( int(random(starColorTable[sRank][0],starColorTable[sRank][1])),
                            starColorTable[sRank][2],
                            starColorTable[sRank][3]);
      starSpeed[i] = random(starSpeedTable[sRank][0],starSpeedTable[sRank][1]);
    }
    else if(starHead[i]==STAR_STATE_WAIT && curMillis>starWaitTime[i]){
      starHead[i]=0;
      if(i<4)
        bouncePath[i]=-1;
      else if(i<7)
        bouncePath[i]=int(random(0,16));
      else
        bouncePath[i]=15;
      print(" ["+i+" ");
    }
    else if(starHead[i]>=VIRTUAL_LED_TOTAL_LEN-1){
      starHead[i]=STAR_STATE_IDLE;
      print(" "+ i +"] ");
    }
    else if(starHead[i]>STAR_STATE_WAIT){
      
      colorMode(RGB, 255);
      int starLen = int(starLenTable[starRanking[i]]);
      for(int j=0;j<starLen;j++){
        int target = int(starHead[i])-j;
        if(target>=0 && target<STAR_LED_NUM){
          shootingStarLED[target]=color(starColor[i],int(map(j,0,starLen,255,0)));
        }
        else{
          for(int b=0;b<RIPPLE_NUM;b++){
            
            int bounceHeadLimit = STAR_LED_NUM+ VIRTUAL_LED_SKIP_DIST + b*(VIRTUAL_LED_SKIP_DIST+BOUNCE_LED_NUM);
            if(target >=  bounceHeadLimit && target < bounceHeadLimit + BOUNCE_LED_NUM){
              if(bouncePath[i]>=0 && b<BOUNCE_TABLE[bouncePath[i]].length){
                int targetBounce = BOUNCE_TABLE[bouncePath[i]][b]-1;
                boolean isLastRipple = targetBounce>=10;
                if(isLastRipple)targetBounce-=10;
                if(j==0 && target<=bounceHeadLimit+BOUNCE_LED_NUM/2 && target+starSpeed[i]>bounceHeadLimit+BOUNCE_LED_NUM/2 ){  //<<<<<<<<<<<<<<<trigger ripples
                print(targetBounce+"!!");
                  rippleColor[targetBounce][rippleColorIndex[targetBounce]] = starColor[i];
                  rippleSinAngle[targetBounce][rippleColorIndex[targetBounce]]=0;
                  rippleSinR[targetBounce][rippleColorIndex[targetBounce]]=1;
                  rippleColorIndex[targetBounce]=(rippleColorIndex[targetBounce]+1)%3;
                }
                
                if(isLastRipple){
                  if(target-bounceHeadLimit<BOUNCE_LED_NUM/2)
                    bounceLED[targetBounce][target-bounceHeadLimit] = color(starColor[i],int(map(j,0,starLen,255,0)));
                }
                else{
                  bounceLED[targetBounce][target-bounceHeadLimit] = color(starColor[i],int(map(j,0,starLen,255,0)));
                }
              }
            }
          }
        }
      }
      
      
      //move led with speed
      if(starHead[i]<=STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST && starHead[i]+starSpeed[i]>STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST){
        starHead[i]+=starSpeed[i];
        starSpeed[i]= 5+(starSpeed[i]-5)/4;
      }
      else
        starHead[i]+=starSpeed[i];

    }
    
  }
}

void drawStar(){
  noStroke();
  colorMode(RGB, 255);
  
  for(int i=STAR_LED_NUM-1;i>=0;i--){
      //fill(255,100,100);
      fill(shootingStarLED[i]);
      ellipse(i*LED_DIST+50,300+i*LED_DIST*0.4,2,5);
      //shootingStar[i]=color(0,0,0);
  }
  
}
