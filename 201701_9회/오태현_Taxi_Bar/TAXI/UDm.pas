unit UDm;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Datasnap.DBClient, Datasnap.DSConnect, Data.DB, Data.SqlExpr,
  UClientClass, FMX.ListBox, FMX.Objects, FMX.StdCtrls, FMX.Types,FMX.Dialogs;

type
  TDm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    OrderDataSet: TClientDataSet;
    MyDataSet: TClientDataSet;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Ud_Num: Integer;
  public
    { Public declarations }
    function Calc_Distance: Integer;
    procedure Insert_UD(Slat, Slong, Phone: string);
    procedure Update_UD(Alat, Along, Dis, Price: string);
    procedure Insert_UD_Detail(Lat, Long: string);
  end;

var
  Dm: TDm;
  demo: TServerMethods1Client; // ���� �޼ҵ� ����ϱ� ���� ����

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

{$R *.dfm}

uses Umain_Mobile, System.Math;

function TDm.Calc_Distance: Integer;
var
  theta, dist: double;
  subI: TListboxItem; // FMX.ListBox
  Num, Content: TText; // FMX.Objects
  Btn_Select_Customer, Btn_Locate: TButton; // FMX.StdCtrls
  count, i: Integer;
begin
  count := 0;
  i := 0;
  OrderDataSet.Close;
  OrderDataSet.Open;
  OrderDataSet.First;

  TaxiMF.WebBrowser1.EvaluateJavaScript('hideSAMarkers();');
  TaxiMF.ListBox_User.Clear;
  while not OrderDataSet.EOF do
  begin

    theta := OrderDataSet.FieldByName('O_LONG').AsFloat - StrToFloat(TaxiMF.Long);
    dist := sin(degTorad(OrderDataSet.FieldByName('O_LAT').AsFloat)) *
    // degTorad ��� - System.Math ���̺귯��
      sin(degTorad(StrToFloat(TaxiMF.Lat))) +
      cos(degTorad(OrderDataSet.FieldByName('O_LAT').AsFloat)) *
      cos(degTorad(StrToFloat(TaxiMF.Lat))) * cos(degTorad(theta));
    dist := arccos(dist);
    dist := radTodeg(dist);
    dist := dist * 60 * 1.1515;
    dist := dist * 1.609344;


    if 2 >= dist then // 2KM �̳��� �մ� ������ ǥ��
    begin
      TaxiMF.WebBrowser1.EvaluateJavaScript
        ('AddSAMarkers(' + OrderDataSet.FieldByName('O_LAT').AsString + ',' +
        OrderDataSet.FieldByName('O_LONG').AsString + ',''' + FormatFloat('(��0.0Km)',
        dist) + ''', 0);');
      showmessage('�մ��� �˻��Ǿ����ϴ�.');
      subI := TListboxItem.Create(TaxiMF.ListBox_User);
      TaxiMF.ListBox_User.AddObject(subI);

      Num := TText.Create(subI); // Text ���� ����
      Num.Parent := subI; // �θ� �����ֱ�
      Num.Text := IntToStr(count + 1); // �ؽ�Ʈ�� �� �ֱ�
      Num.Align := TAlignLayout.Left; // FMX.Types
      Num.Width := 40;

      Content := TText.Create(subI);
      Content.Parent := subI;
      Content.Text := FormatFloat('(��0.0Km)', dist);
      Content.Align := TAlignLayout.Client;
      Content.TextSettings.HorzAlign := TTextAlign.Center;

      Btn_Select_Customer := TButton.Create(subI); // ��ư ���� ����
      Btn_Select_Customer.Parent := subI;
      Btn_Select_Customer.Text := '����';
      Btn_Select_Customer.Align := TAlignLayout.MostRight; // Align ����
      Btn_Select_Customer.Width := 60;
      Btn_Select_Customer.Tag := i; // �±� �� ����
      Btn_Select_Customer.OnClick := TaxiMF.Btn_Select_Customer;
      // ��ư�� �̺�Ʈ �ڵ�� �����ִ� ��

      Btn_Locate := TButton.Create(subI); // ��ư ���� ����
      Btn_Locate.Parent := subI;
      Btn_Locate.Text := '��ġ';
      Btn_Locate.Align := TAlignLayout.Right; // Align ����
      Btn_Locate.Width := 60;
      Btn_Locate.Tag := i; // �±� �� ����
      Btn_Locate.OnClick := TaxiMF.Btn_Locate;
      // ��ư�� �̺�Ʈ �ڵ�� �����ִ� ��

      Inc(count);
      OrderDataSet.Next;
    end
    else
      OrderDataSet.Next;

    Inc(i);
  end;

  Result := count;
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  SQLConnection1.Connected := True;
  OrderDataSet.Active := True;
  demo := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
end;

procedure TDm.Insert_UD(Slat, Slong, Phone: string);
var
  Num : string;
  //Arrive : string;
begin
  //Arrive := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
  Num := MyDataSet.FieldByName('T_NUM').AsString;
  Ud_Num := demo.Insert_UD(Slat, Slong, Num, Phone);
//  demo.Insert_UD(Arrive, Slat, Slong, Alat, Along, Dis, Price, Num, Phone);
end;

procedure TDm.Insert_UD_Detail(Lat, Long: string);
var
  time : string;
begin
  time := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
  demo.Insert_UD_Detail(IntToStr(Ud_Num),Lat,Long, time);
end;

procedure TDm.Update_UD(Alat, Along, Dis, Price: string);
var
  Num : string;
  Arrive : string;
begin
  Arrive := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);
  demo.Update_UD(Arrive,Alat, Along, Dis, Price, IntToStr(Ud_Num));
end;

end.
