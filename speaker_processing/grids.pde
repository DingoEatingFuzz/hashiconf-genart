public class ProductGrid {
  float size;
  Point[] polygon;

  ConstrainedLineFactory constrainedLines;
  ConstrainedCircleFactory constrainedCircles;

  public ProductGrid(float size, Point[] polygon) {
    this.size = size;
    this.polygon = polygon;

    this.constrainedCircles = new ConstrainedCircleFactory();
    this.constrainedLines = new ConstrainedLineFactory();
  }

  public void vagrantGrid() {
    repeatLines(size * sqrt(3) / 2, radians(90), polygon);
    repeatLines(size * sqrt(3) / 2, radians(-30), polygon);
    repeatLines(size * sqrt(3) / 2, radians(30), polygon);
  }

  public void packerGrid() {
    repeatLines(size * sqrt(3) / 2, radians(90), polygon);
    repeatLines(size * sqrt(3) / 2, radians(-30), polygon);
  }

  public void terraformGrid() {
    repeatLines(size * sqrt(3) / 2, radians(90), polygon);
    repeatLines(size * sqrt(3) / 2, radians(30), polygon);
  }

  public void vaultGrid() {
    repeatLines(size * sqrt(3) / 2, 0, polygon);
    repeatLines(size * sqrt(3) / 2, radians(-60), polygon);
    repeatLines(size * sqrt(3) / 2, radians(60), polygon);
  }

  public void consulGrid() {
    repeatLines(size * sqrt(3), radians(90), polygon);
    repeatLines(size * sqrt(3), radians(30), polygon);
    repeatLines(size * sqrt(3), radians(-30), polygon);
    // repeatCircles(size * 2, polygon);
  }

  public void nomadGrid() {
    repeatLines(size * sqrt(3) / 2, radians(-30), polygon);
    repeatLines(size * sqrt(3) / 2, radians(30), polygon);
  }

  void repeatLines(float spacing, float ang, Point[] polygon) {
    float normal = ang + HALF_PI;
    BoundingBox bbox = new BoundingBox(polygon);

    float dx = bbox.xMax - bbox.xMin;
    float dy = bbox.yMax - bbox.yMin;
    Point center = new Point(bbox.xMin + dx / 2, bbox.yMin + dy / 2);
    // Round to the nearest spacing multiple to ensure a line goes through the center.
    // This ensures that patterns are in sync when drawing lines at various angles.
    float maxDimension = ceil(max(dx, dy) / spacing) * spacing;

    float cosNormal = cos(normal);
    float sinNormal = sin(normal);
    float cosAng = cos(ang);
    float sinAng = sin(ang);

    Point start = new Point(center.x - cosNormal * maxDimension, center.y + sinNormal * maxDimension);
    Point end = new Point(center.x + cosNormal * maxDimension, center.y - sinNormal * maxDimension);

    float length = dist(start.x, start.y, end.x, end.y);
    int count = ceil(length / spacing);

    for (int i = 0; i < count; i++) {
      float px = start.x + cosNormal * spacing * i;
      float py = start.y - sinNormal * spacing * i;
      constrainedLines.lineSegment(
        px - cosAng * maxDimension, py + sinAng * maxDimension,
        px + cosAng * maxDimension, py - sinAng * maxDimension,
        polygon
      );
    }
  }

  void repeatCircles(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float y = bbox.yMin - size / 2;
    float x = bbox.xMin - tHeight;
    float r = size * 4 / 3;
    while (y < bbox.yMax + size / 2) {
      while (x < bbox.xMax + tHeight) {
        constrainedCircles.circle(x, y, r, polygon);
        constrainedCircles.circle(x + tHeight, y + size / 2, r, polygon);
        x += tHeight * 2;
      }
      x = bbox.xMin - tHeight;
      y += size;
    }
  }
}
