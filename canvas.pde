qbox [] question;
qbox dp, restart;
qbox quick_game, basic_game, Inter_game, Advance_game;
qbox Options, hira, kata, kanji;
boolean game = false;
boolean answered = false;
int num_choice=4, rounds=0;
int score, wrong;
float box_h, field_w, field_l;
int output = 0;
String [] lines;

void setup() 
{ 
   size(501, 501);
   int box_l = 200, box_w = 50;
   quick_game = new qbox((width-1)/2-(box_l), (height-1)/8*3, box_l, box_w, "Quick game");
   basic_game = new qbox((width-1)/2-(box_l), (height-1)/8*4, box_l, box_w, "Basic");
   Inter_game = new qbox((width-1)/2-(box_l), (height-1)/8*5, box_l, box_w, "Intermediate");
   Advance_game = new qbox((width-1)/2-(box_l), (height-1)/8*6, box_l, box_w, "Advance");
   //option boxs
   Options = new qbox((width-1)/2+50, (height-1)/8*3, box_l/2, box_w, "Pick Options");
   hira = new qbox((width-1)/2+50, (height-1)/8*4, box_l/2, box_w, "Hiragana");
   hira.strokes = true;
   kata = new qbox((width-1)/2+50, (height-1)/8*5, box_l/2, box_w, "Katakana");
   kanji = new qbox((width-1)/2+50, (height-1)/8*6, box_l/2, box_w, "Kanji");
   
   
   box_h = (int)(width-(10*(num_choice-1)+101))/num_choice;

   
   //restart box
   restart = new qbox((width-111), 15, 90, 30, "restart");
   //the question box
   dp = new qbox(175, 50, 150, 100, 0);   
   //reading box
   reading = new qbox(150, 180, 200, 50, 0);
   //loading questions 
   question = new box[num_choice];
   

   field_l = (height/5)*3;
   field_w = 51;
   //creating choice box
   for(int i=0;i<num_choice;i++) {
         question[i] = new qbox(field_w, field_l, box_h, box_h, 0);
         field_w += box_h + 10;
   } 

}

void draw() 
{
   background(1);
   
   if(game) {
      
      textAlign();
      fill(0,200,200);
      text("number of Correct= " + score, 0, 15);
      fill(200,50,50);
      text("number of Wrong= " + wrong, 0, 35);
      fill(250);
      text("rounds= " + rounds, 0, 55);
      //update();
      textAlign(CENTER,CENTER);
      restart.displays();
      if(kanji.strokes == true)
         reading.displays();
      //textAlign(CENTER,CENTER);
      for(int j=0;j<num_choice;j++) {     
        dp.display(true);
        question[j].display(false);
      }
      
   }
   else{
      textAlign(CENTER,CENTER);   
      start_menu();
   }
}

void mouseClicked() {
   for(int i=0;i<num_choice;i++)
     question[i].strokes = false; 

   if(game) {
      if(restart.over()){
         score = wrong = rounds = 0;
         game = false;
         answered = false;
      }
      else {
         if(answered == true) {
            answered = false;
            for(int i=0;i<num_choice;i++)
               question[i].strokes = false;           
            next_question();
         }
         else {   
            for(int j=0;j<num_choice;j++) {
               if(question[j].over()) {
               //check if answer is correct
                  if(question[j].value == dp.value) {
                     score++;
                     question[j].strokes = true;
                     question[j].currentColor = color(0,200,200);
                  }
                  else {
                     wrong++;
                     question[j].strokes = true;
                     question[j].currentColor = color(200,50,50);
                     for(i=0;i<num_choice;i++) {
                        if(question[i].value == dp.value) {
                           question[i].strokes = true;
                           question[i].currentColor = color(0,200,200);                        
                        }
                     }                    
                  }
                     //change rounds
                     answered = true;               			
                  return;
               }
            }
         }
      }
   } 
   else {
      if(hira.over()){
         hira.strokes = true;
         kata.strokes = false;
         kanji.strokes = false;
      }
      if(kata.over()){
         kata.strokes = true;
         hira.strokes = false;
         kanji.strokes = false;
      }
      if(kanji.over()){
         kanji.strokes = true;
         kata.strokes = false;
         hira.strokes = false;
      }
      if(quick_game.over()){
         start_game(1);
      }
      if(basic_game.over()){
         start_game(1);
      }
   } 
}
void start_game(int type){
   if(type == 1) {
      if(hira.strokes){
         lines = loadStrings("hiragana.txt");
      }
      if(kata.strokes){
         lines = loadStrings("katakana.txt");
      }
      if(kanji.strokes){
         lines = loadStrings("kanji_1.txt");
      }
      game = true;
      next_question();
   }

}
void start_menu() {

   //textAlign(CENTER,CENTER);
   quick_game.displays();
   basic_game.displays();
   Inter_game.displays();
   Advance_game.displays();
   Options.displays();
   hira.displays();
   kata.displays();
   kanji.displays();
}

void next_question() {
	rounds++;
	//changing word
    int ran = int(random(lines.length));
    //array of num 
    int [] num = new num[num_choice];
    for(int i=0; i<num_choice;i++)
      num[i]= 0;
    String [] quest = split(lines[ran], ':');
    //choosing which box question
    int ans = int(random(num_choice));
    //put answer number into num[] 
	dp.add(quest);
   int j;
   for(i=0;i<num_choice;i++){
      num[i] = int(random(lines.length));
      for(j=0;j<i;j++) {
         if(num[j] == num[i] || num[i] == ran){
            num[i] = int(random(lines.length));
            j--;
         }
      }
      qchoice = split(lines[num[i]], ":");
      question[i].add(qchoice);     
   }
   question[ans].add(quest);
   if(kanji.strokes == true)
      reading.name = quest[2]; 
}


class box {
   int x, y;
   int size, sizew;
   String name;
   String [] value;
   boolean strokes;
   color currentColor;
   
   boolean overRect(int x, int y, int width, int height) {
      if (mouseX >= x && mouseX <= x+width && 
         mouseY >= y && mouseY <= y+height) {
         return true;
      } 
      else {
         return false;
      }
   }
   void displays() {
      fill(250);
      if(strokes)
         fill(currentColor);
      rect(x, y, size, sizew);
      fill(0, 100, 250);
      
      text(name, x,y, size, sizew);
      noFill();
   }  
}

class qbox extends box
{
   qbox(int ix, int iy, int isize, int isizew, String ival) {
      x = ix;
      y = iy;
      size = isize;
      sizew= isizew;
		name = ival;
      strokes = false;
      currentColor = color(0,50,100);
   }
   
   void add(String [] ival) {
      value = ival;
   }
   
   boolean over() {
      return overRect(x, y, size, sizew);
   }
   void display(boolean s) {
      fill(255);
      if(strokes)
         fill(currentColor);      
      rect(x, y, size, sizew);
      fill(0, 100, 250);
	  //possible option to switch them
	  if(s)
		text(value[1], x, y, size, sizew);
      else
		text(value[0], x, y, size, sizew);
      
      noFill();
   }
 
} 