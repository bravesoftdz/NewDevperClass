unit Umain_Mobile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Objects, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.WebBrowser, System.Sensors, System.Sensors.Components,
  FMX.ListBox, FMX.EditBox, FMX.NumberBox, System.Bluetooth,
  System.Bluetooth.Components;

type
  TTaxiMF = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Timer1: TTimer;
    Btn_Sign_In: TButton;
    Layout1: TLayout;
    Layout2: TLayout;
    Text1: TText;
    Edit1: TEdit;
    ToolBar1: TToolBar;
    WebBrowser1: TWebBrowser;
    Btn_State: TButton;
    Btn_Customer: TButton;
    ToolBar2: TToolBar;
    LocationSensor1: TLocationSensor;
    ListBox_User: TListBox;
    Dis_Box: TNumberBox;
    Price_Box: TNumberBox;
    Text3: TText;
    Text4: TText;
    Btn_Search_Customer: TButton;
    Text2: TText;
    Timer2: TTimer;
    ComboBox1: TComboBox;
    StyleBook1: TStyleBook;
    Timer3: TTimer;
    Timer4: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Btn_Sign_InClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Btn_StateClick(Sender: TObject);
    procedure Btn_CustomerClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure Btn_Select_Customer(Sender: TObject);
    procedure Btn_Locate(Sender: TObject);
    procedure Btn_Search_CustomerClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
  private
    { Private declarations }
    CusPhone: string; // �մ� ��ȭ��ȣ
    CusType: string; // �մ� Ÿ��
    Clat: string; // �մ� ����
    Clong: string; // �մ� �浵
  public
    { Public declarations }
    TextTime: Integer;
    Lat, BLat: string; // �ýñ�� ����, 10���� ����
    Long, BLong: string; // �ýñ�� �浵, 10���� �浵
    Phone: string; // �ýñ�� ��ȭ��ȣ
    TaxiNum: string; // �ýù�ȣ
    Customer: Integer; // �մ� ��
    MapLevel: Integer; // �� ũ�� ����
    IsSelect: Boolean; // �մ� ���ý� Timer�� �̿��� �ֺ��մ� �˻� ���� �ʰ� �ϴ� ����
    Dist_Fee: Double; // �Ÿ��� �ݾ� ��� ����
  end;

var
  TaxiMF: TTaxiMF;

implementation

{$R *.fmx}
{$IFDEF ANDROID}

// �ȵ���̵��ϰ�� �ش� ���� ����
uses
  UDm, Androidapi.JNI.Location, Androidapi.JNIBridge,
  // �ȵ���̵� API ( GPS ���� �̿��� ��ġ�� �޾ƿ��� ��ȭ��ȣ �������� ���� ���)
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Telephony, FMX.Helpers.Android, System.Math;
// System.Math�� �����̿��� �����ϴ� ���а��� ���̺귯��
{$ENDIF}
{$IFDEF MSWINDOWS}

// �������ϰ�� �ش� ���� ����
uses
  UDm, System.Math;
{$ENDIF}

