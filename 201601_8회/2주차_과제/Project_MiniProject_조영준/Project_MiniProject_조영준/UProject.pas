unit UProject;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ComCtrls, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope,
  Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls, System.UITypes;

type
  TProjectForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    DBGrid1: TDBGrid;
    lb_Pname: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    DBEdit1: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkControlToField1: TLinkControlToField;
    LinkControlToField2: TLinkControlToField;
    DBComboBox1: TDBComboBox;
    Bt_Post: TButton;
    Bt_Insert: TButton;
    Bt_Delete: TButton;
    Bt_CanCel: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StringGrid1: TStringGrid;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    DBGrid2: TDBGrid;
    TabSheet5: TTabSheet;
    lb_PMname: TLabel;
    lb_Pmmember: TLabel;
    Btn_PMinsert: TButton;
    btn_PMDelete: TButton;
    Btn_PMPost: TButton;
    Btn_PMCencel: TButton;
    Edit1: TEdit;
    LinkControlToField3: TLinkControlToField;
    DBEdit2: TDBEdit;
    Label5: TLabel;
    procedure Bt_InsertClick(Sender: TObject);
    procedure Bt_DeleteClick(Sender: TObject);
    procedure Bt_CanCelClick(Sender: TObject);
    procedure Bt_PostClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Btn_PMinsertClick(Sender: TObject);
    procedure btn_PMDeleteClick(Sender: TObject);
    procedure Btn_PMCencelClick(Sender: TObject);
    procedure Btn_PMPostClick(Sender: TObject);
  private
    { Private declarations }
    procedure ProjectTotal;
  public
    { Public declarations }
  end;

var
  ProjectForm: TProjectForm;
  i, j: boolean;

implementation

{$R *.dfm}

uses UDM;

procedure TProjectForm.Btn_PMCencelClick(Sender: TObject);
begin
  DM.SimpleDataSet2.Cancel; // ���
  DM.SimpleDataSet2.CancelUpdates;
  showmessage('��ҵǾ����ϴ�.');

end;

procedure TProjectForm.btn_PMDeleteClick(Sender: TObject);
begin
  if Messagedlg('�����Ͻðٽ��ϱ�??', mtconfirmation, [mbok, mbcancel], 0) = mrok then
  begin
    try
      DM.SimpleDataSet2.Delete; // ���õ� ������ ����
      DM.SimpleDataSet2.ApplyUpdates(-1);
    except
      showmessage('���� ����');
    end;
  end;
  ProjectTotal;
  DM.SimpleDataSet2.Refresh;
end;

procedure TProjectForm.Btn_PMinsertClick(Sender: TObject);
begin
  j := true;
  DM.SimpleDataSet2.Insert; //
  DateTimePicker1.Date := now;
  DateTimePicker2.Date := now + 1;
  showmessage('�Է¸���Դϴ�.');
end;

procedure TProjectForm.Btn_PMPostClick(Sender: TObject);
var
  today: TDate;
  Name: string;
begin
  try
    today := now;
    name := DBEdit2.Text;
    DM.dateQuery.Close;
    DM.dateQuery.Params[0].AsDate := today;
    DM.dateQuery.Params[1].AsString := name;
    DM.dateQuery.Open;
    if DM.dateQuery.FieldByName('PM_Member').AsString = name then
    begin
      showmessage('�̹��������� ������Ʈ���ֽ��ϴ�.');
    end
    else
    begin
      DM.SimpleDataSet2.Post; // ����
      DM.SimpleDataSet2.ApplyUpdates(-1);
      if j = true then
      begin
        showmessage('�߰��Ǿ����ϴ�.');

        j := false
      end
      else
      begin
        showmessage('�����Ǿ����ϴ�.')

      end;
      ProjectTotal;
      DM.SimpleDataSet2.Refresh;
    end;
  except
    if j = true then
    begin
      raise Exception.Create('�Է��Ͻ� ������ �ٽ� Ȯ���ϼ���');
    end
    else
      showmessage('�Է¸�尡 �ƴϰų� ������ ������ �����ϴ�');
  end;
end;

procedure TProjectForm.Bt_CanCelClick(Sender: TObject);
begin
  DM.project.Cancel; // ���
  DM.project.CancelUpdates;
  showmessage('��ҵǾ����ϴ�.');
end;

