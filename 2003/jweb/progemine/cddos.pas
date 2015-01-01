program CDDOS;
USES CRT,CDPLAYM,CDAUDIO;


Procedure FooBar(verbose:boolean);
Begin
If DrvBusy then Begin
	Writeln('Drive Busy');
	Halt(1);
End;{if}
If NoDisc then Begin
	writeln('NoDiSc!');
	Halt(1);
End; {IF}

	if verbose then	ClrScr;
	PlayTrack(1);
	CDPLAYER2(10,10,verbose);
	pauseAudio;
	ClrScr;
End; {Proc}


BEGIN
if paramstr(1) = 'v' then FooBar(true);
if paramstr(1) = 'V' then FooBar(true);
FooBar(false);
End.