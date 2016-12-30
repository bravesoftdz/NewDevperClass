unit UDataInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, DBCtrls, StdCtrls, Buttons, Mask, Grids, DBGrids, ExtCtrls;

type
  TDataInputForm = class(TForm)
    ����: TLabel;
    ����: TLabel;
    Label7: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    bbtnOk: TBitBtn;
    bbtnCancle: TBitBtn;
    Label9: TLabel;
    edtTitle: TEdit;
    DateTimePicker1: TDateTimePicker;
    cmbStartTimeH: TComboBox;
    cmbStartTimeM: TComboBox;
    cmbGrade: TComboBox;
    redtText: TRichEdit;
    DBGrid1: TDBGrid;
    cbxAlram: TCheckBox;
    bbtnDelete: TBitBtn;
    procedure bbtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbtnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataInputForm: TDataInputForm;
implementation

uses UDataModule, UMain;

{$R *.dfm}

procedure TDataInputForm.bbtnOkClick(Sender: TObject);
var
  i: integer;
  SQLQuery, tmpAlarmH, tmpAlarmM: string;
begin
  SQLQuery := 'select title from schedule where title = :ptitle';
  with DM.FineSameTitleQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLQuery);
    Params[0].AsString:=edtTitle.Text;
    Open;
  end;
  if (aBeforeTitle <> edtTitle.Text) and (DM.FineSameTitleQuery.RecordCount >=1 ) and (bbtnOk.Caption ='����') then
  begin
    DataInputForm.edtTitle.SetFocus;
    ShowMessage('�ߺ��� ������ �ֽ��ϴ�.');
  end
  else if (DM.FineSameTitleQuery.RecordCount >=1 ) and (bbtnOk.Caption ='�Է�') then
  begin
    DataInputForm.edtTitle.SetFocus;
    ShowMessage('�ߺ��� ������ �ֽ��ϴ�.');
  end
  else if DataInputForm.edtTitle.Text = '' then
  begin
    DataInputForm.edtTitle.SetFocus;
    ShowMessage('������ �Է� �ϼ���.');
    //Raise Exception.Create('������ �Է� �ϼ���.');
  end
  else if DataInputForm.redtText.Text = '' then
  begin
    DataInputForm.redtText.SetFocus;
    ShowMessage('������ �Է� �ϼ���.');
    //Raise Exception.Create('������ �Է� �ϼ���.');
  end
  else
  begin
    if bbtnOk.Caption ='�Է�' then
      DM.ScheduleTable.Insert
    else
    begin
      DM.ScheduleTable.First;
      for i := 1 to DM.ScheduleTable.RecordCount do
      if DM.ScheduleTable.FieldByName('title').AsString <> aBeforeTitle then
        DM.ScheduleTable.Next;
      DM.ScheduleTable.Edit;
    end;
    //DM.ScheduleTable.FieldByName('Start_day').AsDateTime := now;
    with DM.ScheduleTable do
    begin
      FieldByName('createtime').AsString:= FormatDateTime('YYYYMMDDhhnnss',now);
      FieldByName('title').AsString:= edtTitle.Text;
      FieldByName('day_data').AsString:= FormatDateTime('yyyyMMdd',DateTimePicker1.DateTime);
      FieldByName('timeH_data').AsString:=cmbStartTimeH.Text;
      FieldByName('timeM_data').AsString:=cmbStartTimeM.Text;
      case cmbGrade.ItemIndex of
        0: FieldByName('grade').AsInteger:= 0;
        1: FieldByName('grade').AsInteger:= 1;
        2: FieldByName('grade').AsInteger:= 2;
      end;
      if cbxAlram.Checked then
      begin
        FieldByName('alarm_data').AsBoolean:= True;
      end
      else
      begin
        FieldByName('alarm_data').AsBoolean:= False;
      end;
      FieldByName('text').AsString:= redtText.Text;

      try
        post;
        ShowMessage(Format('%s �Ǿ����ϴ�.',[bbtnOk.Caption]));
      except
        on e: Exception do
          ShowMessage(e.Message);
      end;
      refresh;
      ModalResult:= mrOk;
    end;
  end;
end;


procedure TDataInputForm.bbtnDeleteClick(Sender: TObject);
var
  SQLQuery: string;
begin
  if MessageDlg('���� �Ͻðڽ��ϱ�?',mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    try
      SQLQuery := 'delete from schedule where title = :ptitle';
      with DM.SelectDataQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(SQLQuery);
        Params[0].AsString:=edtTitle.Text;
        ExecSQL;
      end;
    except
      on e: Exception do
        ShowMessage(e.Message);
    end;
    DM.ScheduleTable.Refresh;
    ModalResult:= mrOk;
  end;
end;

procedure TDataInputForm.FormCreate(Sender: TObject);
begin
 // showmessage(FormatDateTime('hh',now)+', '+FormatDateTime('nn',now));

  // ���� �ð� dafault ������ ���� �ð� ����
  DateTimePicker1.DateTime := now;
  cmbStartTimeH.ItemIndex := StrToint(FormatDateTime('hh',now));
  cmbStartTimeM.ItemIndex := StrToint(FormatDateTime('nn',now));
end;

end.
