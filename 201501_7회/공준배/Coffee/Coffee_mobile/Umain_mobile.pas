unit Umain_mobile;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.StdCtrls, FMX.TabControl, FMX.ListBox, FMX.WebBrowser, System.Sensors,
  System.Sensors.Components, FMX.Objects, FMX.Controls.Presentation, FMX.Edit,
  System.Rtti, Data.Bind.EngExt, FMX.Bind.DBEngExt, FMX.Bind.Grid,
  System.Bindings.Outputs, FMX.Bind.Editors, FMX.Grid, Data.Bind.Components,
  Data.Bind.Grid, Data.Bind.DBScope, UClientClass, FMX.ExtCtrls, FMX.EditBox,
  FMX.NumberBox, FMX.Memo;

type
  TMobileForm = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabItem4: TTabItem;
    Btn_Login: TButton;
    Btn_SignUp_Page: TButton;
    Layout1: TLayout;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    WebBrowser1: TWebBrowser;
    ListBox1: TListBox;
    Btn_GetMap: TButton;
    ToolBar1: TToolBar;
    Btn_Refresh: TButton;
    Btn_Back: TButton;
    LocationSensor1: TLocationSensor;
    Edit_Id: TEdit;
    Edit_Name: TEdit;
    Edit_Password: TEdit;
    Edit_RePassword: TEdit;
    Edit_PhoneNum: TEdit;
    Edit_Age: TEdit;
    Gender1: TRadioButton;
    Gender2: TRadioButton;
    Text1: TText;
    Text2: TText;
    Text3: TText;
    Text4: TText;
    Text5: TText;
    Text6: TText;
    Text7: TText;
    Btn_SignUp: TButton;
    Btn_Cancel: TButton;
    Btn_GetReserve: TButton;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBox2: TListBox;
    ListBoxItem3: TListBoxItem;
    MetropolisUIListBoxItem1: TMetropolisUIListBoxItem;
    MetropolisUIListBoxItem2: TMetropolisUIListBoxItem;
    Image1: TImage;
    ComboBox1: TComboBox;
    StyleBook1: TStyleBook;
    Text8: TText;
    ToolBar2: TToolBar;
    Btn_Next: TButton;
    Btn_BackMap: TButton;
    TabItem7: TTabItem;
    ToolBar3: TToolBar;
    Btn_Order: TButton;
    Btn_Reserve: TButton;
    Memo1: TMemo;
    Text11: TText;
    ListBox3: TListBox;
    ListBoxItem4: TListBoxItem;
    TabItem8: TTabItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ToolBar4: TToolBar;
    Btn_BackOrder: TButton;
    Btn_CancelOrder: TButton;
    TName_Loca: TText;
    Rect_info: TRoundRect;
    Text17: TText;
    Layout2: TLayout;
    Layout3: TLayout;
    Text13: TText;
    TArrival: TText;
    Text16: TText;
    TPayment: TText;
    Layout4: TLayout;
    Text14: TText;
    TTotal: TText;
    Btn_UpdateOrder: TButton;
    Layout5: TLayout;
    MComment: TMemo;
    Text15: TText;
    ListBox4: TListBox;
    Layout6: TLayout;
    Sign_In_Password: TEdit;
    Text18: TText;
    Text19: TText;
    Image2: TImage;
    Image3: TImage;
    Layout7: TLayout;
    Layout8: TLayout;
    Layout9: TLayout;
    Layout10: TLayout;
    Layout12: TLayout;
    Layout13: TLayout;
    Layout14: TLayout;
    Layout15: TLayout;
    Layout16: TLayout;
    Layout17: TLayout;
    Layout18: TLayout;
    ToolBar5: TToolBar;
    Button1: TButton;
    Image6: TImage;
    Layout11: TLayout;
    Layout20: TLayout;
    Edit_Arrival: TNumberBox;
    Text9: TText;
    Text20: TText;
    Layout21: TLayout;
    Box_Total: TNumberBox;
    Text12: TText;
    Text21: TText;
    Layout23: TLayout;
    Layout22: TLayout;
    Payment_Box: TComboBox;
    Text10: TText;
    Layout24: TLayout;
    Image4: TImage;
    Image5: TImage;
    sign_in_login: TEdit;
    RoundRect1: TRoundRect;
    Text22: TText;
    procedure Btn_GetMapClick(Sender: TObject);
    procedure Btn_LoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LocationSensor1LocationChanged(Sender: TObject;
      const OldLocation, NewLocation: TLocationCoord2D);
    procedure Btn_RefreshClick(Sender: TObject);
    procedure Btn_BackClick(Sender: TObject);
    procedure Btn_SignUp_PageClick(Sender: TObject);
    procedure Btn_SignUpClick(Sender: TObject);
    procedure Btn_CancelClick(Sender: TObject);
    procedure ListBox1ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Btn_GetReserveClick(Sender: TObject);
    procedure Btn_BackMapClick(Sender: TObject);
    procedure Btn_NextClick(Sender: TObject);
    procedure Btn_OrderClick(Sender: TObject);
    procedure ListBox3ItemClick(const Sender: TCustomListBox;
      const Item: TListBoxItem);
    procedure Btn_BackOrderClick(Sender: TObject);
    procedure Btn_CancelOrderClick(Sender: TObject);
    procedure Btn_UpdateOrderClick(Sender: TObject);
    procedure Payment_BoxChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Btn_ReserveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Lat: string;
    Long: string;
    Distance: integer;
    LoginID: string;
    OrderOrModi: boolean;
  end;