const // ���
  HTMLStr: UnicodeString = '<!DOCTYPE html>' + '<html>' + '<head>' +
    '<meta charset="utf-8">' + '<title>���� ���� API</title>' + '</head>' + '<body>'
    + '<div id="map" style="width:100%;height:300px;"></div>'

    + '<script src="http://apis.daum.net/maps/maps3.js?apikey=68f86bb3c0448b7089e8fcd79e94caf0"></script>'
    + '<script>'

    + 'var map;' + 'var markers = [];' + 'var samarkers = [];'

    + 'var markerImageArray = [''http://postfiles10.naver.net/20160113_73/hunter450_14526261888591piAy_PNG/start2.png?type=w3'',''http://postfiles4.naver.net/20160113_163/hunter450_1452626188640w5IYS_PNG/arrive2.png?type=w3'''
    + ' , ''http://postfiles2.naver.net/20160113_49/hunter450_1452626396176TWcLj_PNG/taxi2.png?type=w3''];'

    + 'function SetMap(lat, long){' +
    'var mapContainer = document.getElementById(''map''),' // ������ ǥ���� div
    + 'mapOption = {' + 'center: new daum.maps.LatLng(lat, long),' // ������ �߽���ǥ
    + 'level: 5,' // ������ Ȯ�� ����
    + 'mapTypeId : daum.maps.MapTypeId.ROADMAP' // ��������
    + '};' + 'map = new daum.maps.Map(mapContainer, mapOption);' + '}'

    + 'function AddSAMarkers(lat, long, name, count){' // ���, ���� ��Ŀ �߰�
    + 'var markerImageUrl = markerImageArray[count],' +
    'markerImageSize = new daum.maps.Size(25, 36),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(11, 36)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});'

    + 'daum.maps.event.addListener(marker, ''click'', (function(marker) {'
  // ���,���� ��Ŀ Ŭ�� �� �̺�Ʈ ���
    + 'return function() {' + 'var infowindow = new daum.maps.InfoWindow({' +
    'content: ''<p style="margin:7px 22px 7px 12px;font:12px/1.5 sans-serif">'' + name + ''</p>'','
    + 'removable : true ' + '});' + 'infowindow.open(map, marker);' + '}' +
    '})(marker));' + 'samarkers.push(marker);' + '}'

    + 'function setSAMarkers(map) {' // ��Ŀ ����
    + 'for (var i = 0; i < samarkers.length; i++) {' +
    'samarkers[i].setMap(map);' + '}' + '}'

    + 'function hideSAMarkers() {' // ��Ŀ ��� �����
    + 'setSAMarkers(null);' + '}'

    + 'function AddTaxiMarkers(lat, long, name){' // �ý� ��ġ ��Ŀ �߰�
    + 'var markerImageUrl = ''http://postfiles2.naver.net/20160113_49/hunter450_1452626396176TWcLj_PNG/taxi2.png?type=w3'','
    + 'markerImageSize = new daum.maps.Size(28, 34),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(14, 34)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});'

    + 'daum.maps.event.addListener(marker, ''click'', (function(marker) {'
  // �ý� ��Ŀ Ŭ�� �� �̺�Ʈ ���
    + 'return function() {' + 'var infowindow = new daum.maps.InfoWindow({' +
    'content: ''<p style="margin:7px 22px 7px 12px;font:12px/1.5 sans-serif">'' + name + ''</p>'','
    + 'removable : true ' + '});' + 'infowindow.open(map, marker);' + '}' +
    '})(marker));' + 'markers.push(marker);' + '}'

    + 'function setMarkers(map) {' // ��Ŀ ����
    + 'for (var i = 0; i < markers.length; i++) {' + 'markers[i].setMap(map);'
    + '}' + '}'

    + 'function hideMarkers() {' // ��Ŀ ��� �����
    + 'setMarkers(null);' + '}'

    + 'function panTo(lat,long) {'
  // �̵��� ���� �浵 ��ġ�� �����մϴ�
    + 'var moveLatLon = new daum.maps.LatLng(lat, long);'
  // ���� �߽��� �ε巴�� �̵���ŵ�ϴ�
  // ���� �̵��� �Ÿ��� ���� ȭ�麸�� ũ�� �ε巯�� ȿ�� ���� �̵��մϴ�
    + 'map.panTo(moveLatLon);' + '}'

    + 'function MapLevels(count) {' + 'map.setLevel(count);' + '}'

    + '</script>' + '</body>' + '</html>';

procedure TTaxiMF.Btn_Locate(Sender: TObject);
var
  SLat, SLong: string;
begin
  IsSelect := True;
  Timer2.Enabled := False;
  Text2.Text := '�մ�ã�� ����� �����Ǿ����ϴ�.';
  Btn_Search_Customer.Text := '�մ�ã��';
  Text2.Text := IntToStr(ListBox_User.ItemIndex + 1) + '�� �մ� ����';
  Dm.OrderDataSet.First;
  Dm.OrderDataSet.MoveBy((Sender as TButton).Tag);
  SLat := Dm.OrderDataSet.FieldByName('O_LAT').AsString;
  SLong := Dm.OrderDataSet.FieldByName('O_LONG').AsString;
  WebBrowser1.EvaluateJavaScript('panTo(' + SLat + ',' + SLong + ');');
