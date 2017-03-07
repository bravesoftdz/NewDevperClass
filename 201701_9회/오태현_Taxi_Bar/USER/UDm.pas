unit UDm;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Data.DB, Data.SqlExpr, Datasnap.DBClient, Datasnap.DSConnect,
  UClientClass,
  FMX.ListBox, FMX.Objects, FMX.Types, FMX.StdCtrls;
// listbox, objects, types, stdctrls uses�ؾ� �̿볻�� ���������� ���� ���� ��� ����

type
  TDm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    UserQueryDataSet: TClientDataSet;
    TaxiDataSet: TClientDataSet;
    CheckOrdersDataSet: TClientDataSet;
    UDDetailDataSet: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Btn_Map: array of TButton; // ��ư �����Ҵ� (�迭) TButton = FMX.StdCtrls
    Btn_Del: array of TButton; // �迭 �����Ҵ�� -> a: array[0..10] of Integer;
    procedure Get_UD(Phone: string); // �̿볻�� ����
    procedure Del_UD(Num: Integer);  // �̿볻�� ����
    function Calc_Distance: Integer; // �ý� �Ÿ���� �� ������ ���
    procedure Get_UD_Detail(Num:string);
  end;

var
  Dm: TDm;
  demo: TServerMethods1Client; // ���� �޼ҵ� ����ϱ� ���� ����

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

uses Umain_Mobile, System.Math;

{$R *.dfm}

function TDm.Calc_Distance: Integer; // �Ÿ���� �� 2KM�̳��� �ý� �� ����
var
  theta, dist: double;
  count: Integer;
