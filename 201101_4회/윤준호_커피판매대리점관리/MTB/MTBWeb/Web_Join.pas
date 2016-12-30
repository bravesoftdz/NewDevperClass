unit Web_Join;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, IWCompLabel,
  jpeg, Controls, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl,
  IWExtCtrls, IWGrids, IWDBGrids, IWCompEdit, IWDBStdCtrls, IWCompButton;

type
  TIWJOIN = class(TIWAppForm)
    IWImage1: TIWImage;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    IWLabel6: TIWLabel;
    IWLabel7: TIWLabel;
    IWPID: TIWDBEdit;
    IWPPW: TIWDBEdit;
    IWPNAME: TIWDBEdit;
    IWSID: TIWDBEdit;
    IWPADDR: TIWDBEdit;
    IWPPHONE: TIWDBEdit;
    IWPJOIN: TIWDBEdit;
    IWInsert: TIWButton;
    IWCancel: TIWButton;
    procedure IWInsertClick(Sender: TObject);
    procedure IWCancelClick(Sender: TObject);
  public
  end;

implementation

uses ServerController, UserSessionUnit, Web_Main;

{$R *.dfm}

//���
procedure TIWJOIN.IWCancelClick(Sender: TObject);
begin
  TIWMAIN.Create(WebApplication).Show;
end;

//ȸ�� ���
procedure TIWJOIN.IWInsertClick(Sender: TObject);
begin
  if IWPID.Text = ''  then
  begin
    WebApplication.ShowMessage('ID�� �Է��ϼ���.');
    IWPID.SetFocus;
    exit;
  end;
  if IWPPW.Text = ''  then
  begin
    WebApplication.ShowMessage('Password�� �Է��ϼ���.');
    IWPPW.SetFocus;
    exit;
  end;
  if IWPNAME.Text = ''  then
  begin
    WebApplication.ShowMessage('�̸��� �Է��ϼ���.');
    IWPNAME.SetFocus;
    exit;
  end;
  if IWSID.Text = ''  then
  begin
    WebApplication.ShowMessage('�������� �Է��ϼ���.');
    IWSID.SetFocus;
    exit;
  end;
  if IWPADDR.Text = ''  then
  begin
    WebApplication.ShowMessage('�ּҸ� �Է��ϼ���.');
    IWPADDR.SetFocus;
    exit;
  end;
  if IWPPHONE.Text = ''  then
  begin
    WebApplication.ShowMessage('��ȭ��ȣ�� �Է��ϼ���.');
    IWPPHONE.SetFocus;
    exit;
  end;
  try
//    IWServerController.User.ApplyUpdates(-1);
    WebApplication.ShowMessage('��� �Ϸ�');;
  except
    WebApplication.ShowMessage('��� ����');
//    IWServerController.User.CancelUpdates;
  end;
end;

end.
