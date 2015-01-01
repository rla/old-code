unit CSSList;

{
Moodul CssList. Kuulub mooduli CssParser koosseisu.

Sisaldab objekte TCss klasside ning klassi
muutuja-vääruse nimekirja kasutamiseks.

Alustatud: 10.02.2004
Viimati muudetud: 14.02.2004

(c) Raivo Laanemets 2004
rl@starline.ee
}

interface

uses CSSNode;

type

{Stringide listi osa}
TCssStrListItem=^TCssStrListRec;
TCssStrListRec=record
  Item: String;
  Next: TCssStrListItem;
end;

{Objekt stringide listiga manipuleerimiseks}
TCssStrListPtr=^TCssStrList;
TCssStrList=object
  Count: integer;

  procedure Create;
  procedure Add(AString: string);
  function Take: string;

  private First: TCssStrListItem;
end;

{Muutuja-väärtuse list}
TCssValList=object
  Count: integer;

  procedure Create;
  procedure Add(AField, AValue: string);
  procedure AddNode(ANode: TCssNodeRec);
  procedure Take(var AField, AValue: string);

  private First: TCssNode;
end;

implementation

procedure TCssStrList.Create;
begin
  First:=nil;
  Count:=0;
end;

{
Klasside nimekirja lisamine.
}
procedure TCssStrList.Add;
var new_item: TCssStrListItem;
begin
  New(new_item);
  new_item^.Item:=AString;
  new_item^.Next:=First;
  First:=new_item;
  inc(count);
end;

{
Klasside nimekirjast võtmine.
}
function TCssStrList.Take;
begin
  Take:='';
  if Count=0 then exit;
  Take:=First^.Item;
  First:=First^.Next;
  dec(count);
end;

procedure TCssValList.Create;
begin
  First:=nil;
  Count:=0;
end;

{
Muutuja-väärtuse nimekirja lisamine.
Lisab muutuja ja väärtuse stringidena.
}
procedure TCssValList.Add;
var new_item: TCssNode;
begin
  New(new_item);
  new_item^.Name:=AField;
  new_item^.Value:=AValue;
  new_item^.Next:=First;
  First:=new_item;
  inc(count);
end;

{
Muutuja-väärtuse nimekirja lisamine.
Lisab muutuja ja väärtuse paarina (TCssNode).
}
procedure TCssValList.AddNode;
var new_item: TCssNode;
begin
  New(new_item);
  new_item^:=ANode;
  new_item^.Next:=First;
  First:=new_item;
  inc(count);
end;

{
Muutuja-väärtuse nimekirjast võtmine.
}
procedure TCssValList.Take;
begin
  if Count=0 then exit;
  AField:=First^.Name;
  AValue:=First^.Value;
  First:=First^.Next;
  dec(count);
end;

end.
