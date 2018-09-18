import processing.svg.*;

void setup() {
  size(1000, 1600);
  smooth(2);

  background(150);

  stroke(255);
  strokeWeight(1);
  noFill();

  ProductWheelComp comp1 = new ProductWheelComp();
  ProductComp comp2 = new ProductComp("VAULT");
  comp2.draw();
}
