unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.DBCtrls,
  Vcl.StdCtrls, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Vcl.Mask, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  part = record
    part_n: string;
    TEAM: string;
  end;

  partPrt = ^part;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet9: TTabSheet;
    PageControl4: TPageControl;
    TabSheet10: TTabSheet;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Button3: TButton;
    Button9: TButton;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    DBLookupComboBox2: TDBLookupComboBox;
    Button1: TButton;
    Button2: TButton;
    Button13: TButton;
    PageControl3: TPageControl;
    TabSheet6: TTabSheet;
    Label9: TLabel;
    Label10: TLabel;
    Label22: TLabel;
    Button8: TButton;
    DBEdit1: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit2: TDBEdit;
    Button10: TButton;
    DBGrid1: TDBGrid;
    Button12: TButton;
    Button11: TButton;
    DBGrid2: TDBGrid;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    DBEdit6: TDBEdit;
    Label5: TLabel;
    DBLookupComboBox1: TDBLookupComboBox;
    Label3: TLabel;
    TabSheet5: TTabSheet;
    DBLookupComboBox3: TDBLookupComboBox;
    DBGrid3: TDBGrid;
    Button4: TButton;
    TabSheet7: TTabSheet;
    TreeView1: TTreeView;
    Button5: TButton;
    Button6: TButton;
    Label6: TLabel;
    Label7: TLabel;
    DBLookupComboBox4: TDBLookupComboBox;
    Button7: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label8: TLabel;
    ListView1: TListView;
    Label11: TLabel;
    DBComboBox1: TDBComboBox;
    DBEdit7: TDBEdit;
    DBEdit8: TDBEdit;
    DBGrid4: TDBGrid;
    Label12: TLabel;
    Label15: TLabel;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    DBLookupComboBox5: TDBLookupComboBox;
    procedure Button8Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DBGrid3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure showCount();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  prt: partPrt;

implementation

{$R *.dfm}

uses database;

