unit Vcl_Rest_Add;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Rtti,
  System.Bindings.Outputs, Vcl.Bind.Editors, Data.Bind.EngExt,
  Vcl.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, Vcl.DBCtrls,
  Vcl.Mask, data.db;

type
  TRA_Form = class(TForm)
    Bevel1: TBevel;
    Btn_R_Add: TButton;
    Btn_R_Cancel: TButton;
    lb_RName: TLabel;
    lb_RPhone: TLabel;
    lb_RAddress: TLabel;
    lb_RSName: TLabel;
    Edt_Rname: TDBEdit;
    Edt_Rphone: TDBEdit;
    Edt_Raddress: TDBEdit;
    RSname_ComboBox: TDBLookupComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Btn_R_AddClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RA_Form: TRA_Form;

implementation

{$R *.dfm}

uses Vcl_Main, DM_Vcl, Vcl_Rest;

procedure TRA_Form.Btn_R_AddClick(Sender: TObject);
begin
  if Edt_Rname.text = '' then
  begin
    raise Exception.Create('������ ���� �� �Է����ּ���');
  end
  else if Edt_Raddress.text = '' then
  begin
    raise Exception.Create('�ּҸ� �� �Է����ּ���');
  end
  else
  begin
    if check = 1 then
    begin
      try
        if dm.Rest_Set.UpdateStatus = TUpdateStatus.usInserted then
          dm.Rest_Set.FieldByName('R_no').AsInteger := 0;
        dm.Rest_Set.Post;
        dm.Rest_Set.ApplyUpdates(-1);
        showmessage('��ϿϷ�');
        RA_Form.Close;
      except
        showmessage('�Է� ����')
      end;
    end
    else
    begin
      try
        dm.Rest_Set.Post;
        dm.Rest_Set.ApplyUpdates(-1);
        showmessage('������ �Ϸ�Ǿ����ϴ�.');
        RA_Form.Close;
      except
        showmessage('��������');
      end;
    end;
  end;;
  dm.Rest_Set.active := false;
  dm.Rest_Set.active := true;
end;

procedure TRA_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TRA_Form.FormCreate(Sender: TObject);
begin
  if check = 1 then
  begin
    Btn_R_Add.Caption := '���';
  end;
end;

end.
