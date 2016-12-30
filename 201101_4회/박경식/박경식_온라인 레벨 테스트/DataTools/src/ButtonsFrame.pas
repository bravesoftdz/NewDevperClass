unit ButtonsFrame;

interface

uses
  TestClasses,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TCallByRefEvent = procedure (var IsNull: Boolean) of object;

  TfrmButtons = class(TFrame)
    btDelete: TButton;
    btInsert: TButton;
    btModify: TButton;
    btQueAdd: TButton;
    procedure btQueAddClick(Sender: TObject);
    procedure btModifyClick(Sender: TObject);
    procedure btInsertClick(Sender: TObject);
    procedure btDeleteClick(Sender: TObject);
  private
    FOnNewQuestion: TNotifyEvent;
    FOnInsert: TCallByRefEvent;
    FOnUpdate: TCallByRefEvent;
    FOnDelete: TCallByRefEvent;
    { Private declarations }
  public
    procedure InsertOn;
    procedure QueAddOn;
    { Public declarations }
  published
    property OnInsert: TCallByRefEvent read FOnInsert write FOnInsert;
    property OnUpdate: TCallByRefEvent read FOnUpdate write FOnUpdate;
    property OnDelete: TCallByRefEvent read FOnDelete write FOnDelete;
    property OnNewQuestion : TNotifyEvent read FOnNewQuestion write FOnNewQuestion;
  end;

implementation

{$R *.dfm}

procedure TfrmButtons.btDeleteClick(Sender: TObject);
var
  IsNull: Boolean;
begin
  if assigned(FOnDelete) then FOnDelete(IsNull);
  if IsNull then
  begin
    ShowMessage('���� ������ �����Ͱ� �����ϴ�');
    exit;
  end;
end;

procedure TfrmButtons.btInsertClick(Sender: TObject);
var
  IsNull: Boolean;
begin
  if assigned(FOnInsert) then FOnInsert(IsNull);
  if IsNull then
  begin
    ShowMessage('�Է� ������ �����մϴ�');
    exit;
  end;
end;

procedure TfrmButtons.btModifyClick(Sender: TObject);
var
  IsNull: Boolean;
begin
  if assigned(FOnUpdate) then FOnUpdate(IsNull);
  if IsNull then
  begin
    ShowMessage('���� ������ �����Ͱ�  �����ϴ�');
    exit;
  end;
end;

procedure TfrmButtons.btQueAddClick(Sender: TObject);
begin
  if Assigned(FOnNewQuestion) then FOnNewQuestion(nil);
end;

procedure TfrmButtons.InsertOn;
begin
  btInsert.Visible := true;
  btQueAdd.Visible := false;
  btModify.Visible := false;
  btDelete.Visible := false;
end;

procedure TfrmButtons.QueAddOn;
begin
  btInsert.Visible := false;
  btQueAdd.Visible := true;
  btModify.Visible := true;
  btDelete.Visible := true;
end;

end.
