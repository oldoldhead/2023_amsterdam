final int STAR_STATE_IDLE = -2;
final int STAR_STATE_WAIT = -1;

int[] starRanking = {3,3,3,3,2,2,2,1,1,0};
int[][] starRanInterval={//min,max,sec
  {30,180},
  {10,60},
  {1,30},
  {1,10}
};

int[] starLenTable = {
  300,
  150,
  70,
  70
};

int[][] starColorTable = { //Hmin, Hman, S, B
  {0,360,70,100},
  {0,100,70,70},
  {210,360,50,60},
  {240,300,10,30},
};

float starSpeedSlow = 10;
float starSpeedFast = 30;

void initStar(){
  for(int i=0;i<MAX_STAR_NUM;i++){
    starHead[i]=STAR_STATE_IDLE;
  }
}

void updateStar(){
  for(int i=0;i<MAX_STAR_NUM;i++){
    if(starHead[i]==STAR_STATE_IDLE){
      int sRank = starRanking[i];
      starWaitTime[i]=curMillis+int(random(starRanInterval[sRank][0], starRanInterval[sRank][1])*1000);
      println(starWaitTime[i]);
      starHead[i]=STAR_STATE_WAIT;
      starColor[i] = color( int(random(starColorTable[sRank][0],starColorTable[sRank][1])),
                            starColorTable[sRank][2],
                            starColorTable[sRank][3]);
      starSpeed[i] = random(starSpeedSlow,starSpeedFast);
    }
    else if(starHead[i]==STAR_STATE_WAIT && curMillis>starWaitTime[i]){
      starHead[i]=0;
      println(i +" SHOOT");
    }
    else if(starHead[i]>STAR_LED_NUM+starLenTable[starRanking[i]]){
      starHead[i]=STAR_STATE_IDLE;
      println(i +" OVER");
    }
    else if(starHead[i]>STAR_STATE_WAIT){
      starHead[i]+=starSpeed[i];
      //println(i +" "+starHead[i]);
      for(int j=0;j<STAR_LED_NUM;j++){
        if(j<=starHead[i] && j>starHead[i]-starLenTable[starRanking[i]]){
          shootingStar[j]=starColor[i];
        }
      }
    }
    
  }
}

void drawStar(){
  noStroke();
  for(int i=STAR_LED_NUM-1;i>=0;i--){
      //fill(255,100,100);
      fill(shootingStar[i]);
      ellipse(i,50,2,10);
      shootingStar[i]=color(0,0,0);
  }
}
