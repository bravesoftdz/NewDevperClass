unit UTEAM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ToolWin,
  Vcl.ComCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls;

type
  TTEAM = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    DBGrid1: TDBGrid;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    ListBox1: TListBox;
    Button1: TButton;
    GroupBox2: TGroupBox;
    Button2: TButton;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  TEAM: TTEAM;

implementation

{$R *.dfm}

uses UDM, UProject;

procedure TTEAM.SpeedButton1Click(Sender: TObject);                             //�ɹ� ���
var
  i : integer;
begin
  if label2.Caption = (inttostr(dm.MEMBERTable.FieldByName('M_ID').AsInteger)+'#'+
    (dm.MEMBERTable.FieldByName('M_NAME').AsString)) then
  begin
    showmessage('�̹� �����ڷ� ��ϵǾ� �ֽ��ϴ�.');
    exit;
  end;
  for I := 0 to listbox1.Items.Count-1 do
  begin
    if listbox1.Items.Strings[i] = (inttostr(dm.MEMBERTable.FieldByName('M_ID').AsInteger)+'#'+
    (dm.MEMBERTable.FieldByName('M_NAME').AsString))  then
    begin
      showmessage('�̹� ������ ����Դϴ�.');
      exit;
    end;
  end;
  listbox1.Items.Add(inttostr(dm.MEMBERTable.FieldByName('M_ID').AsInteger)+'#'+
  (dm.MEMBERTable.FieldByName('M_NAME').AsString));
end;

procedure TTEAM.SpeedButton2Click(Sender: TObject);                             //��� �����
begin

  listbox1.Items.Delete(listbox1.ItemIndex);
end;

procedure TTEAM.SpeedButton3Click(Sender: TObject);                             //������
var
  i : integer;
begin
  for I := 0 to listbox1.Items.Count-1 do
  begin
    if listbox1.Items.Strings[i] = label2.Caption  then
    begin
      showmessage('�̹� ����� �߰��Ǿ� �ֽ��ϴ�.');
      exit;
    end;
  end;
  label2.Caption:=(inttostr(dm.MEMBERTable.FieldByName('M_ID').AsInteger)+'#'+
  (dm.MEMBERTable.FieldByName('M_NAME').AsString));
end;

procedure TTEAM.SpeedButton4Click(Sender: TObject);                             //���� �����
begin
  label2.Caption:= '�̸�';
end;

end.
