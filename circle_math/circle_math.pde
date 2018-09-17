import java.util.Collections;
import java.util.Comparator;

float p = 150;
Point[] bounds;
Point[] star;

void setup() {
  size(1200, 1200);
  smooth(2);
  noFill();
  background(20);
  stroke(255);
  textSize(18);

  bounds = new Point[]{
    new Point(p, p),
    new Point(width - p, p),
    new Point(width - p, height - p),
    new Point(p, height - p)
  };

  star = makeStar(width / 2, height / 2, 5, 150, 400);

  for (int i = 0; i < 2000; i++) {
    constrainedCircle(random(p, width - p), random(p, height - p), random(10, 50), star);
  }
}

//void draw() {
//  clear();
//  strokeWeight(1);
//  stroke(255);
//  drawPolygon(bounds);
//  drawPolygon(star);

//  constrainedCircle(mouseX, mouseY, 150, star);
//}

void drawPolygon(Point[] polygon) {
  for (int i = 0; i < polygon.length; i++) {
    Point p1 = polygon[i];
    Point p2 = i != polygon.length - 1 ? polygon[i + 1] : polygon[0];
    line(p1.x, p1.y, p2.x, p2.y);
  }
}

Point[] makeStar(float x, float y, int sides, float innerRadius, float outerRadius) {
  float step = TWO_PI / (sides * 2);
  Point[] points = new Point[]{};
  for (int i = 0; i < sides * 2; i++) {
    float r = i % 2 == 0 ? outerRadius : innerRadius;
    float ang = step * i - (TWO_PI / (sides * 4));
    points = (Point[])append(points, new Point(x + cos(ang) * r, y + sin(ang) * r));
  }
  return points;
}

public class CircleIntersectionComparable implements Comparator<Point> {
  Point center;

  public CircleIntersectionComparable(Point center) {
    this.center = center;
  }

  public int compare(Point p1, Point p2) {
    float a1 = atan2(p1.y - center.y, p1.x - center.x);
    float a2 = atan2(p2.y - center.y, p2.x - center.x);
    if (a1 == a2) return 0;
    if (a1 < a2) return -1;
    return 1;
  }
}

void constrainedCircle(float x, float y, float r, Point[] polygon) {
  // Collect all intersection points
  ArrayList<Point> intersections = new ArrayList<Point>();
  Point circ = new Point(x, y);
  for (int i = 0; i < polygon.length; i++) {
    Point p1 = polygon[i];
    Point p2 = i != polygon.length - 1 ? polygon[i + 1] : polygon[0];
    intersections.addAll(circleLineIntersections(p1, p2, circ, r/2));
  }

  Collections.sort(intersections, new CircleIntersectionComparable(circ));

  // Intersections are in clockwise order. Draw the arcs between intersections if the arcs are in the bounding box
  int count = intersections.size();
  for (int i = 0; i < count; i++) {
    Point pt = intersections.get(i);
    Point pt2 = i + 1 >= count ? intersections.get(0) : intersections.get(i + 1);

    float start = atan2(pt.y - circ.y, pt.x - circ.x);
    float end = atan2(pt2.y - circ.y, pt2.x - circ.x);

    // follow the arc to see if the arc is in the bounds
    PVector normalVector = new PVector(pt.x - x, pt.y - y).setMag(1);
    normalVector.rotate(HALF_PI);
    if (isPointInPolygon(pt.x + normalVector.x, pt.y + normalVector.y, polygon)) {
      drawArc(x, y, r, start, end);
    }
  }

  // If there are no intersections and the circle is in the bounding box, just draw the circle
  if (count == 0 && isPointInPolygon(x, y, polygon)) {
    ellipse(x, y, r, r);
  }
}

boolean isPointInPolygon(float px, float py, Point[] polygon) {
  // draw horizontal line from px,py to infinity,py
  Point p1 = new Point(px, py);
  Point p2 = new Point(1000000, py);
  int intersections = 0;
  // test for intersections with every line in polygon
  for (int i = 0; i < polygon.length; i++) {
    Point q1 = polygon[i];
    Point q2 = i != polygon.length - 1 ? polygon[i + 1] : polygon[0];

    // The point is on the perimeter, which counts as inside
    if (linesIntersect(p1, p2, q1, q2)) {
      if (angleOrientation(q1, p1, q2) == 0) {
        return pointIsOnSegment(p1, q1, q2);
      }
      intersections++;
    }
  }

  // An odd number of intersections means the point is in the polygon.
  // Every time the horizontal line intersects with the perimeter of the polygon,
  // the line is either entering or exiting the polygon.
  // Since we know that the line ends outside of the polygon, we also know that the last intersection
  // is an exit. This means that the intersections follows either the pattern
  // enter, exit, enter, exit (even)
  // exit, enter, exit, enter, exit (odd)
  // Note that for an odd number of intersections, the first intersection has to be an exit, meaning the point
  // was in the polygon to begin with.
  return intersections % 2 == 1;
}

