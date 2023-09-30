unit BlockDescr ;

interface
uses CommonClasses ;

type
  TBlockDescr = class
  public
    items:array of TWaterItem ;    
    entry:array[-1..1,-1..1] of Smallint ;
    linktype:TLinkType ;
    constructor Create() ;
    constructor CreateNull() ;
    constructor CreateStartHorz() ;
    constructor CreateStartVert() ;
    constructor CreateFinish() ;
    constructor CreateHorz() ;
    constructor CreateVert() ;
    constructor CreateLeftTop() ;
    constructor CreateRightTop() ;
    constructor CreateLeftBottom() ;
    constructor CreateRightBottom() ;
  end ;

implementation
uses ObjModule ;

constructor TBlockDescr.Create() ;
begin
  entry[-1,0]:=-1 ; entry[1,0]:=-1 ;
  entry[0,-1]:=-1 ; entry[0,1]:=-1 ;
end ;

constructor TBlockDescr.CreateFinish() ;
begin
  Create() ;
  SetLength(items,1) ;
  linktype:=ltLinear ;
  entry[-1,0]:=0 ;
  entry[1,0]:=0 ;
  entry[0,-1]:=0 ;
  entry[0,1]:=0 ;
end ;

constructor TBlockDescr.CreateNull() ;
begin
  Create() ;
  SetLength(items,1) ;
  linktype:=ltLinear ;
end ;

constructor TBlockDescr.CreateStartHorz() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,7) ;
  for x:=0 to 6 do 
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(13 + x,y+8) ;
  entry[1,0]:=6 ;
end ;

constructor TBlockDescr.CreateStartVert() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,7) ;
  for x:=0 to 6 do 
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(y+8,13+x) ;
  entry[0,1]:=6 ;
end ;

constructor TBlockDescr.CreateHorz() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;
  for x:=0 to BLOCKSIZE-1 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(x,y+8) ;
  entry[-1,0]:=0 ;
  entry[1,0]:=BLOCKSIZE-1 ;
end ;

constructor TBlockDescr.CreateVert() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;
  for x:=0 to BLOCKSIZE-1 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(y+8,x) ;
  entry[0,-1]:=0 ;
  entry[0,1]:=BLOCKSIZE-1 ;
end ;

constructor TBlockDescr.CreateLeftTop() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;

  for x:=0 to 11 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(x,y+8) ;

  for x:=0 to 7 do
    for y:=0 to 3 do
      items[12+x].pixels[y]:=NewXY(y+8,7-x) ;

  entry[-1,0]:=0 ;
  entry[0,-1]:=BLOCKSIZE-1 ;
end ;

constructor TBlockDescr.CreateRightTop() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;

  for x:=0 to 11 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(19-x,y+8) ;

  for x:=0 to 7 do
    for y:=0 to 3 do
      items[12+x].pixels[y]:=NewXY(y+8,7-x) ;

  entry[1,0]:=0 ;
  entry[0,-1]:=BLOCKSIZE-1 ;
end ;

constructor TBlockDescr.CreateLeftBottom() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;

  for x:=0 to 11 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(x,y+8) ;

  for x:=0 to 7 do
    for y:=0 to 3 do
      items[12+x].pixels[y]:=NewXY(y+8,12+x) ;

  entry[-1,0]:=0 ;
  entry[0,1]:=BLOCKSIZE-1 ;
end ;

constructor TBlockDescr.CreateRightBottom() ;
var x,y:Byte ;
begin
  Create() ;
  linktype:=ltLinear ;
  SetLength(items,BLOCKSIZE) ;

  for x:=0 to 11 do
    for y:=0 to 3 do
      items[x].pixels[y]:=NewXY(19-x,y+8) ;

  for x:=0 to 7 do
    for y:=0 to 3 do
      items[12+x].pixels[y]:=NewXY(y+8,12+x) ;

  entry[1,0]:=0 ;
  entry[0,1]:=BLOCKSIZE-1 ;
end ;

end.