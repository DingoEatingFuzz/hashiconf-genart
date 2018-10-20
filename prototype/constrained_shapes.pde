public class ConstrainedShapeFactory {
  public boolean isPointInPolygon(float px, float py, Point[] polygon) {
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
}
