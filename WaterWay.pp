program WaterWay ;

uses GameEngine16, Game, ObjModule, CommonProc, Block ;

var
   nextlevel:Integer ;

function StartGame():Boolean ;
var tekframe:Word ;
    soundlen:Integer ;
    tekgame:TGame ;
    key,scan:Byte ;
begin
   Result:=False ;
   tekgame:=TGame.Create(nextlevel) ;

   soundlen:=0 ;
   ClearScreen(0) ;
   SoundOff() ;
   tekgame.RenderStatic() ;
   tekgame.RenderOnce() ;
   while true do begin
     tekframe:=StartFrame() ;

     if not tekgame.Update() then Break ;

     if tekgame.isBeepEmitted() then begin
       SoundOn() ;
       SoundFreq(1000) ;
       soundlen:=TICKSINSEC ;
     end ;

     if soundlen>0 then begin
       Dec(soundlen) ;
       if soundlen<=0 then SoundOff() ;
     end ;

     if tekgame.isGameOver() then begin
       WriteXY(26,14,'Game over') ;
       WriteXY(26,23,'Press Enter') ;
       if tekgame.isWin() then begin
         WriteXY(26,15,'You winner!') ;
         if nextlevel=levelcount-1 then begin
           WriteXY(26,17,'Game finished!') ;
         end
         else begin
           WriteXY(26,17,'Your code:') ;
           WriteXY(26,18,levelcodes[nextlevel]) ;
           Inc(nextlevel) ;
           Result:=True ;
         end ;
       end 
       else begin ;
         WriteXY(26,15,'You failed!') ;
       end ;
       while True do begin
         WaitKeyPressed(key,scan) ;
         if scan=28 then break ;
       end ;
       break ;
     end ;

     WaitFrameCompleted(tekframe) ;
   end ;

   tekgame.Free ;
end ;

procedure DrawHelp() ;
var key,scan:Byte ;
begin
   ClearScreen(0) ;
   WriteXY(6,2,'The game is a remake of the ') ;
   WriteXY(8,3,'classic "Pipeman" game.') ;

   WriteXY(4,5,'The player''s task is to pipe water');
   WriteXY(2,6,'from the sources to the all') ;
   WriteXY(2,7,'destination points (blue rects).') ;
   WriteXY(2,8,'Pipes can be placed anywhere, ') ;
   WriteXY(2,9,'the installation is done by pressing') ;
   WriteXY(2,10,'the "Space bar". Pipes can be') ;
   WriteXY(2,11,'replaced (several times on level),') ;
   WriteXY(2,12,'but they cannot be rotated.') ;
   WriteXY(2,13,'The level is completed when all the') ;
   WriteXY(2,14,'destination points are filled. ') ;
   WriteXY(2,15,'If the water spills out of the pipe,') ;
   WriteXY(2,16,'then the game is lost.') ;

   WriteXY(13,19,'Developed by:') ;
   WriteXY(8,21,'Aleksandr V. Tereshenkov') ;
   WriteXY(8,22,'github.com/tereshenkovav') ;
   WriteXY(9,23,'tav-developer.itch.io') ;

   WaitKeyPressed(key,scan) ;
end ;

procedure EnterCode() ;
var s:string ;
    i:Integer ;
begin
   WriteXY(10,20,'Enter level code:') ;
   Readln(s) ;
   for i:=0 to levelcount-2 do
     if (s=levelcodes[i]) then nextlevel:=i+1 ;
end ;

var key,scan:Byte ;
    block1:TBlock ;
    i:Integer ;
begin
   Screen($13) ;
   InitRandom() ;
   SetPaletteData(16,3,pal) ;

  while (True) do begin 
   ClearScreen(0) ;

   block1:=TBlockVert.Create() ;
   block1.Draw(4,2) ;
   block1.Draw(4,4) ;
   block1.Draw(4,5) ;
   block1.Draw(4,6) ;
   block1.Draw(11,2) ;
   block1.Draw(11,4) ;
   block1.Draw(11,5) ;
   block1.Draw(11,6) ;
   block1.Free ;
   block1:=TBlockHorz.Create() ;
   for i:=5 to 10 do begin
     block1.Draw(i,1) ;
     block1.Draw(i,3) ;
     block1.Draw(i,7) ;
   end ;
   block1.Free ;
   block1:=TBlockRightBottom.Create() ;   block1.Draw(4,1) ;   block1.Free ;
   block1:=TBlockLeftBottom.Create() ;   block1.Draw(11,1) ;   block1.Free ;
   block1:=TBlockTripleRight.Create() ;   block1.Draw(4,3) ;   block1.Free ;
   block1:=TBlockTripleLeft.Create() ;   block1.Draw(11,3) ;   block1.Free ;
   block1:=TBlockRightTop.Create() ;   block1.Draw(4,7) ;   block1.Free ;
   block1:=TBlockLeftTop.Create() ;   block1.Draw(11,7) ;   block1.Free ;

   WriteXY(14,5,'Pipeman game') ;
   WriteXY(17,6,'v0.5.0') ;

   SetCursorXY(13,11) ; Write('Level: ',nextlevel+1) ;
   WriteXY(13,13,'1 - Start game') ;
   WriteXY(13,14,'2 - Enter code') ;
   WriteXY(13,15,'3 - Help') ;
   WriteXY(13,16,'0 - Exit') ;

   while True do begin
     WaitKeyPressed(key,scan) ;
     if key=48 then begin
       Screen($3) ;
       SoundOff() ;
       Exit ;
     end ;
     if key=49 then begin
       while True do begin
         if not StartGame() then Break ;
       end ;
       break ;
     end ;
     if key=50 then begin
       EnterCode() ;
       break ;
     end ;
     if key=51 then begin
       DrawHelp() ;
       break ;
     end ;
   end ;
  end ;
 
end.
