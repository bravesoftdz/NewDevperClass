unit ReadingForm;

interface

uses
  TestClasses,
  ReadingSQLUnit,
  QuestionABCDInputFrame,
  ExampleFrame,
  QuestionSelectFrame,
  ButtonsFrame,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, DSPack, Buttons, Generics.Collections;

type
  TfrReading = class(TForm)
    Panel4: TPanel;
    PanelLeftInTop: TPanel;
    lbCategory: TLabel;
    cbExamCategory: TComboBox;
    frmQuestionABCDInput: TfrmQuestionABCDInput;
    frmQuestionSelect: TfrmQuestionSelect;
    FrmButtons: TFrmButtons;
    PanelExam: TPanel;
    btExamInsert: TButton;
    btExamModify: TButton;
    btExamDelete: TButton;
    btExamAdd: TButton;
    Panel1: TPanel;
    lbExample: TLabel;
    MemoExample: TMemo;
    edNumber: TLabeledEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btExamAddClick(Sender: TObject);
    procedure cbExamCategorySelect(Sender: TObject);
    procedure btExamInsertClick(Sender: TObject);
    procedure btExamModifyClick(Sender: TObject);
    procedure btExamDeleteClick(Sender: TObject);
    procedure frmQuestionSelectcbNumberSelectSelect(Sender: TObject);
    procedure frmButtonsbtQueAddClick(Sender: TObject);
    procedure frmButtonsbtModifyClick(Sender: TObject);
    procedure frmButtonsbtDeleteClick(Sender: TObject);
    procedure frmButtonsbtInsertClick(Sender: TObject);
  private
    FTest: TTest;
    FReadingData: TObjectList<TReading>;
    FReadingSQL: TReadingSQL;
    FQuizIndex: Integer;
    FExampleIndex: Integer;
    procedure Initialize(CategoryIndex: Integer);
    procedure ExamInsertOn;
    procedure ExamAddOn;
    procedure AllClear;
    procedure NextExampleSetting;
    procedure NextQuestionSetting;

    procedure On_QuestionAdd(Sender: TObject);
    procedure On_QuestionSelect(Sender: TObject);
    procedure On_QuestionInsert(var IsNull: Boolean);
    procedure On_QuestionUpdate(var IsNull: Boolean);
    procedure On_QuestionDelete(var IsNull: Boolean);
  public
    procedure SetReadingIndex(Test: TTest);
  end;
var
  frReading: TfrReading;

implementation

{$R *.dfm}

// �ʱ� ���� �Է�
procedure TfrReading.SetReadingIndex(Test: TTest);
begin
  FTest:= Test;
  Initialize(0);
  ExamAddOn;
end;

// ��� ��Ʈ�� Clear
procedure TfrReading.AllClear;
begin
  MemoExample.Clear;
  edNumber.Clear;
  frmQuestionABCDInput.ClearInput;
  frmQuestionSelect.cbNumberSelect.Clear;
  cbExamCategory.Clear;
end;

// �����߰� Ŭ��
procedure TfrReading.btExamAddClick(Sender: TObject);
begin
  if FTest.Idx = 0 then
  begin
    ShowMessage('�����޴��� ���� ������ �ּ���');
    exit;
  end;
  NextExampleSetting;
end;

// �������� Ŭ��
procedure TfrReading.btExamDeleteClick(Sender: TObject);
begin
  if (edNumber.Text = '') or (MemoExample.Text = '') then Exit;
  if MessageDlg('������ ���Ե� ������ ��� ���� �˴ϴ�. ���� �����Ͻðڽ��ϱ�?',
      mtWarning, mbYesNo,0)= mrYes then
  begin
    FReadingSQL.ReadingTextDelete(FTest.Idx, StrToInt(cbExamCategory.Text));
    Initialize(0);
  end;
end;

// �����Է� Ŭ��
procedure TfrReading.btExamInsertClick(Sender: TObject);
var
  InsertReading : TReading;
