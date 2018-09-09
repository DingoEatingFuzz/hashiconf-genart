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
  //vaultGrid(50, padding, padding, width - padding, height - padding);
  //nomadGrid(50, padding, padding, width - padding, height - padding);
  consulGrid(50, padding, padding, width - padding, height - padding);
}

class Point {
  public float x;
  public float y;
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
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

float[] quadratic(float a, float b, float c) {
  float root = sqrt(b * b - 4 * a * c);
  return new float[]{ (-b + root) / 2 * a, (-b - root) / 2 * a };
}

void constrainedCircle(float x, float y, float r, float xLow, float yLow, float xHigh, float yHigh) {
  // draw a circle at x,y with radius r
  // if the circle goes out of bounds, divide the circle into two arcs and only draw the arc inside
  // the bounding box
}

ArrayList<Point> circleLineIntersections(float lx1, float ly1, float lx2, float ly2, float cx, float cy, float r) {
  ArrayList<Point> intersections = new ArrayList<Point>();
  boolean isVertical = lx2 - lx1 == 0;
  float slope = isVertical ? 0 : (ly2 - ly1) / (lx2 - lx1);
  // b = ly1
  // c = cx
  // m = slope
  // d = cy
  // r = r
  // (x - cx)^2 + (mx + ly1 - cy)^2 = r^2
  //float numerator = 
  //float ix = (sqrt(-(ly1*ly1) - 2 * ly1 * cx * cy - cx * cx * slope * slope + 2 * cx * cy * slope - cy * cy + slope * slope * r * r + r * r) - ly1 * slope + cx + cy * slope) / (slope * slope + 1);
  //float iy = ix * slope + ly1;
  //intersections.add(new Point(ix, iy));
  //ix = 
  
  // Quadratic form of this circle and this line segment
  float a = slope * slope + 1;
  float b = 2 * (slope * ly1 - slope * cy - cx);
  float c = cy * cy + r * r + cx * cx - 2 * ly1 * cy + ly1 * ly1;
  float delta = b * b - 4 * a * c;
  
  // Line either does not intersect or lies tangent
  if (delta <= 0) {
    return intersections;
  }
  
  // Both intersections on the infinite line between the two line coordinates
  float[] xCoords = quadratic(a, b, c);
  println(xCoords);
  for (int i = 0; i < xCoords.length; i++) {
    if (xCoords[i] > lx1 && xCoords[i] < lx2) {
      intersections.add(new Point(xCoords[i], slope * xCoords[i] + ly1));
    }
  }
  println(intersections);
  return intersections;
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

void repeatCircles(float size, float x1, float y1, float x2, float y2) {
  float tHeight = size * sqrt(3) / 2;
  float y = y1 - size / 2;
  float x = x1 - tHeight;
  float r = size * 4 / 3;
  while (y < y2 + size / 2) {
    while (x < x2 + tHeight) {
      ellipse(x, y, r, r);
      ellipse(x + tHeight, y + size / 2, r, r);
      x += tHeight * 2;
    }
    x = x1 - tHeight;
    y += size;
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

void consulGrid(float size, float x1, float y1, float x2, float y2) {
  repeatVertical(size * 2, x1, y1, x2, y2);
  repeatDown30(size * 2, x1, y1, x2, y2);
  repeatUp30(size * 2, x1, y1, x2, y2);
  repeatCircles(size * 2, x1, y1, x2, y2);
}

void nomadGrid(float size, float x1, float y1, float x2, float y2) {
  repeatDown30(size, x1, y1, x2, y2);
  repeatUp30(size, x1, y1, x2, y2);
}