boolean pointIsOnSegment(Point test, Point line1, Point line2) {
  if (
    test.x <= max(line1.x, line2.x) && test.x >= min(line1.x, line2.x) &&
    test.y <= max(line1.y, line2.y) && test.y >= min(line1.y, line2.y)
  ) {
    return true;
  }
  return false;
}

int angleOrientation(Point p, Point q, Point r) {
  float val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y);
  if (val == 0) return 0; // colinear
  return val > 0 ? 1 : 2; // 1 is clockwise, 2 is counterclockwise
}

boolean linesIntersect(Point p1, Point q1, Point p2, Point q2) {
  int o1 = angleOrientation(p1, q1, p2);
  int o2 = angleOrientation(p1, q1, q2);
  int o3 = angleOrientation(p2, q2, p1);
  int o4 = angleOrientation(p2, q2, q1);

  if (o1 != o2 && o3 != o4) return true;

  // Colinearity cases
  if (o1 == 0 && pointIsOnSegment(p2, p1, q1)) return true;
  if (o2 == 0 && pointIsOnSegment(q2, p1, q1)) return true;
  if (o3 == 0 && pointIsOnSegment(p1, p2, q2)) return true;
  if (o4 == 0 && pointIsOnSegment(q1, p2, q2)) return true;

  return false;
}

void drawArc(float x, float y, float r, float start, float end) {
  if (start < 0) {
    start += TWO_PI;
  }
  if (end < 0) {
    end += TWO_PI;
  }

  if (start == end) {
    ellipse(x, y, r, r);
    return;
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

  public String toString() {
    return "{" + this.x + ", " + this.y + "}";
  }
}

float[] quadratic(float a, float b, float c) {
  float root = sqrt(b * b - 4 * a * c);
  return new float[]{ (-b - root) / (2 * a), (-b + root) / (2 * a) };
}

// 4. make it work with lines as well as circles
// 6. apply it to the product grids
// 7. create new comp with product logo in the bottom left and grid filling the rest of the space
// 8. modify comp by adding entropy (circle radius and line spacing)

ArrayList<Point> circleLineIntersections(Point l1, Point l2, Point circleCenter, float r) {
  float lx1 = l1.x;
  float ly1 = l1.y;
  float lx2 = l2.x;
  float ly2 = l2.y;
  float cx = circleCenter.x;
  float cy = circleCenter.y;

  ArrayList<Point> intersections = new ArrayList<Point>();
  PVector vector = new PVector(lx2 - lx1, ly2 - ly1);
  boolean isVertical = lx2 - lx1 == 0;
  if (lx2 < lx1) {
    float tmpx = lx2;
    lx2 = lx1;
    lx1 = tmpx;
    float tmpy = ly2;
    ly2 = ly1;
    ly1 = tmpy;
  }

  // Intersections need to be collected in a clockwise order. Whether points should be collected from
  // left-to-right or right-to-left is based on the angle of the vector of the line segment.
  // If the angle of the line segment is between 270 and 90 (right side), we want ltr, otherwise,
  // we want rtl.
  boolean rtl = isVertical && vector.y > 0 || vector.x < 0;

  if (isVertical) {
    // (x - cx)^2 + (y - cy)^2 = r^2
    // (lx1 - cx)^2 + (y - cy)^2 = r^2
    // (y - cy)^2 = r^2 - (lx1 - cx)^2
    // y - cy = (+/-)sqrt(r^2 - (lx1 - cx)^2)
    // y = sqrt(r^2 - (lx1 - cx)^2) + cy
    float root = sqrt(r * r - (lx1 - cx) * (lx1 - cx));
    float[] yCoords = new float[]{ root + cy, -root + cy };
    if (rtl) {
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
    if (rtl) {
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