procedure TProjectForm.Bt_DeleteClick(Sender: TObject);
begin
  if Messagedlg('�����Ͻðٽ��ϱ�??', mtconfirmation, [mbok, mbcancel], 0) = mrok then
  begin
    try
      DM.project.Delete; // ���õ� ������ ����
      DM.project.ApplyUpdates(-1);
    except
      showmessage('���� ����');
    end;
  end;
  ProjectTotal;
  DM.project.Refresh;

end;

procedure TProjectForm.Bt_InsertClick(Sender: TObject);
begin
  i := true;
  DM.project.Insert; // �Է¸�� ����U
  showmessage('�Է¸���Դϴ�.');
end;

procedure TProjectForm.Bt_PostClick(Sender: TObject);
begin
  try
    if DateTimePicker1.Date < DateTimePicker2.Date then
    begin
      DM.project.Post; // ����
      DM.project.ApplyUpdates(-1);
      if i = true then
      begin
        DM.SimpleDataSet2.Insert;
        Label5.Caption := DBLookupComboBox1.Text;
        DBEdit2.Text := Label5.Caption;

        DM.SimpleDataSet2.Post;
        DM.SimpleDataSet2.ApplyUpdates(-1);
        showmessage('�߰��Ǿ����ϴ�.');
        i := false
      end
      else
      begin
        showmessage('�����Ǿ����ϴ�.')
      end;
      DM.project.Refresh;
      DM.SimpleDataSet2.Refresh;
      ProjectTotal;
    end
    else
      raise Exception.Create('�����ϰ� �������� Ȯ�����ּ���');
  except
    if i = true then
    begin
      raise Exception.Create('�Է��Ͻ� ������ �ٽ� Ȯ���ϼ���');
    end
    else
      showmessage('�Է¸�尡 �ƴϰų� ������ ������ �����ϴ�');
  end;
end;

procedure TProjectForm.Button1Click(Sender: TObject);
begin
  DM.project.First;
end;

procedure TProjectForm.Button2Click(Sender: TObject);
begin
  if not DM.project.Bof then
    DM.project.Prior;
end;

procedure TProjectForm.Button3Click(Sender: TObject);
begin
  if not DM.project.Eof then
    DM.project.Next;
end;

procedure TProjectForm.Button4Click(Sender: TObject);
begin
  DM.project.Last;
end;

procedure TProjectForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
end;

procedure TProjectForm.FormCreate(Sender: TObject);
begin
  ProjectTotal;
end;

procedure TProjectForm.ProjectTotal;
var
  i: byte;
begin
  with StringGrid1 do
  begin
    RowCount := DM.project.RecordCount + 2;
    cells[0, 0] := '������Ʈ��';
    cells[1, 0] := '�ο���';
    for i := 1 to DM.project.RecordCount do
    begin
      cells[0, i] := '';
      cells[1, i] := '';
    end;
    DM.project.First;
    for i := 1 to DM.project.RecordCount do
    begin
      DM.ProjectQuery.Close;
      cells[0, i] := DM.project.FieldByName('P_Name').AsString;
      DM.ProjectQuery.Params[0].AsString := cells[0, i];
      DM.ProjectQuery.Open;
      cells[1, i] := DM.ProjectQuery.FieldByName('total').AsString;
      DM.project.Next;
    end;
    cells[0, i] := '���ο���';
    DM.ProjectQuery.Close;
    DM.ProjectQuery.Params[0].AsString := '%';
    DM.ProjectQuery.Open;
    cells[1, i] := DM.ProjectQuery.FieldByName('total').AsString;
  end;
end;

procedure TProjectForm.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  s: string;
  pos: Integer;
  oldalign: word;
begin
  s := StringGrid1.cells[ACol, ARow];
  with StringGrid1.Canvas do
  begin
    FillRect(Rect);
    if ARow = 0 then
      Font.Color := clBlue;

    if (ACol = 1) and (ARow <> 0) then
    begin
      Font.Color := clRed;
      Font.Size := Font.Size + 4;
      s := s + '��';
      oldalign := SetTextAlign(Handle, TA_RIGHT);
      TextRect(Rect, Rect.Right, Rect.Top + 3, s);
      SetTextAlign(Handle, oldalign);
    end
    else
    begin
      pos := ((Rect.Right - Rect.Left) - TextWidth(s)) div 2;
      TextRect(Rect, Rect.Left + pos, Rect.Top + 3, s);
    end;
  end;
end;

end.