end;

procedure TTaxiMF.Btn_Search_CustomerClick(Sender: TObject);
begin
  if IsSelect then
  begin
    Btn_Search_Customer.Text := '�˻���';
    IsSelect := False;
    Timer2.Enabled := True;
  end
  else
  begin
    Btn_Search_Customer.Text := '�մ�ã��';
    IsSelect := True;
    Timer2.Enabled := False;
    Text2.Text := '�մ�ã�� ����� �����Ǿ����ϴ�.';
  end;
end;

procedure TTaxiMF.Btn_Select_Customer(Sender: TObject);
var
  SLat, SLong: string;
begin
  IsSelect := True;
  Timer2.Enabled := False;
  Text2.Text := '�մ�ã�� ����� �����Ǿ����ϴ�.';
  Btn_Search_Customer.Text := '�մ�ã��';
  Dm.OrderDataSet.First;
  Dm.OrderDataSet.MoveBy((Sender as TButton).Tag);
  SLat := Dm.OrderDataSet.FieldByName('O_LAT').AsString;
  SLong := Dm.OrderDataSet.FieldByName('O_LONG').AsString;
  WebBrowser1.EvaluateJavaScript('panTo(' + SLat + ',' + SLong + ');');
  CusPhone := Dm.OrderDataSet.FieldByName('C_PHONE').AsString;
  CusType := IntToStr(Dm.OrderDataSet.FieldByName('O_TYPE').AsInteger + 2);

  MessageDlg(IntToStr(ListBox_User.ItemIndex + 1) + '��° �մ��� �¿�ðڽ��ϱ�?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        if demo.Change_Types(CusPhone, CusType, TaxiNum) then
        begin
          Text2.Text := '�� ��ȭ��ȣ: ' + CusPhone;
          ShowMessage(IntToStr(ListBox_User.ItemIndex + 1) + '��° �մ����� �����Ǿ����ϴ�');
          demo.Change_State(Phone, '0');
          Btn_State.Text := '�˻����';
          Clat := SLat;
          Clong := SLong;
        end
        else
        begin
          ShowMessage('�ٸ� ���ýð� �ش�մ��� �¿췯 ���� ���Դϴ�. ���ο� �մ��� �˻��մϴ�.');
          Dm.Calc_Distance;
          Btn_Search_Customer.OnClick(Btn_Search_Customer);
        end;
      end;
    end);
end;

procedure TTaxiMF.Btn_Sign_InClick(Sender: TObject);
{$IFDEF ANDROID}
var
  obj: JObject;
  locationManager: JLocationManager;
{$ENDIF}
begin
{$IFDEF ANDROID}
  if not demo.Taxi_Sign_In(Edit1.Text) then
    raise Exception.Create('��ϵ��� ���� �ýñ���ȣ�Դϴ�.');
  Phone := Edit1.Text;
  Dm.MyDataSet.Close;
  Dm.MyDataSet.Open;
  TaxiNum := Dm.MyDataSet.FieldByName('T_NUM').AsString;

  if not LocationSensor1.Active then
    LocationSensor1.Active := True;

  obj := SharedActivityContext.getSystemService // GPS ���� ��������
    (TJContext.JavaClass.LOCATION_SERVICE);
  locationManager := TJLocationManager.Wrap((obj as ILocalObject).GetObjectID);

  if locationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER)
  then
  // GPS on / off Ȯ�� then
  begin
    try
      if Lat = '' then
        raise Exception.Create('��ġ������ ��Ȯ���� �ʽ��ϴ�. ��� �� �ٽ� ������ �ּ���');

      WebBrowser1.Parent := TabItem2;
      WebBrowser1.EvaluateJavaScript('SetMap(37.56682,126.97865);');
      WebBrowser1.EvaluateJavaScript('hideSAMarkers();');
      WebBrowser1.EvaluateJavaScript('MapLevels(5);');
      WebBrowser1.EvaluateJavaScript('panTo(' + Lat + ',' + Long + ');');
      WebBrowser1.EvaluateJavaScript('AddTaxiMarkers(' + Lat + ',' + Long +
        ',''������ġ'');');
      Timer1.Enabled := True;
      Timer2.Enabled := True;
      Dm.Calc_Distance;
    except
      raise Exception.Create('��ġ������ ��Ȯ���� �ʽ��ϴ�. ��� �� �ٽ� ������ �ּ���');
    end;

    TabControl1.ActiveTab := TabItem2;
  end
  else
    ShowMessage('GPS�� ���ּ���');
{$ENDIF}
end;

