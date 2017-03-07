unit Umain_Mobile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.TabControl, FMX.WebBrowser,
  System.Sensors, System.Sensors.Components, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.Objects, FMX.Layouts, FMX.Edit, FMX.ListBox, UClientClass;

type
  TUserMF = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Btn_Start: TButton;
    Btn_Search_CallTaxi: TButton;
    Btn_UsageDetail: TButton;
    TabItem4: TTabItem;
    Btn_CallTaxi: TButton;
    LocationSensor1: TLocationSensor;
    Btn_ReCall: TButton;
    Layout2: TLayout;
    Text1: TText;
    Layout1: TLayout;
    Edit_Phone: TEdit;
    List_UD: TListBox;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    Btn_GoBack2: TButton;
    Timer1: TTimer;
    Btn_GoBack1: TButton;
    Text3: TText;
    StyleBook1: TStyleBook;
    Timer2: TTimer;
    WebBrowser1: TWebBrowser;
    Image1: TImage;
    Timer3: TTimer;
    Text4: TText;
    ToolBar1: TToolBar;
    Timer4: TTimer;
    Text2: TText;
    Text5: TText;
    Btn_Route: TButton;
    Timer5: TTimer;
    Call_Cancel: TButton;
    Timer6: TTimer;
    procedure Btn_StartClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Btn_Search_CallTaxiClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure Btn_CallTaxiClick(Sender: TObject);
    procedure Btn_ReCallClick(Sender: TObject);
    procedure Btn_MapClick(Sender: TObject);
    procedure Btn_DelClick(Sender: TObject);
    procedure Btn_GoBack2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Btn_GoBack1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure Btn_UsageDetailClick(Sender: TObject);
    procedure Timer4Timer(Sender: TObject);
    procedure Btn_RouteClick(Sender: TObject);
    procedure Timer5Timer(Sender: TObject);
    procedure Call_CancelClick(Sender: TObject);
    procedure Timer6Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Lat: string;
    Long: string;
    Phone: string;
    ReOrderIndex: Integer;
    NearbyTaxi: Integer;
    TextTime: Integer;
    MapLevel: Integer;
    count : Integer;
  end;

var
  UserMF: TUserMF;

implementation

{$R *.fmx}

{$IFDEF ANDROID} //�ȵ���̵��ϰ�� �ش� ���� ����
uses
  UDm, Androidapi.JNI.Location, Androidapi.JNIBridge,  // �ȵ���̵� API ( GPS ���� �̿��� ��ġ�� �޾ƿ��� ��ȭ��ȣ �������� ���� ���)
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Telephony, FMX.Helpers.Android, System.Math; // System.Math�� �����̿��� �����ϴ� ���а��� ���̺귯��
{$ENDIF}

{$IFDEF MSWINDOWS} //�������ϰ�� �ش� ���� ����
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

procedure TUserMF.Btn_DelClick(Sender: TObject);
var
  Index: Integer;
begin
  Timer5.Enabled := False;
  MessageDlg('�ش� �̿볻���� �����Ͻðڽ��ϱ�?', TMsgDlgType.mtInformation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then // MessageDlg���� Yes ���ý� ����
      begin
        Index := (Sender as TButton).Tag; // Sender�� Ȱ���� �ҽ� ���̱�
        try
          Dm.Del_UD(Index); // �̿볻�� ����
        except
          raise Exception.Create('���� ����, ��� �� �ٽ� �õ����ּ���');
        end;
        ShowMessage('���� �Ϸ�');
        Dm.Get_UD(Phone); // �̿볻�� ����
      end;
    end);
end;

procedure TUserMF.Btn_MapClick(Sender: TObject);
var
  SLat, SLong: string;
  ALat, ALong: string;
  MLat, MLong: Double;
  theta, dist: Double;