var
  MobileForm: TMobileForm;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}
{$R *.GGlass.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.iPhone55in.fmx IOS}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.Windows.fmx MSWINDOWS}

uses UDm, Androidapi.JNI.Location, Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers, Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Telephony, FMX.Helpers.Android;

var
  SelectCafe: string;
  SelectLoca: string;
  Total_Amount: integer;
  SeeReserve: integer;

const
  HTMLStr: UnicodeString = '<!DOCTYPE html>' + '<html>' + '<head>' +
    '<meta charset="utf-8">' + '<title>���� ���� API</title>' + '</head>' + '<body>'
    + '<div id="map" style="width:345px;height:300px;"></div>'

    + '<script src="http://apis.daum.net/maps/maps3.js?apikey=1a425016e57362d0b0e1f4ed596f96d0"></script>'
    + '<script>'

    + 'var map;' // ������ �����Ѵ�
  // Url �迭
    + 'var markerImageArray = [''http://postfiles15.naver.net/20150127_222/hunter450_14223531048758qVOV_PNG/Untitled-2.png?type=w3'',''http://postfiles10.naver.net/20150127_201/hunter450_1422353514211Q8hiW_PNG/B.png?type=w3'''
    + ', ''http://postfiles9.naver.net/20150127_8/hunter450_1422353514320Xq55d_PNG/C.png?type=w3'',''http://postfiles3.naver.net/20150128_162/hunter450_1422375209483T9wtt_PNG/D.png?type=w3'''
    + ', ''http://postfiles14.naver.net/20150128_253/hunter450_1422375209662o5y5D_PNG/E.png?type=w3'',''http://postfiles15.naver.net/20150128_158/hunter450_1422375209846XGEQM_PNG/F.png?type=w3'''
    + ', ''http://postfiles2.naver.net/20150128_81/hunter450_1422375210067EQUJi_PNG/G.png?type=w3'',''http://postfiles8.naver.net/20150128_295/hunter450_1422375210166818Xb_PNG/H.png?type=w3'''
    + ', ''http://postfiles12.naver.net/20150128_251/hunter450_14223752102823PnX8_PNG/I.png?type=w3'',''http://postfiles12.naver.net/20150128_267/hunter450_1422375210581fRndC_PNG/J.png?type=w3''];'

    + 'function SetMap(lat, long){' +
    'var mapContainer = document.getElementById(''map''),' // ������ ǥ���� div
    + 'mapOption = {' + 'center: new daum.maps.LatLng(lat, long),' // ������ �߽���ǥ
    + 'level: 5,' // ������ Ȯ�� ����
    + 'mapTypeId : daum.maps.MapTypeId.ROADMAP' // ��������
    + '};' + 'map = new daum.maps.Map(mapContainer, mapOption);'

    + 'var markerImageUrl = ''http://postfiles10.naver.net/20150126_153/hunter450_1422254064813Itk7n_PNG/myloca.png?type=w3'','
    + 'markerImageSize = new daum.maps.Size(20, 28),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(10, 28)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});' + '}'

    + 'function SetMarkers(lat, long, count){' +
    'var markerImageUrl = markerImageArray[count],' +
    'markerImageSize = new daum.maps.Size(28, 28),' // ��Ŀ �̹����� ũ��
    + 'markerImageOptions = {' + 'offset : new daum.maps.Point(14, 28)'
  // ��Ŀ ��ǥ�� ��ġ��ų �̹��� ���� ��ǥ
    + '};'

    + 'var markerImage = new daum.maps.MarkerImage(markerImageUrl, markerImageSize, markerImageOptions);'

    + 'marker = new daum.maps.Marker({' +
    'position: new daum.maps.LatLng(lat, long),' + 'image : markerImage,' +
    'map: map' + '});' +
    ' daum.maps.event.addListener(marker, ''click'', function(){' +
    'alert(''�Ʒ� ��Ͽ��� Ŭ�����ּ���'');' + '});' + '}'

    + 'function panTo(lat,long) {'
  // �̵��� ���� �浵 ��ġ�� �����մϴ�
    + 'var moveLatLon = new daum.maps.LatLng(lat, long);'
  // ���� �߽��� �ε巴�� �̵���ŵ�ϴ�
  // ���� �̵��� �Ÿ��� ���� ȭ�麸�� ũ�� �ε巯�� ȿ�� ���� �̵��մϴ�
    + 'map.panTo(moveLatLon);' + '}'

    + '</script>' + '</body>' + '</html>';

