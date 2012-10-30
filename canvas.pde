qbox [] question;
qbox dp, restart;
qbox quick_game, basic_game, Inter_game, Advance_game;
qbox Options, hira, kata, kanji;
boolean game = false;
int num_choice=4, rounds=0;
int score, wrong;
float box_h, field_w, field_l;
int output = 0;
String [] lines;

void setup() 
{ 
   size(501, 501);
   //setting
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
   
   
   box_h = (float)(width-(10*(num_choice-1)+101))/num_choice;
   field_l = (height/5)*3;
   field_w = 51;
   //setting end
   
   //restart box
   restart = new qbox((width-111), 15, 90, 30, "restart");
   
   //loading questions 
   question = new box[num_choice];
   
   
   //the question box
   dp = new qbox(175, 50, 150, 100, 0);
   //creating choice box
   for(int i=0;i<num_choice;i++) {
         question[i] = new qbox(field_w, field_l, box_h, box_h, 0);
         field_w += box_h + 10;
   } 
   //next_question();
}

void draw() 
{
   background(1);
   
   if(game) {
      fill(250);
      textAlign(LEFT);
      text("number of Correct= " + score, 0, 15);
      text("number of Wrong= " + wrong, 0, 35);
      text("rounds= " + rounds, 0, 55);
      //update();
      restart.displays();
      
      textAlign(CENTER);
      for(int j=0;j<num_choice;j++) {
        textSize(30);
        dp.display(true);
        question[j].display(false);
      }
      
   }
   else
      start_menu();
   
}

void mouseClicked() {
   if(game) {
      if(restart.over()){
         score = wrong = round = 0;
         game = false;
      }
      for(int j=0;j<num_choice;j++) {
         if(question[j].over()) {
         //check if answer is correct
            if(question[j].value == dp.value)
               score++;
            else
               wrong++;
               //change rounds
            next_question();			
            return;
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
      game = true;
      next_question();
   }

}
void start_menu() {
   textAlign();
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
    String [] quest = split(lines[ran], ':');
    //choosing which box question
    int ans = int(random(num_choice));
	dp.add(quest);
   for(int i=0;i<num_choice;i++) {
      if(ans == i) {
         question[i].add(quest);
      }
      else {
         ran = int(random(lines.length));
         while(ans == ran) {
            ran = int(random(lines.length));
         }
		 qchoice = split(lines[ran], ":");
         question[i].add(qchoice);
      }
   } 	

}


class box {
   int x, y;
   int size, sizew;
   String [] value;
   boolean strokes;
   
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
         fill(0,50,100);
      rect(x, y, size, sizew);
      fill(0, 100, 250);
      
      //textAlign(CENTER);
      text(value, x + ((size-(value.length*6))/2),y+((sizew+value.length)/2));
      //text(value, x+size-value.length, y+((sizew+value.length)/2));
      noFill();
   }  
}

class qbox extends box
{
   qbox(int ix, int iy, int isize, int isizew, String [] ival) {
      x = ix;
      y = iy;
      size = isize;
      sizew= isizew;
		value = ival;
      strokes = false;
   }
   
   void add(String [] ival) {
      value = ival;
   }
   
   boolean over() {
      return overRect(x, y, size, sizew);
   }
   void display(boolean s) {
      //stroke(255);
      fill(255);
      rect(x, y, size, sizew);
      fill(0, 100, 250);
	  //possible option to switch them
	  if(s)
		text(value[0], x+(size/2), y+(sizew/2)+10);
      else
		text(value[1], x+(size/2), y+(sizew/2)+10);
      
      noFill();
   }
 
} 