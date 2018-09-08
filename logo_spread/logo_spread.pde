import processing.svg.*;

int count = 250;
int diameter = 75;

ArrayList<PShape> sprites = new ArrayList<PShape>();

void setup() {
  size(2000, 2000);
  smooth(2);
  background(255);
  
  sprites.add(loadShape("sprites/vagrant.svg"));
  sprites.add(loadShape("sprites/packer.svg"));
  sprites.add(loadShape("sprites/consul.svg"));
  sprites.add(loadShape("sprites/terraform.svg"));
  sprites.add(loadShape("sprites/vault.svg"));
  sprites.add(loadShape("sprites/nomad.svg"));
  
  //shape(sprites.get(0), 50, 50, 1000, 1000);
  beginRecord(SVG, "output.svg");
  for (int i = 1; i <= count; i++) {
    PVector p = getPoint(i);
    project(p);
    
    stroke(0);
    noFill();
    
    PShape logo = sprites.get(int(random(sprites.size())));
    logo.resetMatrix();
    //shape(logo, p.x, p.y, diameter, diameter);
    logo.translate(-diameter/2, -diameter/2);
    logo.rotate(random(PI / 2) - PI / 4);
    logo.scale(random(0.2) + 0.9);
    shape(logo, p.x, p.y, diameter, diameter);
    //ellipse(p.x, p.y, diameter, diameter);
  }
  endRecord();
}

float THETA = PI * ( 3 - sqrt(5));

// Phyllotaxis arrangement (domain 0 to 1)
PVector getPoint(int index) {
  float r = sqrt(float(index) / count);
  float th = index * THETA;
  return new PVector(r * cos(th), r * sin(th));
}

// Project a point from getPoint to the dimensions of the window
PVector project(PVector p) {
  p.mult(min(float(width / 2), float(height / 2)) - 50);
  p.add(new PVector(width / 2 , height / 2));
  return p;
}
