public class ProductGrid {
  float size;
  float entropy;
  Point[] polygon;

  ConstrainedLineFactory constrainedLines;
  ConstrainedCircleFactory constrainedCircles;

  public ProductGrid(float size, Point[] polygon, float entropy) {
    this.size = size;
    this.polygon = polygon;
    this.entropy = entropy;

    this.constrainedCircles = new ConstrainedCircleFactory();
    this.constrainedLines = new ConstrainedLineFactory();
  }

  public void vagrantGrid() {
    float s = size * sqrt(3) / 2;
    repeatLines(s, radians(90), polygon, round(s * entropy));
    repeatLines(s, radians(-30), polygon, 0);
    repeatLines(s, radians(30), polygon, 0);
  }

  public void packerGrid() {
    float s = size * sqrt(3) / 2;
    repeatLines(s, radians(90), polygon, round(s * entropy));
    repeatLines(s, radians(-30), polygon, round(s * entropy));
  }

  public void terraformGrid() {
    float s = size * sqrt(3) / 2;
    repeatLines(s, radians(90), polygon, round(s * entropy));
    repeatLines(s, radians(30), polygon, round(s * entropy));
  }

  public void vaultGrid() {
    float s = size * sqrt(3) / 2;
    repeatLines(s, 0, polygon, round(s * entropy));
    repeatLines(s, radians(-60), polygon, 0);
    repeatLines(s, radians(60), polygon, 0);
  }

  public void consulGrid() {
    float s = size * sqrt(3);
    repeatLines(s, radians(90), polygon, 0);
    repeatLines(s, radians(30), polygon, 0);
    repeatLines(s, radians(-30), polygon, 0);
    repeatCircles(s, polygon, round(s * entropy));
  }

  public void nomadGrid() {
    float s = size * sqrt(3) / 2;
    repeatLines(s, radians(-30), polygon, round(s * entropy));
    repeatLines(s, radians(30), polygon, round(s * entropy));
  }

  void repeatLines(float spacing, float ang, Point[] polygon, int jitter) {
    float normal = ang + HALF_PI;
    BoundingBox bbox = new BoundingBox(polygon);

    float maxJAngle = jitter == 0 ? 0 : PI / 50 * entropy / 2;

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
      float jspacing = map(noise(px, py), 0, 1, -jitter, jitter);
      float jAngle = map(noise(px, py), 0, 1, -maxJAngle, maxJAngle);
      px = px + cosNormal * jspacing;
      py = py + sinNormal * jspacing;
      constrainedLines.lineSegment(
        px - (cosAng + jAngle) * maxDimension, py + (sinAng + jAngle) * maxDimension,
        px + (cosAng + jAngle) * maxDimension, py - (sinAng + jAngle) * maxDimension,
        polygon
      );
    }
  }

  void repeatCircles(float spacing, Point[] polygon, int jitter) {
    float tHeight = spacing;
    float size = (spacing * 2) / sqrt(3);
    float r = size * 4 / 3;

    BoundingBox bbox = new BoundingBox(polygon);
    float dx = bbox.xMax - bbox.xMin;
    float dy = bbox.yMax - bbox.yMin;
    Point center = new Point(bbox.xMin + dx / 2, bbox.yMin + dy / 2);

    float startY = center.y - ceil(dy / 2 / size) * size;
    float startX = center.x - ceil(dx / 2 / (tHeight*2)) * tHeight * 2;

    float y = startY;
    float x = startX;

    while (y < bbox.yMax + size / 2) {
      while (x < bbox.xMax + tHeight) {
        float jr = r + map(noise(x, y), 0, 1, -jitter * 1.5, jitter * 0.5);
        float jr2 = r + map(noise(x + tHeight, y + size / 2), 0, 1, -jitter * 1.5, jitter * 0.5);
        constrainedCircles.circle(x, y, jr, polygon);
        constrainedCircles.circle(x + tHeight, y + size / 2, jr2, polygon);
        x += tHeight * 2;
      }
      x = startX;
      y += size;
    }
  }
}
