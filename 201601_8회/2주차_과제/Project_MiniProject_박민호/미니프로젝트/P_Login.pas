unit P_Login;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TLogin = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Login: TLogin;

implementation

{$R *.dfm}

uses P_Main;

procedure TLogin.Button1Click(Sender: TObject); // �α��� ��ư Ŭ��
begin
  if Edit1.Text = '' then
     Showmessage('���̵� �Է��ϼ���')
      else
        if Edit2.Text = '' then
           Showmessage('��й�ȣ�� �Է��ϼ���.')
      else
        begin
          showmessage('�α��� �Ϸ�');
          Login.Close;
        end;
end;

procedure TLogin.Button2Click(Sender: TObject); // ��� ��ư Ŭ��
begin
  Login.Close;
end;

end.