begin
  if (edNumber.Text = '') or (MemoExample.Text = '') then
  begin
    ShowMessage('�Է� ������ �����մϴ�');
    exit;
  end;
  InsertReading := TReading.Create;
  try
    InsertReading.TestIdx := FTest.Idx;
    InsertReading.ExampleNumber := StrToInt(edNumber.Text);
    InsertReading.ExampleText := MemoExample.Text;
    FReadingSQL.ReadingTextInsert(InsertReading, FTest.Idx);
  finally
    InsertReading.Free;
  end;
  NextExampleSetting;
end;

// �������� Ŭ��
procedure TfrReading.btExamModifyClick(Sender: TObject);
var
  UpdateText : TReading;
begin
  if (edNumber.Text = '') or (MemoExample.Text = '') then Exit;
  if messagedlg('���� �����Ͻðڽ��ϱ�?', mtWarning, mbYesNo,0)= mryes then
  begin
    UpdateText := TReading.Create;
    try
      UpdateText.ExampleNumber := StrToInt(edNumber.Text);
      UpdateText.ExampleText := MemoExample.Text;
      FReadingSQL.ReadingTextUpdate(UpdateText, FTest.Idx);
    finally
      UpdateText.Free;
    end;
    Initialize(0);
  end;
end;

// ī�װ� ���ý�
procedure TfrReading.cbExamCategorySelect(Sender: TObject);
var
  I: Integer;
  Reading: TReading;
  ComboBox: TComboBox; // absolute Sender;
begin
  ExamAddOn;
  ComboBox := TComboBox(Sender);
  if ComboBox.ItemIndex > -1 then
  begin
    Reading := ComboBox.Items.Objects[ComboBox.ItemIndex] as TReading;
    FExampleIndex := Reading.ExampleIdx;
    edNumber.Text := IntToStr(Reading.ExampleNumber);
    MemoExample.Text := Reading.ExampleText;
    frmQuestionSelect.NumberListing(Reading.QuizList);
  end;
  if frmQuestionSelect.cbNumberSelect.Text = '' then
    frmQuestionABCDInput.ClearInput;
end;

// Example �Է� ���� ��ư ����
procedure TfrReading.ExamInsertOn;
begin
  btExamInsert.Visible := True;
  btExamAdd.Visible    := False;
  btExamModify.Visible := False;
  btExamDelete.Visible := False;
end;

// Example �߰� ���� ��ư ����
procedure TfrReading.ExamAddOn;
begin
  btExamInsert.Visible := False;
  btExamAdd.Visible    := True;
  btExamModify.Visible := True;
  btExamDelete.Visible := True;
end;

// Reading Form ����
procedure TfrReading.FormCreate(Sender: TObject);
begin
  frmQuestionSelect.OnQuestionSelect := On_QuestionSelect;

  frmQuestionSelect.OnQuestionSelect := On_QuestionSelect;
  frmButtons.OnUpdate := On_QuestionUpdate;
  frmButtons.OnInsert := On_QuestionInsert;
  frmButtons.OnDelete := On_QuestionDelete;
  frmButtons.OnNewQuestion := On_QuestionAdd;

  FReadingSQL := TReadingSQL.Create;
end;

// Reading Form �Ҹ�
procedure TfrReading.FormDestroy(Sender: TObject);
begin
  FReadingData.Free;
  FReadingSQL.Free;
end;

procedure TfrReading.frmButtonsbtDeleteClick(Sender: TObject);
begin
  frmButtons.btDeleteClick(Sender);
end;

procedure TfrReading.frmButtonsbtInsertClick(Sender: TObject);
begin
  frmButtons.btInsertClick(Sender);
end;

procedure TfrReading.frmButtonsbtModifyClick(Sender: TObject);
begin
  frmButtons.btModifyClick(Sender);
end;

procedure TfrReading.frmButtonsbtQueAddClick(Sender: TObject);
begin
  frmButtons.btQueAddClick(Sender);
end;

procedure TfrReading.frmQuestionSelectcbNumberSelectSelect(Sender: TObject);
begin
  frmQuestionSelect.cbNumberSelectSelect(Sender);
end;

// Reading Form Defult �� ����
procedure TfrReading.Initialize(CategoryIndex: Integer);
var
  I: Integer;
  Reading: TReading;
