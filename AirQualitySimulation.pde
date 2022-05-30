// Fluid Simulation
// Daniel Shiffman
// https://thecodingtrain.com/CodingChallenges/132-fluid-simulation.html
// https://youtu.be/alhpH6ECFvQ

// This would not be possible without:
// Real-Time Fluid Dynamics for Games by Jos Stam
// http://www.dgp.toronto.edu/people/stam/reality/Research/pdf/GDC03.pdf
// Fluid Simulation for Dummies by Mike Ash
// https://mikeash.com/pyblog/fluid-simulation-for-dummies.html

final int N = 256;
final int iter = 16;
final int SCALE = 4;
float t = 0;

Fluid fluid;

Table data;
float[] nox;
String[] date;
int[] hr;
int[] dy;
int nrow;
float qual;

void settings() {
  size(N*SCALE, N*SCALE);
}

void setup() {
  fluid = new Fluid(0.2, 0, 0.0000001);
  data = loadTable("oxMay22.csv", "header");
  nrow = data.getRowCount();
  nox = new float[nrow];
  date = new String[nrow];
  hr = new int[nrow];
  dy = new int[nrow];

  int i = 0;
  for (TableRow row : data.rows()) {
    nox[i] = (row.getFloat("nox"));
    date[i] = row.getString("date");
    char hrChr[] = {date[i].charAt(11),date[i].charAt(12)};
    String hourStr = new String (hrChr);
    hr[i] = int(hourStr);

    char dayChr[] = {date[i].charAt(8), date[i].charAt(9)};
    String dyStr = new String (dayChr);
    dy[i] = int(dyStr);
    i++;
  }
}

//void mouseDragged() {
//}

void draw() {

  background(0);

  int cx = int(0.5*width/SCALE);
  int cy = int(0.5*height/SCALE);
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      fluid.addDensity(cx + i, cy + j, 200);
    }
  }
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.2);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y );
  }

  fluid.step();

//  float qual = map(mouseX, 0, width, 40, 700);
  for (int h = 0; h < nrow; h++){
    if (hour() == hr[h] && day() == dy[h] + 1){
      qual = nox[h];
      break;
    }

  }
  fluid.renderD(qual);
  fill(255);
  textSize(30);
  text("NOx concentration: ", 40, height - 40);
  text(qual, 300, height - 40);
  text(hour(), width/2, height - 40);

//  fluid.renderV();
  fluid.fadeD();
}
