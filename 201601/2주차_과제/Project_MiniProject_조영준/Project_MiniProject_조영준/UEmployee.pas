unit UEmployee;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.ComCtrls;

type
  TEmployeeForm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet2: TTabSheet;
    Lb_Name: TLabel;
    Lb_Phone: TLabel;
    Lb_Team: TLabel;
    Edt_name: TDBEdit;
    Edt_Phone: TDBEdit;
    Bt_Insert: TButton;
    Bt_Delete: TButton;
    Bt_CanCel: TButton;
    Bt_Post: TButton;
    TeamCombo: TDBLookupComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Lb_NameSeach: TLabel;
    Edt_NameSearch: TEdit;
    procedure Bt_InsertClick(Sender: TObject);
    procedure Bt_DeleteClick(Sender: TObject);
    procedure Bt_CanCelClick(Sender: TObject);
    procedure Bt_PostClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  EmployeeForm: TEmployeeForm;
  i: Boolean;

implementation

{$R *.dfm}

uses UDM;

procedure TEmployeeForm.Bt_CanCelClick(Sender: TObject);
begin
  DM.Employee.Cancel; // ���
  DM.Employee.CancelUpdates;
  showmessage('��ҵǾ����ϴ�.');
end;

procedure TEmployeeForm.Bt_DeleteClick(Sender: TObject);
begin
  if Messagedlg('�����Ͻðٽ��ϱ�??', mtconfirmation, [mbok, mbcancel], 0) = mrok then
  begin
    try
      DM.Employee.Delete; // ���õ� ������ ����
      DM.Employee.ApplyUpdates(-1);
    except
      showmessage('���� ����');
    end;
  end;
  DM.Employee.Refresh;
end;

procedure TEmployeeForm.Bt_InsertClick(Sender: TObject);
begin
  i := true;
  DM.Employee.Insert; // �Է¸�� ����U
  showmessage('�Է¸���Դϴ�.');
end;

procedure TEmployeeForm.Bt_PostClick(Sender: TObject);
begin
  try
    DM.Employee.Post; // ����
    DM.Employee.ApplyUpdates(-1);
    if i = true then
    begin
      showmessage('�߰��Ǿ����ϴ�.');
      i := false
    end
    else
    begin
      showmessage('�����Ǿ����ϴ�.')
    end;
    DM.project.Refresh

  except
    if i = true then
    begin
      raise Exception.Create('�Է��Ͻ� ������ �ٽ� Ȯ���ϼ���');
    end
    else
      showmessage('�Է¸�尡 �ƴϰų� ������ ������ �����ϴ�');
  end;
end;

procedure TEmployeeForm.Button1Click(Sender: TObject);
begin
  DM.Employee.First;
end;

procedure TEmployeeForm.Button2Click(Sender: TObject);
begin
  if not DM.Employee.Bof then
    DM.Employee.Prior;
end;

procedure TEmployeeForm.Button3Click(Sender: TObject);
begin
  if not DM.Employee.Eof then
    DM.Employee.Next;
end;

procedure TEmployeeForm.Button4Click(Sender: TObject);
begin
  DM.Employee.Last;
end;

procedure TEmployeeForm.Edit1Change(Sender: TObject);
begin
  DM.Employee.IndexFieldNames := 'E_NAME';
  DM.Employee.FindNearest([Edt_NameSearch.Text]);
end;

procedure TEmployeeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree
end;

end.
