import processing.svg.*;

String[] products = { "VAGRANT", "PACKER", "VAULT", "TERRAFORM", "CONSUL", "NOMAD" };

void docSetup() {
  clear();
  stroke(0);
  strokeWeight(1);
  noFill();
  background(255);
}

void setup() {
  size(528, 816); // 8.5" x 5.5" when plotted
  smooth(2);
  docSetup();

  int seed = 0;
  if (args != null) {
    seed = parseInt(args[0]);
  } else {
    println("No seed provided");
  }

  noiseSeed(seed);
  println("Seed: " + seed);

  int productIndex = seed % products.length;
  String product = products[productIndex];
  println("Product: " + productIndex + " (" + product + ")");

  ProductComp comp = new ProductComp(product, 30, 0.9);

  // Draw once for the records
  beginRecord(SVG, "archive/plot-" + seed + "-" + product.toLowerCase() + ".svg");
  comp.draw();
  endRecord();

  docSetup();

  // Draw again to override latest
  beginRecord(SVG, "latest.svg");
  comp.draw();
  endRecord();

  exit();
}
