import processing.video.*;
import ddf.minim.*;

Capture      camara;
PGraphics    graficos;
PImage       fondo,logo1,logo2;
PFont        fuente;

Mensaje instruccionestitulo,
        instruccionesrenglon1,instruccionesrenglon2,
        iniciotitulo,
        camaraintrucciones,camaracaptura;

/*
    CONFIGURACIONES
*/

int      esferasx        = 45,
         esferasy        = 45;
         
         
/*
    DEFINICION
*/

final int INICIO = 0,CAMARA = 1,INSTRUCCIONES = 2;
int     estado;

int     tiempoinicio = 0;

float   mintamanio         = 10,
        maxtamanio         = 20;

float   minfrecuencia      = 0.1,
        maxfrecuencia      = 0.5;

float   tamanio[];
float         x[];
float         y[];
float  frecuencia[];
color   colores[];


boolean mascara1,mascara2,mascara3,mascara4,filtro;

void setup(){
    size(800,600);

    camara = new Capture(this,640,480,30);
    camara.start();
    
    graficos = createGraphics(width,height);
    fondo    = loadImage("fondo.jpg");
    fondo.resize(width,height);
    
    logo1    = loadImage("logo.png");
    logo1.resize(logo1.width,logo1.height);
    logo2    = loadImage("logo.png");
    logo2.resize(logo2.width,logo2.height);
    
    background(0);
    
    filtro   = false;
    
    mascara1 = false;
    mascara2 = false;
    mascara3 = false;
    mascara4 = false;
    
    iniciaresferas();       
    SetEstado(INICIO);
    
    String fuente = "fuente.ttf";
       
    iniciotitulo       = new Mensaje("BonisFace UwU",createFont(fuente,64),67, color(255));
 
    instruccionestitulo = new Mensaje("BonisFace UwU",createFont(fuente, 42),45, color(255));
    instruccionesrenglon1 = new Mensaje("Instrucciones ",createFont(fuente, 32),36, color(0,255,0));
    instruccionesrenglon2 = new Mensaje("- Filtro (activar/desactivar) - Pulsa la tecla (F)\n- Mascara1 (activar/desactivar) - Pulsa la tecla (1)\n"
                                       +"- Mascara2 (activar/desactivar) - Pulsa la tecla (2)\n- Mascara3 (activar/desactivar) - Pulsa la tecla (3)\n"
                                       +"- Mascara4 (activar/desactivar) - Pulsa la tecla (4)\n- Captura de pantalla - Pulsa la tecla (ESPACIO)\n"
                                       +"- Reiniciar - Pulsa la tecla (R)\n\n\n- Regresar - Pulsa la tecla (I)",
                                       createFont(fuente, 22),25, color(255,255,255));
    
    camaraintrucciones = new Mensaje("(I) INTRUCCIONES",createFont(fuente, 21),24, color(255));
    camaracaptura      = new Mensaje("(ESPACIO) CAPTURA",createFont(fuente, 21),24, color(255));
}
void draw(){
    fill(0);
    rect(0,0,width,height);
    switch(estado){        
      case INICIO:
        drawInicio();
      break;
      case CAMARA:
        drawCamara();
      break;
      case INSTRUCCIONES:
        drawInstrucciones();
      break;
    }
   
}

void keyPressed(){
  
  switch(estado){  
    case INICIO:
    break;
    case CAMARA:
      CamaraKeyPressed();
    break;
    case INSTRUCCIONES:
      InstruccionesKeyPressed();
    break;
  }
  
}

void SetEstado(int e){
  if(estado==e)
    return;
  estado = e;
  if(estado == INICIO)
    tiempoinicio = frameCount;
}

//########################################################### INICIO

void drawInicio(){
         
  image(fondo,0,0);  
  image(logo1,width/2 - logo1.width/2,height/4);
  
  iniciotitulo.Display(width/4,height*3/4 - iniciotitulo.salto);   
  
  if((frameCount-tiempoinicio)*frameRate >= 10000)
      SetEstado(CAMARA);
  
}



