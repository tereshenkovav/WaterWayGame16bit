unit Block ;

interface
uses BlockDescr, CommonClasses ;

type
  TBlock = class
  protected
    descr:TBlockDescr ;
    filled:array of Boolean ;
    procedure DrawWater(x1,y1:Integer) ;
    function getLinkCount():Integer ;
    function getLink(i:Integer):TLink ;
  public
    constructor Create(Adescr:TBlockDescr) ; 
    function getItemIndexAtEntry(ex,ey:Smallint):Integer ;
    function isItemFilled(idx:Integer):Boolean ;
    procedure fillItem(idx:Integer) ;
    procedure StartWater() ; // Просто обертка для удобства
    function UpdateWater():Boolean ;
    procedure Draw(x,y:Integer); virtual ; abstract ;
    function isEmpty():Boolean ; virtual ;
  end ;

  TBlockEmpty = class(TBlock)
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
    function isEmpty():Boolean ; override ;
  end ;

  TBlockWall = class(TBlock)
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockStartHorz = class(TBlock)
  private
  public
    constructor Create() ;
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockStartVert = class(TBlock)
  private
  public
    constructor Create() ;
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockFinish = class(TBlock)
  private
  public
    constructor Create() ;
    function isFilled():Boolean ;
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockHorz = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockVert = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockLeftTop = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockRightTop = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockLeftBottom = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockRightBottom = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockTripleLeft = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockTripleRight = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockTripleTop = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockTripleBottom = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

  TBlockQuad = class(TBlock)
  private
  public
    constructor Create() ; 
    procedure Draw(x,y:Integer); override ;
  end ;

implementation
uses CommonProc, ObjModule, GameEngine16 ;

constructor TBlock.Create(Adescr:TBlockDescr) ;
var i:Integer ;
begin
  descr:=Adescr ;
  SetLength(filled,Length(descr.items)) ;
  for i:=0 to Length(descr.items)-1 do
    filled[i]:=False ;
end ;

function TBlock.getLinkCount():Integer ;
begin
  if descr.linktype=ltLinear then Result:=Length(filled)-1 ;
  if descr.linktype=ltTriple then Result:=Length(arr_triple) ;
  if descr.linktype=ltQuad then Result:=Length(arr_quad) ;
end ;

function TBlock.getLink(i:Integer):TLink ;
begin
  if descr.linktype=ltLinear then Result:=arr_linear[i] ;
  if descr.linktype=ltTriple then Result:=arr_triple[i] ;
  if descr.linktype=ltQuad then Result:=arr_quad[i] ;
end ;

function TBlock.UpdateWater():Boolean ;
var i,j,p:Integer ;
    newfilled:array[0..15] of Integer ;
begin
  p:=0 ;
  for i:=0 to getLinkCount()-1 do begin
    if filled[getLink(i).i1] and (not filled[getLink(i).i2]) then begin
      newfilled[p]:=getLink(i).i2 ;
      Inc(p) ;
    end ;
    if filled[getLink(i).i2] and (not filled[getLink(i).i1]) then begin
      newfilled[p]:=getLink(i).i1 ;
      Inc(p) ;
    end ;
  end ;

  for i:=0 to p-1 do
    filled[newfilled[i]]:=True ;
  Result:=p>0 ;
end ;

procedure TBlock.DrawWater(x1,y1:Integer) ;
var i,j:Integer ;
begin
  for i:=0 to Length(filled)-1 do 
    if filled[i] then 
      for j:=0 to 3 do
        DrawPixel(x1+descr.items[i].pixels[j].x,y1+descr.items[i].pixels[j].y,11) ;
end ;

function TBlock.getItemIndexAtEntry(ex,ey:Smallint):Integer ;
begin
  Result:=descr.entry[ex,ey] ;
end ;

function TBlock.isItemFilled(idx:Integer):Boolean ;
begin
  Result:=filled[idx] ;
end ;

procedure TBlock.fillItem(idx:Integer) ;
begin
  filled[idx]:=True ;
end ;

function TBlock.isEmpty():Boolean ; 
begin
  Result:=False ;
end ;

procedure TBlock.StartWater() ;
begin
  if Length(filled)>0 then filled[0]:=True ;
end ;

constructor TBlockEmpty.Create() ; 
begin
  inherited Create(bdnull) ;
end ;

function TBlockEmpty.isEmpty():Boolean ; 
begin
  Result:=True ;