procedure TMobileForm.Btn_BackClick(Sender: TObject);
// ����or�ֹ����� ȭ�鿡�� ����ȭ������ �̵� ��ư
begin
  TabControl1.ActiveTab := TabItem2;
end;

procedure TMobileForm.Btn_BackMapClick(Sender: TObject);
// ����or�ֹ����� ���¿��� ���� or ���� ȭ������ ������ ��ư
begin
  if OrderOrModi then
    TabControl1.ActiveTab := TabItem3
  else
    TabControl1.ActiveTab := TabItem2;
end;

procedure TMobileForm.Btn_BackOrderClick(Sender: TObject); // �󼼺��⿡�� ������ȸ�� ���ư���
begin
  TabControl1.ActiveTab := TabItem5;
end;

procedure TMobileForm.Btn_CancelClick(Sender: TObject); // ȸ������ ��� ��ư
begin
  Edit_Id.Text := ''; // �ۼ��� ���� �ʱ�ȭ
  Edit_Name.Text := '';
  Edit_Password.Text := '';
  Edit_RePassword.Text := '';
  Edit_PhoneNum.Text := '';
  Edit_Age.Text := '';
  Gender1.IsChecked := false;
  Gender2.IsChecked := false;

  TabControl1.ActiveTab := TabItem1;
end;

procedure TMobileForm.Btn_CancelOrderClick(Sender: TObject); // �ֹ���� ��ư
var
  CheckTime: TDateTime;
  Temp: double;
begin

  CheckTime := Dm.ReserveDataSet.FieldByName('R_ARRIVAL').AsDateTime; // �ð� üũ
  Temp := CheckTime - Now;
  if Temp <= 0.0032 then // 5�й̸� ���ǰ˻�(����ð��� 5�� �̸��� ��� ���� �Ұ�)
  begin
    Rect_info.Opacity := 1.0;
    Rect_info.AnimateFloat('Opacity', 0.0, 3.0);
    Exit;
  end;

  MessageDlg('���� ����Ͻðڽ��ϱ�?', TMsgDlgType.mtInformation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        try
          demo.Delete_Reserve(IntToStr(SeeReserve)); // �ֹ� ���
        except
          raise Exception.Create('��� ����, ��� �� �ٽ� ������ּ���');
        end;

        ShowMessage('��� �Ϸ�');
        TabControl1.ActiveTab := TabItem2;
      end;
    end);

