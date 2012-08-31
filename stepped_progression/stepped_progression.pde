import processing.pdf.*;
import processing.dxf.*;

boolean recording;
PGraphicsPDF pdf;
ArrayList pts;
int thresh;

void setup()
{
  size(1400, 1400);
  frameRate(0.5);
  background(#000000);
  thresh = 100;
  pts = new ArrayList();
  noStroke();
  smooth();
  pdf = (PGraphicsPDF) createGraphics(width, height, PDF, "hex-steps.pdf");
}

void draw()
{
  float x = random(pmouseX, mouseX);
  float y = random(pmouseY, mouseY);
  float r = random(1, 4);
}

void mouseMoved()
{
  float x = random(pmouseX, mouseX);
  float y = random(pmouseY, mouseY);
  float r = random(1, 4);
  DataPoint p = new DataPoint(x, y, r);
  pts.add(p);
  p.recordPoint(p);
}

void keyPressed()
{
  if(key == 'r')
  {
    if(recording)
    {
      endRecord();
      recording = false;
    }
    else
    {
      beginRaw(DXF, "output.dxf");
      beginRecord(pdf);
      recording = true;
    }
  } else if(key == 'q')
  {
    if(recording)
    {
      endRaw();
      endRecord();
      recording = false;
    }
    exit();
  }
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
