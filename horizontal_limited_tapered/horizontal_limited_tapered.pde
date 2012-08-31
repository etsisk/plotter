ArrayList pts;
int thresh;

void setup()
{
  size(2000, 1000);
  frameRate(30);
  background(#ffffff);
  thresh = 100;
  pts = new ArrayList();
  noStroke();
  smooth();
}

void draw()
{
  int currentTime = millis();
  float x = random(width);
  float y = random(500 - currentTime/300, 500 + currentTime/300);
  float edgeX = -1.0;
  if(x < 20.0) edgeX = x;
  if(x - width > -20.0) edgeX = abs(x - width);
  if(edgeX != -1.0) y = random(500 - edgeX * 5, 500 + edgeX * 5);
  float z = 0;
  float r = random(1, 4);
  if(pts.size() < 2011)
  {
    DataPoint p = new DataPoint(x, y, r);
    pts.add(p);
    p.recordPoint(p);
    println(currentTime);
  }
  else{ println("END IT!");}
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
    fill(0, 0, 0, 50);
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
        stroke(0, 0, 0, td/thresh * 100);
        strokeWeight(1 / td/thresh);
        if(storedPoint.connections < 50)
        {
          line(p.x, p.y, storedPoint.x, storedPoint.y);
          addConnection(p);
          addConnection(storedPoint);
        }
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
    fill(0, 0, 0, 10);
    ellipse(p.x, p.y, p.r, p.r);
  }
}
