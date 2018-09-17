public class BoundingBox {
  public float xMin;
  public float xMax;
  public float yMin;
  public float yMax;

  public BoundingBox(Point[] polygon) {
    if (polygon.length == 0) return;

    Point start = polygon[0];

    float xMin = start.x;
    float xMax = start.x;
    float yMin = start.y;
    float yMax = start.y;

    for (int i = 1; i < polygon.length; i++) {
      Point pt = polygon[i];
      xMin = min(xMin, pt.x);
      xMax = max(xMax, pt.x);
      yMin = min(yMin, pt.y);
      yMax = max(yMax, pt.y);
    }

    this.xMin = xMin;
    this.xMax = xMax;
    this.yMin = yMin;
    this.yMax = yMax;
  }
}
