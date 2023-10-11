unit Game ;

interface
uses Block, CommonClasses ;

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
    state:TGameState ;
    startleft:Integer ;
    beep:Boolean ;
    startbeep:Boolean ;
    procedure DrawSelector() ;
    procedure RedrawSelectorIfAt(x,y:Integer) ;
    function genRandomPipeBlock():TBlock ;
    procedure DrawTekNext() ;
    function createBlockByCode(r:Integer):TBlock ;
  public
    constructor Create(leveln:Integer) ;
    destructor Destroy() ; override ;
    procedure RenderOnce() ;
    procedure RenderStatic() ;
    function Update():Boolean ;
    function isGameOver():Boolean ;
    function isWin():Boolean ;
    function isBeepEmitted():Boolean ;
  end ;

implementation
uses ObjModule, GameEngine16, Level, CommonProc ;

function TGame.createBlockByCode(r:Integer):TBlock ;
begin
  if r=0 then Result:=TBlockHorz.Create() ;
  if r=1 then Result:=TBlockVert.Create() ;
  if r=2 then Result:=TBlockLeftTop.Create() ;
  if r=3 then Result:=TBlockRightTop.Create() ;
  if r=4 then Result:=TBlockLeftBottom.Create() ;
  if r=5 then Result:=TBlockRightBottom.Create() ;
  if r=6 then Result:=TBlockTripleLeft.Create() ;
  if r=7 then Result:=TBlockTripleRight.Create() ;
  if r=8 then Result:=TBlockTripleTop.Create() ;
  if r=9 then Result:=TBlockTripleBottom.Create() ;
  if r=10 then Result:=TBlockQuad.Create() ;
  // —лужебные блоки - на эти коды зав€заны карты уровней
  if r=CODE_STARTHORZ then Result:=TBlockStartHorz.Create() ;
  if r=CODE_STARTVERT then Result:=TBlockStartVert.Create() ;
  if r=CODE_FINISH then Result:=TBlockFinish.Create() ;
  if r=CODE_WALL then Result:=TBlockWall.Create() ;
end ;

function TGame.genRandomPipeBlock():TBlock ;
begin
  Result:=createBlockByCode(GetRandom(11)) ;
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

procedure TGame.RedrawSelectorIfAt(x,y:Integer) ;
begin
  if (x=selx)and(y=sely) then DrawSelector() ;
end ;

procedure TGame.DrawTekNext() ;
begin
  tekblock.Draw(12,1) ;
  nextblock.Draw(12,3) ;
end ;

constructor TGame.Create(leveln:Integer) ;
var i,j:Integer ;
    level:TLevel ;
begin
  beep:=False ;
  startbeep:=False ;
  ticks:=0 ;
  state:=gsNormal ;

  level:=TLevel.Create(leveln) ;

  startleft:=TICKSINSEC*level.getWaterTime() ; 
  selx:=MAPSIZE div 2 ; 
  sely:=MAPSIZE div 2 ;
  oldselx:=-1; oldsely:=-1 ;
  SetLength(map,MAPSIZE) ;
  for i:=0 to MAPSIZE-1 do
    SetLength(map[i],MAPSIZE) ;
  empty:=TBlockEmpty.Create ;
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      map[i][j]:=empty ;
  
  for i:=0 to level.getBlockCount()-1 do 
    map[level.getBlockX(i)][level.getBlockY(i)]:=
      createBlockByCode(level.getBlockCode(i)) ; 

  level.Free ;

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

procedure TGame.RenderOnce() ;
var i,j:Integer ;
begin
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      map[i][j].Draw(i,j) ;

  DrawTekNext() ;
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
    cnt,cntfilled:Integer ;
begin
  Result:=True ;
  if state<>gsNormal then Exit ;

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
        map[selx][sely].Draw(oldselx,oldsely) ;
        DrawTekNext() ;
        DrawSelector() ;
      end ;
    if scan=1 then Result:=False ;
  end ;
  if (oldselx<>selx)or(oldsely<>sely) then begin
    if (oldselx<>-1) then map[oldselx][oldsely].Draw(oldselx,oldsely) ;
    DrawSelector() ;
  end ;

  cntfilled:=0 ;
  cnt:=0 ;
  for i:=0 to MAPSIZE-1 do
    for j:=0 to MAPSIZE-1 do
      if map[i][j] is TBlockFinish then begin
        Inc(cnt) ; 
        if TBlockFinish(map[i][j]).isFilled() then Inc(cntfilled) ;
      end ;
  if cntfilled=cnt then begin
    state:=gsWin ; 
    exit ;
  end ;

  Inc(ticks) ;
  if ticks mod 3 = 0 then begin
    p:=0 ;
    for i:=0 to MAPSIZE-1 do
      for j:=0 to MAPSIZE-1 do
        if map[i][j].UpdateWater() then begin
         map[i][j].Draw(i,j) ;
         RedrawSelectorIfAt(i,j) ;
         for e:=0 to 3 do begin
          idx:=map[i][j].getItemIndexAtEntry(arr_ex[e],arr_ey[e]) ;
          if idx<>-1 then 
            if map[i][j].isItemFilled(idx) then begin
              newi:=i+arr_ex[e] ; newj:=j+arr_ey[e] ; 
              if (newi<0)or(newj<0)or(newi=MAPSIZE)or(newj=MAPSIZE) then begin
                state:=gsFail ; 
                exit ;
              end ;
              if map[newi][newj].isEmpty() then begin
                state:=gsFail ; 
                exit ;
              end ;
              idx2:=map[newi][newj].getItemIndexAtEntry(-arr_ex[e],-arr_ey[e]) ;
              if idx2=-1 then begin 
                state:=gsFail ; 
                exit ;
              end ;
              newfill[p]:=NewWater(newi,newj,idx2) ;
              Inc(p) ;
            end ;
         end ;
        end ;

    for i:=0 to p-1 do begin
      map[newfill[i].i][newfill[i].j].fillItem(newfill[i].idx) ;
      map[newfill[i].i][newfill[i].j].Draw(newfill[i].i,newfill[i].j) ;
      RedrawSelectorIfAt(newfill[i].i,newfill[i].j) ;
    end ;  

  end ;

  if startleft>0 then begin
    Dec(startleft) ;
    SetCursorXY(26,12) ; 
    if startleft>0 then Write('Water in ',startleft div TICKSINSEC + 1,' ') else Write('           ') ;
    if (startleft<=TICKSINSEC) and (not startbeep) then begin
      beep:=True ;
      startbeep:=True ;
    end ;
    if startleft<=0 then
      for i:=0 to MAPSIZE-1 do
        for j:=0 to MAPSIZE-1 do 
          if (map[i][j] is TBlockStartHorz)or(map[i][j] is TBlockStartVert) then
            map[i][j].StartWater() ;
  end ;
end ;

function TGame.isGameOver():Boolean ;
begin
  Result:=state<>gsNormal ;
end ;

function TGame.isWin():Boolean ;
begin
  Result:=state=gsWin ;
end ;

function TGame.isBeepEmitted():Boolean ;
begin
  Result:=beep ;
  beep:=False ;
end ;

end.
