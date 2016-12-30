unit Umain_Vcl;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SHDocVw, MSHTML, Vcl.OleCtrls,
  Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.EngExt, Vcl.Bind.DBEngExt, Data.Bind.Components,
  Data.Bind.DBScope;

type
  TPcForm = class(TForm)
    WebBrowser1: TWebBrowser;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Btn_Payment: TButton;
    Btn_AddMenu: TButton;
    ListBox1: TListBox;
    Timer1: TTimer;
    Memo1: TMemo;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    ComboBox1: TComboBox;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkFillControlToField1: TLinkFillControlToField;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Btn_PaymentClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
    HTMLWindow2: IHTMLWindow2;
  end;

var
  PcForm: TPcForm;

implementation

uses
  ActiveX, UDm;

{$R *.dfm}

const
  HTMLStr: ANSIString = '<!DOCTYPE html>' + '<html>' + '<head>' +
    '<meta charset="utf-8">' + '<title>���� ���� API</title>' + '</head>' + '<body>'
    + '<div id="map" style="width:890px;height:350px;"></div>'

    + '<script src="http://apis.daum.net/maps/maps3.js?apikey=68f86bb3c0448b7089e8fcd79e94caf0"></script>'
    + '<script>'

    + 'var map;' + 'var markers = [];'

    + 'var markerImageArray = [''http://postfiles14.naver.net/20150130_237/hunter450_1422563689145EE0NF_PNG/EDIYA.png?type=w3''];'

    + 'function SetMap(lat, long, count){' +
    'var mapContainer = document.getElementById(''map''),' // ������ ǥ���� div
    + 'mapOption = {' + 'center: new daum.maps.LatLng(lat, long),' // ������ �߽���ǥ
    + 'level: 4,' // ������ Ȯ�� ����
    + 'mapTypeId : daum.maps.MapTypeId.ROADMAP' // ��������
    + '};' + 'map = new daum.maps.Map(mapContainer, mapOption);'

    + 'var markerImageUrl = markerImageArray[count],' +
    'markerImageSize = new daum.maps.Size(38, 33),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(19, 33)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});' + '}'

    + 'function AddCafeMarkers(lat,long, count){' // ī�� ��Ŀ �߰�
    + 'var markerImageUrl = markerImageArray[count],' +
    'markerImageSize = new daum.maps.Size(38, 33),' + 'markerImageOptions = {' +
    'offset : new daum.maps.Point(19, 33)' + '};' +
    'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'var marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat,long),' // ��Ŀ�� ��ǥ
    + 'image : markerImage,' // ��Ŀ�� �̹���
    + 'map: map' // ��Ŀ�� ǥ���� ���� ��ü
    + '});' + '}'

    + 'function AddCustMarkers(lat, long, name){' // �մ� ��ġ ��Ŀ �߰�
    + 'var markerImageUrl = ''http://postfiles16.naver.net/20150130_239/hunter450_1422569121242T7voO_PNG/User.png?type=w3'','
    + 'markerImageSize = new daum.maps.Size(25, 33),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(13, 33)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});'

    + 'daum.maps.event.addListener(marker, ''click'', (function(marker) {'
  // �մ� ��Ŀ Ŭ�� �� �̺�Ʈ ���
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

    + '</script>' + '</body>' + '</html>';

procedure TPcForm.Btn_PaymentClick(Sender: TObject); // ���� �Ϸ� ��ư
begin
  if MessageDlg(ListBox1.Items[ListBox1.ItemIndex] + ' ���� �Ϸ� �Ͻðڽ��ϱ�?',
    mtConfirmation, [mbOK, mbCancel], 0) = mrok then
  begin
    try
      demo.Delete_Reserve(Dm.GetReserveDataSet.FieldByName('R_NUM').AsString);
      // ���� �Ϸ� �� �����
    except
      raise Exception.Create('���� ����, ��� �� �ٽ� �õ��� �ּ���.');
    end;
    Dec(Dm.BeforeRNum);
    ListBox1.Items[ListBox1.ItemIndex].Empty;
    Memo1.Lines.Clear;
    ShowMessage('������ �Ϸ� �Ǿ����ϴ�.');
  end;
