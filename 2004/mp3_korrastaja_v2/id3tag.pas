unit ID3Tag;

interface

uses
  SysUtils, Dialogs;

type
  TID3Tag = record
  ID:string[3];
  Titel:string[30];
  Artist:string[30];
  Album:string[30];
  Year:string[4];
  Comment:string[30];
  Genre:byte;
end;

procedure GetId3Tag(filename:TFileName; var ID3Tag: TID3Tag);
procedure SetId3Tag(filename:TFileName; ID3Tag: TID3Tag);

implementation

function GetFixLenStr(input:string; len:byte; ch:char=' '): string;
var i:integer;
tmp:string;
begin
  tmp:=input;
  for i:=length(input) to len do tmp:=tmp +ch;
  GetFixLenStr:=tmp;
end;

procedure GetId3Tag(filename:TFileName; var ID3Tag: TID3Tag);
var
  Buffer:array[1..128] of char;
  F:File;
begin
  AssignFile(F, Filename);
  Reset(F,1);
  Seek(F,FileSize(F)-128);
  BlockRead(F, Buffer, SizeOf(Buffer));
  CloseFile(F);
  with ID3Tag do begin
    ID:=copy(Buffer,1,3);
    Titel:=copy(Buffer,4,30);
    Artist:=copy(Buffer,34,30);
    Album:=copy(Buffer,64,30);
    Year:=copy(Buffer,94,4);
    Comment:=copy(Buffer,98,30);
    Genre:=ord(Buffer[128]);
  end;
end;

procedure SetId3Tag(filename:TFileName; ID3Tag: TID3Tag);
var
  Buffer:array[1..128] of char;
  F:File;
  i:byte;
begin
  AssignFile(F, filename);
  Reset(F,1);
  Seek(F,FileSize(F)-128);
  FillChar(buffer, 128, ' ');
  for i:=1 to 3 do buffer[i]:=id3tag.id[i];
  for i:=4 to 33 do buffer[i]:=id3tag.titel[i-3];
  for i:=34 to 63 do buffer[i]:=id3tag.artist[i-33];
  for i:=64 to 93 do buffer[i]:=id3tag.album[i-63];
  for i:=94 to 97 do buffer[i]:=id3tag.year[i-93];
  for i:=98 to 127 do buffer[i]:=id3tag.comment[i-97];
  buffer[128]:=chr(id3tag.genre);
  BlockWrite(F, buffer, 128);
  CloseFile(F);
end;

end.
