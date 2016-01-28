unit MainForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.Memo, FMX.Controls.Presentation, FMX.Edit,
  FMX.Layouts, FMX.Objects, FMX.Effects, FMX.ListBox, FMX.ListView,
  FMX.StdCtrls, FMX.TabControl, System.Rtti, System.Bindings.Outputs,
  FMX.Bind.Editors, Data.Bind.EngExt, FMX.Bind.DBEngExt, Data.Bind.Components,
  System.Actions, FMX.ActnList, Data.Bind.DBScope, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ScrollBox, FMX.WebBrowser;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    ToolBar1: TToolBar;
    Label1: TLabel;
    btnNewItem: TButton;
    ListView1: TListView;
    ToolBar2: TToolBar;
    Label2: TLabel;
    btnBackList: TButton;
    btnDetail: TButton;
    Layout1: TLayout;
    ListBox1: TListBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    lblPublisher: TLabel;
    lblPhone: TLabel;
    lblWebSite: TLabel;
    lblComment: TLabel;
    OverflowMenu: TListBox;
    ShadowEffect2: TShadowEffect;
    lstItemModify: TListBoxItem;
    lstItemDelete: TListBoxItem;
    Rectangle1: TRectangle;
    ShadowEffect1: TShadowEffect;
    Image1: TImage;
    Layout2: TLayout;
    lblTitle: TLabel;
    lblAuthor: TLabel;
    ToolBar3: TToolBar;
    Label3: TLabel;
    btnCancel: TButton;
    btnSaveItem: TButton;
    vsbEditFocus: TVertScrollBox;
    lytContentsNew: TLayout;
    Layout4: TLayout;
    Rectangle2: TRectangle;
    imgNewItem: TImage;
    ListBox2: TListBox;
    ListBoxItem7: TListBoxItem;
    ListBoxItem8: TListBoxItem;
    ListBoxitem9: TListBoxItem;
    ListBoxItem10: TListBoxItem;
    ListBoxItem11: TListBoxItem;
    ListBoxItem12: TListBoxItem;
    edtTitle: TEdit;
    edtAuthor: TEdit;
    edtPublisher: TEdit;
    edtPhone: TEdit;
    edtWebSite: TEdit;
    mmoComment: TMemo;
    BindingsList1: TBindingsList;
    ActionList1: TActionList;
    ChangeTabAction1: TChangeTabAction;
    BindSourceDB1: TBindSourceDB;
    LinkPropertyToFieldText6: TLinkPropertyToField;
    LinkControlToField6: TLinkControlToField;
    LinkPropertyToFieldBitmap2: TLinkPropertyToField;
    refresh: TButton;
    count: TLabel;
    TabItem4: TTabItem;
    ToolBar4: TToolBar;
    WebBrowser1: TWebBrowser;
    Button2: TButton;
    TabItem5: TTabItem;
    Layout3: TLayout;
    Label5: TLabel;
    Label6: TLabel;
    edtIP: TEdit;
    edtport: TEdit;
    Button3: TButton;
    Button4: TButton;
    procedure ListView1ItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnNewItemClick(Sender: TObject);
    procedure btnBackListClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveItemClick(Sender: TObject);
    procedure btnDetailClick(Sender: TObject);
    procedure lstItemModifyClick(Sender: TObject);
    procedure lstItemDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblPhoneClick(Sender: TObject);
    procedure lblWebSiteClick(Sender: TObject);
    procedure imgNewItemClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure refreshClick(Sender: TObject);

    procedure TabItem4Resize(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    FKBBounds: TRectF;
    FNeedOffset: Boolean;
    procedure GotoList;
    procedure GotoDetail;
    procedure GotoNew;
    procedure GotoWeb;
    procedure CalcContentBoundsProc(Sender: TObject; var ContentBounds: TRectF);
    procedure RestorePosition;
    procedure UpdateKBBounds;
    procedure ChangeImageEvent(Image: Tbitmap);
    procedure OpneURL;
    procedure refreshbtn();
    { Private declarations }

  public
    procedure FormFocusChanged(Sender: TObject);
    procedure FormVirtualKeyboardShown(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    procedure FormVirtualKeyboardHidden(Sender: TObject;
      KeyboardVisible: Boolean; const Bounds: TRect);
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
{$R *.LgXhdpiPh.fmx ANDROID}

uses DataAccessModule, System.Math, FMX.Platform, FMX.PhoneDialer,
  WebBrowserFrame, PhotoFrame;

{ TForm1 }

// ����Ʈ�� ����
procedure TForm1.btnBackListClick(Sender: TObject);
begin
  // dmDataAccess.CancelItem;
  GotoList;
end;

// ���
procedure TForm1.btnCancelClick(Sender: TObject);
begin
  GotoList;
end;

// �ڼ��� ����
procedure TForm1.btnDetailClick(Sender: TObject);
begin
  OverflowMenu.Visible := not OverflowMenu.Visible;
  if OverflowMenu.Visible then
  begin
    OverflowMenu.ItemIndex := -1;
    OverflowMenu.BringToFront;
    OverflowMenu.ApplyStyleLookup;
    OverflowMenu.RealignContent;
    OverflowMenu.Position.X := Width - OverflowMenu.Width - 5;
    OverflowMenu.Position.Y := ToolBar2.Height;
  end;
end;

// ���� �����
procedure TForm1.btnNewItemClick(Sender: TObject);
begin
  ListView1.ItemIndex := -1;
  dmDataAccess.AppendMode;
  GotoNew;
end;

// �߰�
procedure TForm1.btnSaveItemClick(Sender: TObject);
begin
  dmDataAccess.SaveItem;
  refreshbtn;
  GotoList;
end;

// ���ΰ�ħ�Ͽ� ī��Ʈ
procedure TForm1.refreshbtn;
begin
  // count.text := '(' + demo.
end;

procedure TForm1.refreshClick(Sender: TObject);
begin
  refreshbtn;;
end;

// ��ϰ���
procedure TForm1.Button2Click(Sender: TObject);
begin
  GotoList;
end;

// �α���
procedure TForm1.Button3Click(Sender: TObject);
begin
  try
    dmDataAccess.SQLConnection1.Close;
    dmDataAccess.SQLConnection1.Params.Values['HostName'] := edtIP.Text;
    dmDataAccess.SQLConnection1.Params.Values['Port'] := edtport.Text;
    dmDataAccess.SQLConnection1.Open;
    ChangeTabAction1.Tab := TabItem1;
    ChangeTabAction1.ExecuteTarget(nil);
  except
    // showmessage('d');
  end;
  GotoList;
end;

// ������ ����
procedure TForm1.Button4Click(Sender: TObject);
begin
  GotoWeb;
end;

// �������ϱ�
procedure TForm1.FormCreate(Sender: TObject);
begin
  // DataAccessModule.dmDataAccess.ClientDataSet2.Close;

  TabControl1.TabPosition := TTabPosition.None;
  TabControl1.TabIndex := 0;

  OverflowMenu.Visible := False;

  vsbEditFocus.OnCalcContentBounds := CalcContentBoundsProc; // �߰�

end;

procedure TForm1.FormFocusChanged(Sender: TObject);
begin
  UpdateKBBounds;
end;
 //Ű ������
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
  Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if Assigned(frPhoto) then
    begin
      frPhoto.CloseFrame;
      Key := 0;
    end;

    if Assigned(frWebBrowser) then
    begin
      frWebBrowser.CloseFrame;
      Key := 0;
    end;
  end;
end;
 //Ű���� �����
procedure TForm1.FormVirtualKeyboardHidden(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds.Create(0, 0, 0, 0);
  FNeedOffset := False;
  RestorePosition;
end;
//Ű���� ���̱�
procedure TForm1.FormVirtualKeyboardShown(Sender: TObject;
  KeyboardVisible: Boolean; const Bounds: TRect);
begin
  FKBBounds := TRectF.Create(Bounds);
  FKBBounds.TopLeft := ScreenToClient(FKBBounds.TopLeft);
  FKBBounds.BottomRight := ScreenToClient(FKBBounds.BottomRight);
  UpdateKBBounds;
end;
//��������
procedure TForm1.GotoDetail;
begin
  ChangeTabAction1.Tab := TabItem2;
  ChangeTabAction1.ExecuteTarget(nil);
end;
//����Ʈ
procedure TForm1.GotoList;
begin
  ChangeTabAction1.Tab := TabItem1;
  ChangeTabAction1.ExecuteTarget(nil);
end;
//���ΰ���
procedure TForm1.GotoNew;
begin
  ChangeTabAction1.Tab := TabItem3;
  ChangeTabAction1.ExecuteTarget(nil);
end;
 //������
procedure TForm1.GotoWeb;
begin
  ChangeTabAction1.Tab := TabItem4;
  ChangeTabAction1.ExecuteTarget(nil);
end;
//���̹����ֱ�
procedure TForm1.imgNewItemClick(Sender: TObject);
begin
  TfrPhoto.CreateAndShow(Self, ChangeImageEvent, nil);
end;
//��ȭ�ɱ�
procedure TForm1.lblPhoneClick(Sender: TObject);
var
  PhoneDlrSvc: IFMXPhoneDialerService;
begin
  if TPlatformServices.Current.SupportsPlatformService(IFMXPhoneDialerService,
    IInterface(PhoneDlrSvc)) then
    PhoneDlrSvc.Call(lblPhone.Text);
end;

// ������Ʈ ����
procedure TForm1.lblWebSiteClick(Sender: TObject);
begin
  TfrWebBrowser.CreateAndShow(Self, lblWebSite.Text);
  // GotoWeb;
end;

// ����Ʈ ������ Ŭ��
procedure TForm1.ListView1ItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  GotoDetail;
end;

// ����
procedure TForm1.lstItemDeleteClick(Sender: TObject);
begin
  OverflowMenu.Visible := False;

  MessageDlg('�ش� ������ �����Ͻðڽ��ϱ�?', TMsgDlgType.mtWarning,
    [TmsgDlgBtn.mbYes, TmsgDlgBtn.mbNo], 0,
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        dmDataAccess.DeleteItem;
        GotoList;
      end;
    end);
end;

// ���ΰ�ħ
procedure TForm1.lstItemModifyClick(Sender: TObject);
begin
  OverflowMenu.Visible := False;
  // dmDataAccess.EditMode;
  dmDataAccess.EditMode;
  GotoNew;
end;

// url ����
procedure TForm1.OpneURL;
begin
  WebBrowser1.Navigate(lblWebSite.Text);
end;

procedure TForm1.CalcContentBoundsProc(Sender: TObject;
var ContentBounds: TRectF);
begin
  if FNeedOffset and (FKBBounds.Top > 0) then
  begin
    ContentBounds.Bottom := Max(ContentBounds.Bottom,
      2 * ClientHeight - FKBBounds.Top);
  end;
end;

// �̹����̺�Ʈ
procedure TForm1.ChangeImageEvent(Image: Tbitmap);
begin
  imgNewItem.Bitmap.Assign(Image);
  dmDataAccess.SetImage(Image);
end;

// ��ġ ������
procedure TForm1.RestorePosition;
begin
  vsbEditFocus.ViewportPosition := PointF(vsbEditFocus.ViewportPosition.X, 0);
  lytContentsNew.Align := TALignLayout.Client;
  vsbEditFocus.RealignContent;
end;

// ���� ������ url ����
procedure TForm1.TabItem4Resize(Sender: TObject);
begin
  OpneURL;
end;

procedure TForm1.UpdateKBBounds;
var
  LFocused: TControl;
  LFocusRect: TRectF;
begin
  FNeedOffset := False;
  if Assigned(Focused) then
  begin
    LFocused := TControl(Focused.GetObject);

    LFocusRect := LFocused.AbsoluteRect;
    LFocusRect.Offset(vsbEditFocus.ViewportPosition);
    if (LFocusRect.IntersectsWith(TRectF.Create(FKBBounds))) and
      (LFocusRect.Bottom > FKBBounds.Top) then
    begin
      FNeedOffset := True;
      lytContentsNew.Align := TALignLayout.Horizontal;
      vsbEditFocus.RealignContent;
      Application.ProcessMessages;
      vsbEditFocus.ViewportPosition := PointF(vsbEditFocus.ViewportPosition.X,
        LFocusRect.Bottom - FKBBounds.Top);
    end;
  end;
  if not FNeedOffset then
    RestorePosition;
end;

end.