begin
  count := 0;
  TaxiDataSet.Close;
  TaxiDataSet.Open;
  TaxiDataSet.First; // ������ �������� ù��° �ٷ� �̵�

  UserMF.WebBrowser1.EvaluateJavaScript('hideMarkers();');

  while not TaxiDataSet.EOF do
  begin

    theta := TaxiDataSet.FieldByName('T_LONG').AsFloat - StrToFloat(UserMF.Long);
    dist := sin(degTorad(TaxiDataSet.FieldByName('T_LAT').AsFloat)) *
    // degTorad ��� - System.Math ���̺귯��
      sin(degTorad(StrToFloat(UserMF.Lat))) +
      cos(degTorad(TaxiDataSet.FieldByName('T_LAT').AsFloat)) *
      cos(degTorad(StrToFloat(UserMF.Lat))) * cos(degTorad(theta));
    dist := arccos(dist);
    dist := radTodeg(dist);
    dist := dist * 60 * 1.1515;
    dist := dist * 1.609344;
    // ����, �浵�� �̿��� �Ÿ� ��� ��

    if (2 >= dist) and (TaxiDataSet.FieldByName('T_STATE').AsInteger = 1) then // �Ÿ��� 2KM�̳��̰� Taxi�� ���°� 1(����)�� ��쿡 ����
    begin
      UserMF.WebBrowser1.EvaluateJavaScript('AddTaxiMarkers(' +
        TaxiDataSet.FieldByName('T_LAT').AsString + ',' +
        TaxiDataSet.FieldByName('T_LONG').AsString + ',''' + TaxiDataSet.FieldByName('T_NUM').AsString +
        ' ' + FormatFloat('(��0.0Km)', dist) + ''');');
      Inc(count); // count ������ �� 1�� ����

      TaxiDataSet.Next; // ���̺� ���� �ٷ� �̵�
    end
    else
      TaxiDataSet.Next;
  end;

  Result := count;
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  SQLConnection1.Connected := True;
  demo := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
end;


procedure TDm.Del_UD(Num: Integer); // �̿볻�� ���� ���ν���
var
  InputNum: string;
begin
   UserQueryDataSet.First;
  UserQueryDataSet.MoveBy(Num);
  InputNum := UserQueryDataSet.FieldByName('UD_NUM').AsString;
  // Del_UD�� �ѹ��� �־ ��
  demo.Del_UD(InputNum);
end;

procedure TDm.Get_UD(Phone: string); // �ش� ��ȣ�� �̿볻�� ��������
var
  ListBoxItem: TListBoxItem; // FMX.ListBox
  Num, Content: TText; // FMX.Objects
  Arrive: TDateTime;
  i: Integer;
begin
  demo.Get_UD(Phone); // �̿볻���� �����κ��� �޾ƿ�
  UserQueryDataSet.Close; // �����ͼ��� ����ݾ� �����κ��� ������ ����
  UserQueryDataSet.Open;
  UserQueryDataSet.First;

  UserMF.List_UD.Clear; // ����Ʈ�ڽ� �׸� �ʱ�ȭ
  i := 0;
  Btn_Map := nil; // �迭 �ʱ�ȭ                                              -
  Btn_Del := nil;

  SetLength(Btn_Map, UserQueryDataSet.RecordCount); // �迭 ũ�� ����
  SetLength(Btn_Del, UserQueryDataSet.RecordCount);

  UserQueryDataSet.First; // ù��° �ٷ� �̵�
  while not UserQueryDataSet.EOF do // EOF = End Of Final, not�� �پ��־� ���̾ƴҰ�� while���� �ݺ���
  begin
    ListBoxItem := TListBoxItem.Create(UserMF.List_UD); // ListBoxItem ���� ����
    UserMF.List_UD.AddObject(ListBoxItem); // ListBoxItem �߰�

    Num := TText.Create(ListBoxItem); // Text ���� ����
    Num.Parent := ListBoxItem;  // �θ� �����ֱ�
    Num.Text := IntToStr(i + 1);  // �ؽ�Ʈ�� �� �ֱ�
    Num.Align := TAlignLayout.Left; // FMX.Types
    Num.Width := 40;

    Content := TText.Create(ListBoxItem);
    Content.Parent := ListBoxItem;
    Arrive := UserQueryDataSet.FieldByName('UD_ARRIVE').AsDateTime; // Datetime�������� �� ��ȯ
    Content.Text := FormatDateTime('yy�� mm�� dd�� ampm hh:nn', Arrive) + ', ';
    Content.Text := Content.Text + FormatFloat('0.##', UserQueryDataSet.FieldByName('UD_DIS')
      .AsFloat) + 'Km, ';
    Content.Text := Content.Text + UserQueryDataSet.FieldByName('UD_PRICE')
      .AsString + '��';
    Content.Align := TAlignLayout.Client;
    Content.TextSettings.HorzAlign := TTextAlign.Center;


    Btn_Map[i] := TButton.Create(ListBoxItem); // ��ư ���� ����
    Btn_Map[i].Parent := ListBoxItem;
    Btn_Map[i].Text := '����';
    Btn_Map[i].Align := TAlignLayout.Right; // Align ����
    Btn_Map[i].Width := 60;
    Btn_Map[i].Tag := i; // �±� �� ����
    Btn_Map[i].OnClick := UserMF.Btn_MapClick; // ��ư�� �̺�Ʈ �ڵ�� �����ִ� ��

    Btn_Del[i] := TButton.Create(ListBoxItem);
    Btn_Del[i].Parent := ListBoxItem;
    Btn_Del[i].Text := '����';
    Btn_Del[i].Align := TAlignLayout.MostRight;
    Btn_Del[i].Width := 60;
    Btn_Del[i].Tag := i;
    Btn_Del[i].OnClick := UserMF.Btn_DelClick; // ��ư�� �̺�Ʈ �ڵ�� �����ִ� ��

    Inc(i); // Dec(i);
    UserQueryDataSet.Next; // ���� �ٷ� �̵�
  end;

end;

procedure TDm.Get_UD_Detail(Num: string);
var
  Time: TDateTime;
  i : Integer;
begin
 demo.Get_UD_Detail(Num);
 UDDetailDataSet.Close;
 UDDetailDataSet.Open;
 UDDetailDataSet.First;
 i := 1;

 while not UDDetailDataSet.EOF do
 begin
  Time := UDDetailDataSet.FieldByName('UD_TIME').AsDateTime;
  UserMF.WebBrowser1.EvaluateJavaScript('AddTaxiMarkers(' +
        UDDetailDataSet.FieldByName('UD_LAT').AsString + ',' +
        UDDetailDataSet.FieldByName('UD_LONG').AsString + ',''' + IntToStr(i) +
        '�� ' + FormatDateTime('ampm hh:nn', Time) + ''');');

  UDDetailDataSet.Next;
  Inc(i);
 end;
end;

end.
