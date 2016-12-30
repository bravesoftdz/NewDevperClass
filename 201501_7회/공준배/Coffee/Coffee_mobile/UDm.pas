unit UDm;

interface

uses
  System.SysUtils, System.Classes, Data.DBXDataSnap, IPPeerClient,
  Data.DBXCommon, Data.DB, Datasnap.DBClient, Datasnap.DSConnect, Data.SqlExpr,
  UClientClass, FMX.ListBox, FMX.Objects, FMX.Types, FMX.ExtCtrls,
  System.UITypes, System.UIConsts;

type
  TDm = class(TDataModule)
    SQLConnection1: TSQLConnection;
    DSProviderConnection1: TDSProviderConnection;
    CafeDataSet: TClientDataSet;
    CafeDataSetC_NAME: TWideStringField;
    CafeDataSetC_LOCA: TWideStringField;
    CafeDataSetC_LAT: TSingleField;
    CafeDataSetC_LONG: TSingleField;
    MenuDataSet: TClientDataSet;
    MenuDataSetM_NAME: TWideStringField;
    MenuDataSetM_PRICE: TIntegerField;
    MenuDataSetM_EPRICE: TIntegerField;
    MenuDataSetM_INFO: TWideStringField;
    MenuDataSetM_PHOTO: TBlobField;
    MenuDataSetM_CAFENAME: TWideStringField;
    AlphaDataSet: TClientDataSet;
    ReserveDetailDataSet: TClientDataSet;
    ReserveDataSet: TClientDataSet;
    ReserveDetailDataSetR_NUM: TIntegerField;
    ReserveDetailDataSetM_NAME: TWideStringField;
    ReserveDetailDataSetRL_QUANTITY: TIntegerField;
    ReserveDetailDataSetRL_PRICE: TIntegerField;
    ReserveDetailDataSetM_PRICE: TIntegerField;
    ReserveDetailDataSetM_INFO: TWideStringField;
    ReserveDetailDataSetM_PHOTO: TBlobField;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    MenuI: array of TMetropolisUIListBoxItem;
    DetailI: array of TMetropolisUIListBoxItem;
    CheckQuantity: array of TComboBox;
    procedure Calc_Distance;
    procedure Get_Menu(OrderOrModi: boolean);
    procedure Get_Reserve(LoginID: string);
    procedure Get_Reserve_Detail(Num: string);
  end;

var
  Dm: TDm;
  demo: TServerMethods1Client;

implementation

{ %CLASSGROUP 'FMX.Controls.TControl' }

uses Umain_mobile, System.Math;

{$R *.dfm}

procedure TDm.Calc_Distance; // �Ÿ����
var
  theta, dist: double;
  subI: TListboxItem;
  count: integer;
  BlobStream: TStream;
begin
  count := 0;
  CafeDataSet.First;
  AlphaDataSet.First;
  MobileForm.ListBox1.Clear;
  while not CafeDataSet.EOF do
  begin
    theta := CafeDataSetC_LONG.Value - StrToFloat(MobileForm.Long);
    dist := sin(degTorad(CafeDataSetC_LAT.Value)) *
      sin(degTorad(StrToFloat(MobileForm.Lat))) +
      cos(degTorad(CafeDataSetC_LAT.Value)) *
      cos(degTorad(StrToFloat(MobileForm.Lat))) * cos(degTorad(theta));
    dist := arccos(dist);
    dist := radTodeg(dist);
    dist := dist * 60 * 1.1515;
    dist := dist * 1.609344;

    if MobileForm.Distance >= dist then // dist�� ������ ������ ������ ������ ��ġ ���
    begin
      MobileForm.WebBrowser1.EvaluateJavaScript
        ('SetMarkers(' + FloatToStr(CafeDataSetC_LAT.Value) + ',' +
        FloatToStr(CafeDataSetC_LONG.Value) + ',' + IntToStr(count) + ');');
      Inc(count); // ������ ��ġ ���

      subI := TListboxItem.Create(MobileForm.ListBox1); // ����Ʈ�ڽ��� �ش���ġ ���
      subI.Text := CafeDataSet.FieldByName('C_NAME').AsString;
      subI.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
      subI.ItemData.Detail := CafeDataSet.FieldByName('C_LOCA').AsString;
      subI.StyleLookup := 'listboxitembottomdetail';
      subI.TextSettings.FontColor := claWhite;

      BlobStream := TStream.Create; // ����Ʈ�ڽ� �����ܿ� ���� �̹���(���ĺ�) �ѷ��ִ� �۾�
      BlobStream := AlphaDataSet.CreateBlobStream
        (AlphaDataSet.FieldByName('I_ALPHABET'), TBlobStreamMode.bmRead);
      subI.ItemData.Bitmap.LoadFromStream(BlobStream);
      AlphaDataSet.Next;

      MobileForm.ListBox1.AddObject(subI);
      CafeDataSet.Next;

      if AlphaDataSet.EOF then // ����� ���ĺ����� ���� ���� �˻��� �����ϱ�
        break;
    end
    else
      CafeDataSet.Next;
  end;
