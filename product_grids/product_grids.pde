void setup() {
  size(1200, 1200);
  smooth(2);
  
  background(20);
  stroke(255);
  strokeWeight(1);
  noFill();
  
  int padding = 50;
  
  vagrantGrid(15, padding, padding, width - padding, height - padding);
}

void vagrantGrid(float size, float x1, float y1, float x2, float y2) {
  float x = x1 + size * sqrt(3) / 2;
  while (x < x2) {
    line(x, y1, x, y2);
    x += size * sqrt(3) / 2;
  }
  
  x = x1;
  float y = y1;
  while (y < y2) {
    float xOffset = ((y2 - y) / sin(radians(30))) * sin(radians(60));
    if (x + xOffset > x2) {
      float yOffset = ((x2 - x) / sin(radians(60))) * sin(radians(30));
      line(x, y, x2, y + yOffset);
    } else {
      line(x, y, x + xOffset, y2);
    }
    y += size;
  }
  y = y1;
  x += size * sqrt(3);
  while(x < x2) {
    float xOffset = ((y2 - y) / sin(radians(30))) * sin(radians(60));
    if (x + xOffset > x2) {
      float yOffset = ((x2 - x) / sin(radians(60))) * sin(radians(30));
      line(x, y, x2, y + yOffset);
    } else {
      line(x, y, x + xOffset, y2);
    }
    x += size * sqrt(3);
  }
  
  y = y1;
  x = x1;
  while(y < y2) {
    float yOffset = ((x2 - x) / sin(radians(60))) * sin(radians(30));
    if (y - yOffset < y1) {
      float xOffset = ((y - y1) / sin(radians(30))) * sin(radians(60));
      line(x, y, x + xOffset, y1);
    } else {
      line(x, y, x2, y - yOffset);
    }
    y += size;
  }
  float ratio = (y - y2) / size;
  y = y2;
  x += (size * sqrt(3)) * ratio;
  while(x < x2) {
    float yOffset = ((x2 - x) / sin(radians(60))) * sin(radians(30));
    if (y - yOffset < y1) {
      float xOffset = ((y - y1) / sin(radians(30))) * sin(radians(60));
      line(x, y, x + xOffset, y1);
    } else {
      line(x, y, x2, y - yOffset);
    }
    x += size * sqrt(3);
  }
}

void packerGrid() {
}

void terraformGrid() {
}

void vaultGrid() {
}

void consulGrid() {
}

void nomadGrid() {
}
