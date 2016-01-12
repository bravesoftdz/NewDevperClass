unit uCalcForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdActns, System.Actions,
  Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.ToolWin,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.StdCtrls;

type
  TfrmCalc = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    procedure Button1Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalc: TfrmCalc;

implementation
       var
       T1, T2, result : single;
       Mode : byte;
{$R *.dfm}

   procedure TfrmCalc.Button12Click(Sender: TObject);
        begin
          T2 := strTocurr(Edit1.Text);
             case Mode of
               1: result := T1 + T2;
               2: result := T1 - T2;
               3: result := T1 * T2;
               4: result := T1 / T2;
             end;


          Edit1.Text := currTostr(result);
        end;

   procedure TfrmCalc.Button13Click(Sender: TObject);
        begin
           T1 := strTocurr(Edit1.Text);
           Edit1.Text := '0';
           Mode := 1;
        end;

   procedure TfrmCalc.Button14Click(Sender: TObject);
       begin
          T1 := strTocurr(Edit1.Text);
          Edit1.Text := '0';
          Mode := 2;
       end;

  procedure TfrmCalc.Button15Click(Sender: TObject);
       begin
           T1 := strTocurr(Edit1.Text);

           Edit1.Text := '0';
           Mode := 3;
       end;

  procedure TfrmCalc.Button16Click(Sender: TObject);
       begin
           T1 := strTocurr(Edit1.Text);
           Edit1.Text := '0';
           Mode := 4;
       end;

  procedure TfrmCalc.Button18Click(Sender: TObject);
       begin
          if Edit1.Text = Edit1.Text then Edit1.Text := '0';
          // ���� 0 ���� �ʱ�ȭ
       end;

   procedure TfrmCalc.Button1Click(Sender: TObject);
       begin
           if Edit1.Text = '0' then Edit1.Text := TButton(sender).Caption
                                                   // �޽��������� �������� ó��
              // 0�� �Է��� �Ǿ� �������� ��ư�� caption ������ �ٲ۴�
           else
              Edit1.Text := Edit1.Text + TButton(sender).Caption;
            //���� �Էµ� ���� ��ư�� caption���� �߰��Ѵ�
       end;

   end.
