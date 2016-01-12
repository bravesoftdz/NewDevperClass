program Project_Calc;

uses
  Vcl.Forms,
  uCalcForm in 'uCalcForm.pas' {frmCalc},
  Vcl.Themes,
  Vcl.Styles,
  USplash in 'USplash.pas' {SplashForm},
  ABOUT in 'ABOUT.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TsplashForm.create(Application);  //���÷����� ����
  SplashForm.Show;
  SplashForm.Refresh;
  TStyleManager.TrySetStyle('Slate Classico');
  Application.CreateForm(TfrmCalc, frmCalc);
  SplashForm.Hide;
  SplashForm.free;
  Application.Run;
end.
