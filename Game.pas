unit Game ;

interface

type
  TBlock = class
  protected
    filledv:Single ;
  public
    procedure Draw(x,y:Integer); virtual ; abstract ;
    function isEmpty():Boolean ; virtual ;
  end ;

  TBlockEmpty = class(TBlock)
  public
    procedure Draw(x,y:Integer); override ;
    function isEmpty():Boolean ; override ;
  end ;

  TBlockStartHorz = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockFinish = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockHorz = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockVert = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockLeftTop = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockRightTop = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockLeftBottom = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockRightBottom = class(TBlock)
  private
  public
    procedure Draw(x,y:Integer); override ;
  end ;

  TGame = class
  private
    selx,sely:Integer ;
    oldselx,oldsely:Integer ;
    map:array of array of TBlock ;
    empty:TBlockEmpty ;
    tekblock:TBlock ;
    nextblock:TBlock ;
    procedure DrawSelector() ;
    procedure ClearOldSelector() ;
    function genRandomPipeBlock():TBlock ;
  public
    constructor Create() ;
    destructor Destroy() ; override ;
    procedure Render() ;
    procedure RenderStatic() ;
    function Update():Boolean ;
  end ;

implementation
uses GameEngine16 ;

const 
  BLOCKSIZE = 20 ;
  MAPSIZE = 10 ;
  SCREENW = 320 ;
  SCREENH = 200 ;

procedure DrawCornerDXDY(x1,y1,dx,dy:Integer; color:byte) ;
var x2:Integer ;
begin
  DrawLineHorzByLen(x1,dx,y1,color) ;
  x2:=x1+dx ;
  if dx<0 then Inc(x2) else Dec(x2) ;

  DrawLineVertByLen(x2,y1,dy,color) ;
end ;

procedure DrawCornerDYDX(x1,y1,dy,dx:Integer; color:byte) ;
begin
  DrawLineVertByLen(x1,y1,dy,color) ;
  DrawLineHorzByLen(x1,dx,y1+dy-1,color) ;
end ;

function TBlock.isEmpty():Boolean ; 
begin
  Result:=False ;
end ;

function TBlockEmpty.isEmpty():Boolean ; 
begin
  Result:=True ;
end ;

procedure TBlockEmpty.Draw(x,y:Integer) ; 
begin
  FillRect(x*BLOCKSIZE,y*BLOCKSIZE,BLOCKSIZE,BLOCKSIZE,0) ;
end ;

procedure TBlockStartHorz.Draw(x,y:Integer) ; 
var x1,y1,y2,yw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y1+5,18) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y1+6,17) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y1+7,16) ;

  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y2-7,16) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y2-6,17) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y2-5,18) ;

  DrawLineVertByLen(x1+10,y1+6,8,18) ;
  DrawLineVertByLen(x1+11,y1+7,6,17) ;
  DrawLineVertByLen(x1+12,y1+8,4,16) ;
end ;

procedure TBlockFinish.Draw(x,y:Integer) ; 
var x1,y1:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineHorzByLen(x1,BLOCKSIZE,y1,9) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y1+BLOCKSIZE-1,9) ;
  DrawLineVertByLen(x1,y1,BLOCKSIZE,9) ;
  DrawLineVertByLen(x1+BLOCKSIZE-1,y1,BLOCKSIZE,9) ;
end ;

procedure TBlockHorz.Draw(x,y:Integer) ; 
var x1,y1,y2,yw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineHorzByLen(x1,BLOCKSIZE,y1+5,18) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y1+6,17) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y1+7,16) ;

  DrawLineHorzByLen(x1,BLOCKSIZE,y2-7,16) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y2-6,17) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y2-5,18) ;

  if (filledv>0) then 
    for yw:=y1+8 to y2-8 do
      DrawLineHorzByLen(x1,BLOCKSIZE,yw,11) ;
end ;

procedure TBlockVert.Draw(x,y:Integer) ; 
var x1,y1,x2,xw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineVertByLen(x1+5,y1,BLOCKSIZE,18) ;
  DrawLineVertByLen(x1+6,y1,BLOCKSIZE,17) ;
  DrawLineVertByLen(x1+7,y1,BLOCKSIZE,16) ;

  DrawLineVertByLen(x2-7,y1,BLOCKSIZE,16) ;
  DrawLineVertByLen(x2-6,y1,BLOCKSIZE,17) ;
  DrawLineVertByLen(x2-5,y1,BLOCKSIZE,18) ;

  if (filledv>0) then 
    for xw:=x1+8 to x2-8 do
      DrawLineVertByLen(xw,y1,BLOCKSIZE,11) ;
end ;

procedure TBlockLeftTop.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDYDX(x1+5,y1,6,-6,18) ;
  DrawCornerDYDX(x1+6,y1,7,-7,17) ;
  DrawCornerDYDX(x1+7,y1,8,-8,16) ;

  DrawCornerDYDX(x1+12,y1,13,-13,16) ;
  DrawCornerDYDX(x1+13,y1,14,-14,17) ;
  DrawCornerDYDX(x1+14,y1,15,-15,18) ;
