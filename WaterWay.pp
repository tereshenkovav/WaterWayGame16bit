program WaterWay ;

uses GameEngine16, Game, ObjModule, CommonProc, Block ;

var
   pal:array[0..29] of byte ;
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
       SetCursorXY(26,14) ; Write('Game over') ;
       SetCursorXY(26,23) ; Write('Press Enter') ;
       if tekgame.isWin() then begin
         SetCursorXY(26,15) ; Write('You winner!') ;
         if nextlevel=levelcount-1 then begin
           SetCursorXY(26,17) ; Write('Game finished!') ;
         end
         else begin
           SetCursorXY(26,17) ; Write('Your code:') ;
           SetCursorXY(26,18) ; Write('ABC:') ;
           Inc(nextlevel) ;
           Result:=True ;
         end ;
       end 
       else begin ;
         SetCursorXY(26,15) ;
         Write('You failed!') ;
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
   SetCursorXY(6,2) ; Write('The game is a remake of the ') ;
   SetCursorXY(8,3) ; Write('classic "Pipeman" game.') ;

   SetCursorXY(4,5) ; Write('The player''s task is to pipe water');
   SetCursorXY(2,6) ; Write('from the sources to the all') ;
   SetCursorXY(2,7) ; Write('destination points (blue rects).') ;
   SetCursorXY(2,8) ; Write('Pipes can be placed anywhere, ') ;
   SetCursorXY(2,9) ; Write('the installation is done by pressing') ;
   SetCursorXY(2,10) ; Write('the "Space bar". Pipes can be') ;
   SetCursorXY(2,11) ; Write('replaced (several times on level),') ;
   SetCursorXY(2,12) ; Write('but they cannot be rotated.') ;
   SetCursorXY(2,13); Write('The level is completed when all the') ;
   SetCursorXY(2,14); Write('destination points are filled. ') ;
   SetCursorXY(2,15); Write('If the water spills out of the pipe,') ;
   SetCursorXY(2,16); Write('then the game is lost.') ;

   SetCursorXY(13,19); Write('Developed by:') ;
   SetCursorXY(8,21) ; Write('Aleksandr V. Tereshenkov') ;
   SetCursorXY(8,22) ; Write('github.com/tereshenkovav') ;
   SetCursorXY(9,23) ; Write('tav-developer.itch.io') ;

   WaitKeyPressed(key,scan) ;
end ;

var key,scan:Byte ;
    block1:TBlock ;
    i:Integer ;
    s:string ;
begin
   Screen($13) ;
   InitRandom() ;

   nextlevel:=0 ;

   pal[0]:=20 ; pal[1]:=20 ; pal[2]:=20 ;
   pal[3]:=30 ; pal[4]:=30 ; pal[5]:=30 ;
   pal[6]:=40 ; pal[7]:=40 ; pal[8]:=40 ;
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

   SetCursorXY(14,5) ; Write('Pipeman game') ;
   SetCursorXY(17,6) ; Write('v0.5.0') ;

   Str(nextlevel+1,s) ;
   SetCursorXY(13,11) ; Write('Level: ',s) ;
   SetCursorXY(13,13) ; Write('1 - Start game') ;
   SetCursorXY(13,14) ; Write('2 - Enter code') ;
   SetCursorXY(13,15) ; Write('3 - Help') ;
   SetCursorXY(13,16) ; Write('0 - Exit') ;

   while True do begin
     WaitKeyPressed(key,scan) ;
     if key=ord('0') then begin
       Screen($3) ;
       SoundOff() ;
       Exit ;
     end ;
     if key=ord('1') then begin
       while True do begin
         if not StartGame() then Break ;
       end ;
       break ;
     end ;
     if key=ord('3') then begin
       DrawHelp() ;
       break ;
     end ;
   end ;
  end ;
 
end.
