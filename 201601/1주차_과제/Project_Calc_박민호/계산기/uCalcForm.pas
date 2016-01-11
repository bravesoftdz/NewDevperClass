unit uCalcForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.PlatformDefaultStyleActnCtrls,
  System.Actions, Vcl.ActnList, Vcl.ActnMan, Vcl.ToolWin, Vcl.ActnCtrls,
  Vcl.ExtCtrls, Vcl.StdActns, System.ImageList, Vcl.ImgList, Vcl.ActnMenus,
  Vcl.ComCtrls, Vcl.StdCtrls, System.StrUtils, System.Win.ScktComp;

type

  TfrmCalc = class(TForm)
    ImageList1: TImageList;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action1: TAction;
    FileExit1: TFileExit;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    MHPanel1: TPanel;
    MHEdit2: TEdit;
    MHEdit1: TEdit;
    MHPanel2: TPanel;
    MHBt0: TButton;
    MHBt1: TButton;
    MHBt2: TButton;
    MHBt3: TButton;
    MHBt4: TButton;
    MHBt5: TButton;
    MHBt6: TButton;
    MHBt7: TButton;
    MHBt8: TButton;
    MHBt9: TButton;
    MHBtdot: TButton;
    MHBtde: TButton;
    MHBtre: TButton;
    MHBtpl: TButton;
    MHBtmi: TButton;
    MHBtmu: TButton;
    MHBtdi: TButton;
    MHBtback: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure MHBtdeClick(Sender: TObject);
    procedure MHBt0Click(Sender: TObject);
    procedure MHBtbackClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MHBtdotClick(Sender: TObject);
    procedure MHBtplClick(Sender: TObject);
    procedure MHBtreClick(Sender: TObject);
    procedure MHBtdiClick(Sender: TObject);
    procedure MHBtmiClick(Sender: TObject);
    procedure MHBtmuClick(Sender: TObject);
    procedure MHEdit1KeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  frmCalc: TfrmCalc;

implementation

{$R *.dfm}

uses UCalcAbout; // Use Unit : UCalcAbout Unit, USplash Unit ����

var
  Dot, Bol, Btre : Boolean;              // �οﺯ�� ����
  Result : Real;                         // Equal Button ���� ����
  FourArithmetical : integer;            //  ��Ģ���� ���� ����


procedure TfrmCalc.Action1Execute(Sender: TObject);
begin
  AboutCalc.ShowModal;           // UCalAboutForm�� ShowModal â���� ���ϴ�.
end;


procedure TfrmCalc.FormShow(Sender: TObject);
begin
  Dot := True;                   // FormShow�ÿ� Dot���� �οﰪ Ture   (�Ҽ��� �ߺ� ����)
  Result := 0;                   // FormShow�ÿ� Result���� �� 0 �Ҵ�
  FourArithmetical := 1;         // FormShow�ÿ� ��Ģ���� �� 1 �Ҵ�
  Bol := False;                 //  FormShow�ÿ� Bol���� �οﰪ False   (+,-,*,/,= ���� �Է� ����)
  Btre := True;                 //  FormShow�ÿ� Btre���� �οﰪ True   (= Ŭ�� �� ���� �Է� ����)
end;

procedure TfrmCalc.MHBt0Click(Sender: TObject);
begin
  if (Sender is Tbutton) then           // ���� ��ư Ŭ���� Sender As ���� ���
begin
  if Btre then
begin
  MHEdit2.Text := MHEdit2.Text+(Sender as TButton).caption;
  MHEdit1.Text := MHEdit1.Text+(Sender as TButton).caption;
  Bol := True;                          // ���� ��ư Ŭ���� +,-,*,/,= ��ȣ �Է� ����)
end;
end;
end;

procedure TfrmCalc.MHBtbackClick(Sender: TObject);  //  BackSpace Ŭ��
begin
  MHEdit1.Text := LeftStr(MHEdit1.Text, Length(MHEdit1.Text)-1);
  // LeftStr : ���ڿ��� ���۵� �������� Ư�� ������ �κи� ��Ÿ���� ȣ�����ִ� �Լ�
end;


procedure TfrmCalc.MHBtdeClick(Sender: TObject);
begin
  MHEdit1.Clear;                       // ����Ʈ1 �ڽ� �ʱ�ȭ
  MHEdit1.Text := '';                  // ����Ʈ1 �ڽ� null�� �Ҵ�
  MHEdit2.Text := '';                  // ����Ʈ2 �ڽ� null�� �Ҵ�
  Result := 0;
  FourArithmetical := 1;
  Btre := True;                        //  Clear�� �����Է� ����
