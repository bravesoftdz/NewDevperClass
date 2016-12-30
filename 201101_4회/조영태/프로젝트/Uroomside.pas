unit Uroomside;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls;

type
  TroomsideFrame = class(TFrame)
    roomsidePanel: TPanel;
    roomsideEdit: TEdit;
    namesideEdit: TEdit;
    floowComboBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    roomsideButton: TButton;
    namesideButton: TButton;
    procedure roomsideButtonClick(Sender: TObject);
    procedure namesideButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses udm, usearch, Ugo;

{$R *.dfm}

procedure TroomsideFrame.namesideButtonClick(Sender: TObject);
//�̸�����Ʈ â�� �̸��� �ļ� �̸��� ���� �̸��� ������ ��ġ���� ����� DB�� ������ ���� �ִ´�
var
 search : tsearchform;
begin
 if namesideedit.Text = '' then
   begin
   namesideedit.SetFocus;
   raise exception.Create('�̸��� �Է��Ͻʽÿ�.');
// if dm.crt.Locate('name',namesideedit.Text,[]) then
//    raise exception.Create('�̸��� �����ϴ�.');
   end;
if dm.crt.locate('name',namesideedit.text, []) then
begin
  search := Tsearchform.create(goroom);
  search.searchroomedit.Text := dm.crt.FieldByName('room').AsString;
  search.nameEdit.Text := dm.crt.FieldByName('name').AsString;
  search.telEdit.Text := dm.crt.FieldByName('tel').AsString;
  search.suibEdit.Text := dm.crt.FieldByName('suib').AsString;
//  search.suibDateTimePicker.Date :=dm.crt.FieldByName('suibdate').AsDateTime;
  search.boEdit.Text := dm.crt.FieldByName('bo').AsString;
  search.inDateTimePicker.Date := dm.crt.FieldByName('indate').AsDateTime;
  search.outDateTimePicker.Date :=dm.crt.FieldByName('outdate').AsDateTime;
  search.Show;
end;
end;

procedure TroomsideFrame.roomsideButtonClick(Sender: TObject);
//�濡��Ʈ â�� ȣ���� �ļ� ��� ���� �̸��� ������ ��ġ���� ����� DB�� ������ ���� �ִ´�
var
 search : tsearchform;
begin
 if roomsideedit.Text = '' then
   begin
   roomsideedit.SetFocus;
   raise exception.Create('ȣ���� �Է��Ͻʽÿ� ');
   end;
if dm.crt.locate('room',roomsideedit.text, []) then
begin
  search := Tsearchform.create(goroom);
  search.searchroomedit.Text := dm.crt.FieldByName('room').AsString;
  search.nameEdit.Text := dm.crt.FieldByName('name').AsString;
  search.telEdit.Text := dm.crt.FieldByName('tel').AsString;
  search.suibEdit.Text := dm.crt.FieldByName('suib').AsString;
//  search.suibDateTimePicker.Date :=dm.crt.FieldByName('suibdate').AsDateTime;
  search.boEdit.Text := dm.crt.FieldByName('bo').AsString;
  search.inDateTimePicker.Date := dm.crt.FieldByName('indate').AsDateTime;
  search.outDateTimePicker.Date :=dm.crt.FieldByName('outdate').AsDateTime;
  search.Show;
end;


end;

end.
