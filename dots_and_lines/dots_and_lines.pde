ArrayList pts;
int thresh;

void setup()
{
  size(1000, 1000);
  frameRate(30);
  background(#000000);
  thresh = 100;
  pts = new ArrayList();
  noStroke();
  smooth();
}

void draw()
{
  float x = random(pts.size() - 100, pts.size()/2 + 50);
  float y = random(450 - pts.size()/2, 550 + pts.size()/2);
  float r = random(1, 4);
  DataPoint p = new DataPoint(x, y, r);
  pts.add(p);
  p.recordPoint(p);
}

class DataPoint
{
  float x, y, r, xd, yd, td;
  int connections;
  DataPoint (float xPos, float yPos, float rad)
  {
    connections = 0;
    x = xPos;
    y = yPos;
    r = rad;
    fill(255, 255, 255, 50);
    ellipse(x, y, r, r);
  }
  void recordPoint(DataPoint p)
  {
    for(int i = pts.size() - 1; i >= 0; i--)
    {
      DataPoint storedPoint = (DataPoint) pts.get(i);
      xd = abs(storedPoint.x - p.x);
      yd = abs(storedPoint.y - p.y);
      xd *= xd;
      yd *= yd;
      td = sqrt(xd + yd);
      if(td < thresh)
      {
        stroke(255, 255, 255, td/thresh * 100);
        strokeWeight(1 / abs(td/thresh));
        line(p.x, p.y, storedPoint.x, storedPoint.y);
        addConnection(p);
        addConnection(storedPoint);
      }
    }
    //println("point " + p + " has no of connections: " + connections);
  }
  void addConnection(DataPoint p)
  {
    p.connections += 1;
    //p.redraw(p);
  }
  void redraw(DataPoint p)
  {
    float rad = p.r * p.connections;
    p.r = rad;
    fill(255, 255, 255, 10);
    ellipse(p.x, p.y, p.r, p.r);
  }
}
