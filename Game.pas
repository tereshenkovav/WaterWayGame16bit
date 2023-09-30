unit Game ;

interface
uses Block ;

type
  TGame = class
  private
    selx,sely:Integer ;
    oldselx,oldsely:Integer ;
    map:array of array of TBlock ;
    empty:TBlockEmpty ;
    tekblock:TBlock ;
    nextblock:TBlock ;
    ticks:Cardinal ;
    gameover:Boolean ;
    procedure DrawSelector() ;
    procedure ClearOldSelector() ;
    function genRandomPipeBlock():TBlock ;
  public
    constructor Create() ;
    destructor Destroy() ; override ;
    procedure Render() ;
    procedure RenderStatic() ;
    function Update():Boolean ;
    function isGameOver():Boolean ;
  end ;

implementation
uses ObjModule, CommonClasses, GameEngine16 ;

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
  ticks:=0 ;
  gameover:=False ;

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

  map[4][4]:=TBlockLeftBottom.Create() ;
  map[4][6]:=TBlockLeftTop.Create() ;
  map[2][6]:=TBlockRightBottom.Create() ;
  map[2][8]:=TBlockRightTop.Create() ;

  map[8][8]:=TBlockWall.Create() ;

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
    i,j,e,newi,newj:Integer ;
    p,idx,idx2:Integer ;
    newfill:array[0..15] of TNewWater ;
begin
  Result:=True ;
  if gameover then Exit ;

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

  Inc(ticks) ;
  if ticks mod 2 = 0 then begin
    p:=0 ;
    for i:=0 to MAPSIZE-1 do
      for j:=0 to MAPSIZE-1 do
        if map[i][j].UpdateWater() then begin
         for e:=0 to 3 do begin
          idx:=map[i][j].getItemIndexAtEntry(arr_ex[e],arr_ey[e]) ;
          if idx<>-1 then 
            if map[i][j].isItemFilled(idx) then begin
              newi:=i+arr_ex[e] ; newj:=j+arr_ey[e] ; 
              if (newi<0)or(newj<0)or(newi=MAPSIZE)or(newj=MAPSIZE) then begin
                gameover:=True ; 
                exit ;
              end ;
              if map[newi][newj].isEmpty() then begin
                gameover:=True ; 
                exit ;
              end ;
              idx2:=map[newi][newj].getItemIndexAtEntry(-arr_ex[e],-arr_ey[e]) ;
              if idx2=-1 then begin 
                gameover:=True ; 
                exit ;
              end ;
              newfill[p]:=NewWater(newi,newj,idx2) ;
              Inc(p) ;
            end ;
         end ;
        end ;

    for i:=0 to p-1 do
      map[newfill[i].i][newfill[i].j].fillItem(newfill[i].idx) ;

  end ;

  if ticks=5*18 then 
    for i:=0 to MAPSIZE-1 do
      for j:=0 to MAPSIZE-1 do begin
        if map[i][j] is TBlockStartHorz then 
          TBlockStartHorz(map[i][j]).StartWater() ;
      end ;
end ;

function TGame.isGameOver():Boolean ;
begin
  Result:=gameover ;
end ;

end.