end;


procedure TfrmCalc.MHBtdiClick(Sender: TObject);  //  ������(/) ����
begin
  if Bol then
  begin
  case FourArithmetical of
  1 : Result := Result + StrToFloat(MHEdit1.Text);
  2 : Result := Result - StrToFloat(MHEdit1.Text);
  3 : Result := Result * StrToFloat(MHEdit1.Text);
  4 : Result := Result / StrToFloat(MHEdit1.Text);
  end;
  MHEdit2.Text := MHEdit2.Text + '/';
  MHEdit1.Text := '';
  FourArithmetical := 4;
  Bol := False;
  Btre := True;
  end;
end;

procedure TfrmCalc.MHBtdotClick(Sender: TObject); //  �Ҽ��� Ŭ��
begin
  if Dot then                                     //  �Ҽ����� Ŭ���ϸ�
  begin
  Dot := False;                                   //  �Ҽ����� �Է� �ȵǰ� �ϰ�
  MHEdit2.Text := MHEdit2.Text+'.';               //  ����Ʈ2 �ڽ��� '����Ʈ2' ���� '�Ҽ���' ���� �Ҵ�
  end;
end;


procedure TfrmCalc.MHBtmiClick(Sender: TObject);  //  ����(-) ����
begin
  if Bol then
  begin
  case FourArithmetical of
  1 : Result := Result + StrToFloat(MHEdit1.Text);
  2 : Result := Result - StrToFloat(MHEdit1.Text);
  3 : Result := Result * StrToFloat(MHEdit1.Text);
  4 : Result := Result / StrToFloat(MHEdit1.Text);
  end;
  MHEdit2.Text := MHEdit2.Text + '-';
  MHEdit1.Text := '';
  FourArithmetical := 2;
  Bol := False;
  Btre := True;
  end;
end;

procedure TfrmCalc.MHBtmuClick(Sender: TObject);  //  ���ϱ�(X) ����
begin
  if Bol then
  begin
  case FourArithmetical of
  1 : Result := Result + StrToFloat(MHEdit1.Text);
  2 : Result := Result - StrToFloat(MHEdit1.Text);
  3 : Result := Result * StrToFloat(MHEdit1.Text);
  4 : Result := Result / StrToFloat(MHEdit1.Text);
  end;
  MHEdit2.Text := MHEdit2.Text + '*';
  MHEdit1.Text := '';
  FourArithmetical := 3;
  Bol := False;
  Btre := True;
  end;
end;


procedure TfrmCalc.MHBtplClick(Sender: TObject);  //  ���ϱ�(+) ����
begin
  if Bol then
  begin
  case FourArithmetical of
  1 : Result := Result + StrToFloat(MHEdit1.Text);
  2 : Result := Result - StrToFloat(MHEdit1.Text);
  3 : Result := Result * StrToFloat(MHEdit1.Text);
  4 : Result := Result / StrToFloat(MHEdit1.Text);
  end;
  MHEdit2.Text := MHEdit2.Text + '+';
  MHEdit1.Text := '';
  FourArithmetical := 1;
  Bol := False;
  Btre := True;
  end;
end;


procedure TfrmCalc.MHBtreClick(Sender: TObject);  //  ���(Result) �� ����
begin
  try                                             // ���� ó��
  if Bol then
  begin
  case FourArithmetical of
  1 : Result := Result + StrToFloat(MHEdit1.Text);
  2 : Result := Result - StrToFloat(MHEdit1.Text);
  3 : Result := Result * StrToFloat(MHEdit1.Text);
  4 : Result := Result / StrToFloat(MHEdit1.Text);
  end;
  MHEdit1.Text := FloatToStr(Result);
  MHEdit2.Text := '';
  Result := 0;
  Bol := True;
  Btre := False;
  FourArithmetical := 1;
  end;
  except
  on EzeroDivide do showmessage('0���� ���� �� �����ϴ�.');
  on EOverFlow do showmessage('�Է� ������ ������ϴ�.');
  end;
end;


procedure TfrmCalc.MHEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then                      // ����Ʈ1 �ڽ��� Ŀ���� �ΰ� ����Ű�� ������ �������� ���
     MHBtre.Click;
end;


procedure TfrmCalc.Timer1Timer(Sender: TObject);
begin
  Statusbar1.Panels[1].Text := FormatDateTime('yyyy-mm-dd dddd ampm hh:mm:ss', now);
 // ���¹� �ι�° �гο� ���� ��¥�� �ð��� ������ �մϴ�.
end;

end.