//########################################################### CAMARA

void drawCamara(){

  clear();
  
  if(camara.available()){
    
    camara.read();
    camara.updatePixels();
   
  }  
     
   if(filtro){
     updateesferas();
 
     image(graficos,0,0);
     image(camara,0,height - camara.height/4,camara.width/4,camara.height/4);
   }
   else
     image(camara,0,0,width,height);
    
   fill(0);
   rect(0,0,width,42);
   camaraintrucciones.Display(width - width/4,8);
   camaracaptura.Display(0,8);
}

void CamaraKeyPressed(){
  if(key=='I' || key=='i')
      SetEstado(INSTRUCCIONES);  
  if(key=='F' || key=='f')
      filtro = !filtro;
  if(key=='1')
      mascara1 = !mascara1;
   if(key=='2')
      mascara2 = !mascara2;
   if(key=='3')
      mascara3 = !mascara3;
   if(key=='4')
      mascara4 = !mascara4;
   if(key=='R' || key=='r')
       iniciaresferas();
   if(key==' ')
       graficos.save("Captura" + month()+""+day()+""+year()+"_"+hour()+""+minute()+""+second()+".png");
}

//########################################################### INTRUCCIONES

void drawInstrucciones(){
    
  image(fondo,0,0);
  image(logo2,width - logo2.width, 0);
  
  instruccionestitulo.Display(width/2 - width/8 - 32,height/8 - instruccionestitulo.salto);
  instruccionesrenglon1.Display(width/8,height/4 - instruccionesrenglon1.salto);
  instruccionesrenglon2.Display(width/8,height*5/8 - instruccionesrenglon2.salto*2);
  
}

void InstruccionesKeyPressed(){
    if(key=='I' || key=='i')
        SetEstado(CAMARA);
}

void iniciaresferas(){
  
   tamanio = new float[esferasx*esferasy];
   x       = new float[esferasx*esferasy];
   y       = new float[esferasx*esferasy];
   frecuencia  = new float[esferasx*esferasy];
   colores = new color[esferasx*esferasy];
   
  
  for(int i=0;i<esferasx;i++)
    for(int j=0;j<esferasy;j++){
          int index = j*esferasx + i;
          x[index]  = map(i,0,esferasx-1,0,width);
          y[index]  = map(j,0,esferasy-1,0,height);
          colores[index] = color(255,255,255); 
          tamanio[index] = maxtamanio;
          frecuencia[index] = random(minfrecuencia,maxfrecuencia);
    }
    
}
void dibujaresfera(int i){

    int jj = (int)map(i/esferasx,0,esferasy-1,0,camara.height-1);
    int ii = (int)map(i%esferasx,0,esferasx-1,0,camara.width-1);
    
    
    if(!mascara1)
      colores[i] = camara.pixels[jj*camara.width + ii];    
    else{    
      float multiplicador = max(map(mouseX,0,width,0,6),map(mouseY,0,height,0,6)); 
    
      colores[i] = color( (int)(x[i]*multiplicador)%128,
                          (int)(y[i]*multiplicador)%128,
                          random(0,128));
      colores[i] += camara.pixels[jj*camara.width + ii];            
    }
    if(mascara3)
      colores[i] = color(  (red(colores[i])+green(colores[i])+blue(colores[i]))/3.0f );
    if(mascara4)
      colores[i] = color(  255-red(colores[i]),255-green(colores[i]),255-blue(colores[i]) );
    if(mascara2)
      tamanio[i] = ( sin(frecuencia[i] * frameCount) + 1.0f ) /2.0f * (maxtamanio-mintamanio) + mintamanio;
              
          
    graficos.fill(colores[i]);
    graficos.ellipse(x[i],y[i],tamanio[i],tamanio[i]);

}

void updateesferas(){
  
  graficos.beginDraw();
  graficos.clear();
  graficos.background(255);
  graficos.noStroke();
  
  for(int i=0;i<(esferasx*esferasy);i++)
    dibujaresfera(i);      
    
  graficos.endDraw();
  
}