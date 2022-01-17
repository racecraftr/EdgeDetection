PImage img; //image variable
String filename; //only beginning of filename, don't add filetype (filetype being the ending, such as ".jpeg", ".png", etc.)
float percentDifference;


void setup(){
  size(640, 360);
  filename = "test-image-1";
  percentDifference = 11.5; //the minimum difference in greyscale for it to be an edge
  img = loadImage(filename + ".jpeg");
  noLoop(); //only runs the draw() function once
}

void draw(){
 image(img, 0, 0, width, height); 
 //find edges on the x axis
 for(int x = 0; x < width - 1; x++){
   for(int y = 0; y < height; y++){
     detectEdge(x, y, x+1, y);
   }
 }
 //find edges on the y axis
  for(int x = 0; x < width; x++){
   for(int y = 0; y < height - 1; y++){
     detectEdge(x, y, x, y+1);
   }
 }
}

//edge detection - detects and shows edges.
void detectEdge(int x1, int y1, int x2, int y2){
  //get colors
  color c1 = get(x1, y1);
  color c2 = get(x2, y2);
  
  //get greyscale valuses
  float g1 = .299 * red(c1) + .587 * green(c1) + .114 * blue(c1) + 0.0001;
  float g2 = .299 * red(c2) + .587 * green(c2) + .114 * blue(c2) + 0.0001;
  
  //compare edges
  if((g2 - g1)/g1 * 100>= percentDifference){
   set(x1, y1, color(255, 0, 0)); //set pixel to a red color
  }
}

//scrambling method - very interesting
void scramblePixel(int x1, int y1, int x2, int y2){
  float r1 = red(get(x1, y1));
  float g1 = green(get(x1, y1));
  float b1 = blue(get(x1, y1));
  
  float r2 = red(get(x2, y2));
  float g2 = green(get(x2, y2));
  float b2 = blue(get(x2, y2));
  
  float threshhold = percentDifference;
  
  //add very small value in case r1 = 0
  float rDiff = abs(r2-r1)/(r1 + 0.000000001) * 100;
  float gDiff = abs(g2-g1)/(g1 + 0.000000001) * 100;
  float bDiff = abs(b2-b1)/(b1 + 0.000000001) * 100;
  
  float m = 0.01;
  float mu = 1 + m;//multiply up; increase by (m*100)%
  float md = 1 - m;//multiply down; decrease by (m*100)%
  
  if(rDiff > threshhold){
    if(r1 > r2){
      r1 *= md;
      r2 *= mu;
    }
    if(r2 > r1){
      r1 *= mu;
      r2 *= md;
    }
  }
  if(gDiff > threshhold){
    if(g1 > g2){
      g1 *= md;
      g2 *= mu;
    }
    if(r2 > r1){
      g1 *= mu;
      g2 *= md;
    }
  }
  if(bDiff > threshhold){
    if(b1 > b2){
      b1 *= md;
      b2 *= mu;
    }
    if(r2 > r1){
      b1 *= mu;
      b2 *= md;
    }
  }
  color c1 = color(r1, g1, b1);
  color c2 = color(r2, g2, b2);
  
  set(x1, y1, c1);
  set(x2, y2, c2);
}

//save version with edges detected
void mouseClicked(){
  saveFrame(filename + "-edges.jpg");
}
