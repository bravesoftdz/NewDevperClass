unit W_Main;

interface

uses
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MSHTML, Vcl.OleCtrls,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, IPPeerClient,
  Datasnap.DSCommon, DBXJSon, W_DataModule, System.JSON, SHDocVw,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Chat_Room;

type
  TForm1 = class(TForm)
    WebBrowser1: TWebBrowser;
    btn_HereMeet: TButton;
    Panel1: TPanel;
    Chat_List: TMemo;
    edt_Chat: TEdit;
    btn_Tras_Chat: TButton;
    Loc_Mark: TTimer;
    Meet_Click: TTimer;
    Join_Member: TListBox;
    Nick_Name: TEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    edt_Name: TEdit;
    edt_Address: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    W_Loc_Mark: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btn_HereMeetClick(Sender: TObject);
    procedure Loc_MarkTimer(Sender: TObject);
    procedure Meet_ClickTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_Tras_ChatClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure W_Loc_MarkTimer(Sender: TObject);
  private
    { Private declarations }
    HTMLWindow2: IHTMLWindow2;
  public
    { Public declarations }
    procedure Web1_Reset();
  end;

var
  Form1: TForm1;

implementation

uses
  activeX;

{$R *.dfm}

const
  htmlstr: ansistring = '<!DOCTYPE html>' + '<html>' + '<head>' +
    '<meta charset="utf8">' + '<title>���� �����ϱ�</title>' + '<style>' +
    '  .map_wrap, .map_wrap * {margin:0; padding:0;font-family:''Malgun Gothic'',dotum,''����'',sans-serif;font-size:12px;} '
    + '.map_wrap {position:relative;width:100%;height:350px;}   ' +
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

    '  <div class="places">  ' +
    '<ul id="category">                                    ' +
    ' <li id="BK9" data-order="2">                  ' +
    ' <span class="category_bg pharmacy"></span>    ' +
    ' ����                                      ' +
    '</li>                                         ' +
    '  <li id="MT1" data-order="2">                  ' +
    '   <span class="category_bg pharmacy"></span>    ' +
    '  ��Ʈ                                      ' +
    ' </li>                                        ' +
    ' <li id="CT1" data-order="2">                 ' +
    '  <span class="category_bg pharmacy"></span>' +
    ' ��ȭ�ü�                                 ' +
    '  </li>                                        ' +
    ' <li id="OL7" data-order="2">                 ' +
    '     <span class="category_bg pharmacy"></span>    ' +
    '     ������                                   ' +
    ' </li>                                        ' +
    '  <li id="CE7" data-order="2">                 ' +
    '      <span class="category_bg pharmacy"></span>   ' +
    '     ī��                                     ' +
    '  </li>                                        ' +
    '  <li id="CS2" data-order="2">                 ' +
    '      <span class="category_bg pharmacy"></span>  ' +
    '      ������                                   ' +
    '  </li>                                        ' +
    ' <li id="SW8" data-order="2">                      ' +
    '     <span class="category_bg pharmacy"></span>  ' + '����ö��' +
    '  </li>                                        ' +
    '<li id="FD6" data-order="2">                      ' +
    '   <span class="category_bg pharmacy"></span>  ' +
    '    ������                                   ' +
    ' </li>                                        ' +
    ' <li id="AD5" data-order="2">                      ' +
    '  <span class="category_bg pharmacy"></span>  ' +
    '  ����                                     ' +
    '  </li>                                        ' +
    '  <li id="AT4" data-order="2">                      ' +
    ' <span class="category_bg pharmacy"></span>  ' +
    ' �������                                 ' +
    '  </li>                                        ' +
    '  <li id="PO3" data-order="2">                     ' +
    '   <span class="category_bg pharmacy"></span>  ' +
    '  �������                                 ' +
    ' </li>                                        ' +
    '<li id="PK6" data-order="2">                     ' +
    '  <span class="category_bg pharmacy"></span>  ' +
    '  ������                                   ' +
    '</li>                                         ' +
    ' </ul>                                            ' +
    '</div>                                               ' +
    '<div id="container" class="view_map">                                                                                                                              '
    + '    <div id="map_Wrap" style="width:100%;height:350px;position:relative;">                                                                                         '
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

procedure TForm1.btn_HereMeetClick(Sender: TObject);
begin
  if meet_Count > 1 then
  begin
    dm.btn_HereMeet_Click(room);
    btn_HereMeet.Enabled := false;
  end
  else
    showmessage('�θ� �̻� ���ּ���!');
end;

procedure TForm1.btn_Tras_ChatClick(Sender: TObject);
var
  chatting: string;
begin
  if Nick_Name.Text <> '' then
  begin
    if edt_Chat.Text <> '' then
    begin
      chatting := #13#10 + Nick_Name.Text + ': ' + edt_Chat.Text;
      dm.Chat_Log(chatting, room);
      edt_Chat.Text := '';
    end
    else
      showmessage('������ �Է��ϼ���!');
  end
  else
    showmessage('��ȭ���� �Է��ϼ���!');
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  name, address: string;
begin
  if edt_Name.Text <> '' then
  begin
    if edt_Address.Text <> '' then
    begin
      name := edt_Name.Text;
      address := edt_Address.Text;
      dm.Insert_W_Qrt(name, address, room);
      Button1.Enabled := false;
    end
    else
      showmessage('�ּҸ� �Է��ϼ���!');
  end
  else
    showmessage('�̸��� �Է��ϼ���!');

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Web1_Reset;
  Join_Member.Items.Clear;
  Chat_List.Lines.Clear;
  Nick_Name.Clear;
  edt_Chat.Clear;
  edt_Name.Clear;
  edt_Address.Clear;
  Form4.unRegist;
  Form1.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  WebBrowser1.Navigate('about:blank');
  Web1_Reset;
  Join_Member.Items.Add('������ ���');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Button1.Enabled := true;
  btn_HereMeet.Enabled := true;
end;

procedure TForm1.Loc_MarkTimer(Sender: TObject);
begin
  meet_Count := meet_Count + 1;
  Loc_Mark.Enabled := false;
  HTMLWindow2.execScript('insertName(' + hname + ')', 'JavaScript');
  Sleep(1000);
  HTMLWindow2.execScript('check(' + hlat + ',' + hlng + ')', 'JavaScript');
end;

procedure TForm1.Meet_ClickTimer(Sender: TObject);
begin
  btn_HereMeet.Enabled := false;
  Meet_Click.Enabled := false;
  HTMLWindow2.execScript('meetHere()', 'JavaScript');
end;

procedure TForm1.Web1_Reset;
var
  aStream1: TMemoryStream;
begin
  if Assigned(WebBrowser1.Document) then
  begin
    aStream1 := TMemoryStream.Create;
    try
      // aStream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr));
      aStream1.Write(htmlstr[1], Length(htmlstr));
      aStream1.Seek(0, soFromBeginning);
      (WebBrowser1.Document as IPersistStreamInit)
        .Load(TStreamAdapter.Create(aStream1));
    finally
      aStream1.Free;
    end;
    HTMLWindow2 := (WebBrowser1.Document as IHTMLDocument2).parentWindow;
  end;
end;

procedure TForm1.W_Loc_MarkTimer(Sender: TObject);
begin
  meet_Count := meet_Count + 1;
  W_Loc_Mark.Enabled := false;
  HTMLWindow2.execScript('searchMap(' + hname + ',' + haddress + ')',
    'JavaScript');
end;

end.
