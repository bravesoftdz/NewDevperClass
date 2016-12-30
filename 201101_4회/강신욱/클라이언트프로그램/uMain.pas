unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, DB, Outline, IdGlobal, Menus,
  ImgList, SyncObjs;

type
  TfmMain = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Image1: TImage;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Image_Pic: TImage;
    Label_Weather: TLabel;
    button_Message: TSpeedButton;
    button_Talk: TSpeedButton;
    button_Report: TSpeedButton;
    ListView_Emp_List: TTreeView;
    Timer1: TTimer;
    Label_MyInfo: TLabel;
    PopupMenu_EmpStat: TPopupMenu;
    EmpStat: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Panel_MyStat: TPanel;
    ImageList1: TImageList;
    Image_weather: TImage;
    BalloonHint1: TBalloonHint;
    procedure button_MessageClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListView_Emp_ListDblClick(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure EmpStatClick(Sender: TObject);
    procedure button_ReportClick(Sender: TObject);
  private
    { Private declarations }
    procedure Init_ListView;
    procedure Init_MyInfo;
    procedure show_SendMessageForm(ReceiveName : String);
    procedure show_weather;
  public
    { Public declarations }
    procedure show_ReceiveMessageForm(Msg, SendName : String);
  end;
type
  Emp_Info = record
    Code : Integer;
    Name : String;
    dept : String;
    ClassName : String;
  end;
  Emp_Info_prt = ^Emp_Info;

type
  TClientThread = Class(TThread)
    procedure Execute; override;
  end;
var
  fmMain: TfmMain;
  Emp_prt : Emp_Info_prt;
  LockValue:TCriticalSection;
  ClientThread : TClientThread;

implementation

uses uMessage, ServerMethodsUnit, uDMclient, Connected_Emp_Info,
  MessageProtocol, FormShape, MessagePaser, TraceportCodeToName, weather,
  uReport;

{$R *.dfm}


procedure TfmMain.button_ReportClick(Sender: TObject);
begin
  fmReport := TfmReport.Create(Application);
  fmReport.Show;
end;

procedure TfmMain.FormActivate(Sender: TObject);
begin
  Top := Top;
  Left:= Left;
  show_weather;
end;

procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i, j : Integer;
begin
  for I := 0 to ListView_Emp_List.Items.Count-1 do
    if ListView_Emp_List.Items[i].Data <> nil then
      Dispose(Emp_Info_prt(ListView_Emp_List.Items[i].Data));
  Hide;

  ClientThread.Free;
  LockValue.Free;

  Action := caFree;
end;

//����Ʈ�信 ������ �Ѹ��� �κ�
procedure TfmMain.FormCreate(Sender: TObject);
begin
  Init_MyInfo;
  Init_ListView;




  //�α��� �ߴٴ� ������ ������ ����..
  DMClient.IdTCPClient1.IOHandler.Writeln(Myinfo.LoginMsg, enUTF8);

  //�� �ٵ��..
  DrawRounded(fmMain);
  DrawRounded(Panel1);
  DrawRounded(Panel2);

  // ���� ������ ���ſ� ������ ����..
  ClientThread := TClientThread.Create(True);
end;

//����Ʈ�信 ���� ����� �μ����� �ѷ���
procedure TfmMain.Init_ListView;
var
  Emp_Info_DataSet : TDataSet;
  wk_dept, wk_Name : String;
begin
  try
    //serverMethod := TServerMethods1Client.create(DMClient.SQLConnection_Client.DBXConnection);
    //Emp_Info_DataSet := serverMethod.Get_Emp_TreeInfo;
    with DMClient.ClientDataSet_EmpInfo do
    begin
      while not eof  do
      begin
        if MyInfo.Code = FieldByName('code').AsInteger  then  //���� ������ ����Ʈ�信 �ȻѸ�;..
        begin
          next;
          Continue;
        end;
        new(Emp_prt);
        if wk_dept <> FieldByName('dept').AsString then
          ListView_Emp_List.Selected := ListView_Emp_List.Items.Add
            (ListView_Emp_List.Selected, fieldByName('Dept').AsString);
        Emp_prt^.Code := (FieldByName('code').AsInteger);
        Emp_prt^.dept := (FieldByName('Dept').AsString);
        Emp_prt^.Name := (FieldByName('NAME').AsString);
        Emp_prt^.ClassName    := FieldByName('Class').AsString;
        wk_Name := FieldByName('Name').AsString + ' [' + Emp_prt^.ClassName + ']';
        ListView_Emp_List.Items.AddChildObject(ListView_Emp_List.selected, wk_Name, Emp_prt);
        wk_dept := FieldByName('Dept').AsString;
        Next;
      end;
    end;
  finally
    //serverMethod.Free;
  end;
end;

// �α��ν� ���� ������ ������ ���� �����´�.
procedure TfmMain.Init_MyInfo;
var
  Logined_Emp_Info : TDataSet;
  Stream : TStream;
  Image : TImage;
begin
  MyInfo := TEmployee_Logined.create;
  Stream := TStream.Create;
  try
    //serverMethod := TserverMethods1client.Create(dmClient.SQLCOnnection_CLient.DBXConnection);
    //Logined_Emp_Info := ServerMethod.Get_Logined_info(LoginedCode);
    DMClient.ClientDataSet_Login.Close;
    DMClient.ClientDataSet_Login.Params[0].AsInteger := LoginedCode;
    DMClient.ClientDataSet_Login.Open;
    with DMClient.ClientDataSet_Login do
    begin
      MyInfo.Code  := FieldByName('CODE').AsInteger;
      Myinfo.Name  := fieldByName('NAME').Asstring;
      MyInfo.Dept  := FieldByname('DEPT').AsString;
      MyInFo.Rank  := FieldByName('ClASS').AsString;
      MyInfo.Region :=  FieldByName('WORK_REGION').AsString;
      Stream       := CreateBlobStream(FieldByName('ID_PIC'), bmRead);
      MyInfo.ID_PIC.Picture.Bitmap.LoadFromStream(Stream);
      Image_Pic.Picture.Bitmap := MyInfo.ID_PIC.Picture.Bitmap;
      Label_MyInfo.Caption := MyInfo.Name + '-' + MyInfo.Dept + '[' + MyInfo.Rank + ']';
    end;
  finally
    Stream.Free;
  end;
end;




procedure TfmMain.ListView_Emp_ListDblClick(Sender: TObject);    //����Ʈ �޴� ���� Ŭ���� ���� ����..
begin
  if not (Sender as TtreeView).Selected.HasChildren  then
  begin
    //Ŭ���� ������ ����� ����
    MyInfo.RecieveCode := EMp_Info_prt(ListView_Emp_List.Selected.Data)^.Code;
    show_SendMessageForm(EMp_Info_prt(ListView_Emp_List.Selected.Data)^.Name);
  end;
end;

//�ٹ� ���¸� ��Ÿ���� �˾� �޴�.. �ٸ� ��ȭ ���� ĸ�Ǹ� ����
procedure TfmMain.EmpStatClick(Sender: TObject);
begin
  Panel_MyStat.Caption := copy((Sender as TMenuitem).Caption, 1, 3);
end;

procedure TfmMain.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if y < Panel3.Top then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, $F012, 0);
  end;
