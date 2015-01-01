unit CSSStatement;

interface

type

//Css Lause
TCssStatementPtr=^TCssStatement;
TCssStatement=record
  Statement: string;
  Next: TCssStatementPtr;     //järgmine
  Previous: TCssStatementPtr; //eelmine
end;

//Css lausete hoidja
TCssStatements=object //hoiab üksikuid css lauseid. @import ... jms.
  Count: integer;                    //css lausete arv;
  procedure Create;
  procedure Add(AStatement: string); //lisab
  function Take: string;             //võtab ühe lause.
  procedure Free;                    //tühjendab, mälu vabastamine

  private
  First: TCssStatementPtr;
  Last: TCssStatementPtr;
end;

implementation

//TCssStatements
procedure TCssStatements.Create;
begin
  First:=nil;
  Last:=nil;
  Count:=0;
end;

procedure TCssStatements.Add;
var new_statement: TCssStatementPtr;
begin
  New(new_statement);
  new_statement^.Statement:=AStatement;
  new_statement^.Next:=First;
  First:=new_statement;
  inc(Count);
end;

function TCssStatements.Take;
var current: TCssStatementPtr;
begin
  Take:='';
  if Count=0 then exit;
  Take:=First^.Statement;
  First:=First^.Next;
  dec(count);
  //Dispose(First^.Previous);
end;

procedure TCssStatements.Free;
var current: TCssStatementPtr;
begin
  if Count=0 then exit;
  {current:=Last^.Previous;
  while current^.Previous<>nil do
  begin
    current:=current^.Previous;
    Dispose(current^.Previous);
  end;
  Count:=0;}
end;

end.
