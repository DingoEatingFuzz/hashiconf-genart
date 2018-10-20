import java.util.Map;

public class ProductComp {
  HashMap<String, PShape> sprites;
  HashMap<String, String> versions;
  String product;
  PShape productSprite;
  String version;
  float size;
  float entropy;

  public ProductComp(String product, float size, float entropy) {
    this.sprites = new HashMap<String, PShape>();
    this.product = product;
    this.size = size;
    this.entropy = entropy;

    sprites.put("VAGRANT", loadShape("sprites/vagrant.svg"));
    sprites.put("PACKER", loadShape("sprites/packer.svg"));
    sprites.put("CONSUL", loadShape("sprites/consul.svg"));
    sprites.put("TERRAFORM", loadShape("sprites/terraform.svg"));
    sprites.put("VAULT", loadShape("sprites/vault.svg"));
    sprites.put("NOMAD", loadShape("sprites/nomad.svg"));
    sprites.put("HASHICORP", loadShape("sprites/hashicorp.svg"));
    sprites.put("HASHICONF", loadShape("sprites/hashiconf-18-2.svg"));

    for(Map.Entry entry : sprites.entrySet()) {
      PShape sprite = (PShape)entry.getValue();
      sprite.disableStyle();
    }

    this.productSprite = sprites.get(this.product);
    
    this.versions = new HashMap<String, String>();
    versions.put("VAGRANT", "v2.2");
    versions.put("PACKER", "v1.3");
    versions.put("TERRAFORM", "v0.12");
    versions.put("VAULT", "v1.0");
    versions.put("CONSUL", "v1.4");
    versions.put("NOMAD", "v0.9");
    
    this.version = versions.get(this.product);
  }

  public void draw() {
    // Draw the grid
    makeGrid();

    // Draw the product logo
    noFill();
    float logoSize = 150;
    pushMatrix();
    translate(logoSize / 2 + 50, height - 50 - 50 - logoSize / 2);
    shape(productSprite, -logoSize / 2, -logoSize / 2, logoSize, logoSize);

    // Write out the product version number
    noFill();
    Text t = new Text();
    t.write(this.version, 0, ceil(logoSize / 2), 3);
    popMatrix();

    // Draw the HashiCorp and HashiConf branding
    noFill();
    shape(sprites.get("HASHICORP"), width - 137 - 30, height - 52, 25, 25);
    shape(sprites.get("HASHICONF"), width - 107 - 30, height - 50, 107, 20); 
  }

  void makeGrid() {
    int margin = 30;
    int offset = 5;
    int caption = 30;

    Point[] polygon = new Point[]{
      new Point(margin + offset, margin + offset), // top-left
      new Point(width - margin - offset, margin + offset), // top-right
      new Point(width - margin - offset, height - margin - offset - caption), // bottom-right
    };
    polygon = (Point[])concat(polygon, hexagonPoints(150, 40, 60, margin + offset, caption));
    drawPolygon(polygon);

    noFill();
    Point[] outerPolygon = new Point[]{
      new Point(margin, margin), // top-left
      new Point(width - margin, margin), // top-right
      new Point(width - margin, height - margin - caption), // bottom-right
    };
    outerPolygon = (Point[])concat(outerPolygon, hexagonPoints(143, 30, 50, margin, caption));
    drawPolygon(outerPolygon);

    noFill();
    ProductGrid grid = new ProductGrid(size, polygon, entropy);

    if (product == "VAGRANT") grid.vagrantGrid();
    if (product == "PACKER") grid.packerGrid();
    if (product == "CONSUL") grid.consulGrid();
    if (product == "TERRAFORM") grid.terraformGrid();
    if (product == "VAULT") grid.vaultGrid();
    if (product == "NOMAD") grid.nomadGrid();
  }

  void drawPolygon(Point[] polygon) {
    beginShape();
    for (int i = 0; i < polygon.length; i++) {
      vertex(polygon[i].x, polygon[i].y);
    }
    endShape(CLOSE);
  }

  Point[] hexagonPoints(float size, float tdx, float tdy, float border, float yOffset) {
    float s3 = sqrt(3);
    float sx = size * s3 / 2; // x-component of an angled side
    float sy = size / 2; // y-component of an angled side

    // True deltas after factoring in grid dimensions
    float dx = border - tdx;
    float dy = height - border - yOffset + tdy;

    Point p1 = new Point(dx + sx + (tdy / sy) * sx, height - border - yOffset);
    Point p2 = new Point(dx + sx * 2, dy - sy);
    Point p3 = new Point(dx + sx * 2, dy - sy - size);
    Point p4 = new Point(dx + sx, dy - 2 * size);
    Point p5 = new Point(border, dy - size - sy - (tdx / sx) * sy);

    return new Point[]{p1, p2, p3, p4, p5};
  }
}