end;

procedure TfmMain.show_ReceiveMessageForm(Msg, SendName: String);
var
  TrancprotCode : TTrancportCode;
begin
  //�ڵ� ��ȯ Ŭ���� ����..(�̱��� ����)
  TrancprotCode := TTrancportCode.Create;
  try
    fmMessage := TfmMessage.Create(Application);
    fmMessage.Show;
    fmMessage.Top   := Top;
    fmMessage.Left  := Width+Left;
    fmMessage.Edit_ReceiveName.Text := TrancprotCode.ConversionCodeToName(SendName);
    fmMessage.Memo_Message.Text := Msg;
    fmMessage.Label_LoginCheck.Caption := '�޼��� ���� �ð�' + '['  + DateTimeToStr(Now) + ']';
    fmMessage.Shape1.Hide;
    fmMessage.button_Send.Visible := False;
  finally
    TrancprotCode.Free;
  end;
end;

procedure TfmMain.show_SendMessageForm(ReceiveName : string);
begin
  fmMessage := TfmMessage.Create(Application);
  fmMessage.Show;
  fmMessage.Top   := Top;
  fmMessage.Left  := width;
  fmMessage.ReceiveName := ReceiveName;
end;

procedure TfmMain.show_weather;
var
  Temp : String;
  ixCurrent : IXMLCurrentType;
  procedure Weather_Image( ImageIndex : Integer);
  begin
    Image_weather.Picture.LoadFromFile('../../doc/1.bmp'); //����Ʈ�� ����..
    case iMageIndex of
    1 : Image_weather.Picture.LoadFromFile('../../doc/1.bmp');
    3 : Image_weather.Picture.LoadFromFile('../../doc/2.bmp');
    2 : Image_weather.Picture.LoadFromFile('../../doc/3.bmp');
    11: Image_weather.Picture.LoadFromFile('../../doc/4.bmp');
    end;

    case iMageIndex of
    1 : Label_Weather.Caption := '����';
    3 : Label_Weather.Caption := '��������';
    2 : Label_Weather.Caption := '��';
    11 : Label_Weather.Caption := '��';
    end;
  end;