begin
  Timer5.Enabled := False;
  WebBrowser1.EvaluateJavaScript('hideSAMarkers();'); // html�� �Լ� �����ϴ� ���( FMX������ �̷��� ��� )
  ReOrderIndex := (Sender as TButton).Tag;
  Dm.UserQueryDataSet.First; // ���������̺��� Ÿ���� ù��°���̵�
  Dm.UserQueryDataSet.MoveBy(ReOrderIndex); // Index����ŭ ���������̺� �̵�
  SLat := Dm.UserQueryDataSet.FieldByName('UD_SLAT').AsString;
  SLong := Dm.UserQueryDataSet.FieldByName('UD_SLONG').AsString;
  WebBrowser1.EvaluateJavaScript('AddSAMarkers(' + SLat + ',' + SLong +
    ',''�����'',0);');

  ALat := Dm.UserQueryDataSet.FieldByName('UD_ALAT').AsString;
  ALong := Dm.UserQueryDataSet.FieldByName('UD_ALONG').AsString;
  WebBrowser1.EvaluateJavaScript('AddSAMarkers(' + ALat + ',' + ALong +
    ',''������'',1);');

  Dm.Get_UD_Detail(Dm.UserQueryDataSet.FieldByName('UD_NUM').AsString);

  MLat := (StrToFloat(SLat) + StrToFloat(ALat)) / 2;
  MLong := (StrToFloat(SLong) + StrToFloat(ALong)) / 2;

  // 2���� ��ǥ���� Ȱ���� �Ÿ� ���
  theta := StrToFloat(ALong) - StrToFloat(SLong);
  dist := sin(degTorad(StrToFloat(ALat))) *
  // degTorad ��� - System.Math ���̺귯��
    sin(degTorad(StrToFloat(SLat))) + cos(degTorad(StrToFloat(ALat))) *
    cos(degTorad(StrToFloat(SLat))) * cos(degTorad(theta));
  dist := arccos(dist);
  dist := radTodeg(dist);
  dist := dist * 60 * 1.1515;
  dist := dist * 1.609344;
  // 2���� ��ǥ���� Ȱ���� �Ÿ� ��� ��

  if dist <= 0.3 then // �Ÿ��� 0.3km�̸� ��ũ�⸦ 4�� ����
    MapLevel := 4
  else if dist <= 0.7 then // �Ÿ��� 0.7km�̸� ��ũ�⸦ 5�� ����
    MapLevel := 5
  else if dist <= 1.8 then // �Ȱ��� �ݺ�
    MapLevel := 6
  else if dist <= 3.5 then
    MapLevel := 7
  else if dist <= 7 then
    MapLevel := 8
  else if dist <= 14 then
    MapLevel := 9
  else if dist <= 28 then
    MapLevel := 10
  else if dist <= 56 then
    MapLevel := 11
  else if dist <= 112 then
    MapLevel := 12
  else if dist <= 224 then
    MapLevel := 13
  else if dist <= 448 then // �Ÿ��� 448km�̸� ��ũ�� 14�� ����
    MapLevel := 14;

  WebBrowser1.EvaluateJavaScript('MapLevels(' + IntToStr(MapLevel) + ');');
  WebBrowser1.EvaluateJavaScript('panTo(' + FloatToStr(MLat) + ',' +
    FloatToStr(MLong) + ');');
end;

procedure TUserMF.Btn_StartClick(Sender: TObject);
var
  checklog: Boolean;
begin

  if Edit_Phone.Text = '' then // raise�� �̿��� �Լ� ������ (����ó��)
    raise Exception.Create('������ �̿��� �� �����ϴ�');

  checklog := demo.Sign_In(Edit_Phone.Text); // �α��� SQL
  if checklog then
  begin
    TabControl1.ActiveTab := TabItem2;
    Phone := Edit_Phone.Text;
    Timer2.Enabled := True;
    Timer4.Enabled := True;
  end
  else
    MessageDlg('��ȭ��ȣ�� ȸ���԰� �ýñ�縦 �����ϱ� ���� ����մϴ�. ��ȭ��ȣ�� ����Ͻðڽ��ϱ�?',
      TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          demo.Sign_Up(Edit_Phone.Text);
          TabControl1.ActiveTab := TabItem2;
          Phone := Edit_Phone.Text;
          Timer2.Enabled := True;
        end;
      end);
end;