end;

procedure TDm.DataModuleCreate(Sender: TObject);
begin
  SQLConnection1.Connected := true;
  CafeDataSet.Active := true;
  demo := TServerMethods1Client.Create(SQLConnection1.DBXConnection);
end;

procedure TDm.Get_Menu(OrderOrModi: boolean); // �޴� ��������
var
  Image: TImageViewer;
  BlobStream: TStream;
  i, j: integer;
  Text: TText;
begin
  i := 0;
  MenuI := nil;
  CheckQuantity := nil;
  SetLength(MenuI, MenuDataSet.RecordCount);
  SetLength(CheckQuantity, MenuDataSet.RecordCount);
  BlobStream := TStream.Create;
  MobileForm.ListBox2.Clear;
  MenuDataSet.First;

  while not MenuDataSet.EOF do // ����Ʈ�ڽ��� �޴� �������� �ѷ��ֱ�
  begin
    MenuI[i] := TMetropolisUIListBoxItem.Create(MobileForm.ListBox2);
    // ����Ʈ ������ ���� ����
    MenuI[i].Title := MenuDataSet.FieldByName('M_NAME').AsString;
    MenuI[i].SubTitle := MenuDataSet.FieldByName('M_PRICE').AsString + '��';
    MenuI[i].Description := MenuDataSet.FieldByName('M_INFO').AsString;
    MobileForm.ListBox2.AddObject(MenuI[i]);

    Image := TImageViewer.Create(MenuI[i]);
    Image.Parent := MenuI[i];
    Image.Align := TAlignLayout.Left;
    Image.Width := 130;
    BlobStream := MenuDataSet.CreateBlobStream
      (MenuDataSet.FieldByName('M_PHOTO'), TBlobStreamMode.bmRead);
    Image.Bitmap.LoadFromStream(BlobStream);

    Text := TText.Create(MenuI[i]); // �ؽ�Ʈ ��������
    Text.Parent := MenuI[i];
    Text.Height := 20;
    Text.Width := 20;
    Text.Text := '��';
    Text.Position.X := MenuI[i].Width - Text.Width;
    Text.Position.Y := Text.Position.Y + 7;
    Text.Visible := true;
    Text.TextSettings.FontColor := claWhite;

    CheckQuantity[i] := TComboBox.Create(MenuI[i]); // �޺��ڽ� ��������
    CheckQuantity[i].Parent := MenuI[i];
    CheckQuantity[i].Height := 25;
    CheckQuantity[i].Width := 50;
    CheckQuantity[i].Position.X := MenuI[i].Width - CheckQuantity[i].Width -
      Text.Width;
    CheckQuantity[i].Position.Y := CheckQuantity[i].Position.Y + 5;
    for j := 0 to 10 do
      CheckQuantity[i].Items.Add(IntToStr(j));

    if OrderOrModi then // �������� ���
      CheckQuantity[i].ItemIndex := 0 // �޺��ڽ� �ʱ��ε����� 0
    else // �ֹ� ���� ��� �� ���
    begin
      ReserveDetailDataSet.First;
      while not ReserveDetailDataSet.EOF do
      begin
        if MenuDataSet.FieldByName('M_NAME').AsString = ReserveDetailDataSet.
          FieldByName('M_NAME').AsString then
        begin
          CheckQuantity[i].ItemIndex := ReserveDetailDataSet.FieldByName
            ('RL_QUANTITY').AsInteger; // �޺��ڽ� �ʱ��ε����� ������ִ� �ֹ����� ������ ����
          break;
        end;
        CheckQuantity[i].ItemIndex := 0; // �ֹ� ���� Ŀ�Ǵ� �ʱ��ε��� 0
        ReserveDetailDataSet.Next;
      end;
    end;
    CheckQuantity[i].Visible := true;

    Inc(i);
    MenuDataSet.Next;
  end;

  if not OrderOrModi then // �ֹ� ���� ��� �� �� �� �������� ������ ����ϱ�
  begin
    MobileForm.Edit_Arrival.Text := '0'; // ���������ð� 0 ���� �ʱ�ȭ

    if ReserveDataSet.FieldByName('R_PAYMENT_PLAN').AsString = '����' then
    // ������ ������ ���ݰ���� ���
    begin
      MobileForm.Payment_Box.ItemIndex := 0;
      MobileForm.Image4.Visible := true;
      MobileForm.Image5.Visible := false;
    end
    else // ������ ������ ī������ ���
    begin
      MobileForm.Payment_Box.ItemIndex := 1;
      MobileForm.Image4.Visible := false;
      MobileForm.Image5.Visible := true;
    end;

    MobileForm.Memo1.Lines.Clear;
    MobileForm.Memo1.Lines.Text := ReserveDataSet.FieldByName
      ('R_COMMENT').AsString;
    // ������ ���� �߰��䱸���� ������ �޸� ���
  end;

end;

procedure TDm.Get_Reserve(LoginID: string); // �������� ��������
var
  ReserveI: TListboxItem;
  Arrival: TText;