end ;

procedure TBlockEmpty.Draw(x,y:Integer) ; 
begin
  FillRect(x*BLOCKSIZE,y*BLOCKSIZE,BLOCKSIZE,BLOCKSIZE,0) ;
end ;

constructor TBlockWall.Create() ; 
begin
  inherited Create(bdnull) ;
end ;

procedure TBlockWall.Draw(x,y:Integer) ; 
var x1,y1:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  FillRect(x1+2,y1+2,BLOCKSIZE-4,BLOCKSIZE-4,16) ;
  FillRect(x1+4,y1+4,BLOCKSIZE-8,BLOCKSIZE-8,17) ;
  FillRect(x1+6,y1+6,BLOCKSIZE-12,BLOCKSIZE-12,18) ;
end ;

constructor TBlockStartHorz.Create() ;
begin
  inherited Create(bdstarthorz) ;
end ;

procedure TBlockStartHorz.Draw(x,y:Integer) ; 
var x1,y1,y2,yw:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineHorzByLen(x1+BLOCKSIZE div 2-1,BLOCKSIZE div 2+1,y1+5,18) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y1+6,17) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y1+7,16) ;

  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y2-7,16) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2,BLOCKSIZE div 2,y2-6,17) ;
  DrawLineHorzByLen(x1+BLOCKSIZE div 2-1,BLOCKSIZE div 2+1,y2-5,18) ;

  DrawLineVertByLen(x1+7,y1+4,12,18) ;
  DrawLineVertByLen(x1+8,y1+4,12,18) ;
  DrawLineVertByLen(x1+9,y1+6,8,17) ;
  DrawLineVertByLen(x1+10,y1+6,8,17) ;
  DrawLineVertByLen(x1+11,y1+8,4,16) ;
  DrawLineVertByLen(x1+12,y1+8,4,16) ;

  DrawLineHorzByLen(x1+2,6,y1+3,18) ;
  DrawLineHorzByLen(x1+2,6,y1+16,18) ;
  DrawLineVertByLen(x1+2,y1+3,13,18) ;
  FillRect(x1+3,y1+4,4,12,11) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockStartVert.Create() ;
begin
  inherited Create(bdstartvert) ;
end ;

procedure TBlockStartVert.Draw(x,y:Integer) ; 
var x1,y1,x2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawLineVertByLen(x1+5,y1+BLOCKSIZE div 2-1,BLOCKSIZE div 2+1,18) ;
  DrawLineVertByLen(x1+6,y1+BLOCKSIZE div 2,BLOCKSIZE div 2,17) ;
  DrawLineVertByLen(x1+7,y1+BLOCKSIZE div 2,BLOCKSIZE div 2,16) ;

  DrawLineVertByLen(x2-7,y1+BLOCKSIZE div 2,BLOCKSIZE div 2,16) ;
  DrawLineVertByLen(x2-6,y1+BLOCKSIZE div 2,BLOCKSIZE div 2,17) ;
  DrawLineVertByLen(x2-5,y1+BLOCKSIZE div 2-1,BLOCKSIZE div 2+1,18) ;

  DrawLineHorzByLen(x1+4,12,y1+7, 18) ;
  DrawLineHorzByLen(x1+4,12,y1+8, 18) ;
  DrawLineHorzByLen(x1+6,8, y1+9, 17) ;
  DrawLineHorzByLen(x1+6,8, y1+10,17) ;
  DrawLineHorzByLen(x1+8,4, y1+11,16) ;
  DrawLineHorzByLen(x1+8,4, y1+12,16) ;

  DrawLineVertByLen(x1+3,y1+2,6,18) ;
  DrawLineVertByLen(x1+16,y1+2,6,18) ;
  DrawLineHorzByLen(x1+3,13,y1+2,18) ;
  FillRect(x1+4,y1+3,12,4,11) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockFinish.Create() ;
begin
  inherited Create(bdfinish) ;
end ;

function TBlockFinish.isFilled():Boolean ;
begin
  Result:=filled[0] ;
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

  if filled[0] then FillRect(x1+1,y1+1,BLOCKSIZE-2,BLOCKSIZE-2,11) ;
end ;

constructor TBlockHorz.Create() ;
begin
  inherited Create(bdhorz) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockVert.Create() ;
begin
  inherited Create(bdvert) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockLeftTop.Create() ;
