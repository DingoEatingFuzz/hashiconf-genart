import java.util.Map;

public class ProductComp {
  HashMap<String, PShape> sprites;
  String product;
  PShape productSprite;
  float size;

  public ProductComp(String product, float size) {
    this.sprites = new HashMap<String, PShape>();
    this.product = product;
    this.size = size;

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
      new Point(10, 10),
      new Point(width - 10, 10),
      new Point(width - 10, height - 10),
      new Point(300 + 10 + 10, height - 10),
      new Point(10, height - 300 - 10 - 10),
    };
    ProductGrid grid = new ProductGrid(size, polygon);

    if (product == "VAGRANT") grid.vagrantGrid();
    if (product == "PACKER") grid.packerGrid();
    if (product == "CONSUL") grid.consulGrid();
    if (product == "TERRAFORM") grid.terraformGrid();
    if (product == "VAULT") grid.vaultGrid();
    if (product == "NOMAD") grid.nomadGrid();
  }
}