begin
  demo.Get_Reserve(LoginID); // �ش� ���̵��� �������� ��������
  ReserveDataSet.Close; // ���ΰ�ħ
  ReserveDataSet.Open;
  ReserveDataSet.First;

  MobileForm.ListBox3.Clear;
  while not ReserveDataSet.EOF do // �������� ����Ʈ�ڽ��� ���
  begin
    ReserveI := TListboxItem.Create(MobileForm.ListBox3); // ����Ʈ �ڽ� ������ ���� ����
    ReserveI.Text := ReserveDataSet.FieldByName('C_NAME').AsString;
    ReserveI.ItemData.Accessory := TListBoxItemData.TAccessory.aMore;
    ReserveI.ItemData.Detail := ReserveDataSet.FieldByName('C_LOCA').AsString;
    ReserveI.StyleLookup := 'listboxitembottomdetail';
    ReserveI.TextSettings.FontColor := claWhite;
    MobileForm.ListBox3.AddObject(ReserveI); // ī�� �̸�, ��ġ ���

    Arrival := TText.Create(ReserveI); // �ؽ�Ʈ ���� ����
    Arrival.Parent := ReserveI; // ����ð� ���
    Arrival.Text := '����ð� :' + ReserveDataSet.FieldByName('R_ARRIVAL').AsString;
    Arrival.Align := TAlignLayout.Center;
    Arrival.Width := 120;
    Arrival.HitTest := false;
    Arrival.TextSettings.FontColor := claWhite;
    ReserveDataSet.Next;
  end;
end;

procedure TDm.Get_Reserve_Detail(Num: string); // �� �������� ��������
var
  Image: TImageViewer;
  BlobStream: TStream;
  i, j: integer;
  Text: TText;
begin
  i := 0;
  DetailI := nil;
  demo.Get_Reserve_Detail(Num); // �� ���� ��������
  ReserveDetailDataSet.Close; // ���ΰ�ħ
  ReserveDetailDataSet.Open;
  SetLength(DetailI, ReserveDetailDataSet.RecordCount);

  ReserveDetailDataSet.First;
  MobileForm.ListBox4.Clear;

  MobileForm.TName_Loca.Text := ReserveDataSet.FieldByName('C_NAME').AsString +
    '  ' + ReserveDataSet.FieldByName('C_LOCA').AsString; // ī�� �̸� �� ��ġ ���
  MobileForm.TPayment.Text := ReserveDataSet.FieldByName('R_PAYMENT_PLAN')
    .AsString; // ������� ���
  MobileForm.TArrival.Text := ReserveDataSet.FieldByName('R_ARRIVAL').AsString;
  // ���������ð� ���
  MobileForm.TTotal.Text := ReserveDataSet.FieldByName('R_TOTAL_AMOUNT')
    .AsString + ' ��'; // �� ���� �ݾ� ���
  MobileForm.MComment.Lines.Clear;
  MobileForm.MComment.Lines.Text := ReserveDataSet.FieldByName('R_COMMENT')
    .AsString; // �߰� �䱸 ���� ���

  while not ReserveDetailDataSet.EOF do // ������ Ŀ�� ��� ���
  begin
    DetailI[i] := TMetropolisUIListBoxItem.Create(MobileForm.ListBox2);
    // ����Ʈ �ڽ� ������ ���� ����
    DetailI[i].Title := ReserveDetailDataSet.FieldByName('M_NAME').AsString;
    // Ŀ�� �̸� ���
    DetailI[i].SubTitle := ReserveDetailDataSet.FieldByName('M_PRICE').AsString
      + '��'; // Ŀ�� 1�� ���� ���
    DetailI[i].Description := '�� ' + ReserveDetailDataSet.FieldByName
      ('RL_PRICE').AsString + '��'; // �ֹ��� Ŀ�� �� �� x ���� ���
    MobileForm.ListBox4.AddObject(DetailI[i]);

    Image := TImageViewer.Create(DetailI[i]); // Ŀ�� �̹��� ��������
    Image.Parent := DetailI[i];
    Image.Align := TAlignLayout.Left;
    Image.Width := 130;
    BlobStream := ReserveDetailDataSet.CreateBlobStream
      (ReserveDetailDataSet.FieldByName('M_PHOTO'), TBlobStreamMode.bmRead);
    Image.Bitmap.LoadFromStream(BlobStream);

    Text := TText.Create(DetailI[i]); // �ؽ�Ʈ ���� ����
    Text.Parent := DetailI[i];
    Text.Height := 20;
    Text.Width := 40;
    Text.Text := ReserveDetailDataSet.FieldByName('RL_QUANTITY').AsString +
      ' ��'; // �ֹ��� �� �� ���
    Text.Position.X := DetailI[i].Width - Text.Width;
    Text.Position.Y := Text.Position.Y + 7;
    Text.TextSettings.FontColor := claWhite;

    Inc(i);
    ReserveDetailDataSet.Next;
  end;
end;

end.
