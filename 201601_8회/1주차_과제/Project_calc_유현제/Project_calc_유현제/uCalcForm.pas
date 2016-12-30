unit uCalcForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Themes, Vcl.ActnList,
  System.Actions, Vcl.StdActns, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls,
  Vcl.ActnMenus, System.ImageList, Vcl.ImgList,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.StdCtrls;

type
  TfmCalc = class(TForm)
    ActionManager1: TActionManager;
    ImageList1: TImageList;
    ActionMainMenuBar1: TActionMainMenuBar;
    FileExit1: TFileExit;
    Style1Action: TAction;
    Style2Action: TAction;
    Style3Action: TAction;
    Bs: TButton;
    Bc: TButton;
    Btn1: TButton;
    Btn2: TButton;
    Btn3: TButton;
    Btn4: TButton;
    Btn5: TButton;
    Btn6: TButton;
    Btn7: TButton;
    Btn8: TButton;
    Btn9: TButton;
    Btn0: TButton;
    Add: TButton;
    Sub: TButton;
    Mul: TButton;
    Mod1: TButton;
    Dot: TButton;
    Divide1: TButton;
    Divide: TButton;
    Edit1: TEdit;
    procedure Style1ActionExecute(Sender: TObject);
    procedure Style2ActionExecute(Sender: TObject);
    procedure Style3ActionExecute(Sender: TObject);
    procedure Btn1Click(Sender: TObject);
    procedure BsClick(Sender: TObject);
    procedure BcClick(Sender: TObject);
    procedure AddClick(Sender: TObject);
    procedure SubClick(Sender: TObject);
    procedure MulClick(Sender: TObject);
    procedure DivideClick(Sender: TObject); overload;
    procedure DotClick(Sender: TObject);
    procedure Mod1Click(Sender: TObject);
    procedure Divide1Click(Sender: TObject); overload;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCalc: TfmCalc;
  Num1,Num2 : real; //�Ǽ���
  S : String;   //������
  implementation

{$R *.dfm}

procedure TfmCalc.AddClick(Sender: TObject);
begin
  Num1:= StrToFloat (edit1.Text);      //StrToFloat -���ڿ��� �Ǽ��� ����ȯ
  S :='+';
  Edit1.Text:=''
end;
procedure TfmCalc.SubClick(Sender: TObject);
begin
  Num1:= StrToFloat (edit1.Text);
  S :='-';
  Edit1.Text:=''
end;
procedure TfmCalc.MulClick(Sender: TObject);
begin
  Num1:= StrToFloat (edit1.Text);
  S :='*';
  Edit1.Text:=''
end;
procedure TfmCalc.Divide1Click(Sender: TObject);
begin
  Num1:= StrToFloat (edit1.Text);
  S :='div';
  Edit1.Text:=''
end;
procedure TfmCalc.DivideClick(Sender: TObject);
begin
  Num1:= StrToFloat (edit1.Text);
  S :='/';
  Edit1.Text:=''
end;
procedure TfmCalc.Mod1Click(Sender: TObject);
begin
  try


  Num2:= strToFloat (edit1.text);
  If S = '+' then edit1.Text:=FloatToStr (Num1 + Num2);
  If S = '-' then edit1.Text:=FloatToStr (Num1 - Num2);
  If S = '*' then edit1.Text:=FloatToStr (Num1 * Num2);
  If S = '/' then edit1.Text:=FloatToStr (Num1 / Num2);
  If S = 'div' then edit1.Text:=FloatToStr (Num1 / Num2);

  Except
    On EDivByzero Do
    ShowMessage ('0���� ���� �� �����ϴ�.');
  end;
end;
procedure TfmCalc.DotClick(Sender: TObject);
begin
  Edit1.Text:= Edit1.Text + '.'
end;

procedure TfmCalc.BcClick(Sender: TObject);
begin
  Edit1.Clear;
end;

procedure TfmCalc.BsClick(Sender: TObject);
begin
  Edit1.Text := copy(Edit1.Text,0,Length(Edit1.Text)-1);
  //Length- ���ڿ��� ��� copy ( ��, ������ġ, ũ��)
  //���۹�° ���ں��� ���ڰ�����ŭ ���ڿ��� �߶󳻾� ����Ѵ�.
end;

procedure TfmCalc.Btn1Click(Sender: TObject);
begin
   Edit1.Text := Edit1.Text + IntToStr((Sender as TButton).Tag);
  //Edit1.Text := Edit1.Text + TButton(Sender).Caption ;
end;

procedure TfmCalc.Style1ActionExecute(Sender: TObject);
begin
  TStyleManager.TrySetStyle('Windows')       //��Ÿ������
end;
procedure TfmCalc.Style2ActionExecute(Sender: TObject);
begin
  TStyleManager.TrySetStyle('Auric')
end;
procedure TfmCalc.Style3ActionExecute(Sender: TObject);
begin
  TStyleManager.TrySetStyle('Luna')
end;
Initialization
Finalization
end.
