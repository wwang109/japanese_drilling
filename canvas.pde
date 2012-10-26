box [] question;
box box1;

int num_choice=5, rounds=0, num_rounds=20;
int score, wrong;
float box_h, field_w, field_l;
int output = 0;
String [] lines;

boolean lock = false;
void setup() 
{ 
   size(501, 501);
   //setting
   box_h = (float)(width-(10*(num_choice-1)+101))/num_choice;
   field_l = (height/5)*3;
   field_w = 51;
   //setting end
   //loading questions
   lines = loadStrings("hiragana.txt");  
   question = new box[num_choice];
   
   //big box
   box1 = new qbox(175, 50, 150, 100, 0);

   //creating choice box
   for(int i=0;i<num_choice;i++) {
         question[i] = new qbox(field_w, field_l, box_h, box_h, 0);
         field_w += box_h + 10;
   } 
   next_question();
}

void draw() 
{

   background(50);

   textAlign(LEFT);
   text("number of Correct= " + score, 0, 10);
   text("number of Wrong= " + wrong, 0, 20);
   text("rounds= " + rounds, 0, 30);
   //update();
   textAlign(CENTER);

   for(int j=0;j<num_choice;j++) {
	  textSize(30);
	  fill(250);
	  box1.display(true);
      question[j].display(false);
   }   

}

void mouseClicked() {
      for(int j=0;j<num_choice;j++) {
         if(question[j].over()) {
			//check if answer is correct
			if(question[j].value == box1.value)
				score++;
			else
				wrong++;
            //change rounds
			next_question();			
            return;
            }
   }

}
void next_question() {
	rounds++;
	//changing word
    int ran = int(random(lines.length));
    String [] quest = split(lines[ran], ':');
    //choosing which box question
    int ans = int(random(num_choice));
	box1.add(quest);
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
   
   boolean overRect(int x, int y, int width, int height) {
      if (mouseX >= x && mouseX <= x+width && 
         mouseY >= y && mouseY <= y+height) {
         return true;
      } 
      else {
         return false;
      }
   }

}

class qbox extends box
{
   qbox(int ix, int iy, int isize, int isizew, String [] ival) {
      x = ix;
      y = iy;
      size = isize;
      sizew= isizew;
	  if(ival)
		value = ival;
   }
   
   void add(String [] ival) {
      value = ival;
   }
   
   boolean over() {
      return overRect(x, y, size, sizew);
   }
   void display(boolean s) {
      //stroke(255);
      fill(250);
      rect(x, y, size, sizew);
      fill(0, 100, 200);
	  //possible option to switch them
	  if(s)
		text(value[0], x+(size/2), y+(sizew/2)+10);
      else
		text(value[1], x+(size/2), y+(sizew/2)+10);
   }
} 