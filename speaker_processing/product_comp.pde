import java.util.Map;

public class ProductComp {
  HashMap<String, PShape> sprites;
  String product;
  PShape productSprite;
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

    for(Map.Entry entry : sprites.entrySet()) {
      PShape sprite = (PShape)entry.getValue();
      sprite.disableStyle();
    }

    this.productSprite = sprites.get(this.product);
  }

  public void draw() {
    // draw the frame
    makeFrame();
    // place the logo
    float logoSize = 150;
    pushMatrix();
    translate(logoSize / 2 + 30, height - 30 - logoSize / 2);
    shape(productSprite, -logoSize / 2, -logoSize / 2, logoSize, logoSize);
    popMatrix();
    // draw the grid
    makeGrid();
  }

  void makeFrame() {
    rect(5, 5, width - 10, height - 10);
    rect(10, 10, width - 20, height - 20);
  }

  void makeGrid() {
    Point[] polygon = new Point[]{
      new Point(10, 10), // top-left
      new Point(width - 10, 10), // top-right
      new Point(width - 10, height - 10), // bottom-right
    };

    polygon = (Point[])concat(polygon, hexagonPoints(150, 40, 60));
    println(polygon);
    ProductGrid grid = new ProductGrid(size, polygon, entropy);

    if (product == "VAGRANT") grid.vagrantGrid();
    if (product == "PACKER") grid.packerGrid();
    if (product == "CONSUL") grid.consulGrid();
    if (product == "TERRAFORM") grid.terraformGrid();
    if (product == "VAULT") grid.vaultGrid();
    if (product == "NOMAD") grid.nomadGrid();
  }

  Point[] hexagonPoints(float size, float tdx, float tdy) {
    float s3 = sqrt(3);
    float sx = size * s3 / 2; // x-component of an angled side
    float sy = size / 2; // y-component of an angled side

    // True deltas after factoring in grid dimensions
    float dx = 10 - tdx;
    float dy = height - 10 + tdy;

    Point p1 = new Point(dx + sx + (tdy / sy) * sx, height - 10);
    Point p2 = new Point(dx + sx * 2, dy - sy);
    Point p3 = new Point(dx + sx * 2, dy - sy - size);
    Point p4 = new Point(dx + sx, dy - 2 * size);
    Point p5 = new Point(10, dy - size - sy - (tdx / sx) * sy);

    return new Point[]{p1, p2, p3, p4, p5};
  }
}