begin
  FreeAndNil(FReadingData);
  FReadingData := FReadingSQL.ReadingTextSelect(FTest.Idx);
  AllClear;
  for I := 0 to FReadingData.Count - 1 do
    cbExamCategory.Items.AddObject(IntToStr(FReadingData.Items[I].ExampleNumber), FReadingData.Items[I]);
  cbExamCategory.ItemIndex := CategoryIndex;

  frmQuestionABCDInput.cbAnswer.Text := '';

  if FReadingData.Count > 0 then
  begin
    edNumber.Text := IntToStr(FReadingData.Items[CategoryIndex].ExampleNumber);
    MemoExample.Text := FReadingData.Items[CategoryIndex].ExampleText;
    frmQuestionSelect.NumberListing(FReadingData.Items[CategoryIndex].QuizList);
  end;
end;

// ���� ���� �Է� ����
procedure TfrReading.NextExampleSetting;
begin
  ExamInsertOn;
  Initialize(0);
  MemoExample.Clear;
  frmQuestionABCDInput.ClearInput;
  frmQuestionSelect.cbNumberSelect.Clear;
  cbExamCategory.ItemIndex := -1;

  if cbExamCategory.Items.Count > 0 then
  begin
    edNumber.Text :=
    IntToStr(StrToInt(cbExamCategory.Items[cbExamCategory.Items.Count - 1]) + 1);
  end
  else
  begin
    edNumber.Text := '1';
  end;
end;

procedure TfrReading.NextQuestionSetting;
begin
  frmQuestionABCDInput.ClearInput;
  frmQuestionABCDInput.edNumber.Text := IntToStr(frmQuestionSelect.Numbering + 1 );
  FrmButtons.InsertOn;
  frmQuestionSelect.cbNumberSelect.ItemIndex := -1;
end;

procedure TfrReading.on_QuestionSelect(Sender: TObject);
begin
  frmButtons.QueAddOn;
  frmQuestionABCDInput.Binding(TLRQuiz(Sender));
  FQuizIndex := TLRQuiz(Sender).QuizIdx;
end;

procedure TfrReading.On_QuestionUpdate(var IsNull: Boolean);
var
  ModifyReading : TLRQuiz;
  Idx : Integer;
  Temp : Integer;
begin
  IsNull := frmQuestionABCDInput.IsNull;
  if IsNull then
    exit;
  if messagedlg('���� �����Ͻðڽ��ϱ�?', mtWarning, mbYesNo,0)= mryes then
    begin
      ModifyReading := frmQuestionABCDInput.GetReadingData;
    try
      FReadingSQL.ReadingQuestionUpdate(ModifyReading, FQuizIndex);
    finally
      ModifyReading.Free;
    end;
    Initialize(cbExamCategory.ItemIndex);
  end;
end;

procedure TfrReading.On_QuestionAdd(Sender: TObject);
begin
  if FTest.Idx = 0 then
  begin
    ShowMessage('�����޴��� ���� ������ �ּ���');
    exit;
  end;
  NextQuestionSetting;
end;

procedure TfrReading.On_QuestionDelete(var IsNull: Boolean);
var
  DeleteReading : TLRQuiz;
  Temp : Integer;
begin
  IsNull := frmQuestionABCDInput.IsNull;
  if IsNull then
    exit;
  if MessageDlg('���� �����Ͻðڽ��ϱ�?', mtWarning, mbYesNo,0)= mrYes then
  begin
    DeleteReading := frmQuestionABCDInput.GetReadingData;
    try
      FReadingSQL.ReadingQuestionDelete(FQuizIndex);
    finally
      DeleteReading.Free;
    end;
    Initialize(cbExamCategory.ItemIndex);
  end;
end;

procedure TfrReading.On_QuestionInsert(var IsNull: Boolean);
var
  InsertReading: TLRQuiz;
begin
  IsNull := frmQuestionABCDInput.IsNull;
  if IsNull then
    exit;

  InsertReading := frmQuestionABCDInput.GetReadingData;
  try
    FReadingSQL.ReadingQuestionInsert(InsertReading, FExampleIndex);
  finally
    InsertReading.Free;
  end;
  Initialize(cbExamCategory.ItemIndex);
  NextQuestionSetting;
end;

end.
