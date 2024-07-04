#!/bin/sh

export PATH=/opt/watcom/binl:$PATH
export INCLUDE=/opt/watcom/lh:$INCLUDE
export EDPATH=/opt/watcom/eddat
export WIPFC=/opt/watcom/wipfc
export WATCOM=/opt/watcom

mkdir ../bin
mkdir lib
mkdir lib/i286-dos16
ppcross8086 -Tmsdos -WmTiny -Wtcom -Mobjfpc -Rintel -FE../bin -FUlib/i286-dos16 -Fu/usr/lib/fpc/3.0.4/units/msdos/80286-tiny/rtl -CX -XX -Sg ../src/WaterWay.pp 
