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

  TBlockHorz = class(TBlock)
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
    procedure DrawSelector() ;
    procedure ClearOldSelector() ;
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
  MAPSIZE = 10 ;

function TBlock.isEmpty():Boolean ; 
begin
  Result:=False ;
end ;

function TBlockEmpty.isEmpty():Boolean ; 
begin
  Result:=True ;
end ;

procedure TBlockEmpty.Draw(x,y:Integer) ; 
var i:Integer ;
begin
  for i:=0 to BLOCKSIZE-1 do
    DrawLineHorzByLen(x*BLOCKSIZE,BLOCKSIZE,y*BLOCKSIZE+i,0) ;
end ;

procedure TBlockHorz.Draw(x,y:Integer) ; 
var x1,y1,y2,yw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;
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
    if scan=72 then if sely>0 then Dec(sely) ;
    if scan=80 then if sely<MAPSIZE-1 then Inc(sely) ;
    if scan=75 then if selx>0 then Dec(selx) ;
    if scan=77 then if selx<MAPSIZE-1 then Inc(selx) ;
    if scan=57 then 
      if map[selx][sely].isEmpty() then map[selx][sely]:=TBlockHorz.Create() ;
    if scan=1 then Result:=False ;
  end ;
end ;

end.
