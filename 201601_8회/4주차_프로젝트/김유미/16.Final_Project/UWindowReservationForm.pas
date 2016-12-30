unit UWindowReservationForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ListBox,
  FMX.Layouts, FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation,
  FMX.Edit, System.Rtti, System.Bindings.Outputs, FMX.Bind.Editors,
  Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components, UWindowDMForm,
  Data.Bind.DBScope, FMX.Effects;

type
  TWindowReservationForm = class(TForm)
    Panel1: TPanel;
    ToolBar1: TToolBar;
    LbReservation: TLabel;
    Memo1: TMemo;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    eR_Date: TEdit;
    eR_Time: TEdit;
    eR_Name: TEdit;
    eR_Phone: TEdit;
    eR_Memo: TEdit;
    ListBoxItem8: TListBoxItem;
    LbTotalCost: TLabel;
    CbR_Number: TComboBox;
    CbR_Resvp: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    BindingsList1: TBindingsList;
    CbReservation: TCornerButton;
    CbCancel: TCornerButton;
    BindSourceDB1: TBindSourceDB;
    BindSourceDB2: TBindSourceDB;
    LinkControlToField2: TLinkControlToField;
    LinkControlToField3: TLinkControlToField;
    LinkControlToField4: TLinkControlToField;
    LinkControlToField5: TLinkControlToField;
    LinkControlToField1: TLinkControlToField;
    Panel2: TPanel;
    Label1: TLabel;
    Memo2: TMemo;
    Panel3: TPanel;
    Label4: TLabel;
    Memo3: TMemo;
    BevelEffect1: TBevelEffect;
    StyleBook1: TStyleBook;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CbReservationClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CbR_ResvpChange(Sender: TObject);
    procedure CbR_NumberChange(Sender: TObject);
    procedure CbCancelClick(Sender: TObject);
  private
    { Private declarations }
    FTotalCost: Integer;
  public
    { Public declarations }
    procedure Calc_Price();
    procedure SetInitData(const AClassNum: Integer; const ADate: TDatetime; const ATime: string);
  end;

var
  WindowReservationForm: TWindowReservationForm;

implementation

{$R *.fmx}

uses UWindowMainForm;

procedure TWindowReservationForm.Calc_Price;
var
  Cost: Integer;
begin
  case CbR_Number.ItemIndex of
    0:
      Cost := 55000;
    1:
      Cost := 110000;
    2:
      Cost := 130000;
    3:
      Cost := 200000;
  end;

  FTotalCost := Cost * (CbR_Resvp.ItemIndex + 1);
  LbTotalCost.Text := Format('%d ��', [FTotalCost]);
  {
    if CbR_Number.ItemIndex = 0 then
    begin
    LbTotalCost.Text := inttostr(55000 * (CbR_Resvp.ItemIndex + 1)) + '��';
    end;
    if CbR_Number.ItemIndex = 1 then
    begin
    LbTotalCost.Text := inttostr(110000 * (CbR_Resvp.ItemIndex + 1)) + '��';
    end;
    if CbR_Number.ItemIndex = 2 then
    begin
    LbTotalCost.Text := inttostr(130000 * (CbR_Resvp.ItemIndex + 1)) + '��';
    end;
    if CbR_Number.ItemIndex = 3 then
    begin
    LbTotalCost.Text := inttostr(200000 * (CbR_Resvp.ItemIndex + 1)) + '��';
    end;
  }
end;

procedure TWindowReservationForm.CbCancelClick(Sender: TObject);
begin
  DataModule1.CdsReservationInfo.Cancel;
  WindowReservationForm.Close;
end;

