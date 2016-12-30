unit WritingForm;

interface

uses
  TestClasses,
  WritingSQLUnit,
  QuestionSelectFrame,
  SoundFrame,
  ExampleFrame,
  QuestionInputFrame,
  ButtonsFrame,
  Generics.Collections,
  Forms, StdCtrls, Classes, Controls, ExtCtrls, Windows, Messages, SysUtils,
  Variants, Graphics, Dialogs, ComCtrls, DSPack, Buttons;

type
  TfrWriting = class(TForm)
    PanelQuestionInput: TPanel;
    frmQuestionSelect: TfrmQuestionSelect;
    frmSound: TfrmSound;
    frmQuestionInput: TfrmQuestionInput;
    frmButtons: TFrmButtons;
    Panel1: TPanel;
    MemoExample: TMemo;
    lbExample: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frmButtonsbtQueAddClick(Sender: TObject);
    procedure frmButtonsbtModifyClick(Sender: TObject);
  private
    { Private declarations }
    FTest : TTest;
    FWritingData: TObjectList<TQuiz>;
    FWritingSQL: TWritingData;
    procedure On_QuestionSelect(Sender: TObject);
    procedure On_QuestionAdd(Sender: TObject);
    procedure On_QuestionInsert(var IsNull: Boolean);
    procedure On_QuestionUpdate(var IsNull: Boolean);
    procedure On_QuestionDelete(var IsNull: Boolean);
    procedure NextQuestionSetting;
    procedure Initialize;
  public
    procedure SetWritingIndex(Test: TTest);
    { Public declarations }
  end;

var
  frWriting: TfrWriting;

implementation

{$R *.dfm}

// Writing Form Defult �� ����
procedure TfrWriting.SetWritingIndex(Test: TTest);
begin
  FTest := Test;
  FTest.idx := FTest.Idx;
  Initialize;
end;

// Writing Form ����
procedure TfrWriting.FormCreate(Sender: TObject);
begin
  frmQuestionSelect.OnQuestionSelect := On_QuestionSelect;
  frmButtons.OnUpdate := On_QuestionUpdate;
  frmButtons.OnInsert := On_QuestionInsert;
  frmButtons.OnDelete := On_QuestionDelete;
  frmButtons.OnNewQuestion := On_QuestionAdd;
  FWritingSQL := TWritingData.Create;

  frmSound.Part := qpWriting;
end;


// Writing Form �Ҹ�
procedure TfrWriting.FormDestroy(Sender: TObject);
begin
  FWritingData.Free;
  FWritingSQL.Free;
end;

procedure TfrWriting.frmButtonsbtModifyClick(Sender: TObject);
begin
  frmButtons.btModifyClick(Sender);

end;

procedure TfrWriting.frmButtonsbtQueAddClick(Sender: TObject);
begin
  frmButtons.btQueAddClick(Sender);

end;

procedure TfrWriting.Initialize;
begin
  FreeAndNil(FWritingData);
  FWritingData := FWritingSQL.Select(FTest.idx);
  frmQuestionInput.ClearInput;
  MemoExample.Clear;
  frmQuestionSelect.NumberListing(FWritingData);
  frmSound.Test := FTest;
end;

// ���� ���� ����
procedure TfrWriting.NextQuestionSetting;
begin
  frmQuestionInput.QuestionSet(frmQuestionSelect.Numbering + 1);
  MemoExample.Clear;
  FrmButtons.InsertOn;
  frmQuestionSelect.SetIndex;
end;

// SpeakingSelect Frame�� �� �Է�
procedure TfrWriting.On_QuestionSelect(Sender: TObject);
begin
  frmButtons.QueAddOn;
  MemoExample.Text := TWriting(Sender).ExampleText;
  frmQuestionInput.Binding(TQuiz(Sender));
  frmSound.SelectedQuestion := TQuiz(Sender);
end;

// �����߰� Ŭ��
procedure TfrWriting.On_QuestionAdd(Sender: TObject);
begin
  if FTest.idx = 0 then
  begin
    ShowMessage('�����޴��� ���� ������ �ּ���');
    exit;
  end;

  NextQuestionSetting;
end;

// �Է� Ŭ��
procedure TfrWriting.On_QuestionInsert(var IsNull: Boolean);
var
  InsertWriting: TWriting;
begin
  IsNull := frmQuestionInput.IsNull;
  if IsNull then Exit;

  InsertWriting := TWriting.Create;
  try
    InsertWriting.Idx := FTest.idx;
    InsertWriting.QuizNumber := frmQuestionInput.Number;
    InsertWriting.Quiz := frmQuestionInput.Question;
    InsertWriting.ExampleText := MemoExample.Text;
    FWritingSQL.Insert(InsertWriting);
  finally
    InsertWriting.Free;
  end;

  Initialize;
  NextQuestionSetting;
end;

// ���� Ŭ��
procedure TfrWriting.On_QuestionUpdate(var IsNull: Boolean);
var
  ModifyWriting: TWriting;
begin
  IsNull := frmQuestionInput.IsNull;
  if IsNull then Exit;

  if messagedlg('���� �����Ͻðڽ��ϱ�?', mtWarning, mbYesNo,0)= mryes then
  begin
    ModifyWriting := TWriting.Create;
    try
      ModifyWriting.Idx := FTest.idx;
      ModifyWriting.QuizNumber := frmQuestionInput.Number;
      ModifyWriting.Quiz := frmQuestionInput.Question;
      ModifyWriting.ExampleText := MemoExample.Text;
      FWritingSQL.Update(ModifyWriting);
    finally
      ModifyWriting.Free;
    end;

    Initialize;
  end;
end;

// ���� Ŭ��
procedure TfrWriting.On_QuestionDelete(var IsNull: Boolean);
begin
  IsNull := frmQuestionInput.IsNull;
  if IsNull then Exit;

  if MessageDlg('���� �����Ͻðڽ��ϱ�?', mtWarning, mbYesNo,0)= mrYes then
  begin
    FWritingSQL.Delete(StrToInt(frmQuestionSelect.cbNumberSelect.Text), FTest.idx);
    Initialize;
  end;
end;

end.
