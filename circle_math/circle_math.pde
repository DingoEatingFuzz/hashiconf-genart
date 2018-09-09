float p = 150;

void setup() {
  size(1200, 1200);
  smooth(2);
  noFill();
  background(20);
  stroke(255);
  
  for (int i = 0; i < 75; i++) {
    constrainedCircle(random(p, width - p), random(p, height - p), random(30, 250), p, p, width - p, height - p);
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


class Point {
  public float x;
  public float y;
  public Point(float x, float y) {
    this.x = x;
    this.y = y;
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
