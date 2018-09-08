void setup() {
  size(1200, 1200);
  smooth(2);
  
  background(20);
  stroke(255);
  strokeWeight(1);
  noFill();
  
  int padding = 50;
  
  // vagrantGrid(50, padding, padding, width - padding, height - padding);
  // packerGrid(50, padding, padding, width - padding, height - padding);
  //terraformGrid(50, padding, padding, width - padding, height - padding);
  vaultGrid(50, padding, padding, width - padding, height - padding);
}

void constrainedLine(float x, float y, float ang, float xLimit, float yLimit) {
  float sinA = sin(ang);
  float sinB = sin(HALF_PI - ang);
  float xOffset = ((yLimit - y) / sinA) * sinB;
  if (x + xOffset > xLimit) {
    float yOffset = ((xLimit - x) / sinB) * sinA;
    line(x, y, xLimit, y + yOffset);
  } else {
    line(x, y, x + xOffset, yLimit);
  }
}

void repeatVertical(float size, float x1, float y1, float x2, float y2) {
  // Vertical lines from left to right
  float tHeight = size * sqrt(3) / 2;
  float x = x1 + tHeight;
  while (x < x2) {
    line(x, y1, x, y2);
    x += tHeight;
  }
}

void repeatHorizontal(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float y = y1 + tHeight;
  while (y < y2) {
    line(x1, y, x2, y);
    y += tHeight;
  }
}

void repeatDown30(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float x = x1;
  float y = y1;
  
  // 30deg lines from top-left to bottom-left
  while (y < y2) {
    constrainedLine(x, y, radians(30), x2, y2);
    y += size;
  }
  
  // 30 deg lines from top-left to top-right;
  y = y1;
  x += tHeight * 2;
  while(x < x2) {
    constrainedLine(x, y, radians(30), x2, y2);
    x += tHeight * 2;
  }
}

void repeatUp30(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float y = y1;
  float x = x1;
  
  // -30deg lines from top-left to bottom-left
  while(y < y2) {
    constrainedLine(x, y, radians(-30), x2, y1);
    y += size;
  }
  
  // -30deg lines from bottom-left to bottom-right
  x += tHeight * 2 * ((y - y2) / size); // start x proportionally based on the remainder between y and the max y)
  y = y2;
  while(x < x2) {
    constrainedLine(x, y, radians(-30), x2, y1);
    x += tHeight * 2;
  }
}

void repeatDown60(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float x = x1;
  float y = y1;
  
  // 30deg lines from top-left to bottom-left
  while (y < y2) {
    constrainedLine(x, y, radians(60), x2, y2);
    y += tHeight * 2;
  }
  
  // 30 deg lines from top-left to top-right;
  y = y1;
  x += size;
  while(x < x2) {
    constrainedLine(x, y, radians(60), x2, y2);
    x += size;
  }
}

void repeatUp60(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float y = y1;
  float x = x1;
  
  // -30deg lines from top-left to bottom-left
  while(y < y2) {
    constrainedLine(x, y, radians(-60), x2, y1);
    y += tHeight * 2;
  }
  
  // -30deg lines from bottom-left to bottom-right
  x += size * ((y - y2) / (tHeight * 2)); // start x proportionally based on the remainder between y and the max y)
  y = y2;
  while(x < x2) {
    constrainedLine(x, y, radians(-60), x2, y1);
    x += size;
  }
}


void vagrantGrid(float size, float x1, float y1, float x2, float y2) {  
  repeatVertical(size, x1, y1, x2, y2);
  repeatDown30(size, x1, y1, x2, y2);
  repeatUp30(size, x1, y1, x2, y2);
}

void packerGrid(float size, float x1, float y1, float x2, float y2) {
  repeatVertical(size, x1, y1, x2, y2);
  repeatDown30(size, x1, y1, x2, y2);
}

void terraformGrid(float size, float x1, float y1, float x2, float y2) {
  repeatVertical(size, x1, y1, x2, y2);
  repeatUp30(size, x1, y1, x2, y2);
}

void vaultGrid(float size, float x1, float y1, float x2, float y2) {
  repeatHorizontal(size, x1, y1, x2, y2);
  repeatDown60(size, x1, y1, x2, y2);
  repeatUp60(size, x1, y1, x2, y2);
}

void consulGrid() {
}

void nomadGrid(float size, float x1, float y1, float x2, float y2) {
  repeatDown30(size, x1, y1, x2, y2);
  repeatUp30(size, x1, y1, x2, y2);
}
