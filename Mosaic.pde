Tile[] tiles;
int size = 10;  // size of pixel block to replace

void setup() {
  PImage img = loadImage("Melbourne.jpg");
  size(img.width, img.height);
  background(255);
  loadTiles();
  img.loadPixels();
  for (int x=0; x<img.width; x+=size) {
    for (int y=0; y<img.height; y+=size) {
      color c = avgRGB(img, x, y, size);
      if (red(c) + green(c) + blue(c) < 700) { // only replace those that are not the white background
        int i = findTile(c);
        image(tiles[i].img, x, y);
      }
    }
  }
  save("output.png");
} // end setup()

// Compute average r, g, b for the pixel block (x, y, s, s) in img, and return as a single color
color avgRGB(PImage img, int x, int y, int s) {
  float r=0, g=0, b=0;
  for (int i=x; i<x+s; i++) {
    for (int j=y; j<y+s; j++) {
      color c = img.pixels[y*img.width+x];
      r+= red(c);
      g+= green(c);
      b+= blue(c);
    }
  }
  r/=s*s;
  g/=s*s;
  b/=s*s;
  return color(r, g, b);
} // end avgRGB()

// load all the files of .png format in data/ into the tiles array
void loadTiles() {
  java.io.File folder = new java.io.File(dataPath("")); // reads tiles from data folder
  // filter to weed out those that don't end with .png from the file name list
  java.io.FilenameFilter imgNameFilter = new java.io.FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.toLowerCase().endsWith(".png") && !name.contains("@");
    }
  };
  // get the list of file names with filter applied  
  String[] fileNames = folder.list(imgNameFilter); 
  // create the tile array now that we know the length  
  tiles = new Tile[fileNames.length]; 
  for (int i = 0; i < fileNames.length; i++) {
    tiles[i] = new Tile(loadImage(fileNames[i]), size);
  }
} // end loadTiles()

// returns the index of the tile that is the closest match to input color c
int findTile(color c){
  float minDist = (255 * 3 ) + 1  ;    // initialize to be larger than the largest possible distance
  int minIdx = -1;
  for (int i=0; i<tiles.length; i++) {
    float d = dist(red(c), green(c), blue(c), tiles[i].avgR, tiles[i].avgG, tiles[i].avgB);
    if (d<minDist) {
      minDist = d;
      minIdx = i;
    }
  }
  return minIdx;
} // end findTile()
