import processing.svg.*;

void setup() {
  size(1000, 1600);
  smooth(2);

  background(150);

  stroke(255);
  strokeWeight(1);
  noFill();

  ProductWheelComp comp1 = new ProductWheelComp();
  ProductComp comp2 = new ProductComp("CONSUL");
  comp2.draw();
}

// Not all of the diagonal line functions extend the full breadth of a polygon
// All that code is due for a refactor anyway