procedure TUserMF.Btn_Search_CallTaxiClick(Sender: TObject);
{$IFDEF ANDROID}
var
  obj: JObject;
  locationManager: JLocationManager;
{$ENDIF}
begin
{$IFDEF ANDROID}
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

      WebBrowser1.Parent := TabItem3;
      WebBrowser1.EvaluateJavaScript('hideSAMarkers();');
      WebBrowser1.EvaluateJavaScript('MapLevels(5);');
      WebBrowser1.EvaluateJavaScript('panTo(' + Lat + ',' + Long + ');');
      WebBrowser1.EvaluateJavaScript('AddSAMarkers(' + Lat + ',' + Long +
        ',''������ġ'',0);');
      Timer1.Enabled := True;
      NearbyTaxi := Dm.Calc_Distance;
    except
      raise Exception.Create('��ġ������ ��Ȯ���� �ʽ��ϴ�. ��� �� �ٽ� ������ �ּ���');
    end;
    Timer3.Enabled := True;
    TabControl1.ActiveTab := TabItem3;
  end
  else
    ShowMessage('GPS�� ���ּ���');
{$ENDIF}
end;
procedure TUserMF.Btn_UsageDetailClick(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem4;
  WebBrowser1.Parent := TabItem4;
  Dm.Get_UD(Phone);
  WebBrowser1.EvaluateJavaScript('hideSAMarkers();');
  WebBrowser1.EvaluateJavaScript('hideMarkers();');
end;

procedure TUserMF.Call_CancelClick(Sender: TObject);
begin
     if not demo.Check_Order(phone) then
     begin
        showmessage('���ýø� ȣ�� ���� �����̽��ϴ�.');
     end
     else
     begin
        MessageDlg('���ýø� ����Ͻðڽ��ϱ�?',TMSgDlgType.mtInformation,[TMSgDlgBtn.mbYes, TMsgDlgBtn.mbNo],0,
        procedure(const CanResult: TModalResult)
        begin
          if CanResult = mrYes then
          begin
            demo.Del_Order(phone);
          end;
        end);
     end;
end;

procedure TUserMF.Btn_CallTaxiClick(Sender: TObject); //���ýø� �ٽ� �θ���� �θ��� UD���̺� �ٽ� �������� ����
begin
  if NearbyTaxi = 0 then
  begin
    Showmessage('��ó�� ���ýð� �Ѵ뵵 �������� �ʽ��ϴ�.');
  end
  else
  begin
     MessageDlg('��ó�� ' + IntToStr(NearbyTaxi) + '���� ���ý� ����, ���ýø� �θ��ðڽ��ϱ�?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        if not demo.Check_Order(Phone) then
        begin
          demo.Insert_Order(Phone, Lat, Long, '0');
          ShowMessage('���ýø� �ҷ����ϴ�');
          Timer3.Enabled:=false;
          Timer4.Enabled:= True;
          Call_cancel.Enabled := true;
        end
        else
        begin
          MessageDlg('���ýø� �̹� ��û�߾����ϴ�. ��ġ�� �纯���Ͻðڽ��ϱ�?',
            TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
            procedure(const Result: TModalResult)
            begin
              if Result = mrYes then
              begin
                demo.Update_Order(Phone, Lat, Long);
                ShowMessage('��ġ�� ����Ǿ����ϴ�');
                Timer4.Enabled:= True;
              end;
            end);
        end;
      end;
    end);
  end;
end;

procedure TUserMF.Btn_ReCallClick(Sender: TObject);
var
  O_Lat: string;
  O_Long: string;
begin
  if ReOrderIndex = -1 then
  begin
    ShowMessage('�ٽ� �̿��� �׸��� ���� ��ư�� �����ּ���');
  end
  else
  begin
    if dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString <> '' then
    raise Exception.Create('���� �ýð� ���������� �ʽ��ϴ�.');
    MessageDlg(IntToStr(ReOrderIndex + 1) + '���� ���̿��Ͻðڽ��ϱ�?',
      TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      begin
        if AResult = mrYes then
        begin
          if not demo.Check_Order(Phone) then
          begin
            Dm.UserQueryDataSet.First;
            Dm.UserQueryDataSet.MoveBy(ReOrderIndex);
            O_Lat := Dm.UserQueryDataSet.FieldByName('UD_SLAT').AsString;
            O_Long := Dm.UserQueryDataSet.FieldByName('UD_SLONG').AsString;
            demo.Insert_Order(Phone, O_Lat, O_Long, '1');
            ShowMessage('���ýø� �ҷ����ϴ�');
            Timer4.Enabled:= True;
          end
          else
            ShowMessage('�̹� ���ýø� �ҷ����ϴ�');
        end;
      end);
  end;
end;

procedure TUserMF.Btn_RouteClick(Sender: TObject);
var
  SLat, SLong: string;
  ALat, ALong: string;
begin

  if ReOrderIndex = -1 then
  begin
    ShowMessage('��θ� ǥ���� ���� ��ư�� Ŭ�����ּ���');
  end
  else
  begin
    WebBrowser1.EvaluateJavaScript('hideSAMarkers();');
    WebBrowser1.EvaluateJavaScript('hideMarkers();');
    MapLevel := MapLevel - 1;
    WebBrowser1.EvaluateJavaScript('MapLevels(' + IntToStr(MapLevel) + ');');
    Dm.UserQueryDataSet.First; // ���������̺��� Ÿ���� ù��°���̵�
    Dm.UserQueryDataSet.MoveBy(ReOrderIndex); // Index����ŭ ���������̺� �̵�
    Dm.UDDetailDataSet.First;
    count := 0;
    Timer5.Enabled := True;
  end;
end;

procedure TUserMF.Btn_GoBack2Click(Sender: TObject);
begin
  TabControl1.ActiveTab := TabItem2;
  ReOrderIndex := -1;
  Timer5.Enabled := False;
end;

procedure TUserMF.Btn_GoBack1Click(Sender: TObject);
begin
  Timer1.Enabled := False;   //�ý� �˻� ����
  TabControl1.ActiveTab := TabItem2;
  Timer3.Enabled := False;   //���� ���� ����
end;

procedure TUserMF.FormActivate(Sender: TObject);
begin
  Btn_Start.OnClick(self);
end;

procedure TUserMF.FormCreate(Sender: TObject);
var
{$IFDEF ANDROID}
  TelephonyServiceNative: JObject; // ����� ��ȭ��ȣ �������� ����
  TelephonyManager: JTelephonyManager; // ����� ��ȭ��ȣ �������� ����
{$ENDIF}
  aStream: TMemoryStream; // �������� �ʱ�ȭ����
begin
  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.ActiveTab := TabItem1;
  Layout1.Height := UserMF.ClientHeight / 3;
  List_UD.Height := UserMF.ClientHeight / 3;
  Lat := '';
  Long := '';
  ReOrderIndex := -1;

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

  // ����� ��ȭ��ȣ ��������
{$IFDEF ANDROID}
  TelephonyServiceNative := SharedActivityContext.getSystemService
    (TJContext.JavaClass.TELEPHONY_SERVICE);
  TelephonyManager := TJTelephonyManager.Wrap
    ((TelephonyServiceNative as ILocalObject).GetObjectID);

  Edit_Phone.Text := JStringToString(TelephonyManager.getLine1Number);
{$ENDIF}
  // ����� ��ȭ��ȣ �������� ��

end;

procedure TUserMF.LocationSensor1LocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
begin
  Lat := FormatFloat('#.#####', NewLocation.Latitude);
  Long := FormatFloat('#.#####', NewLocation.Longitude);
end;

procedure TUserMF.Timer1Timer(Sender: TObject);
begin
  Dm.Calc_Distance;
  WebBrowser1.EvaluateJavaScript('panTo(' + Lat + ',' + Long + ');');
end;

procedure TUserMF.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;
  WebBrowser1.EvaluateJavaScript('SetMap(37.56682,126.97865);');
end;

procedure TUserMF.Timer3Timer(Sender: TObject);
begin
  if TextTime = 0 then // �˻����� ���� ǥ�ó�������
    Text4.Text := '�ý� �˻���'
  else if TextTime = 1 then
    Text4.Text := '�ý� �˻���.'
  else if TextTime = 2 then
    Text4.Text := '�ý� �˻���..'
  else if TextTime = 3 then
    Text4.Text := '�ý� �˻���...';

  Inc(TextTime);  //���� �����ϰ� ����
  TextTime := TextTime mod 4; // mod = ���� ������ ��
end;

procedure TUserMF.Timer4Timer(Sender: TObject);
begin
  if demo.Check_Order(Phone) then
  begin
    Dm.CheckOrdersDataSet.Close;
    Dm.CheckOrdersDataSet.Open;
    Dm.CheckOrdersDataSet.First;

    if Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString = '' then
    begin
     Text2.Text := '���� �ݹ��� �ýð� �����ϴ�';
     Text5.Text := '���� �ݹ��� �ýð� �����ϴ�';
    end
    else
    begin
     Text2.Text := '�ýù�ȣ '+ Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString+ '�� ȸ������ �¿췯 �������Դϴ�';
     Text5.Text := '�ýù�ȣ '+ Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString+ '�� ȸ������ �¿췯 �������Դϴ�';
     Text4.Text := '�ýù�ȣ '+ Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString+ '�� ȸ������ �¿췯 �������Դϴ�';
     ShowMessage('�ýù�ȣ '+ Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString+ '�� ȸ������ �¿췯 �������Դϴ�');
     Timer4.Enabled := False;
     Call_cancel.Enabled := false;
    end;
  end;
end;

procedure TUserMF.Timer5Timer(Sender: TObject);
var
  Time: TDateTime;
//  i : Integer;
begin
 //demo.Get_UD_Detail(Num);
 if count = 0 then
 begin
//SLat := Dm.UserQueryDataSet.FieldByName('UD_SLAT').AsString;
//  SLong := Dm.UserQueryDataSet.FieldByName('UD_SLONG').AsString;

    WebBrowser1.EvaluateJavaScript('AddSAMarkers(' + Dm.UserQueryDataSet.FieldByName('UD_SLAT').AsString + ',' +
    Dm.UserQueryDataSet.FieldByName('UD_SLONG').AsString +
    ',''�����'',0);');
    WebBrowser1.EvaluateJavaScript('panTo(' + Dm.UserQueryDataSet.FieldByName('UD_SLAT').AsString + ',' +
  Dm.UserQueryDataSet.FieldByName('UD_SLONG').AsString + ');');
 end
 else if Dm.UDDetailDataSet.Eof then
 begin
     WebBrowser1.EvaluateJavaScript('AddSAMarkers(' + Dm.UserQueryDataSet.FieldByName('UD_ALAT').AsString + ','
     + Dm.UserQueryDataSet.FieldByName('UD_ALONG').AsString +
    ',''������'',1);');
    WebBrowser1.EvaluateJavaScript('panTo(' + Dm.UserQueryDataSet.FieldByName('UD_ALAT').AsString + ',' +
  Dm.UserQueryDataSet.FieldByName('UD_ALONG').AsString + ');');
    Timer5.Enabled := False;
 end
 else
 begin
//  ALat := Dm.UserQueryDataSet.FieldByName('UD_ALAT').AsString;
//  ALong := Dm.UserQueryDataSet.FieldByName('UD_ALONG').AsString;


// i := 1;

// while not UDDetailDataSet.EOF do
// begin

  Time := Dm.UDDetailDataSet.FieldByName('UD_TIME').AsDateTime;
  WebBrowser1.EvaluateJavaScript('AddTaxiMarkers(' +
        Dm.UDDetailDataSet.FieldByName('UD_LAT').AsString + ',' +
        Dm.UDDetailDataSet.FieldByName('UD_LONG').AsString + ',''' + IntToStr(count) +
        '�� ' + FormatDateTime('ampm hh:nn', Time) + ''');');
  WebBrowser1.EvaluateJavaScript('panTo(' + Dm.UDDetailDataSet.FieldByName('UD_LAT').AsString + ',' +
  Dm.UDDetailDataSet.FieldByName('UD_LONG').AsString + ');');
  Dm.UDDetailDataSet.Next;
 end;
 Inc(count);
end;

procedure TUserMF.Timer6Timer(Sender: TObject);
begin
   if demo.Check_Order(Phone) then
  begin
    Dm.CheckOrdersDataSet.Close;
    Dm.CheckOrdersDataSet.Open;
    Dm.CheckOrdersDataSet.First;

    if Dm.CheckOrdersDataSet.FieldByName('T_NUM').AsString = '' then
    begin
     Text2.Text := '���� �ݹ��� �ýð� �����ϴ�';
    end
  end;

end;

end.
