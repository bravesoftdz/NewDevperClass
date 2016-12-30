program Project_Mini;

uses
  Vcl.Forms,
  System.SysUtils,
  main in 'main.pas' {Form1} ,
  database in 'database.pas' {DM: TDataModule} ,
  splash in 'splash.pas' {splashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  splashForm := TsplashForm.create(Application);       //SPLASH ����
  splashForm.show;                                     //SPLASH ���
  splashForm.refresh;
  sleep(1000);     //SPLASH�� ���ӽ�Ű�� ���� SLEEP�Լ�(1��)
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TForm1, Form1);
  splashForm.hide;      //SPLASH ����
  splashForm.free;      //SPLASH ����
  Application.Run;
end.
