unit Uproject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.DBCtrls, Data.Bind.Components,
  Data.Bind.DBScope, Vcl.Mask, Data.FMTBcd, Data.SqlExpr,System.UITypes;

type
  Tproject = class(TForm)
    PageControl: TPageControl;
    TabSheet2: TTabSheet;
    btn_pro_delete: TButton;
    TabSheet3: TTabSheet;
    DBGrid1: TDBGrid;
    lb_pname: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lb_pmanager: TLabel;
    Label11: TLabel;
    edit_pname: TDBEdit;
    DBEdit5: TDBEdit;
    edit_ppersons: TDBEdit;
    combo_pmanager: TDBLookupComboBox;
    btn_pro_cancel: TButton;
    btn_pro_post: TButton;
    Label12: TLabel;
    edit_pstartd: TDBEdit;
    edit_endd: TDBEdit;
    btn_pro_insert: TButton;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure Button4Click(Sender: TObject);
    procedure btn_pro_deleteClick(Sender: TObject);
    procedure btn_pro_cancelClick(Sender: TObject);
    procedure btn_pro_postClick(Sender: TObject);
    procedure edit_pnameChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  project: Tproject;
  a: byte;

implementation

{$R *.dfm}

uses ClientModuleUnit1;

// ����
procedure Tproject.btn_pro_deleteClick(Sender: TObject);
begin
  if messagedlg('����', mtconfirmation, [mbyes, mbno], 0) = mryes then
  begin
    try
      dm.project.Delete;
      dm.project.ApplyUpdates(-1);
    except
      showmessage('����');

    end;
  end;

end;

// ������Ʈ �߰�
procedure Tproject.Button4Click(Sender: TObject);
var
  flag: Integer;
begin
  if edit_pname.Text = '' then
    showmessage('������Ʈ �̸��� �Է��ϼ���');
  if combo_pmanager.Text = '' then
    showmessage('�Ŵ����� �����ϼ���');
  if edit_pstartd.Text = '' then
    showmessage('���� ��¥�� �����ϼ���');
  if edit_endd.Text = '' then
    showmessage('���� ��¥�� �����ϼ���.');
  if dbedit5.Text = '' then
    showmessage('������¸� ������ �ּ���.')
  else
  begin
    dm.search.Close;
    dm.search.SQL.Text :=
      'select count(*) from project where pro_no=:pname;';
    //dm.search.ParamByName('pname').AsString := edit_pname;
    dm.search.open;
    flag := dm.search.FieldByName('count').AsInteger;
    if flag > 0 then // �ߺ� Ȯ��
    begin
      showmessage('�ߺ��� ������Ʈ ��ȣ�Դϴ�.');
      dm.project.Cancel;
    end
    else
    begin
      dm.project.post; // ������Ʈ ���
      dm.project.ApplyUpdates(-1);
    end;
  end;
end;

procedure Tproject.edit_pnameChange(Sender: TObject);
begin
  // SQLQuery1.Close;
  // SQLQuery1.FieldByName('pname').AsString;
  // SQLQuery1.Open;
end;

// ����� ���� ���
procedure Tproject.btn_pro_cancelClick(Sender: TObject);
begin
  dm.project.Cancel;
end;

// ���� �Էµ� ������ ����
procedure Tproject.btn_pro_postClick(Sender: TObject);
begin
  dm.project.post;
end;

// ���� ������ dbgrid�� ���� ���
procedure Tproject.FormCreate(Sender: TObject);
begin
  try
    // dm.count.Close;
    // dm.count.SQL :=
    // 'select count(*) from emp where pname =:''������Ʈ1''';
    // dm.count.Open;
  except

  end;
  begin
    DBGrid1.columns[0].title.Caption := '������Ʈ ��';
    DBGrid1.columns[1].title.Caption := '���� ��¥';
    DBGrid1.columns[2].title.Caption := '�� ��¥';
    DBGrid1.columns[3].title.Caption := '������';
    DBGrid1.columns[4].title.Caption := '���� �ο�';
    DBGrid1.columns[5].title.Caption := '���൵';

    DBGrid1.columns[0].width := 78;
    DBGrid1.columns[1].width := 60;
    DBGrid1.columns[2].width := 78;
    DBGrid1.columns[3].width := 60;
    DBGrid1.columns[4].width := 60;
    DBGrid1.columns[5].width := 50;
  end;
end;

procedure Tproject.FormResize(Sender: TObject);
begin
  // label5.caption := inttostr(datetimepicker2.Date) - inttostr(datetimepicker1.Date);

end;

procedure Tproject.FormShow(Sender: TObject);
begin
dm.count.Close;
dm.count.SQL.Text:=
'select count(*) from e_project where epname_eppersons';
dm.count.Params[0].AsString:=edit_ppersons.Text;
dm.count.Open;
edit_ppersons.Text:=dm.count.FieldByName('count').AsString;
end;

end.