end ;

procedure TBlockRightTop.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDYDX(x1+14,y1,6,6,18) ;
  DrawCornerDYDX(x1+13,y1,7,7,17) ;
  DrawCornerDYDX(x1+12,y1,8,8,16) ;

  DrawCornerDYDX(x1+7,y1,13,13,16) ;
  DrawCornerDYDX(x1+6,y1,14,14,17) ;
  DrawCornerDYDX(x1+5,y1,15,15,18) ;
end ;

procedure TBlockLeftBottom.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDXDY(x1,y1+5,15,15,18) ;
  DrawCornerDXDY(x1,y1+6,14,14,17) ;
  DrawCornerDXDY(x1,y1+7,13,13,16) ;
  
  DrawCornerDXDY(x1,y1+12,8,8,16) ;
  DrawCornerDXDY(x1,y1+13,7,7,17) ;
  DrawCornerDXDY(x1,y1+14,6,6,18) ;
end ;

procedure TBlockRightBottom.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+5,-15,15,18) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+6,-14,14,17) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+7,-13,13,16) ;

  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+12,-8,8,16) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+13,-7,7,17) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+14,-6,6,18) ;
end ;

function TGame.genRandomPipeBlock():TBlock ;
var r:Integer ;
begin
  r:=Random(2) ;
  if r=0 then Result:=TBlockHorz.Create() ;
  if r=1 then Result:=TBlockVert.Create() ;
end ;

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

constructor TGame.Create() ;
var i,j:Integer ;
begin
  selx:=3 ; 
  sely:=5 ;
  oldselx:=-1; oldsely:=-1 ;
  SetLength(map,MAPSIZE) ;
  for i:=0 to MAPSIZE-1 do
    SetLength(map[i],MAPSIZE) ;
  empty:=TBlockEmpty.Create ;
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      map[i][j]:=empty ;

  // level conf
  map[2][4]:=TBlockStartHorz.Create() ;

  map[8][1]:=TBlockFinish.Create() ;
  map[4][8]:=TBlockFinish.Create() ;

  map[5][5]:=TBlockLeftTop.Create() ;
  map[3][5]:=TBlockRightTop.Create() ;
  map[5][3]:=TBlockLeftBottom.Create() ;
  map[3][3]:=TBlockRightBottom.Create() ;

  tekblock:=genRandomPipeBlock() ;
  nextblock:=genRandomPipeBlock() ;
end ;

destructor TGame.Destroy() ;
var i,j:Integer ;
begin
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      if not empty.IsEmpty() then map[i][j].Free ;
  for i:=0 to MAPSIZE-1 do
    SetLength(map[i],0) ;
  SetLength(map,0) ;
  empty.Free ;
  inherited Destroy ;
end ;

procedure TGame.Render() ;
var i,j:Integer ;
begin
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      map[i][j].Draw(i,j) ;

  tekblock.Draw(12,1) ;
  nextblock.Draw(12,3) ;

  if (oldselx<>selx)or(oldsely<>sely) then begin
    if (oldselx<>-1) then ClearOldSelector() ;    
  end ;
  DrawSelector() ;
end ;

procedure TGame.RenderStatic() ;
begin
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,0,18) ;
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,1,17) ;
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,2,16) ;
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,SCREENH-3,16) ;
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,SCREENH-2,17) ;
  DrawLineHorz(MAPSIZE*BLOCKSIZE,SCREENW-1,SCREENH-1,18) ;
  DrawLineVert(MAPSIZE*BLOCKSIZE,0,SCREENH-1,18) ;
  DrawLineVert(MAPSIZE*BLOCKSIZE+1,1,SCREENH-2,17) ;
  DrawLineVert(MAPSIZE*BLOCKSIZE+2,2,SCREENH-3,16) ;
  DrawLineVert(SCREENW-3,2,SCREENH-3,16) ;
  DrawLineVert(SCREENW-2,1,SCREENH-2,17) ;
  DrawLineVert(SCREENW-1,0,SCREENH-1,18) ;

  SetCursorXY(28,1) ; Write('Current') ;
  SetCursorXY(28,6) ; Write(' Next') ;
end ;

function TGame.Update():Boolean ;
var key,scan:Byte ;
begin
  Result:=True ;
  oldselx:=selx; oldsely:=sely ;
  if IsKeyPressed(key,scan) then begin
    //Writeln(key,scan) ;
    if scan=72 then if sely>0 then Dec(sely) ;
    if scan=80 then if sely<MAPSIZE-1 then Inc(sely) ;
    if scan=75 then if selx>0 then Dec(selx) ;
    if scan=77 then if selx<MAPSIZE-1 then Inc(selx) ;
    if scan=57 then 
      if map[selx][sely].isEmpty() then begin
        map[selx][sely]:=tekblock ;
        tekblock:=nextblock ;
        nextblock:=genRandomPipeBlock() ;
      end ;
    if scan=1 then Result:=False ;
  end ;
end ;

end.
