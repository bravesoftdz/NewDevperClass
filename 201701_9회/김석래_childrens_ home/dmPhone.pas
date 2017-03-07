unit dmPhone;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, Data.DBXCommon,
  IPPeerClient, Data.DB, Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr,
  FireDAC.Comp.DataSet, FMX.Dialogs, system.uitypes;

type
  TDataModule2 = class(TDataModule)
    qryKids: TClientDataSet;
    DSProviderConnection1: TDSProviderConnection;
    SQLConnection1: TSQLConnection;
    qryParents: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
    //�߰�, ����, ���, ���� �޼ҵ� ����
    procedure NewData;
    procedure SaveData(AImage, AThumbnail: TStream);
    procedure CancelData;
    procedure DeleteData;

  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}



{$R *.dfm}

{ TDataModule2 }






{ TDataModule2 }

//���
procedure TDataModule2.CancelData;
begin
  if qryKids.UpdateStatus = TUpdateStatus.usInserted then
    qryKids.Cancel;
end;

//����
procedure TDataModule2.DeleteData;
var
  Title, Msg : string;

begin
  // �߰��ϰ� �������� ������� ���
  if qryKids.UpdateStatus = TUpdateStatus.usInserted then
  begin
    qryKids.Cancel;
  end
  else if qryKids.UpdateStatus = TUpdateStatus.usUnmodified then
  begin
    qryKids.Delete;
    qryKids.ApplyUpdates(-1);
    qryKids.Refresh;
  end;
end;

//�߰�
procedure TDataModule2.NewData;
begin
  qryKids.Append;
end;

//����
procedure TDataModule2.SaveData(AImage, AThumbnail: TStream);
begin
  if qryKids.UpdateStatus = TUpdateStatus.usUnmodified then
    qryKids.Edit;

  // �̹��� ��Ʈ�� ����
  (qryKids.FieldByName('KIDS_IMAGE') as TBlobField).LoadFromStream(AImage);
 // (qryKids.FieldByName('KIDS_IMAGE') as TBlobField).LoadFromStream(AThumbnail);
  qryKids.Post;
  qryKids.ApplyUpdates(0);
  qryKids.UpdateStatus;
  qryKids.Refresh;
end;

end.
