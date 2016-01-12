unit uClacForm;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Themes;

type

  TfrmCalc = class(TForm)
    Panel1: TPanel;
    clear: TButton;
    num0: TButton;
    num1: TButton;
    num2: TButton;
    num3: TButton;
    num4: TButton;
    num5: TButton;
    num6: TButton;
    num7: TButton;
    num8: TButton;
    num9: TButton;
    Panel2: TPanel;
    Edit1: TEdit;
    btnadd: TButton;
    btnsub: TButton;
    bunmul: TButton;
    btndiv: TButton;
    result: TButton;
    Memo1: TMemo;
    Swindow: TButton;
    SAmakrits: TButton;
    SAuric: TButton;
    SCarbon: TButton;
    GroupBox1: TGroupBox;
    procedure num(Sender: TObject);
    procedure asmd(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure SwindowClick(Sender: TObject);
    procedure SAuricClick(Sender: TObject);
    procedure SAmakritsClick(Sender: TObject);
    procedure SCarbonClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Clac (rnum : nativeint):nativeint;     //���� �Լ�

    { Public declarations }
  end;
var
  frmCalc: TfrmCalc;
  numa :Nativeint=0;                                //�Է��� �ڸ� ���ڸ� ��ġ�� ����
  chara : shortstring ='';                          //�Է¹��� ���ڵ�(���������� ����)
  resultclac :nativeint =0;                         //���� ���
  functionnum : nativeint=0;                        //+,-,*,/ �� �Ǻ��ϱ� ���� ����
implementation


{$R *.dfm}

procedure TfrmCalc.asmd(Sender: TObject);
begin
  case (Sender as TButton).Tag of
      1:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'+';
        numa := StrToInt(chara);
        functionnum :=1;
      end;
      2:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'-';
        numa := StrToInt(chara);
        functionnum :=2;
      end;
      3:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'��';
        numa := StrToInt(chara);
        functionnum :=3;
      end;
      4:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'��';
        numa := StrToInt(chara);
        functionnum :=4;
      end;
      5:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'=';
        numa := StrToInt(chara);
        case functionnum of
          1:resultclac:= numa+StrToInt(Edit1.Text);
          2:resultclac:= numa-StrToInt(Edit1.Text);
          3:resultclac:= numa*StrToInt(Edit1.Text);
          4:resultclac:= numa div StrToInt(Edit1.Text);
        end;
        Memo1.Lines.Text := Memo1.Lines.Text+IntToStr(resultclac);
      end;
  end;
  Clac(functionnum);
  chara :='';
end;
function TfrmCalc.Clac(rnum: nativeint) :nativeint;  //�Է��� �����ڿ� ���� ���
begin
  if functionnum <>0 then
  begin
    case functionnum of
      1:resultclac:= numa+StrToInt(Edit1.Text);
      2:resultclac:= numa-StrToInt(Edit1.Text);
      3:resultclac:= numa*StrToInt(Edit1.Text);
      4:resultclac:= numa div StrToInt(Edit1.Text);
    end;
    Edit1.Text := IntToStr(resultclac);
  end;
end;
procedure TfrmCalc.clearClick(Sender: TObject);  //�ʱ�ȭ
begin
  Edit1.Text :='0';
  Memo1.Clear;
  numa :=0;
  chara := '';
  resultclac :=0;
  functionnum :=0;
end;

procedure TfrmCalc.num(Sender: TObject);         //���� �Է�
var
  countnum : ShortString;
begin
  countnum := '10';
  case (Sender as TButton).Tag of                //���� �ڵ鷯�� �����Ͽ� �Է��� ��ư�� �ɽ����� ã�� ���� ����
      10:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'0';
        countnum :='0';
      end;
      11:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'1';
        countnum :='1';
      end;
      12:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'2';
        countnum :='2';
      end;
      13:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'3';
        countnum :='3';
      end;
      14:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'4';
        countnum :='4';
      end;
      15:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'5';
        countnum :='5';
      end;
      16:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'6';
        countnum :='6';
      end;
      17:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'7';
        countnum :='7';
      end;
      18:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'8';
        countnum :='8';
      end;
      19:
      begin
        Memo1.Lines.Text := Memo1.Lines.Text+'9';
        countnum :='9';
      end;
  end;
  chara := chara+countnum;                       //2�ڸ� �̻� ���ڸ� ��������� ����
end;

procedure TfrmCalc.SAmakritsClick(Sender: TObject);
begin
    TStyleManager.TrySetStyle('Amakrits');
end;

procedure TfrmCalc.SAuricClick(Sender: TObject);
begin
    TStyleManager.TrySetStyle('Auric');
end;

procedure TfrmCalc.SCarbonClick(Sender: TObject);
begin
      TStyleManager.TrySetStyle('Carbon');
end;

procedure TfrmCalc.SwindowClick(Sender: TObject);
begin
      TStyleManager.TrySetStyle('Windows');
end;

end.
