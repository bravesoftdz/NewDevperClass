program Project_Calc;

uses
  Vcl.Forms,
  uClacForm in 'uClacForm.pas' {frmCalc},
  Vcl.Themes,
  Vcl.Styles,
  USplash in 'USplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  SplashForm := TSplashForm.Create(application);     //���÷����� ����
  SplashForm.Show;                                   //�����ֱ�
  SplashForm.Refresh;                                //����
  Application.CreateForm(TfrmCalc, frmCalc);
  SplashForm.Hide;                                   //�����
  SplashForm.Free;                                   //����
  Application.Run;
end.


