Program CheckDiscType;
uses dos, crt, cdaudio;
Procedure main(verbose:boolean);
Type
  TMSFrec = record {<T>rack, <M>inutes, <S>econds, <F>rames}
    Frm,
    Sec, Min,
    Trk : String;
    Disp:String; {mm:ss/ff}
  end;
var
 bob:TMSF;

begin
if verbose then
begin
	writeln('testcd (c) 2000 M. Ernisse.');
        writeln('developed for SpeckAmp/DOS.');
end; {if verbose}
if NoDisc then
begin
      	if verbose then writeln('No Disc in drive... Halting, Exit code 1');
	halt(1);
end; {IF NoDisc}

if verbose then writeln('Checking Disc Status(Data/Audio)');
GetDiscLen(bob);
if bob.trk = 1 then
       	if bob.min >= 20 then
        begin
  	if verbose then
        begin
		write('Disc has 1 track & is ');
                write(bob.min);
                writeln(' minutes long, assuming data disc, halting with code 2');
	 end; {if verbose}
         	halt(2);
         end; {if bob.min}
halt(0);
end;{proc main}

begin
if paramstr(1) = 'v' then main(true);
if paramstr(1) = 'V' then main(true);
main(false);
end. {program}