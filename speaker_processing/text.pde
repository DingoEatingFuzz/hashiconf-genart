public class Text {
  void write(String msg, int x, int y, float size) {
    float charWidth = size * 5;
    float xOffset = charWidth * msg.length() / 2;
    for (int i = 0; i < msg.length() ; i++) {
      drawChar(msg.charAt(i), ceil((x + i * size * 4) - xOffset), y, size);
    }
  }
  
  void drawChar(char c, int x, int y, float size) {
    pushMatrix();
    translate(x, y);
    switch (c) {
      case 'v':
        pLine(1, 3, 2, 6, size);
        pLine(2, 6, 3, 3, size);
        break;
      case '.':
        pLine(2, 5.5, 2, 6, size);
        break;
      case '1':
        pLine(2, 1, 2, 6, size);
        pLine(1, 2, 2, 1, size);
        break;
      case '2':
        pLine(3, 6, 1, 6, size);
        pLine(1, 6, 3, 2, size);
        pLine(3, 2, 2, 1, size);
        pLine(2, 1, 1, 2, size);
        break;
      case '3':
        pLine(1, 1, 3, 1, size);
        pLine(3, 1, 1, 3, size);
        pLine(1, 3, 3, 3, size);
        pLine(3, 3, 3, 6, size);
        pLine(3, 6, 1, 6, size);
        break;
      case '4':
        pLine(3, 1, 1, 3, size);
        pLine(1, 3, 3, 3, size);
        pLine(3, 1, 3, 6, size);
        break;
      case '5':
        break;
      case '6':
        break;
      case '7':
        break;
      case '8':
        break;
      case '9':
        pLine(3, 3, 1, 3, size);
        pLine(1, 3, 1, 1, size);
        pLine(1, 1, 3, 1, size);
        pLine(3, 1, 3, 6, size);
        break;
      case '0':
        pLine(1, 1, 3, 1, size);
        pLine(3, 1, 3, 6, size);
        pLine(3, 6, 1, 6, size);
        pLine(1, 6, 1, 1, size);
        pLine(1, 1, 3, 6, size);
        break;
    }
    popMatrix();
  }
  
  void pLine(float x1, float y1, float x2, float y2, float size) {
    line(x1 * size, y1 * size, x2 * size, y2 * size);
  }
}
