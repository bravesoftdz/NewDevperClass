unit Uproject_1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ComCtrls;

type
  Tproject_1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    DBComboBox1: TDBComboBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure cancel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  project_1: Tproject_1;

implementation

{$R *.dfm}

uses ClientModuleUnit1, Uproject;

procedure Tproject_1.FormCreate(Sender: TObject);
begin
  if a = 1 then
    dm.project.Append
  else

end;

procedure Tproject_1.Button1Click(Sender: TObject);
begin
//  if DBEdit1.Text = '' then
//  begin
//    cancel;
//    raise Exception.Create('������Ʈ ���� �Է��ϼ���');
//  end;
//  if DBEdit2.Text = '' then
//  begin
//    cancel;
//    raise Exception.Create('���� ���¸� �Է��ϼ���');
//  end;
//  if DBComboBox1.Text = '' then
//  begin
//    cancel;
//    raise Exception.Create('������ ���� �������ּ���');
//  end;
//  begin
//    try
//      dm.project.Post;
//      dm.project.ApplyUpdates(-1);
//      dm.project.Refresh;
//    except
//      cancel;
//      showmessage('�̹� ��ϵ� .. �Դϴ�.');
//      exit;
//
//    end;
//  end;
//  if a = 0 then
//    showmessage('�߰��Ǿ����ϴ�.')
//  else
//    showmessage('�����Ǿ����ϴ�.');

end;

procedure Tproject_1.Button2Click(Sender: TObject);
begin
  clientModuleUnit1.DM.project.CancelUpdates;
end;

procedure Tproject_1.cancel;
begin
  dm.project.cancel;
  dm.project.CancelUpdates;
  project.DBgrid1.Refresh;
end;

procedure Tproject_1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
end;



end.
