unit CSSClass;

interface

uses CSSNode;

type

//Klass
TCssClassPtr=^TCssClass;
TCssClass=object
  Name: string;         //klassi nimi.
  Next: TCssClassPtr;
  Count: integer;       //klassi muutujate arv.
  First: TCssNode;      //kõrgeim muutuja-väärtuse paar.

  procedure Create;
  procedure Add(AField, AValue: string);
end;

implementation

//Klassi funktsioonid ja protseduurid.
procedure TCssClass.Create;
begin
  First:=nil;
  Count:=0;
end;

procedure TCssClass.Add; //uue muutuja-väärtuse paari lisamine klassi
var
  new_node: TCssNode;
begin
  //Form4.Memo1.Lines.Add('TCss->TCssMedia->TCssClass->Add('+AField+', '+AValue+')');
  New(new_node);
  new_node^.Name:=AField;
  new_node^.Value:=AValue;
  new_node^.Next:=First;
  First:=new_node;
  inc(Count);
end;

end.