procedure TForm1.Button10Click(Sender: TObject);
begin
  DM.part.Insert; // �μ� �߰�
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
  DM.part.Cancel; // �μ� ���
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
  if messagedlg('�μ��� �����Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    try // �μ� ����
      DM.part.delete;
      DM.part.ApplyUpdates(-1);
    except
      showmessage('������ �����Ͽ����ϴ�.');
    end;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
  DM.employee.Cancel; // ��� �Է� ���
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
  if messagedlg('�߰� ����� �����Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
    try // �߰� �ο� ����
      DM.proEmp.delete;
      DM.proEmp.ApplyUpdates(-1);
      showCount();
    except
      showmessage('������ �����Ͽ����ϴ�.');
    end;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
  DM.proEmp.Insert; // ������Ʈ �߰� �ο� �߰�
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
  DM.proEmp.Cancel; // ������Ʈ �߰� �ο� ���
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  flag: Integer;
begin
  if DBEdit6.Text = '' then
    showmessage('�����ȣ�� �Է��� �ּ���.');
  if DBEdit4.Text = '' then
    showmessage('�̸��� �Է��� �ּ���.');
  if DBEdit5.Text = '' then
    showmessage('��ȭ��ȣ�� �Է��� �ּ���.');
  if DBLookupComboBox1.Text = '' then
    showmessage('�μ��� ������ �ּ���.');
  if DBLookupComboBox2.Text = '' then
    showmessage('���� ������ �ּ���.')
  else
  begin
    DM.insertCheck.close;
    DM.insertCheck.SQL.Text :=
      'select count(*) from employee where emp_no=:eno;';
    DM.insertCheck.ParamByName('eno').AsString := DBEdit6.Text;
    DM.insertCheck.open;
    flag := DM.insertCheck.FieldByName('count').AsInteger;
    if flag > 0 then
    begin
      showmessage('�ߺ��� �����ȣ�Դϴ�.');
      DM.employee.Cancel;
    end
    else
    begin
      DM.employee.post; // ��� ���
      DM.employee.ApplyUpdates(-1);
    end;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if messagedlg('����� �����Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    try // ��� ����
      DM.employee.delete;
      DM.employee.ApplyUpdates(-1);
    except
      showmessage('������ �����Ͽ����ϴ�.');
    end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  DM.employee.Insert; // ��� �߰�
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  DM.project.Insert; // ������Ʈ �߰�
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  if messagedlg('������Ʈ�� �����Ͻðڽ��ϱ�?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then
    try // ������Ʈ ����
      DM.project.delete;
      DM.project.ApplyUpdates(-1);
      DBGrid4.datasource.DataSet.Active := false; //����� �����͸� ������ϱ�����  DBGRID �����
      DBGrid4.datasource.DataSet.Active := true;
      DBGrid4.Columns[0].Title.caption := '������Ʈ ��ȣ';
      DBGrid4.Columns[0].width := 70;
      DBGrid4.Columns[1].Title.caption := '������ �̸�';
      DBGrid4.Columns[1].width := 150;
    except
      showmessage('������ �����Ͽ����ϴ�.');
    end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  DM.project.Cancel; // ������Ʈ ���
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  flag: Integer;
begin
  if DBLookupComboBox5.Text = '' then
    showmessage('������Ʈ ��ȣ�� �Է��� �ּ���.');
  if DBLookupComboBox4.Text = '' then
    showmessage('�߰� ����� ������ �ּ���.')
  else
  begin   //IB ���׷� ���� ���������� �ߺ������� �˻� ó��
    DM.insertCheck.close;
    DM.insertCheck.SQL.Text :=
      'select count(*) from pro_emp where project_no=:pno and employee_name=:ename;';
    DM.insertCheck.ParamByName('pno').AsString := DBLookupComboBox5.Text;
    DM.insertCheck.ParamByName('ename').AsString := DBLookupComboBox4.Text;
    DM.insertCheck.open;
    flag := DM.insertCheck.FieldByName('count').AsInteger;
    if flag > 0 then //������Ʈ �߰� �ο� �ߺ� �˻�
    begin
      showmessage('�ߺ��� ����Դϴ�.');
      DM.proEmp.Cancel;
    end
    else
    begin
      // ������Ʈ �߰� �ο� ���
      DM.proEmp.post;
      DM.proEmp.ApplyUpdates(-1);
      showCount();
    end;
  end;
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  flag: Integer;
begin
  if DBEdit3.Text = '' then
    showmessage('�μ� ��ȣ�� �Է��� �ּ���.');
  if DBEdit1.Text = '' then
    showmessage('�μ����� �Է��� �ּ���.');
  if DBEdit2.Text = '' then
    showmessage('������ �Է��� �ּ���.')
  else
  begin
    DM.insertCheck.close;
    DM.insertCheck.SQL.Text := 'select count(*) from part where part_no=:pno;';
    DM.insertCheck.ParamByName('pno').AsString := DBEdit3.Text;
    DM.insertCheck.open;
    flag := DM.insertCheck.FieldByName('count').AsInteger;
    if flag > 0 then //�μ� �ߺ� Ȯ��
    begin
      showmessage('�ߺ��� �μ� ��ȣ�Դϴ�.');
      DM.part.Cancel;
    end
    else
    begin
      DM.part.post; // �μ� ���
      DM.part.ApplyUpdates(-1);
    end;
  end;
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  flag: Integer;
begin
  if DBEdit7.Text = '' then
    showmessage('������Ʈ ��ȣ�� �Է��� �ּ���.');
  if DBEdit8.Text = '' then
    showmessage('������Ʈ �̸��� �Է��� �ּ���.');
  if DBLookupComboBox3.Text = '' then
    showmessage('�Ŵ����� ������ �ּ���.');
  if DBComboBox1.Text = '' then
    showmessage('������¸� ������ �ּ���.')
  else
  begin
    DM.insertCheck.close;
    DM.insertCheck.SQL.Text :=
      'select count(*) from project where pro_no=:pno;';
    DM.insertCheck.ParamByName('pno').AsString := DBEdit7.Text;
    DM.insertCheck.open;
    flag := DM.insertCheck.FieldByName('count').AsInteger;
    if flag > 0 then //������Ʈ �ߺ� Ȯ��
    begin
      showmessage('�ߺ��� ������Ʈ ��ȣ�Դϴ�.');
      DM.project.Cancel;
    end
    else
    begin
      DM.project.post; // ������Ʈ ���
      DM.project.ApplyUpdates(-1);
    end;
  end;
end;

procedure TForm1.DBGrid3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  showCount(); // ���� �ο��� ���
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Byte;
begin
  for i := 0 to TreeView1.Items.Count - 1 do // Ʈ���� ��� �Ҵ� ����
    if TreeView1.Items[i].Data <> nil then
      Dispose(partPrt(TreeView1.Items[i].Data));
  Action := caFree;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  wk_part: string;
begin
  DM.partView.close;
  DM.partView.open;
  with DM.partView, TreeView1 do
  begin
    while not EOF do
    begin
      new(prt); // ������ ����
      if wk_part <> FieldByName('part_name').AsString then
        selected := Items.Add(selected, FieldByName('part_name').AsString);
      prt^.TEAM := FieldByName('part_team').AsString;
      Items.AddChildObject(selected, FieldByName('part_team').AsString, prt);
      wk_part := FieldByName('part_name').AsString;
      next;
    end;
  end;

  showCount();

  begin // LISTVIEW, DBGRID �ʱ�ȭ
    ListView1.Columns[0].width := 70;
    ListView1.Columns[1].width := 70;
    ListView1.Columns[2].width := 100;
    ListView1.Columns[3].width := 100;
    ListView1.Columns[4].width := 100;

    DBGrid1.Columns[0].Title.caption := '��ȣ';
    DBGrid1.Columns[0].width := 70;
    DBGrid1.Columns[1].Title.caption := '�μ���';
    DBGrid1.Columns[1].width := 150;
    DBGrid1.Columns[2].Title.caption := '����';
    DBGrid1.Columns[2].width := 150;

    DBGrid2.Columns[0].Title.caption := '�����ȣ';
    DBGrid2.Columns[0].width := 70;
    DBGrid2.Columns[1].Title.caption := '�̸�';
    DBGrid2.Columns[1].width := 70;
    DBGrid2.Columns[2].Title.caption := '��ȭ��ȣ';
    DBGrid2.Columns[2].width := 100;
    DBGrid2.Columns[3].Title.caption := '�μ�';
    DBGrid2.Columns[3].width := 150;
    DBGrid2.Columns[4].Title.caption := '��';
    DBGrid2.Columns[4].width := 150;

    DBGrid3.Columns[0].Title.caption := '��ȣ';
    DBGrid3.Columns[0].width := 70;
    DBGrid3.Columns[1].Title.caption := '������Ʈ �̸�';
    DBGrid3.Columns[1].width := 180;
    DBGrid3.Columns[2].Title.caption := '���� ��¥';
    DBGrid3.Columns[2].width := 100;
    DBGrid3.Columns[3].Title.caption := '���� ������';
    DBGrid3.Columns[3].width := 100;
    DBGrid3.Columns[4].Title.caption := '�Ŵ���';
    DBGrid3.Columns[4].width := 70;
    DBGrid3.Columns[5].Title.caption := '�������';
    DBGrid3.Columns[5].width := 70;

    DBGrid4.Columns[0].Title.caption := '������Ʈ ��ȣ';
    DBGrid4.Columns[0].width := 70;
    DBGrid4.Columns[1].Title.caption := '������ �̸�';
    DBGrid4.Columns[1].width := 150;
  end;
end;

procedure TForm1.showCount;
begin
  DM.empcount.close;
  DM.empcount.Params[0].AsString := DBEdit7.Text;
  DM.empcount.open;
  Label15.caption := DM.empcount.FieldByName('count').AsString + ' ��';
  // DBGRID Ŭ���� ������Ʈ ���� �ο� �� ���
end;

procedure TForm1.TreeView1Click(Sender: TObject);
var
  listitem: tlistitem;
begin
  if not TreeView1.selected.HasChildren then
  begin
    DM.empview.close;
    DM.empview.Params[0].AsString := partPrt(TreeView1.selected.Data)^.TEAM;
    // ���� �޾ƿ� �ش� ������ ���
    DM.empview.open;
    ListView1.Items.clear;

    while not DM.empview.EOF do
    begin
      listitem := ListView1.Items.Add; // �ش� ���� ��� ���� ���
      listitem.caption := DM.empview.FieldByName('emp_no').AsString;
      listitem.SubItems.Add(DM.empview.FieldByName('emp_name').AsString);
      listitem.SubItems.Add(DM.empview.FieldByName('emp_phone').AsString);
      listitem.SubItems.Add(DM.empview.FieldByName('emp_part').AsString);
      listitem.SubItems.Add(DM.empview.FieldByName('emp_team').AsString);
      DM.empview.next;
    end;

  end;
end;

end.
