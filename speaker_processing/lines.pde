import java.util.Collections;
import java.util.Comparator;

public class LineIntersectionComparable implements Comparator<Point> {
  public int compare(Point p1, Point p2) {
    if (p1.x != p2.x) {
      float dx = p2.x - p1.x;
      if (dx == 0) return 0;
      if (dx > 0) return -1;
      return 1;
    }
    float dy = p2.y - p1.y;
    if (dy == 0) return 0;
    if (dy > 0) return -1;
    return 1;
  }
}

public class ConstrainedLineFactory extends ConstrainedShapeFactory {
  public void lineSegment(float x1, float y1, float x2, float y2, Point[] polygon) {
    ArrayList<Point> intersections = new ArrayList<Point>();
    Point start = new Point(x1, y1);
    Point end = new Point(x2, y2);
    // Make sure lines are drawn left-to-right
    if (start.x - end.x > 0.001 || abs(start.x - end.x) < 0.001 && start.y > end.y) {
      Point tmp = start;
      start = end;
      end = tmp;
    }
    for (int i = 0; i < polygon.length; i++) {
      Point p1 = polygon[i];
      Point p2 = polygon[(i + 1) % polygon.length];
      Point intersection = lineLineIntersections(p1, p2, start, end);
      if (intersection != null) {
        intersections.add(intersection);
      }
    }

    Collections.sort(intersections, new LineIntersectionComparable());

    int count = intersections.size();
    for (int i = -1; i < count; i++) {
      Point pt1 = i == -1 ? start : intersections.get(i);
      Point pt2 = i + 1 >= count ? end : intersections.get(i + 1);
      Point mid = midPoint(pt1, pt2);
      if (isPointInPolygon(mid.x, mid.y, polygon)) {
        line(pt1.x, pt1.y, pt2.x, pt2.y);
      }
    }

    // If there are no intersections and either the start or the end is in the polygon, draw the line segment
    if (count == 0 && isPointInPolygon(start.x, start.y, polygon)) {
      line(x1, y1, x2, y2);
    }
  }

  public void ray(float x1, float y1, float ang, Point[] polygon) {
    float x2 = x1 + cos(ang) * 1000;
    float y2 = y1 + sin(ang) * 1000;
    lineSegment(x1, y1, x2, y2, polygon);
  }

  Point lineLineIntersections(Point testStart, Point testEnd, Point subjectStart, Point subjectEnd) {
    // A line can intersect another line 0, 1, or infinity times
    // For the infinity times case, we return no points, since it's the functional equivalent as not intersecting

    // Re-orient points to make sure end.x > start.x
    if (testEnd.x > testStart.x) {
      Point tmp = testStart;
      testStart = testEnd;
      testEnd = tmp;
    }

    if (subjectEnd.x > subjectEnd.x) {
      Point tmp = subjectStart;
      subjectStart = subjectEnd;
      subjectEnd = tmp;
    }

    // Exit early if there is no intersection
    if (!linesIntersect(testStart, testEnd, subjectStart, subjectEnd)) return null;
    // Exit early if the lines are colinear
    if (angleOrientation(subjectStart, testStart, subjectEnd) == 0) return null;

    // Finally, calculate the actual intersection
    float testSlope = slope(testStart, testEnd);
    float subjectSlope = slope(subjectStart, subjectEnd);
    float testYInt = testStart.y - testSlope * testStart.x;
    float subjectYInt = subjectStart.y - subjectSlope * subjectStart.x;

    float x;
    float y;

    // Test is vertical case
    if (testSlope == Float.MAX_VALUE) {
      x = testStart.x;
      return new Point(x, subjectSlope * x + subjectYInt);
    }

    // Subject is vertical case
    if (subjectSlope == Float.MAX_VALUE) {
      x = subjectStart.x;
      return new Point(x, testSlope * x + testYInt);
    }

    // Usual Case
    x = (testYInt - subjectYInt) / (subjectSlope - testSlope);
    return new Point(x, subjectSlope * x + subjectYInt);
  }

  float slope(Point start, Point end) {
    boolean isVertical = abs(end.x - start.x) < 0.001;
    return isVertical ? Float.MAX_VALUE : (end.y - start.y) / (end.x - start.x);
  }

  Point midPoint(Point start, Point end) {
    float dx = abs(end.x - start.x);
    float dy = abs(end.y - start.y);
    return new Point(min(start.x, end.x) + dx/2, min(start.y, end.y) + dy/2);
  }
}