procedure TTaxiMF.Btn_StateClick(Sender: TObject);
begin
  if Btn_State.Text = '�˻����' then
  begin
    demo.Change_State(Phone, '1');
    Btn_State.Text := '�˻��Ұ�';
  end
  else
  begin
    demo.Change_State(Phone, '0');
    Btn_State.Text := '�˻����';
  end;
end;

procedure TTaxiMF.ComboBox1Change(Sender: TObject);
begin
  if ComboBox1.ItemIndex <> 0 then
    MapLevel := ComboBox1.ItemIndex + 2; // ���� ũ�� ����
  WebBrowser1.EvaluateJavaScript('MapLevels(' + IntToStr(MapLevel) + ');');
end;

procedure TTaxiMF.Btn_CustomerClick(Sender: TObject);
begin
  if Btn_Customer.Text = '�մ�ž��' then
  begin
    // Btn_State.OnClick(Btn_State);
    if ListBox_User.ItemIndex = -1 then
      raise Exception.Create('���õ� �մ��� �����ϴ�.');
    MessageDlg('�մ� ž�� Ȯ��', TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      begin
        Btn_Customer.Text := '��ݰ��';
        IsSelect := True;
        Timer2.Enabled := False;
        Price_Box.Value := 2800;
        Dis_Box.Value := 0;
        Timer3.Enabled := True;
        Timer4.Enabled := True;
        if CusType = '2' then
        begin
          Dm.Insert_UD(Clat, Clong, CusPhone);
        end;

      end);

  end
  else
  begin
    MessageDlg(Dis_Box.Text + 'Km, ' + Price_Box.Text + '�� �����Ͻðڽ��ϱ�?',
      TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          try
            if CusType = '2' then
            begin
              Dm.Update_UD(Lat, Long, FormatFloat('0.##', Dis_Box.Value),
                Price_Box.Text);
                Price_Box.Value := 2800;
                Dis_Box.Value := 0;
              // Dm.Insert_UD(Clat, Clong, Lat, Long, FormatFloat('0.##',
              // Dis_Box.Value), Price_Box.Text, CusPhone);
            end;
            demo.Del_Order(CusPhone);
            Timer3.Enabled := False;
            Timer4.Enabled := False;

          except
            raise Exception.Create('���� ����, �ٽ� �õ��� �ּ���');
          end;
          ShowMessage('������ �Ϸ�Ǿ����ϴ�.');
          Btn_Customer.Text := '�մ�ž��';
          Btn_Search_Customer.Text := '�˻���';
          IsSelect := False;
          Timer2.Enabled := True;
          demo.Change_State(Phone, '1');
          Btn_State.Text := '�˻��Ұ�';
        end;
      end);
  end;
end;

procedure TTaxiMF.FormCreate(Sender: TObject);
var
  aStream: TMemoryStream; // �������� �ʱ�ȭ����
  TelephonyServiceNative: JObject;
  TelephonyManager: JTelephonyManager;
