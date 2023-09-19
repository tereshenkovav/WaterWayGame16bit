unit Game ;

interface

type
  TGame = class
  private
    selx,sely:Integer ;
    oldselx,oldsely:Integer ;
    procedure DrawSelector() ;
    procedure ClearOldSelector() ;
    procedure DrawPipe(x,y:Integer; filled:Boolean) ;
  public
    constructor Create() ;
    destructor Destroy() ; override ;
    procedure Render() ;
    function Update():Boolean ;
  end ;

implementation
uses GameEngine16 ;

const 
  BLOCKSIZE = 20 ;

procedure TGame.ClearOldSelector() ;
var x1,y1,x2,y2:Integer ;
begin
  // ѕо умолчанию, затираем селектор, если место пустое
  x1:=oldselx*BLOCKSIZE ;
  x2:=oldselx*BLOCKSIZE+BLOCKSIZE-1 ;
  y1:=oldsely*BLOCKSIZE ;
  y2:=oldsely*BLOCKSIZE+BLOCKSIZE-1 ;
  DrawLineHorz(x1,x2,y1,0) ;
  DrawLineHorz(x1,x2,y2,0) ;
  DrawLineVert(x1,y1,y2,0) ;
  DrawLineVert(x2,y1,y2,0) ;
end ;

procedure TGame.DrawSelector() ;
var x1,y1,x2,y2:Integer ;
begin
  x1:=selx*BLOCKSIZE ;
  x2:=selx*BLOCKSIZE+BLOCKSIZE-1 ;
  y1:=sely*BLOCKSIZE ;
  y2:=sely*BLOCKSIZE+BLOCKSIZE-1 ;
  DrawLineHorz(x1,x2,y1,10) ;
  DrawLineHorz(x1,x2,y2,10) ;
  DrawLineVert(x1,y1,y2,10) ;
  DrawLineVert(x2,y1,y2,10) ;
end ;

procedure TGame.DrawPipe(x,y:Integer; filled:Boolean) ;
var x1,y1,x2,y2,yw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y1:=y*BLOCKSIZE ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;
  DrawLineHorz(x1,x2,y1+5,18) ;
  DrawLineHorz(x1,x2,y1+6,17) ;
  DrawLineHorz(x1,x2,y1+7,16) ;

  DrawLineHorz(x1,x2,y2-7,16) ;
  DrawLineHorz(x1,x2,y2-6,17) ;
  DrawLineHorz(x1,x2,y2-5,18) ;

  if (filled) then 
    for yw:=y1+8 to y2-8 do
      DrawLineHorz(x1,x2,yw,11) ;
end ;

constructor TGame.Create() ;
begin
  selx:=3 ; 
  sely:=5 ;
  oldselx:=-1; oldsely:=-1 ;
end ;

destructor TGame.Destroy() ;
begin
  inherited Destroy ;
end ;

procedure TGame.Render() ;
begin
  DrawPipe(3,3,True) ;
  DrawPipe(4,3,True) ;
  DrawPipe(5,3,False) ;
  DrawPipe(6,3,False) ;

  DrawPipe(7,7,False) ;
  DrawPipe(8,7,False) ;
  DrawPipe(9,7,False) ;

  if (oldselx<>selx)or(oldsely<>sely) then begin
    if (oldselx<>-1) then ClearOldSelector() ;    
  end ;
  DrawSelector() ;
end ;

function TGame.Update():Boolean ;
var key,scan:Byte ;
begin
  Result:=True ;
  oldselx:=selx; oldsely:=sely ;
  if IsKeyPressed(key,scan) then begin
    //Writeln(key,scan) ;
    if scan=72 then Dec(sely) ;
    if scan=80 then Inc(sely) ;
    if scan=75 then Dec(selx) ;
    if scan=77 then Inc(selx) ;
    if scan=1 then Result:=False ;
  end ;
end ;

end.
