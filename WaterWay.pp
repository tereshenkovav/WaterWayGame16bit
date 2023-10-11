program WaterWay ;

uses GameEngine16, Game, ObjModule, CommonProc ;

var
   pal:array[0..29] of byte ;
   tekframe:Word ;
   soundlen:Integer ;
   tekgame:TGame ;
   key,scan:Byte ;
begin
   Screen($13) ;
   InitRandom() ;

   tekgame:=TGame.Create(0) ;

   pal[0]:=20 ; pal[1]:=20 ; pal[2]:=20 ;
   pal[3]:=30 ; pal[4]:=30 ; pal[5]:=30 ;
   pal[6]:=40 ; pal[7]:=40 ; pal[8]:=40 ;
   SetPaletteData(16,3,pal) ;

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
       SetCursorXY(28,12) ; Write('Game over') ;
       SetCursorXY(28,13) ;
       if tekgame.isWin() then Write('You winner!') else Write('You failed!') ;
       while True do begin
         if IsKeyPressed(key,scan) then 
           if scan=1 then Break ;
       end ;
       Break ;
     end ;

     WaitFrameCompleted(tekframe) ;
   end ;
  
   Screen($3) ;
   SoundOff() ;
   Writeln(MemAvail()) ;
   tekgame.Free ;
end.
