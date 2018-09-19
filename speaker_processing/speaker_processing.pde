import processing.svg.*;

float i = 0;
float p = 0;
float duration = 50;
String[] products = { "VAGRANT", "PACKER", "VAULT", "TERRAFORM", "CONSUL", "NOMAD" };

void setup() {
  size(1000, 1600);
  smooth(2);
  stroke(0);
  strokeWeight(1);
  noFill();

  background(255);

  // ProductWheelComp comp1 = new ProductWheelComp();
  // ProductComp comp2 = new ProductComp("VAGRANT", 50, 0.7);
  // comp2.draw();

  // draw all the controls
  for (int i = 0; i < products.length; i++) {
    clear();
    background(255);

    String product = products[i];
    beginRecord(SVG, "controls/" + product.toLowerCase() + ".svg");
    stroke(0);
    strokeWeight(1);
    noFill();
    ProductComp comp = new ProductComp(product, 50, 0);
    comp.draw();
    endRecord();
  }
  // draw 15 instances of each chart
  for (int i = 1; i <= 15; i++) {
    for (int productIndex = 0; productIndex < products.length; productIndex++) {
      clear();
      background(255);
      noiseSeed(i * productIndex);

      String product = products[productIndex];
      beginRecord(SVG, "samples/" + product.toLowerCase() + "-" + i + ".svg");
      stroke(0);
      strokeWeight(1);
      noFill();
      ProductComp comp = new ProductComp(product, 50, 0.8);
      comp.draw();
      endRecord();
    }
  }
  exit();
}

// void draw() {
//   clear();
//   background(255);
//   ProductComp comp2 = new ProductComp(products[floor(p/duration)%products.length], 50 + sin(i) * 10, 0.7);
//   comp2.draw();
//   i = (i + PI / 40) % TWO_PI;
//   p++;
// }
