unit UDM;

interface

uses
  System.SysUtils, System.Classes, Fmx.Bind.GenData, Data.Bind.GenData,
  Data.Bind.Components, Data.Bind.ObjectScope, FMX.Graphics, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  Data.SqlExpr, Data.DBXDataSnap, IPPeerClient, Data.DBXCommon,
  Datasnap.DBClient, Datasnap.DSConnect, serverMethods;

type
  TDM = class(TDataModule)
    ClientDataSet1: TClientDataSet;
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
//    procedure FDConnection1BeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
//    procedure Connect; // �����ͺ��̽� ����
    procedure AppendMode; // �Է� ���� ����
    procedure EditMode; // ���� ���� ����
    procedure SetImage(ABitmap: TBitmap); // �̹�������(����, ����� ����� �̹���)
    procedure SaveItem; // �׸� ����(�Է�/����)
    procedure CancelItem; // �Է�/���� ��� ���
    procedure DeleteItem; // �����׸� ����
  end;

var
  DM: TDM;
  demo : TServerMethods1Client;
implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}


// �Է�/���� ��� ���
procedure TDM.CancelItem;
begin
  if ClientDataSet1.UpdateStatus = TUpdateStatus.usInserted then
    ClientDataSet1.Cancel;
end;

// �����ͺ��̽� ����
//procedure TdmDataAccess.Connect;
//begin
//
//
//
//  ClientDataSet1.Connected := True;
//  ClientDataSet1.Active := True;
//end;

// �����׸� ����
procedure TDM.DataModuleCreate(Sender: TObject);
begin
demo := TServerMethods1Client.Create(SQLConnection1.dbxconnection);
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
demo.free ;
end;

procedure TDM.DeleteItem;
begin
  ClientDataSet1.Delete;
  ClientDataSet1.ApplyUpdates(-1);
 // FDQuery1.CommitUpdates;
  ClientDataSet1.Refresh;
end;

// �������
procedure TDM.EditMode;
begin
  ClientDataSet1.Edit;
end;

//procedure TdmDataAccess.FDConnection1BeforeConnect(Sender: TObject);
//begin
//{$IFNDEF MSWINDOWS}
//  FDConnection1.Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'BOOKLOG.GDB');
//{$ENDIF}
//end;

// �Է¸��
procedure TDM.AppendMode;
begin
  ClientDataSet1.Append;
end;

// �׸� ����
procedure TDM.SaveItem;
begin
  // �Է� ��  BOOK_SEQ �ڵ����������� �� �Է� �� ����
  if ClientDataSet1.UpdateStatus = TUpdateStatus.usInserted then
    ClientDataSet1.FieldByName('BOOK_SEQ').AsInteger := 0;

  ClientDataSet1.Post;
  ClientDataSet1.ApplyUpdates(-1);
 // FDQuery1.CommitUpdates;
  ClientDataSet1.Refresh;
end;

// �̹��� ����(�����̹����� ��Ͽ� ǥ���� �����)
procedure TDM.SetImage(ABitmap: TBitmap);
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

    (ClientDataSet1.FieldByName('BOOK_IMAGE') as TBlobField).LoadFromStream(ImgStream);
    (ClientDataSet1.FieldByName('BOOK_THUMB') as TBlobField).LoadFromStream(ThumbStream);
  finally
    ImgStream.Free;
    ThumbStream.Free;
  end;
end;


end.
