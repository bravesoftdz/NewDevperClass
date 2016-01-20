program Project;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {MainForm},
  UMember in 'UMember.pas' {Member},
  UDataModule in 'UDataModule.pas' {DataModule1: TDataModule},
  Vcl.Themes,
  Vcl.Styles,
  UProject in 'UProject.pas' {frmProject},
  UDept in 'UDept.pas' {Dept},
  USplash in 'USplash.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  SplashForm := TSplashForm.Create(Application);     //���÷��� ����
  SplashForm.Show;                                   //�����ֱ�
  SplashForm.Refresh;                                //����
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TMainForm, MainForm);
  SplashForm.Hide;                                   //���� �Ǳ� ���� �����
  SplashForm.Free;                                   //����
  Application.Run;
end.
