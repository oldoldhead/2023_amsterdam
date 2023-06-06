final int STAR_STATE_IDLE = -2;
final int STAR_STATE_WAIT = -1;
float LED_DIST = 1*SCALE;



int[] starRanking = {3,3,3,3,2,2,1,0};
float[][] starRanInterval={//min,max,sec
  {5,5},//{30,60},
  {1,20},
  {1,10},
  {1,3}
};

float[] starLenTable = {
  1200*SCALE,
  900*SCALE,
  500*SCALE,
  100*SCALE
};

int[][] starColorTable = { //Hmin, Hman, S, B
  {0,360,70,100},
  {0,50,70,100},
  {190,220,80,100},
  {0,0,0,80},
};

float[][] starSpeedTable = {
  {50,50},
  {30,50},
  {30,70},
  {20,60}
};
float starSpeedSlow = 10;
float starSpeedFast = 100;
float superStarLen;

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
    
    //========================================star states changing==============================================
    colorMode(HSB, 360, 100, 100);
    if(starHead[i]==STAR_STATE_IDLE){
      int sRank = starRanking[i];
      starWaitTime[i]=curMillis+int(random(starRanInterval[sRank][0], starRanInterval[sRank][1])*1000);
      //println(starWaitTime[i]);
      starHead[i]=STAR_STATE_WAIT;
      starColor[i] = int(random(starColorTable[sRank][0],starColorTable[sRank][1]));
      //starColor[i] = color( int(random(starColorTable[sRank][0],starColorTable[sRank][1])),
      //                      starColorTable[sRank][2],
      //                      starColorTable[sRank][3]);
      if(starRanking[i]==0) {
        starColor[i]=0;//color(0,0,100);
        superStarLen=starLenTable[0];
      }
      starSpeed[i] = random(starSpeedTable[sRank][0],starSpeedTable[sRank][1]);

      //print(" "+i+":"+starSpeed[i]+" ");
    }
    else if(starHead[i]==STAR_STATE_WAIT && curMillis>starWaitTime[i]){
      starHead[i]=0;
      
      if(starRanking[i]==0)
        bouncePath[i]=15;
      //else if(i==5)
      //  bouncePath[i]=bouncePath[i-1];
      else if(starRanking[i]>0)
        bouncePath[i]=int(random(0,16));
        
      if(i==4 && starHead[i+1]==STAR_STATE_WAIT && random(0,1)>0.5){ //trigger twin stars
        starWaitTime[i+1]=curMillis+300;
      }
      //if(i==4)starHead[i]=STAR_STATE_IDLE;
      
      print(" ["+i+" ");
    }
    else if( starRanking[i]==0 && curMillis<starWaitTime[i] && starWaitTime[i]-curMillis<3000){ //3 sec before super star, cancel big star
    print(" ("+starWaitTime[i]+" "+curMillis+" )");
      for(int s=0;s<MAX_STAR_NUM;s++){
        if((starRanking[s] == 1 || starRanking[s] == 2) && i!=s && starWaitTime[s]-curMillis<3000){
                starHead[s]=STAR_STATE_IDLE;
                print(" ["+s+" cancel]");
        }
      }
    }
    else if(starHead[i]>=VIRTUAL_LED_TOTAL_LEN-1){
      starHead[i]=STAR_STATE_IDLE;
      print(" "+ i +"] ");
    }
    //========================================star moving==============================================
    else if(starHead[i]>STAR_STATE_WAIT){
      for(int s=0;s<MAX_STAR_NUM;s++){
        if(i!=s && starRanking[s]>starRanking[i] && starHead[s]==STAR_STATE_WAIT){
          starHead[s] = STAR_STATE_IDLE;
        }
      }
      
      int starLen = starRanking[i]==0?int(superStarLen):int(starLenTable[starRanking[i]]);
      for(int j=0;j<starLen;j++){
        int target = int(starHead[i])-j;
        //========================================straight part==============================================
        if(target>=0 && target<STAR_LED_NUM){
          if(starRanking[i]==0){
            colorMode(HSB, 360, 100, 100);
            color rainbow;
            if(j<10)
              rainbow= color(0,0,noise(frameCount)>0.3?100:noise(frameCount)*100);
            else{
              boolean isWhite = noise((frameCount*50+target)*0.05)>0.7;
              rainbow= color(360-(frameCount*10+target)%360,isWhite?0:60,isWhite?int(map(j,starLen*0.5,starLen,255,0)):int(map(j,starLen*0.5,starLen*0.8,255,0)));
            }
            colorMode(RGB, 255);
            shootingStarLED[target]=rainbow;//color(rainbow,int(map(j,starLen/2,starLen,255,0)));
          }
          else{
            colorMode(HSB, 360, 100, 100);
            shootingStarLED[target]=color(starColor[i],
                                          int(map(j,0,starLen/3,0,starColorTable[starRanking[i]][2])),
                                          int(map(j,0,starLen,starColorTable[starRanking[i]][3],0)));
          }
        }
        //========================================bouncing part==============================================
        else{
          for(int b=0;b<RIPPLE_NUM;b++){
            
            int bounceHeadLimit = STAR_LED_NUM + b*(VIRTUAL_LED_SKIP_DIST+BOUNCE_LED_NUM)+ VIRTUAL_LED_SKIP_DIST;
            if(target >=  bounceHeadLimit && target < bounceHeadLimit + BOUNCE_LED_NUM){
              if(bouncePath[i]>=0 && b<BOUNCE_TABLE[bouncePath[i]].length){
                int targetBounce = BOUNCE_TABLE[bouncePath[i]][b]-1;
                boolean isLastRipple = targetBounce>=10;
                if(isLastRipple){
                  targetBounce-=10;
                }
                //<<<<<<<<<<<<<<<trigger ripples
                if(j==0 && target<=bounceHeadLimit+BOUNCE_LED_NUM/2 && target+starSpeed[i]>bounceHeadLimit+BOUNCE_LED_NUM/2 && starRanking[i]!=3){  
                  colorMode(HSB, 360, 100, 100);
                  if(starRanking[i]==0)
                    rippleColor[targetBounce][rippleColorIndex[targetBounce]]=color(0,0,100);
                  else
                    rippleColor[targetBounce][rippleColorIndex[targetBounce]] = color(starColor[i],
                                            starColorTable[starRanking[i]][2],
                                            starColorTable[starRanking[i]][3]);
                  rippleSinAngle[targetBounce][rippleColorIndex[targetBounce]]=0;
                  rippleSinR[targetBounce][rippleColorIndex[targetBounce]]=1;
                  rippleColorIndex[targetBounce]=(rippleColorIndex[targetBounce]+1)%RIPPLE_COLOR_LAYER_NUM;
                  if(isLastRipple){
                    starSpeed[i] = (starLen/starLenTable[0])*10; //the shorter move slower 
                    //println(starSpeed[i]);
                    if(starRanking[i]==0)starSpeed[i]=0.2;
                  }
                }
                if( isLastRipple && j==starLen-1 && int(starHead[i])-j>bounceHeadLimit+BOUNCE_LED_NUM/2)
                {
                  starHead[i]=STAR_STATE_IDLE;
                  print(" "+ i +"] ");
                }
                
                //<<<<<<<<<<<<<<<fill bouncing colors
                if(starRanking[i]==0){  //super star
                  colorMode(HSB, 360, 100, 100);
                  color rainbow;
                  if(j<10)
                    rainbow= color(0,0,noise(frameCount)>0.3?100:noise(frameCount)*100);
                  else{
                    rainbow= color(360-(frameCount*10+target)%360,60,100);
                  }
                  colorMode(RGB, 255);
                  if(isLastRipple){
                    if(target-bounceHeadLimit<BOUNCE_LED_NUM/2)
                      bounceLED[targetBounce][target-bounceHeadLimit] = color(rainbow,int(map(j,0,starLen,255,0)));
                  }
                  else{
                    bounceLED[targetBounce][target-bounceHeadLimit] = color(rainbow,int(map(j,0,starLen,255,0)));
                  }
                  
                }
                else{  //normal star
                  if(isLastRipple){
                    if(target-bounceHeadLimit<BOUNCE_LED_NUM/2)
                      bounceLED[targetBounce][target-bounceHeadLimit] = color(starColor[i],
                                          int(map(j,0,starLen/3,0,starColorTable[starRanking[i]][2])),
                                          int(map(j,0,starLen,starColorTable[starRanking[i]][3],0)));
                  }
                  else{
                    bounceLED[targetBounce][target-bounceHeadLimit] = color(starColor[i],
                                          int(map(j,0,starLen/3,0,starColorTable[starRanking[i]][2])),
                                          int(map(j,0,starLen,starColorTable[starRanking[i]][3],0)));
                    //color(starColor[i],int(map(j,0,starLen,255,0)));
                  }
                }
              }
            }
          }
        }
      }//j
      
      //========================================speed adjustment==============================================
      if(starHead[i]>STAR_STATE_WAIT){
        //move led with speed
        if(starRanking[i]==0 ){  //super star
          if(starHead[i] < STAR_LED_NUM-250){
            if(starSpeed[i]>0.5)starSpeed[i]=starSpeed[i]*0.93;
          }
          else{
            if(starSpeed[i]>0.3)starSpeed[i]=min(25,starSpeed[i]*1.08);
            if(starHead[i]<STAR_LED_NUM + (RIPPLE_NUM-1)*(VIRTUAL_LED_SKIP_DIST+BOUNCE_LED_NUM))
              superStarLen+=8;
            else
              superStarLen-=4;
          }
        }
        else if(starRanking[i]==1 ){  //slow star
          if(starHead[i] < STAR_LED_NUM-300){
            if(starSpeed[i]>5)starSpeed[i]=starSpeed[i]*0.96;
          }
          else{
            if(starSpeed[i]>0.3)starSpeed[i]=min(10,starSpeed[i]*1.05);
            //if(starHead[i]<STAR_LED_NUM + (RIPPLE_NUM-1)*(VIRTUAL_LED_SKIP_DIST+BOUNCE_LED_NUM))
            //  superStarLen+=10;
            //else
            //  superStarLen-=3;
          }
        }
        if(starHead[i]<=STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST && starHead[i]+starSpeed[i]>STAR_LED_NUM + VIRTUAL_LED_SKIP_DIST){
          starHead[i]+=starSpeed[i];
          starSpeed[i]= 5+(starSpeed[i]-5)/4;
        }
        else
          starHead[i]+=starSpeed[i];
      }
    }
  }
}

void drawStar(){
  noStroke();
  colorMode(RGB, 255);
  
  for(int i=STAR_LED_NUM-1;i>=0;i--){
      //fill(255,100,100);
      fill(shootingStarLED[i]);
      if(SHOW_PATH)fill(255);
      ellipse(i*LED_DIST*0.9+50,500-(STAR_LED_NUM-i)*LED_DIST*0.3,2,5);
      //shootingStar[i]=color(0,0,0);
  }
}
