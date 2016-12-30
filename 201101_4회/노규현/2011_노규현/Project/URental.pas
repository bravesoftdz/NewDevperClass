Unit URental;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, Mask, DBCtrls, ExtCtrls, FMTBcd, DB,
  SqlExpr, ComCtrls;

Type
  TRentalForm = Class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    DBGrid1: TDBGrid;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DBEdit4: TDBEdit;
    DBEdit5: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit3: TEdit;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button3: TButton;
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure Button2Click(Sender: TObject);
    Procedure Edit1Change(Sender: TObject);
    Procedure Button1Click(Sender: TObject);
    Procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);

  Private
    { Private declarations }
  Public
    { Public declarations }
  End;

Var
  RentalForm: TRentalForm;

Implementation

Uses Udm, Uclientclass, Ucus, Usearch;

{$R *.dfm}

Var
  cc: TserverMethodsClient;
  demo : tservermethodsclient;

  // ��Ż ��Ϲ�ư Ŭ��
Procedure TRentalForm.Button1Click(Sender: TObject);
Begin
  //Insert_RENTAL ������ ����
  cc := TserverMethodsClient.create(dm.SQLConnection1.DBXConnection);

  If cc.Insert_RENTAL(datetostr(date) + (DBEdit3.Text),   //��ƮID
                      DBEdit2.Text,                       //��ID
                      DBEdit3.Text,                       //��ID
                      DBEdit4.Text,                       //����ID
                      inttostr(strtoint(DBEdit5.Text)*strtoint(Edit3.Text)), //����                      //����
                      inttostr(strtoint(Edit3.Text)),     //�����
                      datetostr(date),                    //��Ʈ��
                      datetostr(date+strtoint(Edit3.Text)), //�ݳ���
                      '', 'N','') = 0 Then

    Raise Exception.create('��Ͻ���');


  showmessage('��Ʈ �Ϸ�');
  Edit1.Text := '';
  Edit3.Text := '';
  DBEdit2.Text := '';
  DBEdit3.Text := '';
  DBEdit4.Text := '';
  DBEdit5.Text := '';
End;

Procedure TRentalForm.Button2Click(Sender: TObject);
Begin
  RentalForm.Close;
End;

Procedure TRentalForm.Button3Click(Sender: TObject);
Begin
  searchform := Tsearchform.create(application);
  searchform.Show;

End;

procedure TRentalForm.ComboBox1Change(Sender: TObject);
begin
case combobox1.ItemIndex of
    0: begin
       dm.JOINTABLE.IndexFieldNames := 'name';

       end;
    1: dm.Jointable.IndexFieldNames := 'name_1';

end;
end;


Procedure TRentalForm.Edit1Change(Sender: TObject);
Begin
  dm.JOINTABLE.IndexFieldNames := 'name';
  dm.JOINTABLE.FindNearest([Edit1.Text]);
End;

Procedure TRentalForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  Action := cafree;
  cc.Free;
End;

End.