begin
  inherited Create(bdlefttop) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockRightTop.Create() ;
begin
  inherited Create(bdrighttop) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockLeftBottom.Create() ;
begin
  inherited Create(bdleftbottom) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockRightBottom.Create() ;
begin
  inherited Create(bdrightbottom) ;
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

  DrawWater(x1,y1) ;
end ;

constructor TBlockTripleLeft.Create() ;
begin
  inherited Create(bdtripleleft) ;
end ;

procedure TBlockTripleLeft.Draw(x,y:Integer) ; 
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

  DrawCornerDXDY(x1,y1+12,8,8,16) ;
  DrawCornerDXDY(x1,y1+13,7,7,17) ;
  DrawCornerDXDY(x1,y1+14,6,6,18) ;

  DrawLineVertByLen(x2-7,y1,BLOCKSIZE,16) ;
  DrawLineVertByLen(x2-6,y1,BLOCKSIZE,17) ;
  DrawLineVertByLen(x2-5,y1,BLOCKSIZE,18) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockTripleRight.Create() ;
begin
  inherited Create(bdtripleright) ;
end ;

procedure TBlockTripleRight.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+12,-8,8,16) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+13,-7,7,17) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+14,-6,6,18) ;

  DrawCornerDYDX(x1+14,y1,6,6,18) ;
  DrawCornerDYDX(x1+13,y1,7,7,17) ;
  DrawCornerDYDX(x1+12,y1,8,8,16) ;

  DrawLineVertByLen(x1+5,y1,BLOCKSIZE,18) ;
  DrawLineVertByLen(x1+6,y1,BLOCKSIZE,17) ;
  DrawLineVertByLen(x1+7,y1,BLOCKSIZE,16) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockTripleTop.Create() ;
begin
  inherited Create(bdtripletop) ;
end ;

procedure TBlockTripleTop.Draw(x,y:Integer) ; 
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

  DrawCornerDYDX(x1+14,y1,6,6,18) ;
  DrawCornerDYDX(x1+13,y1,7,7,17) ;
  DrawCornerDYDX(x1+12,y1,8,8,16) ;

  DrawLineHorzByLen(x1,BLOCKSIZE,y2-7,16) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y2-6,17) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y2-5,18) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockTripleBottom.Create() ;
begin
  inherited Create(bdtriplebottom) ;
end ;

procedure TBlockTripleBottom.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDXDY(x1,y1+12,8,8,16) ;
  DrawCornerDXDY(x1,y1+13,7,7,17) ;
  DrawCornerDXDY(x1,y1+14,6,6,18) ;

  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+12,-8,8,16) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+13,-7,7,17) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+14,-6,6,18) ;

  DrawLineHorzByLen(x1,BLOCKSIZE,y1+5,18) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y1+6,17) ;
  DrawLineHorzByLen(x1,BLOCKSIZE,y1+7,16) ;

  DrawWater(x1,y1) ;
end ;

constructor TBlockQuad.Create() ;
begin
  inherited Create(bdquad) ;
end ;

procedure TBlockQuad.Draw(x,y:Integer) ; 
var x1,y1,x2,y2:Integer ;
begin
  x1:=x*BLOCKSIZE ;
  y1:=y*BLOCKSIZE ;
  x2:=x*BLOCKSIZE+BLOCKSIZE-1 ;
  y2:=y*BLOCKSIZE+BLOCKSIZE-1 ;

  FillRect(x1,y1,BLOCKSIZE,BLOCKSIZE,0) ;

  DrawCornerDXDY(x1,y1+12,8,8,16) ;
  DrawCornerDXDY(x1,y1+13,7,7,17) ;
  DrawCornerDXDY(x1,y1+14,6,6,18) ;

  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+12,-8,8,16) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+13,-7,7,17) ;
  DrawCornerDXDY(x1+BLOCKSIZE-1,y1+14,-6,6,18) ;

  DrawCornerDYDX(x1+5,y1,6,-6,18) ;
  DrawCornerDYDX(x1+6,y1,7,-7,17) ;
  DrawCornerDYDX(x1+7,y1,8,-8,16) ;

  DrawCornerDYDX(x1+14,y1,6,6,18) ;
  DrawCornerDYDX(x1+13,y1,7,7,17) ;
  DrawCornerDYDX(x1+12,y1,8,8,16) ;

  DrawWater(x1,y1) ;
end ;

end.