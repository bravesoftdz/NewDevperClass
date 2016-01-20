unit Uemp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, System.UITypes, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  Temp = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    lb_enumber: TLabel;
    btn_emp_cancel: TButton;
    btn_emp_post: TButton;
    btn_emp_insert: TButton;
    lb_ename: TLabel;
    edit_enumber: TDBEdit;
    lb_ephone: TLabel;
    lb_eteam: TLabel;
    edit_ephone: TDBEdit;
    edit_ename: TDBEdit;
    btn_emp_delete: TButton;
    combo_eteam: TDBComboBox;
    Label1: TLabel;
    DBComboBox1: TDBComboBox;

    procedure btn_emp_insertClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_emp_cancelClick(Sender: TObject);
    procedure btn_emp_postClick(Sender: TObject);
    procedure btn_emp_deleteClick(Sender: TObject);
    procedure edit_enumberKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cancel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  emp: Temp;

implementation

{$R *.dfm}

uses ClientModuleUnit1;

//����
procedure Temp.btn_emp_deleteClick(Sender: TObject);
begin
  if messagedlg('����', mtconfirmation, [mbyes, mbno], 0) = mryes then

  begin
    try
      dm.emp.Delete;
      dm.emp.ApplyUpdates(-1);
    except
      showmessage('����');
    end;
  end;
  // DM.emp.Delete;
end;
//�߰�
procedure Temp.btn_emp_insertClick(Sender: TObject);
begin
  if edit_enumber.Text = '' then
  begin
    cancel;
    raise Exception.Create('��� ��ȣ�� �Է����ּ���')
  end;

  begin
    try
      dm.emp.Insert;
      dm.emp.ApplyUpdates(-1);
      dm.emp.Refresh;
    except

      showmessage('�̹� �ִ� �̸��Դϴ�');
      cancel;
      exit;
    end;

  end;

  dm.emp.Insert;
end;

//���
procedure Temp.btn_emp_cancelClick(Sender: TObject);
begin
  dm.emp.cancel;
end;

procedure Temp.btn_emp_postClick(Sender: TObject);
begin
  dm.emp.Post;
end;

procedure Temp.cancel;
begin
  emp.cancel;
  emp.DBGrid1.Refresh;
end;

procedure Temp.edit_enumberKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  // edit_enumber.Text := edit_enumber.Text + '1';
end;

//���� �����ɶ� dbgrid ũ�� ����
procedure Temp.FormCreate(Sender: TObject);
begin

  begin
    // dm.count.Close;
    // dm.count.SQL.Text :=
    // 'select count * from emp where eproject';
    // dm.count.FieldByName('eproject')
  end;

  begin

    DBGrid1.columns[0].title.caption := '��� ��ȣ';
    DBGrid1.columns[1].title.caption := '�̸�';
    DBGrid1.columns[2].title.caption := '����ó';
    DBGrid1.columns[3].title.caption := '�Ҽ� ��';
    DBGrid1.columns[4].title.caption := '������ ������Ʈ';

    DBGrid1.columns[0].width := 60;
    DBGrid1.columns[1].width := 60;
    DBGrid1.columns[2].width := 80;
    DBGrid1.columns[3].width := 60;
    DBGrid1.columns[4].width := 80;
  end;

end;

end.
