@echo off
mkdir ..\bin
mkdir lib
mkdir lib\i286-dos16
ppcross8086 -Tmsdos -WmTiny -Wtcom -Mobjfpc -Rintel -FE../bin -FUlib/i286-dos16 -FuC:\fpc\3.0.4-DOS\units\msdos\80286-tiny\rtl -CX -XX -Sg ../src/WaterWay.pp 

