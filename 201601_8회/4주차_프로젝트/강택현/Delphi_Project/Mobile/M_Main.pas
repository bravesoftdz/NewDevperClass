unit M_Main;

interface

uses
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, System.Sensors,
  System.Sensors.Components, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TabControl, FMX.Dialogs, FMX.Edit,
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  FMX.Bind.DBEngExt, System.Rtti,
  Data.Bind.DBScope, FMX.Layouts, FMX.WebBrowser, FMX.ScrollBox, FMX.Memo,
  FMX.ListBox, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.EngExt, Data.Bind.Components, DBXJSON,
  System.Variants, FMX.Objects;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    btnFind_Loc: TButton;
    LocationSensor1: TLocationSensor;
    ToolBar2: TToolBar;
    Label4: TLabel;
    swActiveSensor: TSwitch;
    Label6: TLabel;
    edt_Name: TEdit;
    edt_Lat: TEdit;
    edt_Lng: TEdit;
    WebBrowser1: TWebBrowser;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Button1: TButton;
    M_Join_Member: TListBox;
    M_Chat_List: TMemo;
    M_edt_Chat: TEdit;
    Button2: TButton;
    Label3: TLabel;
    edt_M_Room_Create: TEdit;
    Button3: TButton;
    ListView1: TListView;
    M_edt_JoinRoom: TEdit;
    Button4: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    LinkControlToField1: TLinkControlToField;
    M_Loc_Mark: TTimer;
    M_Meet_Click: TTimer;
    W_Loc_Mark: TTimer;
    Button5: TButton;
    Label5: TLabel;
    Button6: TButton;
    Button7: TButton;
    Label7: TLabel;
    StyleBook1: TStyleBook;
    Image1: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure btnFind_LocClick(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const [Ref] OldLocation, NewLocation: TLocationCoord2D);
    procedure swActiveLocationSensor1(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure M_Loc_MarkTimer(Sender: TObject);
    procedure M_Meet_ClickTimer(Sender: TObject);
    procedure W_Loc_MarkTimer(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TabItem3Click(Sender: TObject);
    procedure TabItem1Click(Sender: TObject);
    procedure TabItem2Click(Sender: TObject);
    procedure TabItem4Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageViewer1Click(Sender: TObject);
    // procedure FormFocusChanged(Sender: TObject);
    // procedure FormVirtualKeyboardShown(Sender: TObject;
    // KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
    // procedure FormVirtualKeyboardHidden(Sender: TObject;
    // KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
  private
    { Private declarations }
    FGeocoder: TGeocoder;
    procedure OnGeocodeReverseEvent(const Address: TCivicAddress);
    // FKBBounds: TRectF;
    // FNeedOffset: Boolean;
    // procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    // procedure RestorePosition;
    // procedure UpdateKBBounds;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  room: string;
  join_room: Boolean = false;
  exit_room: Boolean = true;
  trans_lat, trans_lng: string;

implementation

{$R *.fmx}

uses System.Math, M_DataModule;

const
  htmlstr: Unicodestring = '<!DOCTYPE html>' + '<html>' + '<head>' +
    '<meta charset="utf8">' + '<title>���� �����ϱ�</title>' + '<style>' +
    '  .map_wrap, .map_wrap * {margin:0; padding:0;font-family:''Malgun Gothic'',dotum,''����'',sans-serif;font-size:12px;} '
    + '.map_wrap {position:relative;width:100%;height:300px;}   ' +
    '.places, .places * {margin:0; padding:0;font-family:''Malgun Gothic'',dotum,''����'',sans-serif;font-size:12px;} '
    + '.places {position:relative;width:100%;height:64px;}  ' +
    '#category {top:10px;left:10px;border-radius: 5px; border:1px solid #909090;box-shadow: 0 1px 1px rgba(0, 0, 0, 0.4);background: #fff;overflow: hidden;z-index: 2;}'
    + '#category li {float:left;list-style: none;width:50px;px;border-right:1px solid #acacac;padding:6px 0;text-align: center; cursor: pointer;} '
    + '#category li.on {background: #eee;}' +
    '#category li:hover {background: #ffe6e6;border-left:1px solid #acacac;margin-left: -1px;} '
    + '#category li:last-child{margin-right:0;border-right:0;}' +
    '#category li span {display: block;margin:0 auto 3px;width:27px;height: 28px;} '
    + '#category li .category_bg {background:url(http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png) no-repeat;} '
    + '#category li .pharmacy {background-position: -10px -72px;}  ' +
    '#category li.on .category_bg {background-position-x:-46px;}' +
    '.placeinfo_wrap {position:absolute;bottom:28px;left:-150px;width:300px;}' +
    '.placeinfo {position:relative;width:100%;border-radius:6px;border: 1px solid #ccc;border-bottom:2px solid #ddd;padding-bottom: 10px;background: #fff;} '
    + '.placeinfo:nth-of-type(n) {border:0; box-shadow:0px 1px 2px #888;} ' +
    '.placeinfo_wrap .after {content:'''';position:relative;margin-left:-12px;left:50%;width:22px;height:12px;background:url(''http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png'')} '
    + '.placeinfo a, .placeinfo a:hover, .placeinfo a:active{color:#fff;text-decoration: none;} '
    + '.placeinfo a, .placeinfo span {display: block;text-overflow: ellipsis;overflow: hidden;white-space: nowrap;}'
    + '.placeinfo span {margin:5px 5px 0 5px;cursor: default;font-size:13px;} '
    + '.placeinfo .title {font-weight: bold; font-size:14px;border-radius: 6px 6px 0 0;margin: -1px -1px 0 -1px;padding:10px;'
    + ' color: #fff;background: #d95050;background: #d95050 url(http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/arrow_white.png) no-repeat right 14px center;}  '
    + '.placeinfo .tel {color:#0f7833;}' +
    '.placeinfo .jibun {color:#999;font-size:11px;margin-top:0;} ' +
    '#container {overflow:hidden;height:300px;position:relative;}                                                                                                                                                        '
    + '#btnRoadview,  #btnMap {top:5px;left:5px;padding:7px 12px;font-size:12px;border: 1px solid #dbdbdb;background-color: #fff;border-radius: 5px;box-shadow: 0 1px 1px rgba(0,0,0,.04);z-index:1;cursor:pointer;}       '
    + '#btnRoadview:hover,  #btnMap:hover{background-color: #fcfcfc;border: 1px solid #c1c1c1;}                                                                                                                            '
    + '#container.view_map #map_Wrap {z-index: 10;}                                                                                                                                                                        '
    + '#container.view_map #btnMap {display: none;}                                                                                                                                                                        '
    + '#container.view_roadview #map_Wrap {z-index: 0;}                                                                                                                                                                    '
    + '#container.view_roadview #btnRoadview {display: none;}                                                                                                                                                              '
    + '   .MapWalker {position:absolute;margin:-26px 0 0 -51px}                                                                                            '
    + '   .MapWalker .figure {position:absolute;width:25px;left:38px;top:-2px;                                                                             '
    + '       height:39px;background:url(http://i1.daumcdn.net/localimg/localimages/07/2012/roadview/roadview_minimap_wk.png) -298px -114px no-repeat}     '
    +

    '</style>' + '</head>' + '<body>' +

    '<div id="container" class="view_map">                                                                                                                              '
    + '    <div id="map_Wrap" style="width:100%;height:300px;position:relative;">                                                                                         '
    + '        <div id="map" style="width:100%;height:100%"></div>                                                                    '
    + '    </div>                                                                                                                                                         '
    + '    <div id="rvWrapper" style="width:100%;height:300px;position:absolute;top:0;left:0;">                                                                           '
    + '        <div id="roadview" style="height:100%"></div>                                                                        '
    + '    </div>                                                                                                                                                         '
    + '</div>                                                                                                                                                             '
    + '<div id="footer"> <input type="button" id="btnMap" onclick="toggleMap(true)" title="���� ����" value="����">                                                       '
    + '<input type="button" id="btnRoadview" onclick="toggleMap(false)" title="�ε�� ����" value="�ε��"></div>                                                         '
    +

  // setTimeout(function(){},2000);
    '<script type="text/javascript" src="http://apis.daum.net/maps/maps3.js?apikey=129496d49adf0fecff26ee145d7ccbd1&libraries=services"></script>'
    +

    '<script type="text/javascript">' + 'var mapContainer,mapOption;' +
    'var lat=0,lng=0;' + 'var count=0;' + 'var points=[];' +
    'var bounds = new daum.maps.LatLngBounds();' + 'var flag = false;' +
    'var name;' +
  // ��Ŀ�� Ŭ������ �� �ش� ����� �������� ������ Ŀ���ҿ��������Դϴ�
    '   var placeOverlay = new daum.maps.CustomOverlay({zIndex:1}),                                         '
    +
  // Ŀ���� ���������� ������ ������Ʈ �Դϴ�
    '   contentNode = document.createElement(''div''),            ' +
  // ��Ŀ�� ���� �迭�Դϴ�
    '   markers = [],                                                              '
    +
  // ���� ���õ� ī�װ��� ������ ���� �����Դϴ�
    '   currCategory = '''';                                 ' +

    'mapContainer = document.getElementById("map"),' + // ������ ǥ���� div
    'mapOption = {' + 'center: new daum.maps.LatLng(37.56682, 126.97865),' +
  // ������ �߽���ǥ
    'level: 4' + // ������ Ȯ�� ����
    '};' +
  // ������ �����Ѵ�
    'var map = new daum.maps.Map(mapContainer, mapOption);' +

  // ��� �˻� ��ü�� �����մϴ�
    'var ps = new daum.maps.services.Places(map);             ' +

  // ������ idle �̺�Ʈ�� ����մϴ�
    'daum.maps.event.addListener(map, ''idle'', searchPlaces);   ' +

  // Ŀ���� ���������� ������ ��忡 css class�� �߰��մϴ�
    'contentNode.className = ''placeinfo_wrap'';                ' +

  // Ŀ���� ���������� ������ ��忡 mousedown, touchstart �̺�Ʈ�� �߻�������
  // ���� ��ü�� �̺�Ʈ�� ���޵��� �ʵ��� �̺�Ʈ �ڵ鷯�� daum.maps.event.preventMap �޼ҵ带 ����մϴ�
    'addEventHandle(contentNode, ''mousedown'', daum.maps.event.preventMap);   '
    + 'addEventHandle(contentNode, ''touchstart'', daum.maps.event.preventMap);  '
    +

  // Ŀ���� �������� �������� �����մϴ�
    'placeOverlay.setContent(contentNode);                         ' +
  // �� ī�װ��� Ŭ�� �̺�Ʈ�� ����մϴ�
    'addCategoryClickEvent();                                      ' +
  // ������Ʈ�� �̺�Ʈ �ڵ鷯�� ����ϴ� �Լ��Դϴ�
    'function addEventHandle(target, type, callback) {             ' +
    '    if (target.addEventListener) {                            ' +
    '        target.addEventListener(type, callback);              ' +
    '    } else {                                                  ' +
    '        target.attachEvent(''on'' + type, callback);          ' +
    '    }                                                         ' +
    '}                                                             ' +

  // ī�װ� �˻��� ��û�ϴ� �Լ��Դϴ�
    'function searchPlaces() {                                                                       '
    + '    if (!currCategory) {                                                                        '
    + '        return;                                                                                 '
    + '    }                                                                                           '
    +
  // Ŀ���� �������̸� ����ϴ�
    '    placeOverlay.setMap(null);                                                                  '
    +
  // ������ ǥ�õǰ� �ִ� ��Ŀ�� �����մϴ�
    '    removeMarker();                                                                             '
    + '    ps.categorySearch(currCategory, placesSearchCB,{location: new daum.maps.LatLng(lat,lng)});                       '
    + '}                                                                                               '
    +
  // ��Ұ˻��� �Ϸ���� �� ȣ��Ǵ� �ݹ��Լ� �Դϴ�
    'function placesSearchCB( status, data, pagination ) {                                           '
    + '    if (status === daum.maps.services.Status.OK) {                                              '
    +
  // ���������� �˻��� �Ϸ������ ������ ��Ŀ�� ǥ���մϴ�
    '        displayPlaces(data.places);                                                             '
    + '    } else if (status === daum.maps.services.Status.ZERO_RESULT) {                              '
    +
  // �˻������ ���°�� �ؾ��� ó���� �ִٸ� �̰��� �ۼ��� �ּ���
    '    } else if (status === daum.maps.services.Status.ERROR) {                                    '
    +
  // ������ ���� �˻������ ������ ���� ��� �ؾ��� ó���� �ִٸ� �̰��� �ۼ��� �ּ���
    '    }                                                                                           '
    + '}                                                                                               '
    +

  // ������ ��Ŀ�� ǥ���ϴ� �Լ��Դϴ�
    'function displayPlaces(places) {  ' +

  // ���° ī�װ��� ���õǾ� �ִ��� ���ɴϴ�
  // �� ������ ��������Ʈ �̹��������� ��ġ�� ����ϴµ� ���˴ϴ�
    '    var order = document.getElementById(currCategory).getAttribute(''data-order'');                                   '
    + '    for ( var i=0; i<places.length; i++ ) {                                                                         '
    +
  // ��Ŀ�� �����ϰ� ������ ǥ���մϴ�
    '            var marker = addMarker(new daum.maps.LatLng(places[i].latitude, places[i].longitude), order);           '
    +
  // ��Ŀ�� �˻���� �׸��� Ŭ�� ���� ��
  // ��������� ǥ���ϵ��� Ŭ�� �̺�Ʈ�� ����մϴ�
    '            (function(marker, place) {                                                                              '
    + '                daum.maps.event.addListener(marker, ''click'', function() {                                         '
    + '                    displayPlaceInfo(place);                                                                        '
    + '               });                                                                                                 '
    + '           })(marker, places[i]);                                                                                  '
    + '   }                                                                                                              '
    + '}                                                                                                                   '
    +

  // ��Ŀ�� �����ϰ� ���� ���� ��Ŀ�� ǥ���ϴ� �Լ��Դϴ�
    'function addMarker(position, order) {                                                                                     '
    + '   var imageSrc = ''http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/places_category.png'',                      '
    +
  // ��Ŀ �̹��� url, ��������Ʈ �̹����� ���ϴ�
  // ��Ŀ �̹����� ũ��
    '       imageSize = new daum.maps.Size(27, 28),                                                     '
    + '       imgOptions =  {                                                                                                  '
    +
  // ��������Ʈ �̹����� ũ��
    '           spriteSize : new daum.maps.Size(72, 208),                                         '
    +
  // ��������Ʈ �̹��� �� ����� ������ �»�� ��ǥ
    '           spriteOrigin : new daum.maps.Point(46, (order*36)),        ' +
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� �������� ��ǥ
    '           offset: new daum.maps.Point(11, 28)                            '
    + '       },                                                                                                               '
    + '       markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imgOptions),                                        '
    + '           marker = new daum.maps.Marker({                                                                              '
    +
  // ��Ŀ�� ��ġ
    '           position: position,                                                                           '
    + '           image: markerImage                                                                                           '
    + '       });                                                                                                              '
    +
  // ���� ���� ��Ŀ�� ǥ���մϴ�
    '   marker.setMap(map);                                                                    '
    +
  // �迭�� ������ ��Ŀ�� �߰��մϴ�
    '   markers.push(marker);                                                             '
    + '   return marker;                                                                                                       '
    + '}                                                                                                                        '
    +

  // ���� ���� ǥ�õǰ� �ִ� ��Ŀ�� ��� �����մϴ�
    'function removeMarker() {                               ' +
    '    for ( var i = 0; i < markers.length; i++ ) {        ' +
    '        markers[i].setMap(null);                        ' +
    '    }                                                   ' +
    '    markers = [];                                       ' +
    '}                                                       ' +

  // Ŭ���� ��Ŀ�� ���� ��� �������� Ŀ���� �������̷� ǥ���ϴ� �Լ��Դϴ�
    'function displayPlaceInfo (place) {                                                                                                                                  '
    + 'var content = ''<div class="placeinfo">'' + ' +
    ' ''   <a class="title" href="'' + place.placeUrl + ''" target="_blank" title="'' + place.title + ''">'' + place.title + ''</a>'';   '
    +

    ' if (place.newAddress) {' +
    ' content += ''    <span title="'' + place.newAddress + ''">'' + place.newAddress + ''</span>'' +   '
    + '    ''  <span class="jibun" title="'' + place.address + ''">(���� : '' + place.address + '')</span>'';  '
    + '}  else {' +
    ' content += ''    <span title="'' + place.address + ''">'' + place.address + ''</span>'';      '
    + ' }  ' +

    ' content += ''    <span class="tel">'' + place.phone + ''</span>'' + ' +
    '   ''</div>'' +    ' + ' ''<div class="after"></div>'';  ' +
    '   contentNode.innerHTML = content;                                                                                                                                 '
    + '   placeOverlay.setPosition(new daum.maps.LatLng(place.latitude, place.longitude));                                                                                 '
    + '   placeOverlay.setMap(map);                                                                                                                                        '
    + '}                                                                                                                                                                    '
    +

  // �� ī�װ��� Ŭ�� �̺�Ʈ�� ����մϴ�
    'function addCategoryClickEvent() {                              ' +
    '    var category = document.getElementById(''category''),         ' +
    '        children = category.children;                           ' +
    '    for (var i=0; i<children.length; i++) {                     ' +
    '        children[i].onclick = onClickCategory;                  ' +
    '    }                                                           ' +
    '}                                                               ' +

  // ī�װ��� Ŭ������ �� ȣ��Ǵ� �Լ��Դϴ�
    'function onClickCategory() {                                  ' +
    '    var id = this.id,                                        ' +
    '        className = this.className;                          ' +
    '    placeOverlay.setMap(null);                               ' +
    '    if (className === ''on'') {                              ' +
    '        currCategory = '''';                                 ' +
    '        changeCategoryClass();                               ' +
    '        removeMarker();                                      ' +
    '    } else {                                                 ' +
    '        currCategory = id;                                   ' +
    '        changeCategoryClass(this);                           ' +
    '        searchPlaces();                                      ' +
    '    }                                                        ' +
    '}                                                            ' +

  // Ŭ���� ī�װ����� Ŭ���� ��Ÿ���� �����ϴ� �Լ��Դϴ�
    'function changeCategoryClass(el) {                             ' +
    '    var category = document.getElementById(''category''),        ' +
    '        children = category.children,                          ' +
    '        i;                                                     ' +

    '    for ( i=0; i<children.length; i++ ) {                      ' +
    '        children[i].className = '''';                            ' +
    '    }                                                          ' +

    '    if (el) {                                                  ' +
    '        el.className = ''on'';                                   ' +
    '    }                                                          ' +
    '}                                                              ' +

  // ������ �ε�並 ���ΰ� �ִ� div�� class�� �����Ͽ� ������ ����ų� ���̰� �ϴ� �Լ��Դϴ�
    'function toggleMap(active) {  ' + ' if (active) { ' +
  // ������ ���̵��� ������ �ε�並 ���ΰ� �ִ� div�� class�� �����մϴ�
    '  container.className = "view_map" ' + ' } else {   ' +
    'if (flag){          ' +
  // ������ ���������� ������ �ε�並 ���ΰ� �ִ� div�� class�� �����մϴ�
    'container.className = "view_roadview";' +
  // 'roadViewFloat();
    '}' + 'else {' + ' alert(''���� ��Ҹ� �����ּ���!'');}' + ' }  ' + '}' +

    '  function roadViewFloat(){  ' +

    'var mapCenter =  new daum.maps.LatLng(lat/count, lng/count);' +
    'var rvContainer = document.getElementById(''roadview''); ' +
  // �ε�並 ǥ���� div
    'var rv = new daum.maps.Roadview(rvContainer);' +
  // �ε�� ��ü
    'var rvClient = new daum.maps.RoadviewClient(); ' +
  // ��ǥ�κ��� �ε�� �ĳ�ID�� ������ �ε�� helper��ü

    'toggleRoadview(mapCenter);' +

  // ��Ŀ �̹����� �����մϴ�.
    'var markImage = new daum.maps.MarkerImage( ' +
    '     ''http://i1.daumcdn.net/localimg/localimages/07/mapapidoc/roadview_wk.png'', '
    + '  new daum.maps.Size(35,39), ' + ' { ' +
  // ��Ŀ�� ��ǥ�� �ش��ϴ� �̹����� ��ġ�� �����մϴ�.
  // �̹����� ��翡 ���� ���� �ٸ� �� ������, ���� width/2, height�� �ָ� ��ǥ�� �̹����� �ϴ� �߾��� �ö󰡰� �˴ϴ�.
    '  offset: new daum.maps.Point(14, 39)' + '   }  ' + '); ' +

  // �巡�װ� ������ ��Ŀ�� �����մϴ�.
    'var rvMarker = new daum.maps.Marker({    ' +
    '    image : markImage,                   ' +
    '    position: mapCenter,                 ' +
    '    draggable: true,                     ' +
    '    map: map                             ' +
    '});                                      ' +

  // ��Ŀ�� dragend �̺�Ʈ�� �Ҵ��մϴ�
    'daum.maps.event.addListener(rvMarker, ''dragend'', function(mouseEvent) {'
    + '    var position = rvMarker.getPosition(); ' +
  // ���� ��Ŀ�� ���� �ڸ��� ��ǥ
    '    toggleRoadview(position);' +
  // �ε�並 ����մϴ�
    '});   ' +

  // ������ Ŭ�� �̺�Ʈ�� �Ҵ��մϴ�
    'daum.maps.event.addListener(map, ''click'', function(mouseEvent){  ' +

  // ���� Ŭ���� �κ��� ��ǥ�� ����
    '  var position = mouseEvent.latLng;' +

    '  rvMarker.setPosition(position);' + ' toggleRoadview(position);' +
  // �ε�並 ����մϴ�
    '});  ' +

  // �ε�� toggle�Լ�
    'function toggleRoadview(position){' +

  // ���޹��� ��ǥ(position)�� ����� �ε���� panoId�� �����Ͽ� �ε�並 ���ϴ�
    'rvClient.getNearestPanoId(position, 50, function(panoId) { ' +
    ' if (panoId === null) {   ' + '  rvContainer.style.display = ''none'';' +
  // �ε�並 ���� �����̳ʸ� ����ϴ�
    '  map_Wrap.style.width = ''100%'';  ' + '  map.relayout();  ' +
    '  } else { ' + '   map_Wrap.style.width = ''100%''; ' +
    ' map.relayout(); ' +
  // ������ ���ΰ� �ִ� ������ ����ʿ� ����, ������ ��迭�մϴ�
    '  rvContainer.style.display = ''block'';' +
  // �ε�並 ���� �����̳ʸ� ���̰��մϴ�
    '  rv.setPanoId(panoId, position);' +
  // panoId�� ���� �ε�� ����
    'rv.relayout();' + // �ε�並 ���ΰ� �ִ� ������ ����ʿ� ����, �ε�並 ��迭�մϴ�
    ' }                 ' + '   }); ' + '} ' + '}' +

    'function insertName(hname){name = hname;}' +

    'function check(hlat,hlng) {' + 'var lat2=hlat,lng2=hlng;' +
    'lat = lat+ lat2;' + 'lng = lng+ hlng;' +
    'points[count]=new daum.maps.LatLng(hlat, hlng);' +
    'bounds.extend(points[count]);' + ' map.setBounds(bounds);' +
    'count=count+1;' +
  // ��������� ���� ��ġ�� ��Ŀ�� ǥ���մϴ�
    ' var marker = new daum.maps.Marker({   ' +
    'position: new daum.maps.LatLng(hlat, hlng) ,   ' + ' map: map });    ' +
  // ����������� ��ҿ� ���� ������ ǥ���մϴ�
    ' var infowindow = new daum.maps.InfoWindow({   ' +
    '  content: ''<div style="padding:5px;">''+name+''</div>''  ' + '  });  ' +
    '  infowindow.open(map, marker); } ' +
  // searchMap func ��

    'function searchMap(name,address) {' +
    ' var geocoder = new daum.maps.services.Geocoder();  ' +
  // �ּҷ� ��ǥ�� �˻��մϴ�
    'geocoder.addr2coord(address, function(status, result) { ' +

  // ���������� �˻��� �Ϸ������
    '  if (status === daum.maps.services.Status.OK) {  ' +

    '  var coords = new daum.maps.LatLng(result.addr[0].lat, result.addr[0].lng),position; '
    + 'lat = lat+ result.addr[0].lat;' + 'lng = lng+ result.addr[0].lng;' +
    'points[count]=coords;' + 'bounds.extend(points[count]);' +
    ' map.setBounds(bounds);' + 'count=count+1;' +
  // ��������� ���� ��ġ�� ��Ŀ�� ǥ���մϴ�
    ' var marker = new daum.maps.Marker({   ' + 'position: coords,   ' +
    ' map: map ' + ' });    ' +
  // ����������� ��ҿ� ���� ������ ǥ���մϴ�
    ' var infowindow = new daum.maps.InfoWindow({   ' +
    '  content: ''<div style="padding:5px;">''+name+''</div>'' });  ' +
    '  infowindow.open(map, marker); ' + '  } ' + '}); } ' +

    'function meetHere(){' + 'flag = true;' +
    'var marker = new daum.maps.Marker({  ' + '  map: map, ' +
    'position: new daum.maps.LatLng(lat/count, lng/count) ' + '   });   ' +

  // ����������� �� �ҿ� ���� ������ ǥ���մϴ�
    '   var infowindow = new daum.maps.InfoWindow({  ' +
    '  content: ''<div style="padding:5px;">���⼭ ����!</div>''  ' + ' });  ' +
    ' infowindow.open(map, marker);' + 'roadViewFloat();' + '}' +
  // hereMeet func ��

    '</script>' + '</body>' + '</html>';

procedure TForm3.btnFind_LocClick(Sender: TObject);
begin
  if edt_Name.Text <> '' then
  begin
    if edt_Lat.Text <> '' then
    begin
      dm.Insert_Qrt(edt_Name.Text, trans_lat, trans_Lng, room);
      btnFind_Loc.Enabled := false;
    end
    else
      showmessage('��ġ�� ã�� ���߽��ϴ�.');
  end
  else
    showmessage('�̸��� �Է��� �ּ���.');
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  if meet_Count > 1 then
  begin
    dm.btn_HereMeet_Click(room);
    Button1.Enabled := false;
  end
  else
    showmessage('�θ� �̻� ���ּ���!');
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  chatting: string;
begin
  if edt_Name.Text <> '' then
  begin
    chatting := #13#10 + edt_Name.Text + ': ' + M_edt_Chat.Text;
    dm.Chat_Log(chatting, room);
    M_edt_Chat.Text := '';
  end
  else
    showmessage('������ �Է��ϼ���!');
end;

procedure TForm3.Button3Click(Sender: TObject); // ä�ù� ����
begin
  room := edt_M_Room_Create.Text;
  dm.Create_Room(room);
  DataModule1.M_ChannelManager.ChannelName := room;
  DataModule1.M_ChannelManager.RegisterCallback(room,
    TM_Client_Callback.Create());
  showmessage('���� �����Ͽ����ϴ�.');
  join_room := true;
  exit_room := false;
  M_Join_Member.items.Add('������ ���');
  TabControl1.ActiveTab := TabItem3;
end;

procedure TForm3.Button4Click(Sender: TObject); // ä�ù� ����
begin
  room := M_edt_JoinRoom.Text;
  DataModule1.M_ChannelManager.ChannelName := room;
  DataModule1.M_ChannelManager.RegisterCallback(room,
    TM_Client_Callback.Create());
  showmessage('�濡 �����Ͽ����ϴ�.');
  join_room := true;
  exit_room := false;
  M_Join_Member.items.Add('������ ���');
  TabControl1.ActiveTab := TabItem3;
end;

procedure TForm3.Button5Click(Sender: TObject); // �� ������
var
  aStream: TMemoryStream;
begin
  aStream := TMemoryStream.Create;
  try
    aStream.WriteBuffer(Pointer(htmlstr)^, Length(htmlstr)); // �ڹٽ�ũ��Ʈ �о����
    aStream.Seek(0, soFromBeginning);
    WebBrowser1.LoadFromStrings(htmlstr, htmlstr);
  finally
    aStream.Free;
  end;
  // �������� �ʱ�ȭ ��
  DataModule1.M_ChannelManager.UnregisterCallback(room);
  edt_Lat.Text := '';
  edt_Lng.Text := '';
  M_Join_Member.items.Clear;
  M_Chat_List.Lines.Clear;
  btnFind_Loc.Enabled := true;
  Button1.Enabled := true;
  join_room := false;
  exit_room := true;
  TabControl1.ActiveTab := TabItem1;
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  DataModule1.location_trans.Refresh;
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
  Form3.Destroy;
end;

// procedure TForm3.CalcContentBoundsProc(Sender: TObject;
// var ContentBounds: TRectF);
// begin
// if FNeedOffset and (FKBBounds.Top > 0) then
// begin
// ContentBounds.Bottom := Max(ContentBounds.Bottom,
// 2 * ClientHeight - FKBBounds.Top);
// end;
// end;

procedure TForm3.FormCreate(Sender: TObject);
var
  aStream: TMemoryStream;
begin
  WebBrowser1.Navigate('about:blank');
  aStream := TMemoryStream.Create;
  try
    aStream.WriteBuffer(Pointer(htmlstr)^, Length(htmlstr)); // �ڹٽ�ũ��Ʈ �о����
    aStream.Seek(0, soFromBeginning);
    WebBrowser1.LoadFromStrings(htmlstr, htmlstr);
  finally
    aStream.Free;
    TabControl1.TabIndex := 0;
    // M_Chat_List.OnCalcContentBounds := CalcContentBoundsProc;
  end;
  // �������� �ʱ�ȭ ��
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  Form3.Close;
end;

procedure TForm3.ImageViewer1Click(Sender: TObject);
begin

end;

// procedure TForm3.FormFocusChanged(Sender: TObject);
// begin
// UpdateKBBounds;
// end;

// procedure TForm3.FormVirtualKeyboardHidden(Sender: TObject;
// KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
// begin
// FKBBounds.create(0, 0, 0, 0);
// FNeedOffset := false;
// RestorePosition;
// end;

// procedure TForm3.FormVirtualKeyboardShown(Sender: TObject;
// KeyboardVisible: Boolean; const [Ref] Bounds: TRect);
// begin
// FKBBounds := TRectF.create(Bounds);
// FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
// FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
// UpdateKBBounds;
// end;

procedure TForm3.LocationSensor1LocationChanged(Sender: TObject;
  const [Ref] OldLocation, NewLocation: TLocationCoord2D);
var
  x, y: string;
begin
  // if swActiveSensor.IsChecked = true then
  // begin
  swActiveSensor.IsChecked := false;
  x := NewLocation.Latitude.ToString;
  y := NewLocation.Longitude.ToString;
  trans_lat := x;
  trans_lng := y;
  try
    if not Assigned(FGeocoder) then
    begin
      if Assigned(TGeocoder.Current) then
        FGeocoder := TGeocoder.Current.Create;
      if Assigned(FGeocoder) then
        FGeocoder.OnGeocodeReverse := OnGeocodeReverseEvent;
    end;
  except
    showmessage('��ġ ������ ã�� ���߽��ϴ�.');
  end;

  if Assigned(FGeocoder) and not FGeocoder.Geocoding then
    FGeocoder.GeocodeReverse(NewLocation);
  // end;
end;

procedure TForm3.M_Loc_MarkTimer(Sender: TObject);
begin
  meet_Count := meet_Count + 1;
  M_Loc_Mark.Enabled := false;
  WebBrowser1.EvaluateJavaScript('insertName(' + hname + ')');
  Sleep(1000);
  WebBrowser1.EvaluateJavaScript('check(' + hlat + ',' + hlng + ')');
end;

procedure TForm3.M_Meet_ClickTimer(Sender: TObject);
begin
  M_Meet_Click.Enabled := false;
  Button1.Enabled := false;
  WebBrowser1.EvaluateJavaScript('meetHere()');
end;

procedure TForm3.OnGeocodeReverseEvent(const Address: TCivicAddress);
begin
  edt_Lat.Text := Address.AdminArea + ' ' + Address.Locality;
  edt_Lng.Text := Address.Thoroughfare + ' ' + Address.SubThoroughfare;
end;

// procedure TForm3.RestorePosition;
// begin
// M_Chat_List.ViewportPosition := PointF(M_Chat_List.ViewportPosition.x, 0);
// layout4.Align := TAlignLayout.Client;
// M_Chat_List.RealignContent;
// end;

procedure TForm3.swActiveLocationSensor1(Sender: TObject);
begin
  LocationSensor1.Active := swActiveSensor.IsChecked;
end;

procedure TForm3.TabItem1Click(Sender: TObject);
begin
  if exit_room = false then
  begin
    showmessage('�����⸦ �����ּ���!');
    TabControl1.ActiveTab := TabItem3;
  end;
end;

procedure TForm3.TabItem2Click(Sender: TObject);
begin
  if exit_room = false then
  begin
    showmessage('�����⸦ �����ּ���!');
    TabControl1.ActiveTab := TabItem3;
  end;
end;

procedure TForm3.TabItem3Click(Sender: TObject);
begin
  if join_room = false then
  begin
    showmessage('���� ������ �ּ���!');
    TabControl1.ActiveTab := TabItem1;
  end;
end;

procedure TForm3.TabItem4Click(Sender: TObject);
begin
  if join_room = false then
  begin
    showmessage('���� ������ �ּ���!');
    TabControl1.ActiveTab := TabItem1;
  end;
end;

// procedure TForm3.UpdateKBBounds;
// var
// LFocused: TControl;
// LFocusRect: TRectF;
// begin
// FNeedOffset := false;
// if Assigned(Focused) then
// begin
// LFocused := TControl(Focused.GetObject);
// LFocusRect := LFocused.AbsoluteRect;
// LFocusRect.Offset(M_Chat_List.ViewportPosition);
// if (LFocusRect.IntersectsWith(TRectF.create(FKBBounds))) and
// (LFocusRect.Bottom > FKBBounds.Top) then
// begin
// FNeedOffset := true;
// layout4.Align := TAlignLayout.Horizontal;
// M_Chat_List.RealignContent;
// Application.ProcessMessages;
// M_Chat_List.ViewportPosition := PointF(M_Chat_List.ViewportPosition.x,
// LFocusRect.Bottom - FKBBounds.Top);
// end;
// end;
// if not FNeedOffset then
// RestorePosition;
// end;

procedure TForm3.W_Loc_MarkTimer(Sender: TObject);
begin
  meet_Count := meet_Count + 1;
  W_Loc_Mark.Enabled := false;
  WebBrowser1.EvaluateJavaScript('searchMap(' + hname + ',' + haddress + ')');
end;

end.
