Program MP3PlaySetup;
uses dos, crt;
{$M $4000,0,0}

function fileExists(s : string) : boolean;
begin
  fileExists := fSearch(s, '') <> '';
end; { Funct fileexists }

Procedure doit;
var
cfgFile:Text;
s,fn:string;
{vars to hold cfg data}
verbose:boolean;
plsdir,
plsfile,
batdir:string;
x,numplsi:integer;

Begin
     verbose := true;
     if paramstr(1) = 'h' then
     begin
          writeln('useage: chkpls [v,h]');
          halt(1);
     end; { if paramstr }
     if paramstr(1) = 'v' then verbose := false;
     if paramstr(1) = 'V' then verbose := false;

     if verbose then
     begin
          writeln('chkpls 1.1b for SpeckAmp');
          writeln('(c) 1999, 2000 M Ernisse');
     end; {if verbose}

     fn :='config.dat';
     if fileExists(fn) then
     begin
             assign(cfgFile,fn);
             reset(cfgFile);
             readln(cfgFile,s);
             plsdir:=s;
             readln(cfgFile,s);
             val(s,numplsi,x);
             readln(cfgFile,batdir);
             close(cfgFile);
             for x := 1 to numplsi do
             begin
                  str(x,s);
                  fn := plsdir + s + '.pls';
                  assign(cfgFile,fn);
                  reset(cfgFile);
                  readln(cfgFile,s);
                  if fileExists(s) then
                  begin
                       if verbose then writeln('file found!  This is the CD for the playlist!');
                       {success!}
                       str(x,s);
                       fn := batdir + s + '.bat';
                       if verbose then writeln('shelling to: command.com /c '+fn);
                       Swapvectors;
                       exec(getenv('COMSPEC'),'/C '+fn);
                       Swapvectors;
                       if DosError <> 0 then
                       begin
                          write('error: exec() exited with error code ');
                          writeln(DosError);
                       	  halt(DosError);
                       end; {if DosError}
                       halt(2);
                  end; {if fileExists(s)}
                  if verbose then writeln('file not found!  This is not the CD for the pls file');
             end; {for x := 1 to numplsi}
     end; {if fileexists config.dat}
end; {proc}

begin
doit;
end.