end;

procedure TPcForm.ComboBox1Change(Sender: TObject); // �ش� ���� �մ� Ȯ��
var
  lat, long: string;
  a: integer;
begin
  Dm.CurrentRNum := 0;
  Dm.BeforeRNum := 0;
  a := ComboBox1.ItemIndex;
  Dm.CafeInfoDataSet.First;
  Dm.CafeInfoDataSet.MoveBy(ComboBox1.ItemIndex);
  lat := Dm.CafeInfoDataSet.FieldByName('C_LAT').AsString;
  // ������ ���������� ���� �浵 �޾ƿ���
  long := Dm.CafeInfoDataSet.FieldByName('C_LONG').AsString;

  HTMLWindow2.execScript('panTo(' + lat + ',' + long + ')', 'JavaScript');
  // �ش� �������� ����API ȭ�� �̵�

  Timer1Timer(Timer1);

end;

procedure TPcForm.FormCreate(Sender: TObject);
var
  aStream: TMemoryStream;
begin
  WebBrowser1.Navigate('about:blank');
  if Assigned(WebBrowser1.Document) then // ���� ���� API����� ���� �ʱ� �۾�
  begin
    aStream := TMemoryStream.Create;
    try
      aStream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr));
      aStream.Seek(0, soFromBeginning);
      (WebBrowser1.Document as IPersistStreamInit)
        .Load(TStreamAdapter.Create(aStream));
    finally
      aStream.Free;
    end;
    HTMLWindow2 := (WebBrowser1.Document as IHTMLDocument2).parentWindow;

  end;

end;

procedure TPcForm.ListBox1Click(Sender: TObject); // �մ� ���� ������ Ŭ��
var
  lat, long: string;
begin
  Dm.GetReserveDataSet.First;
  Dm.GetReserveDataSet.MoveBy(ListBox1.ItemIndex);
  lat := Dm.GetReserveDataSet.FieldByName('U_LAT').AsString;
  long := Dm.GetReserveDataSet.FieldByName('U_LONG').AsString;
  HTMLWindow2.execScript('panTo(' + lat + ',' + long + ')', 'JavaScript');
  // �ش� �մ��� ��ġ�� ���� ȭ�� �̵�
end;

procedure TPcForm.ListBox1DblClick(Sender: TObject); // �մ� ���� ������ ���� Ŭ��
begin
  Dm.GetReserveDataSet.First;
  Dm.GetReserveDataSet.MoveBy(ListBox1.ItemIndex); // �մ� �� ���� ���� ���
  Dm.Get_Reserve_Detail;
end;

procedure TPcForm.Timer1Timer(Sender: TObject); // ������ �ð����� ����� �մ� ���� ����
begin
  Dm.Get_Reserve;
  StaticText2.Caption := IntToStr(Dm.GetReserveDataSet.RecordCount);
end;

procedure TPcForm.Timer2Timer(Sender: TObject); // ���� API ���
var
  lat, long: string;
begin
  Timer2.Enabled := false; // �ѹ��� �۵�
  lat := Dm.CafeInfoDataSet.FieldByName('C_LAT').AsString;
  long := Dm.CafeInfoDataSet.FieldByName('C_LONG').AsString;
  HTMLWindow2.execScript('SetMap(' + lat + ',' + long + ',0)', 'JavaScript'); // ���� API����

  while not Dm.CafeInfoDataSet.Eof do // ������ ���� API�� ���� ��ġ ������ �Ѹ���
  begin
    Dm.CafeInfoDataSet.Next;
    lat := Dm.CafeInfoDataSet.FieldByName('C_LAT').AsString;
    long := Dm.CafeInfoDataSet.FieldByName('C_LONG').AsString;
    HTMLWindow2.execScript('AddCafeMarkers(' + lat + ',' + long + ', 0)',
      'JavaScript');
  end;

  Dm.CafeInfoDataSet.First;
end;

end.
