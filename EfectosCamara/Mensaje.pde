class Mensaje {

  private PFont font;
  private String text;
  private color  textColor;

  private int currentposicion;
  private float posicionx,posiciony;

  private float salto = 30,tamanio=-1;
  private PGraphics imgtext;
  

  Mensaje(String text, PFont font, float salto,color textColor) {    
    
    this.font    = font;
    this.textColor = textColor;
    this.text     = text;   
    this.salto    = salto;
    
    currentposicion = 0;
    posicionx       = 0;
    posiciony       = salto;
    
    imgtext = createGraphics(width,height);
    imgtext.updatePixels();
    
  }
 Mensaje(String text, PFont font,float tamanio, float salto,color textColor) {    
    
    this.font    = font;
    this.textColor = textColor;
    this.text     = text;   
    this.salto    = salto;
    
    currentposicion = 0;
    posicionx       = 0;
    posiciony       = salto;
    
    imgtext = createGraphics(width,height);
    imgtext.updatePixels();
    
  }
 
 
  void Display(float x,float y) {
    
    if(currentposicion < text.length()){    
        
        int k = int(posiciony*imgtext.width + posicionx);              
                     
            textFont(font);
    
            if(k < width*height){
                                                   
              Next(1.0f,textWidth(text.charAt(currentposicion)));                  
              k = int(posiciony*imgtext.width + posicionx);
              
            }        
           if(k < width*height){              
            
            imgtext.beginDraw();     
            if(tamanio < 0)
              imgtext.textFont(font);
            else
              imgtext.textFont(font,tamanio);
            imgtext.fill(textColor);
            imgtext.textAlign(LEFT);
            if(text.charAt(currentposicion)=='\n'){
                posiciony+=salto;
                posicionx=0;
            }
            else
              imgtext.text(text.charAt(currentposicion),posicionx,posiciony);
            imgtext.endDraw();
            
            if((currentposicion+1) < text.length()){
                Next(textWidth(text.charAt(currentposicion)),textWidth(text.charAt(currentposicion+1)));
            }
             currentposicion++;  
             
          }
    }
    
    image(imgtext,x,y);
          
          
  }
  
  void Reiniciar(){
  
    currentposicion = 0;
    posicionx       = 0;
    posiciony       = salto;    
    
    imgtext.beginDraw();
    imgtext.clear();
    imgtext.endDraw();
    
  }
  
  void Reiniciar(String text){
  
    currentposicion = 0;
    posicionx       = 0;
    posiciony       = salto;
    this.text       = text;
    
    imgtext.clear();
    
  }
  
  private boolean Next(float mod,float size){  
      posicionx += mod;
      if((posicionx+size) > imgtext.width){
        posicionx  = 0;
        posiciony += salto;
      }                
      if((posiciony-salto) >= imgtext.height)
        return true;
        
        return false;       
  }
  
  

}