end;

procedure TMobileForm.Btn_GetMapClick(Sender: TObject); // �ֺ��˻� ��ư
var
  obj: JObject;
  locationManager: JLocationManager;
begin

  if not LocationSensor1.Active then // ��ġ���� �ѱ�
    LocationSensor1.Active := true;

  obj := SharedActivityContext.getSystemService // GPS ���� ��������
    (TJContext.JavaClass.LOCATION_SERVICE);
  locationManager := TJLocationManager.Wrap((obj as ILocalObject).GetObjectID);

  if locationManager.isProviderEnabled(TJLocationManager.JavaClass.GPS_PROVIDER)
  then // GPS on/off Ȯ��
  begin

    try
      WebBrowser1.EvaluateJavaScript('SetMap(' + Lat + ',' + Long + ');');
      // ��������API ȣ��
      Dm.Calc_Distance; // �Ÿ���� �� 3km �̳� ī�� ������ ����
    except
      raise Exception.Create('��ġ������ ��Ȯ���� �ʽ��ϴ�. ��� �� �ٽ� ������ �ּ���');
    end;

    TabControl1.ActiveTab := TabItem3;
    Btn_Order.Text := '�����ϱ�'; // ���� �����ϱ�(or �ֹ�����) �ؽ�Ʈ�� �����ϱ�� �ٲ���
    OrderOrModi := true; // ���� ���� ����

  end
  else
    ShowMessage('GPS�� ���ּ���');

end;

procedure TMobileForm.Btn_GetReserveClick(Sender: TObject); // ������ȸ ��ư
begin
  Dm.Get_Reserve(LoginID);
  TabControl1.ActiveTab := TabItem5;
end;

procedure TMobileForm.Btn_LoginClick(Sender: TObject); // �α��� ��ư
var
  checklog: boolean;
begin

  if sign_in_login.Text = '' then
    raise Exception.Create('���̵� �Է����ּ���');

  if Sign_In_Password.Text = '' then
    raise Exception.Create('��й�ȣ�� �Է����ּ���');

  try
    checklog := demo.Log_in(sign_in_login.Text, Sign_In_Password.Text);
    if checklog then
    begin
      TabControl1.ActiveTab := TabItem2; // �α��� ������ ����ȭ��
      LoginID := sign_in_login.Text;
      sign_in_login.Text := '';
      Sign_In_Password.Text := '';
    end
    else
      ShowMessage('���̵� �Ǵ� ��й�ȣ�� �ٽ� Ȯ���ϼ���');
  except
    raise Exception.Create('���̵� �Ǵ� ��й�ȣ�� �ٽ� Ȯ���ϼ���');
  end;

end;

procedure TMobileForm.Btn_NextClick(Sender: TObject); // �ֹ�or���ຯ�� ���� ��ư
var
  i: integer;
  Rl_Quantity: array of integer;
  Rl_Price: array of integer;
begin
  i := 0;
  Total_Amount := 0;
  SetLength(Rl_Quantity, Dm.MenuDataSet.RecordCount);
  SetLength(Rl_Price, Dm.MenuDataSet.RecordCount);

  Dm.MenuDataSet.First;
  while not Dm.MenuDataSet.EOF do // �� �ݾ� ���
  begin
    if Dm.CheckQuantity[i].ItemIndex <> 0 then // �� �ݾ� ���(1���̻� ���õ� �͸� ���)
    begin
      Total_Amount := Total_Amount + Dm.MenuDataSet.FieldByName('M_PRICE')
        .AsInteger * Dm.CheckQuantity[i].ItemIndex;
    end;
    Dm.MenuDataSet.Next;
    Inc(i);
  end;

  Rl_Quantity := nil; // �迭 �ʱ�ȭ
  Rl_Price := nil;

  if Total_Amount = 0 then // ���õ� ���ᰡ ���� ��
  begin
    raise Exception.Create('1���̻� �������ּ���');
  end;

  MessageDlg('��' + IntToStr(Total_Amount) + '�� �Դϴ� ����â���� ���ðڽ��ϱ�?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        TabControl1.ActiveTab := TabItem7; // ���� â���� �Ѿ��
        Box_Total.Text := IntToStr(Total_Amount); // �� ���� ���
      end;
    end);
