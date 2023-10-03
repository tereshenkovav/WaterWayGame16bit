unit CommonClasses ;

interface

type
  TLinkType = (ltLinear,ltTriple,ltQuad) ;

  TGameState = (gsNormal,gsWin,gsFail) ;

  TXY = record
    x:Byte ;
    y:Byte ;
  end ;
  
  TWaterItem = record
    pixels:array[0..3] of TXY ;
  end ;

  TLink = record
    i1:Byte ;
    i2:Byte ;
  end ;

  TNewWater = record
    i:Integer ;
    j:Integer ;
    idx:Integer ;
  end ;

function NewXY(x,y:Byte):TXY ;
function NewLink(i1,i2:Byte):TLink ;
function NewWater(i,j,idx:Integer):TNewWater ;

implementation

function NewXY(x,y:Byte):TXY ;
begin
  Result.x:=x ;
  Result.y:=y ;
end ;

function NewLink(i1,i2:Byte):TLink ;
begin
  Result.i1:=i1 ;
  Result.i2:=i2 ;
end ;

function NewWater(i,j,idx:Integer):TNewWater ;
begin
  Result.i:=i ;
  Result.j:=j ;
  Result.idx:=idx ;
end ;

end.