unit UDm;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Datasnap.DBClient, Datasnap.DSConnect, Data.DB, Data.SqlExpr,
  UClientClass, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TDm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    CafeInfoDataSet: TClientDataSet;
    GetReserveDataSet: TClientDataSet;
    GetReserveDetailDataSet: TClientDataSet;
    GetReserveDataSetR_TOTAL_AMOUNT: TIntegerField;
    GetReserveDataSetR_ARRIVAL: TSQLTimeStampField;
    GetReserveDataSetR_PAYMENT_PLAN: TWideStringField;
    GetReserveDataSetU_LAT: TSingleField;
    GetReserveDataSetU_LONG: TSingleField;
    GetReserveDataSetR_COMMENT: TWideStringField;
    GetReserveDataSetU_ID: TWideStringField;
    GetReserveDataSetU_NAME: TWideStringField;
    GetReserveDataSetU_PHONENUM: TWideStringField;
    GetReserveDataSetU_GENDER: TBooleanField;
    GetReserveDataSetR_NUM: TIntegerField;
    CafeInfoDataSet_Source: TDataSource;
    CafeInfoDataSetC_NAME: TWideStringField;
    CafeInfoDataSetC_LOCA: TWideStringField;
    CafeInfoDataSetC_LAT: TSingleField;
    CafeInfoDataSetC_LONG: TSingleField;
    GetReserveDetailDataSetR_NUM: TIntegerField;
    GetReserveDetailDataSetM_NAME: TWideStringField;
    GetReserveDetailDataSetRL_QUANTITY: TIntegerField;
    GetReserveDetailDataSetRL_PRICE: TIntegerField;
    GetReserveDetailDataSetM_PRICE: TIntegerField;
    GetReserveDetailDataSetM_INFO: TWideStringField;
    GetReserveDetailDataSetM_PHOTO: TBlobField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BeforeRNum: integer;
    CurrentRNum: integer;
    procedure Get_Reserve;
    procedure Get_Reserve_Detail;
  end;

var
  Dm: TDm;
  demo: TServerMethods1Client;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

uses Umain_Vcl, System.Math;

{$R *.dfm}

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  SQLConnection1.Connected := true;
  demo := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
  BeforeRNum := 0;
  CurrentRNum := 0;
end;

procedure TDm.Get_Reserve; // ���� ���� ��������
var
  i, j: integer;
  lat, long: string;
  name, arrival: string;
  theta, dist: double;
begin
  demo.Get_Reserve_info(CafeInfoDataSet.FieldByName('C_LOCA').AsString);
  GetReserveDataSet.Close;
  GetReserveDataSet.Open;
  CurrentRNum := GetReserveDataSet.RecordCount;

  if CurrentRNum > BeforeRNum then // ����ڰ� ���� ��
  begin
    i := CurrentRNum - BeforeRNum;
    ShowMessage(IntToStr(i) + '���� �մ��̿��� �߽��ϴ�. �� ' +
      IntToStr(CurrentRNum) + '��');

    PcForm.ListBox1.Clear;

  end
  else if CurrentRNum < BeforeRNum then // ����ڰ� ���� ��� ��
  begin
    i := BeforeRNum - CurrentRNum;
    ShowMessage(IntToStr(i) + '���� �մ��� ��������߽��ϴ�. ��' +
      IntToStr(CurrentRNum) + '��');
    PcForm.Memo1.Lines.Clear;
  end;
  // ������ �����ϸ� ��� �˷����ұ�?

  PcForm.ListBox1.Clear;
  GetReserveDataSet.First;

  PcForm.HTMLWindow2.execScript('hideMarkers()', 'JavaScript'); // ��Ŀ �ʱ�ȭ
  while not GetReserveDataSet.Eof do // �մ� ���� ����Ʈ�ڽ��� �Ѹ���
  begin
    name := GetReserveDataSet.FieldByName('U_NAME').AsString + '��';
    arrival := GetReserveDataSet.FieldByName('R_ARRIVAL').AsString;
    PcForm.ListBox1.Items.Add(name + '   ' + arrival);
    lat := GetReserveDataSet.FieldByName('U_LAT').AsString;
    long := GetReserveDataSet.FieldByName('U_LONG').AsString;

    theta := CafeInfoDataSet.FieldByName('C_LONG').AsFloat - StrToFloat(long);
    dist := sin(degTorad(CafeInfoDataSet.FieldByName('C_LAT').AsFloat)) *
      sin(degTorad(StrToFloat(lat))) +
      cos(degTorad(CafeInfoDataSet.FieldByName('C_LAT').AsFloat)) *
      cos(degTorad(StrToFloat(lat))) * cos(degTorad(theta));
    dist := arccos(dist);
    dist := radTodeg(dist);
    dist := dist * 60 * 1.1515;
    dist := dist * 1.609344; // �մ԰� ī����ġ �Ÿ� ���

    PcForm.HTMLWindow2.execScript('AddCustMarkers(' + lat + ',' + long + ',''' +
      name + ' ' + FormatFloat('(��0.0km)', dist) + ''')', 'JavaScript');
    // ��Ŀ�� ���������� �߰�

    GetReserveDataSet.Next;
  end;
  GetReserveDataSet.First;

  BeforeRNum := CurrentRNum;
end;

procedure TDm.Get_Reserve_Detail; // �� �������� ��������
var
  num: string;
begin
  num := GetReserveDataSet.FieldByName('R_NUM').AsString;
  demo.Get_Reserve_Detail(num); // �����ȣ�� ������ ��������
  GetReserveDetailDataSet.Close; // ����
  GetReserveDetailDataSet.Open;

  PcForm.Memo1.Lines.Clear;
  PcForm.Memo1.Lines.Add('�̸�: ' + GetReserveDataSet.FieldByName('U_NAME')
    .AsString);
  PcForm.Memo1.Lines.Add('���������ð�: ' + GetReserveDataSet.FieldByName('R_ARRIVAL')
    .AsString);
  PcForm.Memo1.Lines.Add('��ȭ��ȣ: ' + GetReserveDataSet.FieldByName('U_PHONENUM')
    .AsString);
  PcForm.Memo1.Lines.Add('�������: ' + GetReserveDataSet.FieldByName
    ('R_PAYMENT_PLAN').AsString);
  PcForm.Memo1.Lines.Add('�� �����ݾ�:' + GetReserveDataSet.FieldByName
    ('R_TOTAL_AMOUNT').AsString + '��');
  PcForm.Memo1.Lines.Add('�߰��䱸����:' + GetReserveDataSet.FieldByName('R_COMMENT')
    .AsString);

  GetReserveDetailDataSet.First;
  while not GetReserveDetailDataSet.Eof do // �ֹ�����
  begin
    PcForm.Memo1.Lines.Add('�ֹ�ǰ��: ' + GetReserveDetailDataSet.FieldByName
      ('M_NAME').AsString + '  ' + GetReserveDetailDataSet.FieldByName
      ('RL_QUANTITY').AsString + '��' + '(' + GetReserveDetailDataSet.FieldByName
      ('RL_PRICE').AsString + '��)');
    GetReserveDetailDataSet.Next;
  end;

end;

end.
