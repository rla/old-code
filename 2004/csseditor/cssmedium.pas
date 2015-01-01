unit CSSMedium;

interface

uses SysUtils, CSSClass;

type

//Meedium
TCssMediaPtr=^TCssMedia;
TCssMedia=object         //media, sisaldab vastavaid klasse.
  Name: string;          //meediumi nimi.
  Count: integer;        //klasside arv.
  Next: TCssMediaPtr;    //järgmine meedium.
  ClassName: string;     //viimati kasutatud klass.
  FirstClass: TCssClassPtr;     //esimene klass loendis.
  LastClass: TCssClassPtr; //viimati kasutatud klassi viit.


  procedure Create;
  procedure AddClass(AClassName: string); //klassi lisamine
  procedure Add(AClass, AField, AValue: string);  //lisamine
end;{TCssMedia}

implementation

//TCssMedia funktsioonid ja protseduurid->
procedure TCssMedia.Create;
begin
  Next:=nil;
  FirstClass:=nil;
  Count:=0;
end;

procedure TCssMedia.AddClass; //klassi lisamine.
var new_class: TCssClassPtr;
begin
  New(new_class);
  new_class^.Create; {Klassis olevate muutujate nimekirja tekitamine.}
  new_class^.Name:=AClassName;
  new_class^.Next:=FirstClass;
  FirstClass:=new_class;
  inc(Count);
end;

procedure TCssMedia.Add;
var
  current: TCssClassPtr;
  found: boolean;
begin
  //DEBUG
  //Form4.Memo1.Lines.Add('TCss->TCssMedia->Add('+AClass+', '+AField+', '+AValue+')');
  //-DEBUG
  //if AClass=ClassName then LastClass^.Add(AField, AValue)
  //else
  //begin
    current:=FirstClass;
    found:=false;

    while (current<>nil) and not(found) do
    begin
      if current^.Name=LowerCase(AClass) then
      begin
        //showmessage('class leitud');
        current^.Add(AField, AValue); {Klassile listakse muutuja}
        found:=true;
      end;
      current:=current^.Next;
    end;

    if not(found) then
    begin
      AddClass(LowerCase(AClass));
      FirstClass^.Add(AField, AValue);
    end;  
end;

end.
