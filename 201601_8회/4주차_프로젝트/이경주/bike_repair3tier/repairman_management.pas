unit repairman_management;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.DBCtrls, Vcl.ComCtrls, Vcl.Mask;

type
  TRepairMan = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    rman_add: TButton;
    rman_delete: TButton;
    rman_cancle: TButton;
    rman_post: TButton;
    DBEdit5: TDBEdit;
    Button1: TButton;
    procedure rman_addClick(Sender: TObject);
    procedure rman_deleteClick(Sender: TObject);
    procedure rman_cancleClick(Sender: TObject);
    procedure rman_postClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RepairMan: TRepairMan;

implementation

{$R *.dfm}

uses bike_dm;

procedure TRepairMan.Button1Click(Sender: TObject);
begin
  DBEdit5.Text := datetostr(now);
end;

procedure TRepairMan.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  RepairMan.Free;
end;

procedure TRepairMan.FormCreate(Sender: TObject);
begin
  DBGrid1.Columns[0].Title.Caption := '������ȣ';
  DBGrid1.Columns[1].Title.Caption := '�̸�';
  DBGrid1.Columns[2].Title.Caption := '�� ��ȣ';
  DBGrid1.Columns[3].Title.Caption := '��� ����';
  DBGrid1.Columns[4].Title.Caption := '��� ��¥';

  DBGrid1.Columns[0].width := 60;
  DBGrid1.Columns[1].width := 60;
  DBGrid1.Columns[2].width := 80;
  DBGrid1.Columns[3].width := 60;
  DBGrid1.Columns[4].width := 80;

end;

procedure TRepairMan.rman_addClick(Sender: TObject);
var
  flag: integer;
begin
  if DBEdit1.Text = '' then
    showmessage('������ ��ȣ�� �Է��ϼ���');
  if DBEdit2.Text = '' then
    showmessage('������ �̸��� �Է��ϼ���');
  if DBEdit3.Text = '' then
    showmessage('�� ��ȣ�� �Է��ϼ���');
  if DBEdit5.Text = '' then
    showmessage('��� ��¥�� �Է��ϼ���')
  else
  begin

    try
      demo.insertcheck(dbedit1.Text);//������ ��ȣ �ߺ� ��ã��
      dm1.RepairMan.Insert;

    except
    showmessage('�ߺ��� ��ȣ �Դϴ�');
    dm1.repairman.Cancel;
      raise
    end;

    dm1.repairman.post;
    dm1.repairman.ApplyUpdates(-1);
    showmessage('�߰� �Ǿ����ϴ�.');
  end;
end;

procedure TRepairMan.rman_cancleClick(Sender: TObject);
begin
  dm1.RepairMan.Cancel;
  dm1.RepairMan.CancelUpdates;
end;

procedure TRepairMan.rman_deleteClick(Sender: TObject);
begin
  if messagedlg('���� �ұ��?', mtconfirmation, [mbyes, mbno], 0) = mryes then
  try
    dm1.RepairMan.Delete;
  dm1.RepairMan.ApplyUpdates(-1);
  except
  raise
  end;
  showmessage('�����Ǿ����ϴ�');
end;

procedure TRepairMan.rman_postClick(Sender: TObject);
begin
  dm1.RepairMan.Post;
  dm1.RepairMan.ApplyUpdates(-1);
end;

end.
