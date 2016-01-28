unit UClient_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Data.DB, Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr,FMX.Graphics,FMX.Types;

type
  TDataModule1 = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    Book_Log_CDS: TClientDataSet;
    Book_Log_CDSBOOK_SEQ: TIntegerField;
    Book_Log_CDSBOOK_TITLE: TWideStringField;
    Book_Log_CDSBOOK_AUTHOR: TWideStringField;
    Book_Log_CDSBOOK_PUBLISHER: TWideStringField;
    Book_Log_CDSBOOK_PHONE: TWideStringField;
    Book_Log_CDSBOOK_WEBSITE: TWideStringField;
    Book_Log_CDSBOOK_COMMENT: TWideStringField;
    Book_Log_CDSBOOK_THUMB: TBlobField;
    Book_Log_CDSBOOK_IMAGE: TBlobField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Connect(AHost, APort:string):Boolean; // �����ͺ��̽� ����
    procedure AppendMode; // �Է� ���� ����
    procedure EditMode; // ���� ���� ����
    procedure SetImage(ABitmap: TBitmap); // �̹�������(����, ����� ����� �̹���)
    procedure SaveItem; // �׸� ����(�Է�/����)
    procedure CancelItem; // �Է�/���� ��� ���
    procedure DeleteItem; // �����׸� ����
    procedure Refresh; //���ΰ�ħ
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDataModule1 }

procedure TDataModule1.AppendMode;
begin
  Book_Log_CDS.Append;
end;

procedure TDataModule1.CancelItem; //�Է� ���� ��� ���
begin
  if Book_Log_CDS.UpdateStatus= TUpdateStatus.usInserted then
    Book_Log_CDS.Cancel;
end;


function TDataModule1.Connect(AHost, APort: string): Boolean;//����
begin
  Result := False;
  SQLConnection1.Connected :=False;
  Book_Log_CDS.Active := False;
  try
    SQLConnection1.Params.Values['HostName']:= AHost;
    SQLConnection1.Params.Values['Port']:=APort;
    SQLConnection1.Connected :=True;
    Book_Log_CDS.Active := True;
    Book_Log_CDS.Refresh;
    Result:= True;
  except on E : Exception do
    Log.d(E.Message);
  end;
end;

procedure TDataModule1.DeleteItem;//����
begin
  Book_Log_CDS.Delete;
  Book_Log_CDS.ApplyUpdates(0);
  Book_Log_CDS.Refresh;
end;

procedure TDataModule1.EditMode;//����
begin
  Book_Log_CDS.Edit;
end;

procedure TDataModule1.Refresh;//���ΰ�ħ
begin
  Book_Log_CDS.Refresh;
end;

procedure TDataModule1.SaveItem;//����
begin
  if Book_Log_CDS.UpdateStatus = TUpdateStatus.usInserted then
    Book_Log_CDS.FieldByName('BOOK_SEQ').AsInteger :=0;
  Book_Log_CDS.Post;
  Book_Log_CDS.ApplyUpdates(0);
  Book_Log_CDS.Refresh;
end;

// �̹��� ����(�����̹����� ��Ͽ� ǥ���� �����)
procedure TDataModule1.SetImage(ABitmap: TBitmap);
var
  Thumbnail: TBitmap;
  ImgStream, ThumbStream: TMemoryStream;
begin
  ImgStream := TMemoryStream.Create;
  ThumbStream := TMemoryStream.Create;
  try
    ABitmap.SaveToStream(ImgStream);
    Thumbnail := ABitmap.CreateThumbnail(100, 100);
    Thumbnail.SaveToStream(ThumbStream);

    (Book_Log_CDS.FieldByName('BOOK_IMAGE') as TBlobField).LoadFromStream(ImgStream);
    (Book_Log_CDS.FieldByName('BOOK_THUMB') as TBlobField).LoadFromStream(ThumbStream);
  finally
    ImgStream.Free;
    ThumbStream.Free;
  end;
end;

end.
