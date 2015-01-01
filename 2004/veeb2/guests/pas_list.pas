unit pas_list;
{
Lihtne stringide list.
Raivo Laanemets 2004
rl@starline.ee
}

interface

type
TListPtr=^TListKirje;
TListKirje=record
  str: string;
  next: TListPtr;
end;

Ts_list=object
  public
  first: TListPtr
  procedure Create; {listi tekitamine}

end;

implementation

procedure Ts_list.Create;
begin
  first:=nil;
end;

end.
