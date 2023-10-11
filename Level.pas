unit Level ;

interface

type 
  TLevel = class
  private
    leveln:Integer ;
    arr:array of Byte ;
    freq:array of Byte ;
  public
    constructor Create(Aleveln:Integer) ;
    function getRandomBlockCode():Integer ;
    function getWaterTime():Byte ;
    function getBlockCount():Byte ;
    function getBlockX(i:Integer):Byte ;
    function getBlockY(i:Integer):Byte ;
    function getBlockCode(i:Integer):Byte ;
  end ;

implementation
uses ObjModule, CommonProc ;

constructor TLevel.Create(Aleveln:Integer) ;
begin
  Self.leveln:=Aleveln ;
  if leveln=0 then arr:=level1_blocks ;
  if leveln=1 then arr:=level2_blocks ;
  if leveln=0 then freq:=level1_freq_blocks ;
  if leveln=1 then freq:=level2_freq_blocks ;
end ;

function TLevel.getRandomBlockCode():Integer ;
begin
  Result:=freq[GetRandom(Length(freq))]
end ;

function TLevel.getWaterTime():Byte ;
begin
  Result:=levelwatertimes[leveln] ;
end ;

function TLevel.getBlockCount():Byte ;
begin
  Result:=Length(arr) div 3 ;
end ;

function TLevel.getBlockX(i:Integer):Byte ;
begin
  Result:=arr[3*i+1] ;
end ;

function TLevel.getBlockY(i:Integer):Byte ;
begin
  Result:=arr[3*i+2] ;
end ;

function TLevel.getBlockCode(i:Integer):Byte ;
begin
  Result:=arr[3*i] ;
end ;

end.