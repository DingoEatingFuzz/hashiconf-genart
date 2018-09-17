import processing.svg.*;
import java.util.Map;

HashMap<String, PShape> sprites = new HashMap<String, PShape>();

PShape VAGRANT;
PShape PACKER;
PShape CONSUL;
PShape TERRAFORM;
PShape VAULT;
PShape NOMAD;
PShape HASHICORP;

float metadataMargin = 60;
float wHeight;

void setup() {
  size(1000, 1600);
  smooth(2);

  wHeight = height - metadataMargin;

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

  background(150);

  stroke(255);
  strokeWeight(1);
  noFill();
  makeFrame();

  float mainLogoSize = 450;
  shape(sprites.get("HASHICORP"), width / 2 - mainLogoSize / 2, wHeight / 2 - mainLogoSize / 2, mainLogoSize, mainLogoSize);

  logoGridlines(mainLogoSize);
  drawLogos(mainLogoSize);

  Point[] topBox = new Point[]{
    new Point(10, 10),
    new Point(width - 10, 10),
    new Point(width - 10, 200),
    new Point(10, 400),
  };

  Point[] bottomBox = new Point[]{
    new Point(10, height - metadataMargin - 200),
    new Point(width - 10, height - metadataMargin - 400),
    new Point(width - 10, height - metadataMargin - 10),
    new Point(10, height - metadataMargin - 10),
  };

  ProductGrid gridTop = new ProductGrid(30, topBox);
  gridTop.consulGrid();

  ProductGrid gridBottom = new ProductGrid(30, bottomBox);
  gridBottom.consulGrid();
}

void makeFrame() {
  rect(5, 5, width - 10, height - 10 - metadataMargin);
  rect(10, 10, width - 20, height - 20 - metadataMargin);
}

void logoGridlines(float size) {
  float r = size - 50;
  float len = r * 2;
  for (float i = 0; i < TWO_PI; i += TWO_PI / 6) {
    pushMatrix();
    translate(width / 2, wHeight / 2);
    translate(cos(i) * r, sin(i) * r);
    rotate(i - TWO_PI / 12);
    translate(-len + 60, 0);
    line(0, 0, len, 0);
    popMatrix();
  }
}

void drawLogos(float size) {
  String[] logoOrder = new String[]{"TERRAFORM", "VAULT", "VAGRANT", "PACKER", "CONSUL", "NOMAD"};
  float logoSize = 150;
  float r = size * 0.8;

  for (int i = 0; i < 6; i++) {
    float ang = float(i) * TWO_PI / 6 + TWO_PI / 12;
    pushMatrix();
    translate(width / 2, wHeight / 2);
    translate(cos(ang) * r, sin(ang) * r);
    println(logoOrder[i]);
    PShape logo = sprites.get(logoOrder[i]);
    shape(logo, -logoSize / 2, -logoSize / 2, logoSize, logoSize);
    logo.resetMatrix();
    popMatrix();
  }
}
