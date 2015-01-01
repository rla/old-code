unit CSSNode;

interface

type

//Muutuja, väärtus
TCssNode=^TCssNodeRec;
TCssNodeRec=record
  Name: string;   //klassi muutuja nimi.
  Value: string; //klassi muutuja väärtus.
  Next: TCssNode;     //järgmine klassi muutuja nime-väärtuse paar;
end;

implementation

end.
