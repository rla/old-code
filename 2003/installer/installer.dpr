program Installer;

uses
  Forms,
  AlgForm in 'AlgForm.pas' {CopyForm},
  KuhuInst in 'KuhuInst.pas' {KuhuForm},
  Settingud in 'Settingud.pas' {SetForm},
  SpecSet in 'SpecSet.pas' {SpecForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TCopyForm, CopyForm);
  Application.CreateForm(TKuhuForm, KuhuForm);
  Application.CreateForm(TSetForm, SetForm);
  Application.CreateForm(TSpecForm, SpecForm);
  Application.Run;
end.
