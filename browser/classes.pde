class TextBox{
  int x, y, size;
  String text = "";
  boolean focus = false;
  boolean release = true;
  color foreColor, backColor;
  TextBox(int x, int y, int size, color foreColor, color backColor){
    this.x = x;
    this.y = y;
    this.size = size;
    this.foreColor = foreColor;
    this.backColor = backColor;
  }
  
  void render(){
    if(focus){
      fill(200);
    }else{
      fill(backColor);
    }
    rect(x, y, width-3, size);
    
    fill(foreColor);
    textSize(size/1.4);
    text(text, x+5, y+size/1.3);
  }
}
