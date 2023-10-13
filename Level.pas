unit Level ;

interface

type 
  TLevel = class
  private
    leveln:Integer ;
    arr:array of Byte ;
    seq:array of Byte ;
    nextp:Integer ;
  public
    constructor Create(Aleveln:Integer) ;
    destructor Destroy ; override ;
    function getLevelN():Integer ;
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
var src:array of byte ;
    i,idx1,idx2:Integer ;
    tmp:byte; 
begin
  Self.leveln:=Aleveln ;
  if leveln=0 then arr:=level1_blocks ;
  if leveln=1 then arr:=level2_blocks ;
  if leveln=2 then arr:=level3_blocks ;
  if leveln=3 then arr:=level4_blocks ;
  if leveln=4 then arr:=level5_blocks ;
  if leveln=5 then arr:=level6_blocks ;
  if leveln=6 then arr:=level7_blocks ;
  if leveln=7 then arr:=level8_blocks ;
  if leveln=0 then src:=level1_freq_blocks ;
  if leveln=1 then src:=level2_freq_blocks ;
  if leveln=2 then src:=level3_freq_blocks ;
  if leveln=3 then src:=level4_freq_blocks ;
  if leveln=4 then src:=level5_freq_blocks ;
  if leveln=5 then src:=level6_freq_blocks ;
  if leveln=6 then src:=level7_freq_blocks ;
  if leveln=7 then src:=level8_freq_blocks ;
  SetLength(seq,Length(src)) ;
  for i:=0 to Length(seq)-1 do
    seq[i]:=src[i] ;
  for i:=0 to 10*Length(seq)-1 do begin
    idx1:=GetRandom(Length(seq)) ;
    idx2:=GetRandom(Length(seq)) ;
    tmp:=seq[idx1] ;
    seq[idx1]:=seq[idx2] ;
    seq[idx2]:=tmp ;
  end ;
  nextp:=0 ;
end ;

destructor TLevel.Destroy ;
begin
  SetLength(seq,0) ;
  inherited Destroy ; 
end ;

function TLevel.getLevelN():Integer ;
begin
  Result:=leveln ;
end ;

function TLevel.getRandomBlockCode():Integer ;
begin
  Result:=seq[nextp] ;
  Inc(nextp) ;
  if nextp=Length(seq) then nextp:=0 ;
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