begin
  //Phone := '01087664920'; // ������ȣ �̸� �Ҵ� ( �׽�Ʈ �ϱ� ���� )
  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.ActiveTab := TabItem1;
  MapLevel := 5;
  IsSelect := False;
  TextTime := 0;

  // �������� �ʱ�ȭ ����
  WebBrowser1.Navigate('about:blank');
  aStream := TMemoryStream.Create;
  try
    aStream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr)); // �ڹٽ�ũ��Ʈ �о����
    aStream.Seek(0, soFromBeginning);
    WebBrowser1.LoadFromStrings(HTMLStr, HTMLStr);
  finally
    aStream.Free;
  end;
  // �������� �ʱ�ȭ ��

  TelephonyServiceNative := SharedActivityContext.getSystemService
    (TJContext.JavaClass.TELEPHONY_SERVICE);
  TelephonyManager := TJTelephonyManager.Wrap
    ((TelephonyServiceNative as ILocalObject).GetObjectID);

  Edit1.Text := JStringToString(TelephonyManager.getLine1Number);
end;

procedure TTaxiMF.LocationSensor1LocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
begin
  BLat := Lat;
  BLong := Long;
  Lat := FormatFloat('#.#####', NewLocation.Latitude);
  Long := FormatFloat('#.#####', NewLocation.Longitude);
  if BLat = '' then
  begin
    BLat := Lat;
    BLong := Long;
  end;

end;

procedure TTaxiMF.Timer1Timer(Sender: TObject);
begin
  WebBrowser1.EvaluateJavaScript('hideMarkers();');
  WebBrowser1.EvaluateJavaScript('MapLevels(' + IntToStr(MapLevel) + ');');
  WebBrowser1.EvaluateJavaScript('panTo(' + Lat + ',' + Long + ');');
  WebBrowser1.EvaluateJavaScript('AddTaxiMarkers(' + Lat + ',' + Long +
    ',''������ġ'');');
  demo.Update_Taxi_Locate(Phone, Lat, Long);

  if not IsSelect then // �մ� ���ý� Timer�� �̿��� �ֺ��մ� �˻� ���� �ʰ� ��
    Customer := Dm.Calc_Distance;



end;

procedure TTaxiMF.Timer2Timer(Sender: TObject);
begin
  if TextTime = 0 then
    Text2.Text := '�մ� �˻���'
  else if TextTime = 1 then
    Text2.Text := '�մ� �˻���.'
  else if TextTime = 2 then
    Text2.Text := '�մ� �˻���..'
  else if TextTime = 3 then
    Text2.Text := '�մ� �˻���...';

  Inc(TextTime);
  TextTime := TextTime mod 4;
end;

procedure TTaxiMF.Timer3Timer(Sender: TObject);
var
  theta, dist: Double;
  dis_price: Double;
  price_count: Integer;
begin
  theta := StrToFloat(BLong) - StrToFloat(Long);
  dist := sin(degTorad(StrToFloat(BLat))) *
  // degTorad ��� - System.Math ���̺귯��
    sin(degTorad(StrToFloat(Lat))) + cos(degTorad(StrToFloat(BLat))) *
    cos(degTorad(StrToFloat(Lat))) * cos(degTorad(theta));
  dist := arccos(dist);
  dist := radTodeg(dist);
  dist := dist * 60 * 1.1515;
  dist := dist * 1.609344;
  Dis_Box.Value := Dis_Box.Value + dist;

  if Dis_Box.Value >= 2 then
  begin // �⺻ 2km = 2800��
    // Dis_Box.Value >= 2, (Dis_Box.Value - 2) �κ��� ���� 2�� ������ �⺻��� ���� ����
    // 0.1�� �س����� �⺻������� �̵��� �� �ִ� �Ÿ��� 0.1 km
    dis_price := (Dis_Box.Value - 2) / 0.15; // 150���ʹ� 100���߰�
    // dis_price := (Dis_Box.Value - 2) / 0.15; <- 0.15���ڸ� �����ϸ� 100���� �Ÿ����� ����( 0.1�� �س����� 100���ʹ� 100���߰� )
    price_count := Trunc(dis_price);
    Price_Box.Value := 2800 + (price_count * 100);
  end;
end;

procedure TTaxiMF.Timer4Timer(Sender: TObject);
begin
  Dm.Insert_UD_Detail(Lat, Long);
end;

end.