procedure TWindowReservationForm.CbReservationClick(Sender: TObject);
begin
  if CbR_Number.ItemIndex = -1 then
  begin
    ShowMessage('���� Ƚ���� ���� �� �ּ���.');
    CbR_Number.SetFocus;
    Exit;
  end;

  if CbR_Resvp.ItemIndex = -1 then
  begin
    ShowMessage('���� �ο��� ���� �� �ּ���.');
    CbR_Resvp.SetFocus;
    Exit;
  end;

  if eR_Name.Text = '' then
  begin
    ShowMessage('�����ڸ��� ���� �� �ּ���.');
    eR_Name.SetFocus;
    Exit;
  end;

  if eR_Phone.Text = '' then
  begin
    ShowMessage('����ó�� ���� �� �ּ���.');
    eR_Phone.SetFocus;
    Exit;
  end;

  DataModule1.CdsReservationInfo.FieldByName('R_TotalClassCost').AsInteger :=
    FTotalCost;

  case CbR_Number.ItemIndex of
    0:
      DataModule1.CdsReservationInfo.FieldByName('R_ClassNumber')
        .AsInteger := 1;
    1:
      DataModule1.CdsReservationInfo.FieldByName('R_ClassNumber')
        .AsInteger := 2;
    2:
      DataModule1.CdsReservationInfo.FieldByName('R_ClassNumber')
        .AsInteger := 3;
    3:
      DataModule1.CdsReservationInfo.FieldByName('R_ClassNumber')
        .AsInteger := 5;
  end;

  DataModule1.CdsReservationInfo.FieldByName('R_ResvP').AsInteger :=
    CbR_Resvp.ItemIndex + 1;

  DataModule1.CdsReservationInfo.Post;
  DataModule1.CdsReservationInfo.ApplyUpdates(-1); // ������ �ݿ�
  // DataModule1.CdsReservationInfo.Refresh; // ������ ����ȭ
  DataModule1.CdsReservationInfo.Refresh;
  ShowMessage('             ������ �� �ּż� �����մϴ�.(o^��^o)�ܢ�'
    +#13+'1 ȸ ���� ��û �� 3 ȸ, 5 ȸ�� �����Ͻ� ���� ���׸� �����Ͻø� �˴ϴ�.'
    +#13+'���� ���Ա��ϼž� ����Ϸ� �˴ϴ�.'
    +#13+'3 ȸ �̻� ���� �����ô� ���� ���ϴ� ��¥ ���ϴ� �ð��� ���� �����մϴ�.'
    +#13+'���� �� ��� ��Ż ����� ������ ���ԵǾ� �ֽ��ϴ�.'
    +#13+'10�� �̻� ��ü ������ ���� �� ��ȭ ���� �ּ���. (Tel. 051-701-4851)'
    +#13+'     = �Ա� ����(IBK �������) : 051-701-4851 / ������: SURF =');

  Close;
end;

procedure TWindowReservationForm.CbR_NumberChange(Sender: TObject);
begin
  Calc_Price;
end;

procedure TWindowReservationForm.CbR_ResvpChange(Sender: TObject);
begin
  Calc_Price;
end;

procedure TWindowReservationForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  // Action :=CaFree;
  DataModule1.CdsReservationInfo.Cancel;
end;

procedure TWindowReservationForm.FormCreate(Sender: TObject);
begin
  DataModule1.CdsReservationInfo.Insert;
  Calc_Price;
  // LbTotalCost.Text := '55,000 ��';
  // Calc_Price;
  { if CbR_Number.ItemIndex = 0 then
    begin
    LbTotalCost.Text := inttostr(55000 * (CbR_Resvp.ItemIndex + 1)) + '��';
    end; }
end;

procedure TWindowReservationForm.SetInitData(const AClassNum: Integer; const ADate: TDatetime;
  const ATime: string);
begin
  DataModule1.CdsReservationInfo.FieldByName('C_Num').AsInteger := AClassNum;
  DataModule1.CdsReservationInfo.FieldByName('R_DATE').AsDateTime := ADate;
  DataModule1.CdsReservationInfo.FieldByName('R_TIME').AsString := ATime;
  // DataModule1.CdsReservationInfo.FieldByName('R_TotalClassCost').AsInteger := 55000;
end;

end.
