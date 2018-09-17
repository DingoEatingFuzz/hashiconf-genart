class Point {
  public float x;
  public float y;
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
  }
}

public class ProductGrid {
  float size;
  float x1;
  float y1;
  float x2;
  float y2;
  
  public ProductGrid(float size, float x1, float y1, float x2, float y2) {
    this.size = size;
    this.x1 = x1;
    this.x2 = x2;
    this.y1 = y1;
    this.y2 = y2;
  }
  
  public void vagrantGrid() {  
    repeatVertical(size, x1, y1, x2, y2);
    repeatDown30(size, x1, y1, x2, y2);
    repeatUp30(size, x1, y1, x2, y2);
  }
  
  public void packerGrid() {
    repeatVertical(size, x1, y1, x2, y2);
    repeatDown30(size, x1, y1, x2, y2);
  }
  
  public void terraformGrid() {
    repeatVertical(size, x1, y1, x2, y2);
    repeatUp30(size, x1, y1, x2, y2);
  }
  
  public void vaultGrid() {
    repeatHorizontal(size, x1, y1, x2, y2);
    repeatDown60(size, x1, y1, x2, y2);
    repeatUp60(size, x1, y1, x2, y2);
  }
  
  public void consulGrid() {
    repeatVertical(size * 2, x1, y1, x2, y2);
    repeatDown30(size * 2, x1, y1, x2, y2);
    repeatUp30(size * 2, x1, y1, x2, y2);
    repeatCircles(size * 2, x1, y1, x2, y2);
  }
  
  public void nomadGrid() {
    repeatDown30(size, x1, y1, x2, y2);
    repeatUp30(size, x1, y1, x2, y2);
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

  void constrainedCircle(float x, float y, float r, float xLow, float yLow, float xHigh, float yHigh) {
    // Collect all intersection points
    ArrayList<Point> intersections = new ArrayList<Point>();
    // Across the four line segments of the bounding box
    intersections.addAll(circleLineIntersections(xLow, yLow, xHigh, yLow, x, y, r/2, false)); // top
    intersections.addAll(circleLineIntersections(xLow, yLow, xLow, yHigh, x, y, r/2, false)); // left
    intersections.addAll(circleLineIntersections(xHigh, yLow, xHigh, yHigh, x, y, r/2, true)); // right
    intersections.addAll(circleLineIntersections(xLow, yHigh, xHigh, yHigh, x, y, r/2, true)); // bottom
    
    // Intersections are in clockwise order. Draw the arcs between intersections if the arcs are in the bounding box
    int count = intersections.size();
    for (int i = 0; i < count; i++) {
      Point pt = intersections.get(i);
      Point pt2 = i + 1 >= count ? intersections.get(0) : intersections.get(i + 1);
      Point circ = new Point(x, y);
      
      boolean isVertical = pt.x == pt2.x;
      boolean isHorizontal = pt.y == pt2.y;
      
      float start = atan2(pt.y - circ.y, pt.x - circ.x);
      float end = atan2(pt2.y - circ.y, pt2.x - circ.x);
      
      if (count == 2) {
        // draw the arc whose normal vector points into the rectangle
        PVector normalVector = new PVector(pt2.x - pt.x, pt2.y - pt.y).rotate(HALF_PI).setMag(20);
        if (isPointInRect(pt.x - normalVector.x, pt.y - normalVector.y, xLow, yLow, xHigh, yHigh)) {
          drawArc(x, y, r, start, end);
        }
      } else if (!isVertical && !isHorizontal) {
        // draw the arcs that aren't horizontal or vertical
        drawArc(x, y, r, start, end);
      }
    }
    
    // If there are no intersections and the circle is in the bounding box, just draw the circle
    if (count == 0 && x > xLow && x < xHigh && y > yLow && y < yHigh) {
      ellipse(x, y, r, r);
    }
  }
  
  boolean isPointInRect(float px, float py, float rx1, float ry1, float rx2, float ry2) {
    return px > rx1 && px < rx2 && py > ry1 && py < ry2;
  }
  
  void drawArc(float x, float y, float r, float start, float end) {
    if (start < 0) {
      start += TWO_PI;
    }
    if (end < 0) {
      end += TWO_PI;
    }
    arc(x, y, r, r, start, end);
    if (start > end) {
      arc(x, y, r, r, start, TWO_PI);
      arc(x, y, r, r, 0, end);
    }
  }
  
  float[] quadratic(float a, float b, float c) {
    float root = sqrt(b * b - 4 * a * c);
    return new float[]{ (-b - root) / (2 * a), (-b + root) / (2 * a) };
  }
  
  ArrayList<Point> circleLineIntersections(float lx1, float ly1, float lx2, float ly2, float cx, float cy, float r, boolean reverse) {
    ArrayList<Point> intersections = new ArrayList<Point>();
    boolean isVertical = lx2 - lx1 == 0;
    
    if (isVertical) {
      // (x - cx)^2 + (y - cy)^2 = r^2
      // (lx1 - cx)^2 + (y - cy)^2 = r^2
      // (y - cy)^2 = r^2 - (lx1 - cx)^2
      // y - cy = (+/-)sqrt(r^2 - (lx1 - cx)^2)
      // y = sqrt(r^2 - (lx1 - cx)^2) + cy
      float root = sqrt(r * r - (lx1 - cx) * (lx1 - cx));
      float[] yCoords = new float[]{ root + cy, -root + cy };
      if (reverse) {
        yCoords = reverse(yCoords);
      }
      for (int i = 0; i < yCoords.length; i++) {
        if (yCoords[i] > ly1 && yCoords[i] < ly2) {
          intersections.add(new Point(lx1, yCoords[i]));
        }
      }
      return intersections;
    } else {
      float slope = isVertical ? Float.MAX_VALUE : (ly2 - ly1) / (lx2 - lx1);
      float yInt = ly1 - slope * lx1;
      
      // Quadratic form of this circle and this line segment
      float a = slope * slope + 1;
      // 2(mc−mq−p)
      float b = 2 * (slope * yInt - slope * cy - cx);
      // (q^2−r^2+p^2−2cq+c^2)
      float c = cy * cy - r * r + cx * cx - 2 * yInt * cy + yInt * yInt;
      float delta = b * b - 4 * a * c;
      
      // Line either does not intersect or lies tangent
      if (delta <= 0) {
        return intersections;
      }
      
      float[] xCoords = quadratic(a, b, c);
      if (reverse) {
        xCoords = reverse(xCoords);
      }
      for (int i = 0; i < xCoords.length; i++) {
        if (xCoords[i] > lx1 && xCoords[i] < lx2) {
          intersections.add(new Point(xCoords[i], slope * xCoords[i] + yInt));
        }
      }
      return intersections;
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
  
  void repeatCircles(float size, float x1, float y1, float x2, float y2) {
    float tHeight = size * sqrt(3) / 2;
    float y = y1 - size / 2;
    float x = x1 - tHeight;
    float r = size * 4 / 3;
    while (y < y2 + size / 2) {
      while (x < x2 + tHeight) {
        constrainedCircle(x, y, r, x1, y1, x2, y2);
        constrainedCircle(x + tHeight, y + size / 2, r, x1, y1, x2, y2);
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
}
