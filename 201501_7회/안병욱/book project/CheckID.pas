unit CheckID;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TCheckIDForm = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    GroupBox1: TGroupBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckIDForm: TCheckIDForm;

implementation

{$R *.dfm}

uses BookDm, Join;

procedure TCheckIDForm.Button1Click(Sender: TObject);
begin
  if DataModule1.MemberDataSet.Locate('ID', Edit1.Text, []) then
  begin
    raise Exception.Create('�̹� ��ϵ� ID �Դϴ�.');
  end;

  DataModule1.MemberDataSet.Append;
 // JoinForm.DBEdit1.Text := Edit1.Text;
  ShowMessage('��� ������ ID�Դϴ�.');

end;

end.
