// Fluid Simulation
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// https://youtu.be/alhpH6ECFvQ

// This would not be possible without:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf
// Fluid Simulation for Dummies by Mike Ash
// https://mikeash.com/pyblog/fluid-simulation-for-dummies.html

final int N = 128;
final int iter = 16;
final int SCALE = 4;
float t = 0;

Fluid fluid;
Fluid no;

Table data;
float[] nox;
int nrow;

void settings() {
  size(N*SCALE, N*SCALE);
}

void setup() {
  fluid = new Fluid(0.2, 0, 0.0000001);
  no = new Fluid(0.2, 0, 0.0000001);

  data = loadTable("ox2021.csv", "header");
  nrow = data.getRowCount();
  nox = new float[nrow];
  int i = 0;
  for (TableRow row : data.rows()) {
    nox[i] = (row.getFloat("nox"));
    i++;
  }
}

//void mouseDragged() {
//}

void draw() {

  background(0);

  int cx = int(0.5 * width / SCALE);
  int cy = int(0.5 * height / SCALE);
  int nx = int(0.1 * width / SCALE);
  int ny = int(0.1 * height / SCALE);

  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      fluid.addDensity(cx + i, cy + j, 200);
      no.addDensity(nx + i, ny + j, 200);
    }
  }
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    float angleno = noise(t + 2) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    PVector vno = PVector.fromAngle(angleno);

    v.mult(0.2);
    vno.mult(0.2);

    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y );
    no.addVelocity(nx, ny, vno.x, vno.y);
  }

  fluid.step();
  no.step();

  float qualf = map(mouseX, 0, width, 40, 700);
  float qualn = map(mouseY, 0, height, 40, 700);

  no.renderD(qualn);

  fluid.renderD(qualf);


//  fluid.renderV();
  fluid.fadeD();
  no.fadeD();
}
