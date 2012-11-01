qbox [] question, kanji_mode;
qbox dp, restart;
qbox quick_game, option1, option2, option3;
qbox Options, hira, kata, kanji;
boolean game = false;
boolean answered = false;
int edge = 50;
int num_choice=4, rounds=0;
int score, wrong;
float box_h, field_w, field_l;
int output = 0;
String [] lines;

void setup() 
{ 
   size(501, 501);

   int box_l = 300, box_w = 50;
   quick_game = new qbox((width-1)/2-(box_l/2), (height-1)/10*2, box_l, box_w, "Start Game");
   //option box
   option1 = new qbox(edge+ (box_l/3)+20,(height-1)/10*4, box_l, box_w, "Place holder");
   option2 = new qbox(edge+ (box_l/3)+20,(height-1)/10*5.2, box_l, box_w, "Place holder");
   option3 = new qbox(edge+ (box_l/3)+20,(height-1)/10*6.4, box_l, box_w, "Place holder");
   
   hira = new qbox(edge,(height-1)/10*4, box_l/3, box_w, "Hiragana");
   hira.strokes = true;
   kata = new qbox(edge,(height-1)/10*5.2, box_l/3, box_w, "Katakana");
   kanji = new qbox(edge,(height-1)/10*6.4, box_l/3, box_w, "Kanji");
   kanji_mode = new qbox[7];
   for(int i=0;i<7;i++) {
      kanji_mode[i] = new qbox(edge+(50*i), (height-1)/10*8, box_w, box_w, i);
   }
   
   box_h = (int)(width-(10*(num_choice-1)+101))/num_choice;

   //restart box
   restart = new qbox((width-111), 15, 90, 30, "restart");
   //the question box
   dp = new qbox(175, 50, 150, 100, 0);   
   //reading box
   reading = new qbox(150, 180, 200, 50, 0);
   //loading questions 
   question = new qbox[num_choice];
   

   field_l = (height/5)*3;
   field_w = 51;
   //creating choice box
   for(i=0;i<num_choice;i++) {
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
      if(kanji.strokes) {
         for(i=0;i<7;i++) {
            if(kanji_mode[i].over()){
               kanji_mode[i].strokes = !kanji_mode[i].strokes;
            }
         }
      }
      if(quick_game.over()){
         start_game();
      }
   } 
}
void start_game(){
   lines = null;
   if(hira.strokes){
      lines = loadStrings("hiragana.txt");
   }
   if(kata.strokes){
      lines = loadStrings("katakana.txt");
   }
   if(kanji.strokes){
      for(int i=0,k =0;i<7;i++) {
         if(kanji_mode[i].strokes ==true) {
            if(lines == null)
               lines = loadStrings("kanji_"+ i + ".txt");
            else   
               lines = concat(lines, loadStrings("kanji_"+ i + ".txt"));
         k++;
         }
      }
      if(k==0)
         return; //get out of here if none selected
   }   
         
      game = true;
      next_question();

}
void start_menu() {

   textAlign(CENTER,CENTER);
   quick_game.displays();
   fill(150);
   text("Choose Options", (width-1)/2-(100), (height-1)/10*3, 200, 50);
   
   noFill();
   if(kanji.strokes == true) {
      text("kenji levels: click to include or remove from pool of words", edge, (height-1)/10*7.2, 350, 50);
      for(int i =0;i<7;i++)
         kanji_mode[i].displays();
         
   }
   
   option1.displays();
   option2.displays();
   option3.displays();
   
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