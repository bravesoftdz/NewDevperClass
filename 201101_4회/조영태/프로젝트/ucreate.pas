unit ucreate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, dblookup, DBCtrls;

type
  TcrtForm = class(TForm)
    Panel1: TPanel;
    namelabel: TLabel;
    telLabel: TLabel;
    suibLabel: TLabel;
    boLabel: TLabel;
    indateLabel: TLabel;
    outdateLabel9: TLabel;
    nameEdit: TEdit;
    telEdit: TEdit;
    suibEdit: TEdit;
    boEdit: TEdit;
    crinbt: TButton;
    crcancelbt: TButton;
    inDateTimePicker: TDateTimePicker;
    outDateTimePicker: TDateTimePicker;
    roomdblc: TDBLookupComboBox;
    crdelbt: TButton;
    roomnamelabel: TLabel;
    procedure crinbtClick(Sender: TObject);
    procedure crcancelbtClick(Sender: TObject);
    procedure crdelbtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  crtForm: TcrtForm;

implementation

uses udm;

{$R *.dfm}

procedure TcrtForm.crcancelbtClick(Sender: TObject);
begin
//��Һκ�
  nameEdit.Text := '';
  telEdit.Text := '';
  suibEdit.Text := '';
  boEdit.Text := '';
end;

procedure TcrtForm.crdelbtClick(Sender: TObject);
 begin
 //���ó���κ�
 if dm.crt.locate('room', roomdblc.Text, []) then
  begin
    dm.crt.Edit;
    dm.crt.FieldByName('NAME').AsString := '0';
    dm.crt.FieldByName('TEL').AsString := '0';
    dm.crt.FieldByName('SUIB').Asinteger := 0;
    dm.crt.FieldByName('SUIBDATE').AsDateTime := date;
    dm.crt.FieldByName('BO').Asinteger :=0;
    dm.crt.FieldByName('INDATE').AsDateTime := date;
    dm.crt.FieldByName('OUTDATE').AsDateTime := date;
    dm.crt.Post;
    dm.crt.ApplyUpdates(-1);
  end;
  showmessage('�Ϸ�');
end;

procedure TcrtForm.crinbtClick(Sender: TObject);
begin
//��Ϻκ�
  if dm.crt.locate('room', roomdblc.Text, []) then
  begin
  //DB�����Ϳ� �ش��ϴ� ������ �����Ͽ� �ִ´�.
    dm.crt.Edit;
    dm.crt.FieldByName('ROOM').Asinteger := strtoint(roomdblc.Text);
    dm.crt.FieldByName('NAME').AsString := nameEdit.Text;
    dm.crt.FieldByName('TEL').AsString := telEdit.Text;
    dm.crt.FieldByName('SUIB').Asinteger := strtoint(suibEdit.Text);
    dm.crt.FieldByName('BO').Asinteger := strtoint(boEdit.Text);
    dm.crt.FieldByName('INDATE').AsDateTime := inDateTimePicker.Date;
    dm.crt.FieldByName('OUTDATE').AsDateTime := outDateTimePicker.Date;
    dm.crt.Post;
    dm.crt.ApplyUpdates(-1);
  end;
  showmessage('�Ϸ�');
end;

end.