end;

procedure TMobileForm.Btn_RefreshClick(Sender: TObject);
begin
  WebBrowser1.EvaluateJavaScript('SetMap(' + Lat + ',' + Long + ');');
  ListBox1.Clear;
end;

procedure TMobileForm.Btn_ReserveClick(Sender: TObject);
// ���� or �ֹ����� �� ���뿡�� Ŀ�� ���� ���� ȭ������ �Ѿ��
begin
  TabControl1.ActiveTab := TabItem4;
end;

procedure TMobileForm.Btn_SignUp_PageClick(Sender: TObject); // ȸ������ ��ư
var
  TelephonyServiceNative: JObject;
  TelephonyManager: JTelephonyManager;
begin

  TelephonyServiceNative := SharedActivityContext.getSystemService
    (TJContext.JavaClass.TELEPHONY_SERVICE);
  TelephonyManager := TJTelephonyManager.Wrap
    ((TelephonyServiceNative as ILocalObject).GetObjectID);

  TabControl1.ActiveTab := TabItem6;
  Edit_PhoneNum.Text := JStringToString(TelephonyManager.getLine1Number);
  // ����� ��ȭ��ȣ ��������(�ȵ���̵�API)
end;

procedure TMobileForm.Btn_UpdateOrderClick(Sender: TObject); // �ֹ� �����ư
var
  CheckTime: TDateTime;
  Temp: double;
begin

  CheckTime := Dm.ReserveDataSet.FieldByName('R_ARRIVAL').AsDateTime; // �ð� üũ
  Temp := CheckTime - Now;
  if Temp <= 0.0032 then // 5�й̸� ���ǰ˻�(����ð��� 5�� �̸��� ��� ���� �Ұ�)
  begin
    Rect_info.Opacity := 1.0;
    Rect_info.AnimateFloat('Opacity', 0.0, 3.0);
    Exit;
  end;

  MessageDlg('���� �����Ͻðڽ��ϱ�?', TMsgDlgType.mtInformation,
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        Dm.Get_Menu(false); // �ֹ����� �޴��о����
        Btn_Order.Text := '�ֹ�����'; // ���� �����ϱ� �ؽ�Ʈ�� �ֹ��������� �ٲ���
        TabControl1.ActiveTab := TabItem4;
        OrderOrModi := false; // �ֹ����� ���� ����
        RoundRect1.Opacity := 1.0;
        RoundRect1.AnimateFloat('Opacity', 0.0, 3.0);
      end;
    end);

end;

procedure TMobileForm.Button1Click(Sender: TObject); // ������ȸ���� ����ȭ������ ���ư���
begin
  TabControl1.ActiveTab := TabItem2;
end;

procedure TMobileForm.Btn_OrderClick(Sender: TObject); // �ֹ� or ���ຯ�� ��ư
var
  Arrival_time: TDateTime;
