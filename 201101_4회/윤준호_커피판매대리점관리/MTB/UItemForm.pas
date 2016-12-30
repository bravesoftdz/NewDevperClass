unit UItemForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, Mask, DBCtrls, Grids, DBGrids, StdCtrls, ComCtrls, Buttons,
  ExtCtrls;

type
  TItemForm = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    ItemEdit: TEdit;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Bt_Insert: TButton;
    Bt_Delete: TButton;
    Bt_Apply: TButton;
    ItemIma: TDBImage;
    Bt_Image: TButton;
    Bt_Cancel: TButton;
    DBGrid1: TDBGrid;
    ItemNum: TDBEdit;
    ItemNa: TDBEdit;
    ItemCo: TDBEdit;
    ItemDa: TDBEdit;
    OpenPictureDialog1: TOpenPictureDialog;
    Label1: TLabel;
    ShopNum: TDBEdit;
    procedure Bt_InsertClick(Sender: TObject);
    procedure Bt_DeleteClick(Sender: TObject);
    procedure Bt_ApplyClick(Sender: TObject);
    procedure Bt_ImageClick(Sender: TObject);
    procedure Bt_CancelClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure ItemEditChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ItemForm: TItemForm;

implementation

uses ClientModuleUnit1, JPEG;

{$R *.dfm}

//��� ���
procedure TItemForm.Bt_CancelClick(Sender: TObject);
begin
  ClientModule1.Item.Cancel;
  ClientModule1.Item.CancelUpdates;
end;

//������ ����
procedure TItemForm.Bt_DeleteClick(Sender: TObject);
begin
with ClientModule1.Item do
  if Messagedlg('���� �Ͻðڽ��ϱ�?', mtconfirmation, [mbYes, mbNo], 0) = mrYes then
  try
    Delete;
    ApplyUpdates(-1);
  except
    on e: Exception do
    ShowMessage(e.Message);
  end;
  Refresh;
end;

//ApplyUpdate
procedure TItemForm.Bt_ApplyClick(Sender: TObject);
begin
  ShowMessage('���� ���');
  ClientModule1.Item.ApplyUpdates(-1);
end;

//���� �ҷ�����
procedure TItemForm.Bt_ImageClick(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  ItemIma.Picture.LoadFromFile(OpenPictureDialog1.FileName);
end;

procedure TItemForm.Bt_InsertClick(Sender: TObject);
begin
{
  if ItemNum.Text = '' then
  Begin
     ItemNum.SetFocus;
     Raise Exception.Create('��ǰ�ڵ带 �Է�!');
  End;

  if ItemNa.Text = '' then
  Begin
     ItemNa.SetFocus;
     Raise Exception.Create('��ǰ�� �Է� !');
  End;

  if ItemCo.Text = '' then
  Begin
     ItemCo.SetFocus;
     Raise Exception.Create('��ǰ���� �Է� !');
  End;

  if ItemDa.Text = '' then
  Begin
     ItemCo.SetFocus;
     Raise Exception.Create('��ǰ������� �Է� !');
  End;

  if CM.Item.Locate('I_ID', ItemNum.Text, []) then
  begin
    raise Exception.Create('�̹� ��ϵ� �ڵ���');
  end
  else
    CM.Item.Edit;

  with CM.Item do
  begin
    Try
      Post;
      ApplyUpdates(-1);
      Showmessage('%s �Ϸ�Ǿ����ϴ�');
    Except
      on e:Exception do
         ShowMessage(e.Message);
    End;
    Refresh;
  end;
}
  ClientModule1.Item.Insert;
end;

//��ǰ �˻�
procedure TItemForm.ItemEditChange(Sender: TObject);
begin
  ClientModule1.Item.IndexFieldNames := 'I_NAME';
  ClientModule1.Item.FindNearest([ItemEdit.Text]);
end;

//�� ����
procedure TItemForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//������ �ֻ���
procedure TItemForm.SpeedButton1Click(Sender: TObject);
begin
  ClientModule1.Item.First;
end;

//���� ������
procedure TItemForm.SpeedButton2Click(Sender: TObject);
begin
  if not ClientModule1.Item.Bof then
  ClientModule1.Item.Prior;
end;

//���� ������
procedure TItemForm.SpeedButton3Click(Sender: TObject);
begin
  if not ClientModule1.Item.Eof then
     ClientModule1.Item.Next;
end;

//������ ������
procedure TItemForm.SpeedButton4Click(Sender: TObject);
begin
  ClientModule1.Item.Last;
end;

end.
