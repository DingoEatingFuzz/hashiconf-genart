import processing.svg.*;

float i = 0;
float p = 0;
float duration = 50;
String[] products = { "VAGRANT", "PACKER", "VAULT", "TERRAFORM", "CONSUL", "NOMAD" };

void setup() {
  size(1000, 1600);
  smooth(2);

  background(255);

  stroke(0);
  strokeWeight(1);
  noFill();

  ProductWheelComp comp1 = new ProductWheelComp();
  ProductComp comp2 = new ProductComp("CONSUL", 30, 0.8);
  comp2.draw();
}

// void draw() {
//   clear();
//   ProductComp comp2 = new ProductComp(products[floor(p/duration)%products.length], 50 + sin(i) * 10);
//   comp2.draw();
//   i = (i + PI / 40) % TWO_PI;
//   p++;
// }
