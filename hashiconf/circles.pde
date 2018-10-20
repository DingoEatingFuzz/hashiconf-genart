import java.util.Collections;
import java.util.Comparator;

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

public class ConstrainedCircleFactory extends ConstrainedShapeFactory {
  public void circle(float x, float y, float r, Point[] polygon) {
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
      PVector normalVector = new PVector(pt.x - x, pt.y - y).setMag(2);
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

  ArrayList<Point> circleLineIntersections(Point l1, Point l2, Point circleCenter, float r) {
    float lx1 = l1.x;
    float ly1 = l1.y;
    float lx2 = l2.x;
    float ly2 = l2.y;
    float cx = circleCenter.x;
    float cy = circleCenter.y;

    ArrayList<Point> intersections = new ArrayList<Point>();
    PVector vector = new PVector(lx2 - lx1, ly2 - ly1);
    boolean isVertical = lx2 == lx1;

    // Lines must be oriented left to right for the upcoming math to work
    if (lx1 - lx2 > 0.001) {
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
        if (yCoords[i] > ly1 && yCoords[i] < ly2 || yCoords[i] > ly2 && yCoords[i] < ly1) {
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
        if (xCoords[i] > lx1 && xCoords[i] < lx2 || xCoords[i] > lx2 && xCoords[i] < lx1) {
          intersections.add(new Point(xCoords[i], slope * xCoords[i] + yInt));
        }
      }
      return intersections;
    }
  }

  float[] quadratic(float a, float b, float c) {
    float root = sqrt(b * b - 4 * a * c);
    return new float[]{ (-b - root) / (2 * a), (-b + root) / (2 * a) };
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

    noFill();
    arc(x, y, r, r, start, end, OPEN);
    if (start > end) {
      arc(x, y, r, r, start, TWO_PI, OPEN);
      arc(x, y, r, r, 0, end, OPEN);
    }
  }
}
