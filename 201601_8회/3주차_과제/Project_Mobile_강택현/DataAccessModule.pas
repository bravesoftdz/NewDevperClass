unit DataAccessModule;

interface

uses
  System.SysUtils, System.Classes, Fmx.Bind.GenData, Data.Bind.GenData,
  Data.Bind.Components, Data.Bind.ObjectScope, Fmx.Graphics, System.IOUtils,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.FMXUI.Wait, FireDAC.Phys.IBBase, FireDAC.Comp.UI,
  Data.DBXDataSnap, IPPeerClient, Data.DBXCommon, Datasnap.DBClient,
  Datasnap.DSConnect, Data.SqlExpr, Main_Class;

type
  TdmDataAccess = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    get_Count: TClientDataSet;
    book_Qry: TClientDataSet;
    book_Qry_Source1: TDataSource;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    // procedure Connect; // �����ͺ��̽� ����
    procedure AppendMode; // �Է� ���� ����
    procedure EditMode; // ���� ���� ����
    procedure SetImage(ABitmap: TBitmap); // �̹�������(����, ����� ����� �̹���)
    procedure SaveItem; // �׸� ����(�Է�/����)
    procedure CancelItem; // �Է�/���� ��� ���
    procedure DeleteItem; // �����׸� ����
    function connect(): integer;  //���� ����
  end;

var
  dmDataAccess: TdmDataAccess;
  dm: TServerMethods1Client;

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

uses MainForm;

{$R *.dfm}

// �Է�/���� ��� ���
procedure TdmDataAccess.CancelItem;
begin
  if book_Qry.UpdateStatus = TUpdateStatus.usInserted then
    book_Qry.Cancel;
end;

//���� ����
function TdmDataAccess.connect(): integer;
begin
  // ���� ���� �Է�
  SQLConnection1.params.values['HostName'] := form1.Edit1.Text;
  SQLConnection1.params.values['Port'] := form1.Edit2.Text;
  try
    SQLConnection1.connected := true;
    dm := TServerMethods1Client.Create
      (dmDataAccess.SQLConnection1.DBXConnection);
    book_Qry.Active := true;
    result := 1;
  except
    abort();
  end;
end;

// ����� �ö� �� ���� ����
procedure TdmDataAccess.DataModuleCreate(Sender: TObject);
begin
  // dm := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
end;

// ����� ����� �� ���� ����
procedure TdmDataAccess.DataModuleDestroy(Sender: TObject);
begin
  dm.Free;
end;

// �����׸� ����
procedure TdmDataAccess.DeleteItem;
begin
  book_Qry.delete;
  book_Qry.applyupdates(-1);
  book_Qry.refresh;
end;

// �������
procedure TdmDataAccess.EditMode;
begin
  book_Qry.edit;
end;

// �Է¸��
procedure TdmDataAccess.AppendMode;
begin
  book_Qry.append;
end;

// �׸� ����
procedure TdmDataAccess.SaveItem;
begin
  // �Է� ��  BOOK_SEQ �ڵ����������� �� �Է� �� ����
  if book_Qry.UpdateStatus = TUpdateStatus.usInserted then
    book_Qry.fieldbyname('book_seq').AsInteger := 0;

  book_Qry.post;
  book_Qry.applyupdates(-1);
  book_Qry.refresh;
end;

// �̹��� ����(�����̹����� ��Ͽ� ǥ���� �����)
procedure TdmDataAccess.SetImage(ABitmap: TBitmap);
var
  Thumbnail: TBitmap;
  ImgStream, ThumbStream: TMemoryStream;
begin
  ImgStream := TMemoryStream.Create; // �޸� ���� �Ҵ�
  ThumbStream := TMemoryStream.Create;
  try
    ABitmap.SaveToStream(ImgStream); // ���ۿ� ����� �̹��� ����
    Thumbnail := ABitmap.CreateThumbnail(100, 100); // �̹��� ������ ����
    Thumbnail.SaveToStream(ThumbStream); // ����

    (book_Qry.fieldbyname('BOOK_IMAGE') as TBlobField)
      .LoadFromStream(ImgStream);
    (book_Qry.fieldbyname('BOOK_THUMB') as TBlobField)
      .LoadFromStream(ThumbStream);
  finally
    ImgStream.Free; // �޸� ���� ����
    ThumbStream.Free;
  end;
end;

end.
