program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  UDm in 'UDm.pas' {DataModule1: TDataModule},
  USplash in 'USplash.pas' {SplashForm},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TSplashForm.Create(Application);  //���� �����,��帮�����Ѵٰ��� �н������Է¹޾� üũ �����
  SplashForm.Show;
  SplashForm.Refresh;
  SplashForm.Hide;
  SplashForm.Free;
  TStyleManager.TrySetStyle('Iceberg Classico');
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
