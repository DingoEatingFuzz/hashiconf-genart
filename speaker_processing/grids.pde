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
    repeatVertical(size, polygon);
    repeatDown30(size, polygon);
    repeatUp30(size, polygon);
  }

  public void packerGrid() {
    repeatVertical(size, polygon);
    repeatDown30(size, polygon);
  }

  public void terraformGrid() {
    repeatVertical(size, polygon);
    repeatUp30(size, polygon);
  }

  public void vaultGrid() {
    repeatHorizontal(size, polygon);
    repeatDown60(size, polygon);
    repeatUp60(size, polygon);
  }

  public void consulGrid() {
    repeatVertical(size * 2, polygon);
    repeatDown30(size * 2, polygon);
    repeatUp30(size * 2, polygon);
    repeatCircles(size * 2, polygon);
  }

  public void nomadGrid() {
    repeatDown30(size, polygon);
    repeatUp30(size, polygon);
  }

  void repeatVertical(float size, Point[] polygon) {
    // Vertical lines from left to right
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float x = bbox.xMin + tHeight;
    while (x < bbox.xMax) {
      constrainedLines.lineSegment(x, bbox.yMin, x, bbox.yMax, polygon);
      x += tHeight;
    }
  }

  void repeatHorizontal(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float y = bbox.yMin + tHeight;
    while (y < bbox.yMax) {
      constrainedLines.lineSegment(bbox.xMin, y, bbox.xMax, y, polygon);
      y += tHeight;
    }
  }

  void repeatDown30(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float x = bbox.xMin;
    float y = bbox.yMin;

    // 30deg lines from top-left to bottom-left
    while (y < bbox.yMax) {
      constrainedLines.ray(x, y, radians(30), polygon);
      y += size;
    }

    // 30 deg lines from top-left to top-right;
    y = bbox.yMin;
    x += tHeight * 2;
    while(x < bbox.xMax) {
      constrainedLines.ray(x, y, radians(30), polygon);
      x += tHeight * 2;
    }
  }

  void repeatUp30(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float y = bbox.yMin;
    float x = bbox.xMin;

    // -30deg lines from top-left to bottom-left
    while(y < bbox.yMax) {
      constrainedLines.ray(x, y, radians(-30), polygon);
      y += size;
    }

    // -30deg lines from bottom-left to bottom-right
    x += tHeight * 2 * ((y - bbox.yMax) / size); // start x proportionally based on the remainder between y and the max y)
    y = bbox.yMax;
    while(x < bbox.xMax) {
      constrainedLines.ray(x, y, radians(-30), polygon);
      x += tHeight * 2;
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

  void repeatDown60(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float x = bbox.xMin;
    float y = bbox.yMin;

    // 30deg lines from top-left to bottom-left
    while (y < bbox.yMax) {
      constrainedLines.ray(x, y, radians(60), polygon);
      y += tHeight * 2;
    }

    // 30 deg lines from top-left to top-right;
    y = bbox.yMin;
    x += size;
    while(x < bbox.xMax) {
      constrainedLines.ray(x, y, radians(60), polygon);
      x += size;
    }
  }

  void repeatUp60(float size, Point[] polygon) {
    BoundingBox bbox = new BoundingBox(polygon);
    float tHeight = size * sqrt(3) / 2;
    float y = bbox.yMin;
    float x = bbox.xMin;

    // -30deg lines from top-left to bottom-left
    while(y < bbox.yMax) {
      constrainedLines.ray(x, y, radians(-60), polygon);
      y += tHeight * 2;
    }

    // -30deg lines from bottom-left to bottom-right
    x += size * ((y - bbox.yMax) / (tHeight * 2)); // start x proportionally based on the remainder between y and the max y)
    y = bbox.yMax;
    while(x < bbox.xMax) {
      constrainedLines.ray(x, y, radians(-60), polygon);
      x += size;
    }
  }
}