begin
  if Edit_Arrival.Value = 0 then // ���� �����ð� ���Է�
  begin
    raise Exception.Create('���������ð��� �����ּ���');
  end;

  if OrderOrModi then // ���� �� ��
  begin
    MessageDlg('�����Ͻðڽ��ϱ�?', TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      var
        i, num, price: integer;
      begin
        i := 0;
        price := 0;
        if AResult = mrYes then
        begin
          Arrival_time := Now + (StrToInt(Edit_Arrival.Text) / (24 * 60));
          // ����ð��� ���������ð� ���ؼ� ����
          try
            demo.Reserve_Coffee(Total_Amount, Arrival_time,
              Payment_Box.Items[Payment_Box.ItemIndex], Lat, Long, LoginID,
              SelectCafe, SelectLoca, Memo1.Text); // Ŀ�� ����

            Dm.MenuDataSet.First;
            num := demo.Get_R_Num(LoginID); // ���� ��ȣ ��������

            while not Dm.MenuDataSet.EOF do
            begin
              if Dm.CheckQuantity[i].ItemIndex <> 0 then
              begin
                price := Dm.MenuDataSet.FieldByName('M_PRICE').AsInteger *
                  Dm.CheckQuantity[i].ItemIndex;
                demo.Reserve_list(num, Dm.CheckQuantity[i].ItemIndex, price,
                  Dm.MenuI[i].Title); // Ŀ�� ������ ����
              end;
              Dm.MenuDataSet.Next;
              Inc(i);
            end;

          except
            raise Exception.Create('���࿡ �����߽��ϴ�. ��� �� �ٽ� �õ��� �ּ���');
          end;
          ShowMessage('����Ǿ����ϴ�');
          Memo1.Text := '';
          Edit_Arrival.Text := '0';
          Payment_Box.ItemIndex := 0;
          TabControl1.ActiveTab := TabItem2;
        end;
      end);
  end
  else
  begin // ���� ���� �� ��
    MessageDlg('������ �����Ͻðڽ��ϱ�?', TMsgDlgType.mtInformation,
      [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
      procedure(const AResult: TModalResult)
      var
        i, num, price: integer;
      begin
        i := 0;
        price := 0;
        if AResult = mrYes then
        begin
          Arrival_time := Now + (StrToInt(Edit_Arrival.Text) / (24 * 60));
          // ����ð��� ���������ð� ���ؼ� ����
          try
            demo.Delete_Reserve(IntToStr(SeeReserve)); // ���� �������� ����

            demo.Reserve_Coffee(Total_Amount, Arrival_time,
              Payment_Box.Items[Payment_Box.ItemIndex], Lat, Long, LoginID,
              SelectCafe, SelectLoca, Memo1.Text); // Ŀ�� ����

            Dm.MenuDataSet.First;
            num := demo.Get_R_Num(LoginID); // ���� ��ȣ ��������

            while not Dm.MenuDataSet.EOF do
            begin
              if Dm.CheckQuantity[i].ItemIndex <> 0 then
              begin
                price := Dm.MenuDataSet.FieldByName('M_PRICE').AsInteger *
                  Dm.CheckQuantity[i].ItemIndex;
                demo.Reserve_list(num, Dm.CheckQuantity[i].ItemIndex, price,
                  Dm.MenuI[i].Title); // Ŀ�� ������ ����
              end;
              Dm.MenuDataSet.Next;
              Inc(i);
            end;

          except
            raise Exception.Create('���濡 �����߽��ϴ�. ��� �� �ٽ� �õ��� �ּ���');
          end;
          ShowMessage('����Ǿ����ϴ�');
          Memo1.Text := '';
          Edit_Arrival.Text := '0';
          Payment_Box.ItemIndex := 0;
          TabControl1.ActiveTab := TabItem2;
          OrderOrModi := true;
        end;
      end);
  end;
end;

procedure TMobileForm.Btn_SignUpClick(Sender: TObject); // ȸ������ ��ư
var
  Gender: integer;
begin
  if Edit_Id.Text = '' then // ���� Ȯ��
    raise Exception.Create('���̵� �Է����ּ���');

  if Edit_Name.Text = '' then
    raise Exception.Create('�̸��� �Է����ּ���');

  if Edit_Password.Text = '' then
    raise Exception.Create('��й�ȣ�� �Է����ּ���');

  if Edit_Password.Text <> Edit_RePassword.Text then
    raise Exception.Create('���Է� ��й�ȣ�� �ٸ��ϴ�');

  if not(Gender1.IsChecked) and not(Gender2.IsChecked) then
    raise Exception.Create('������ ������ �ּ���');

  if Edit_Age.Text = '' then
    raise Exception.Create('���̸� �Է��� �ּ���');

  if Gender1.IsChecked then // ���� Ȯ��
    Gender := 1
  else
    Gender := 0;

  try
    demo.Sign_Up(Edit_Id.Text, Edit_Name.Text, Edit_Password.Text,
      Edit_PhoneNum.Text, Gender, StrToInt(Edit_Age.Text));
  except
    raise Exception.Create('�����ϴ� ���̵��Դϴ�'); // �⺻Ű ����
  end;
  ShowMessage('ȸ������ �Ϸ�!');
  TabControl1.ActiveTab := TabItem1;
end;

procedure TMobileForm.FormCreate(Sender: TObject);
var
  aStream: TMemoryStream;
begin
  Distance := 3; // �ʱ�ȭ
  TabControl1.ActiveTab := TabItem1;
  LocationSensor1.Active := true;
  Rect_info.Opacity := 0;
  Edit_Arrival.Text := '0';
  Layout2.Visible := true;
  OrderOrModi := true;
  Btn_CancelOrder.Margins.Right := 0;
  TabControl1.TabPosition := TTabPosition.None;
  Text2.Margins.Top := 0;
  Layout12.Padding.Left := 0;
  Layout13.Padding.Left := 0;
  Layout14.Padding.Left := 0;
  Layout16.Padding.Left := 0;
  Layout17.Padding.Left := 0;
  Layout18.Padding.Left := 0;
  Btn_SignUp.Margins.Bottom := 0; // �ʱ�ȭ

  WebBrowser1.Navigate('about:blank'); // ���� ���� API����� ���� �ʱ� �۾�
  aStream := TMemoryStream.Create;
  try
    aStream.WriteBuffer(Pointer(HTMLStr)^, Length(HTMLStr)); // �ڹٽ�ũ��Ʈ �о����
    aStream.Seek(0, soFromBeginning);
    WebBrowser1.LoadFromStrings(HTMLStr, HTMLStr);
  finally
    aStream.Free;
  end;

end;

procedure TMobileForm.ListBox1ItemClick(const Sender: TCustomListBox;
// ���� ����Ʈ ��ư
const Item: TListBoxItem);
begin
  SelectCafe := Item.Text; // �����ϴ� �� ī�� �̸��� ��ġ ����
  SelectLoca := Item.ItemData.Detail;

  MessageDlg(SelectCafe + ' ' + SelectLoca + '�� �����Ͻðڽ��ϱ�?',
    TMsgDlgType.mtInformation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        TabControl1.ActiveTab := TabItem4;
        Dm.Get_Menu(true); // �޴� ��������
        RoundRect1.Opacity := 1.0;
        RoundRect1.AnimateFloat('Opacity', 0.0, 3.0);
        // �� �ι��ؾ� �ߴ°ɱ�..
      end;
    end);
end;

procedure TMobileForm.ListBox3ItemClick(const Sender: TCustomListBox;
// �������� �󼼺���
const Item: TListBoxItem);
begin
  Dm.ReserveDataSet.First;
  Dm.ReserveDataSet.MoveBy(ListBox3.ItemIndex); // �ش� �ε����� ������
  Dm.Get_Reserve_Detail(Dm.ReserveDataSet.FieldByName('R_NUM').AsString);
  // ������ ��������
  SeeReserve := Dm.ReserveDataSet.FieldByName('R_NUM').AsInteger;
  TabControl1.ActiveTab := TabItem8;
end;

procedure TMobileForm.LocationSensor1LocationChanged(Sender: TObject;
const OldLocation, NewLocation: TLocationCoord2D);
begin
  Lat := FormatFloat('#.#####', NewLocation.Latitude);
  Long := FormatFloat('#.#####', NewLocation.Longitude);
end;

procedure TMobileForm.Payment_BoxChange(Sender: TObject);
begin
  if Payment_Box.ItemIndex = 0 then
  begin
    Image4.Visible := true;
    Image5.Visible := false;
  end
  else
  begin
    Image4.Visible := false;
    Image5.Visible := true;
  end;

end;

end.