begin
  ixCurrent := Loadcurrent('../../../Test1.xml');
  with iXCurrent.Weather do
    Label_Weather.hint := '������ ���Žð� ' + IntToStr(Year) +'�� ' +
                          IntToStr(Month) + '�� '  + IntToStr(day) + '�� ' +
                          IntToStr(Hour) + '��';

  if MyInfo.Region = '�λ�' then
  begin
    With iXCurrent.Weather.Local[89] do
    begin
      if Icon < 0 then Icon := 1;
      Weather_Image(Icon);
      Label_Weather.Caption :=  Label_Weather.Caption  + '��� ' + Ta + '��';
    end;
  end;

  if MyInfo.Region = '����' then
  begin
    With iXCurrent.Weather.Local[79] do
    begin
      Weather_Image(Icon);
      Label_Weather.Caption :=  Label_Weather.Caption  + '��� ' + Ta + '��';
    end;
  end;

  if Myinfo.Region = '��õ' then
  begin
    With iXCurrent.Weather.Local[67] do
    begin
      Weather_Image(Icon);
      Label_Weather.Caption :=  Label_Weather.Caption  + '��� ' + Ta + '��';
    end;
  end;

end;

procedure TfmMain.SpeedButton1Click(Sender: TObject);
begin
   close;
end;

procedure TfmMain.button_MessageClick(Sender: TObject);
begin
  fmMessage := TfmMessage.Create(Application);
  fmMessage.Show;
  fmMessage.Top   := Top;
  fmMessage.Left  := Width+Left;
end;

procedure TfmMain.Timer1Timer(Sender: TObject);
var
  stTemp : string;

begin
  if (DMClient.IdTCPClient1.Connected = False) then
    Exit;
   if DMClient.IdTCPClient1.IOHandler.InputBuffer.Size <= 0 then
    Exit;
  if DMClient.IdTCPClient1.IOHandler.InputBufferIsEmpty then
    Exit;
  stTemp :=  DMClient.IdTCPClient1.Socket.ReadLn(enUTF8);
  if stTEmp <> '' then
  begin
    stringParser := TStringParser.Create;
    stringParser.Text := stTemp;
    show_ReceiveMessageForm(stringParser.Msg, stringParser.ReceiveCode);
  end;


end;

{ ClientThread }
// Ÿ�̸Ӹ� �̿��� üũ�ϴ°� ���...

procedure TClientThread.Execute;
begin
  inherited;

  LockValue.Acquire;
  try
    if (DMClient.IdTCPClient1.Connected = False) then
      Exit;
    if DMClient.IdTCPClient1.IOHandler.InputBuffer.Size <= 0 then
      Exit;
    if DMClient.IdTCPClient1.IOHandler.InputBufferIsEmpty then
      Exit;

  if DMClient.IdTCPClient1.Socket.ReadLn <> '' then
  begin
    stringParser := TStringParser.Create;
    stringParser.Text := DMClient.IdTCPClient1.Socket.ReadLn;
    fmMain.show_ReceiveMessageForm(stringParser.Msg, stringParser.ReceiveCode);
  end;
  finally
    LockValue.Release;
  end;
  Sleep(300);
end;

end.
