unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Calendar, ComCtrls, ExtCtrls, StdCtrls, ActnList, StdActns,
  PlatformDefaultStyleActnCtrls, ActnMan, ActnCtrls, ToolWin, ActnMenus, ImgList,
  Spin, Buttons, DBGrids, Menus;

type
  TMainForm = class(TForm)
    ListBox5: TListBox;
    ListBox7: TListBox;
    ListBox6: TListBox;
    ListBox4: TListBox;
    ListBox3: TListBox;
    ListBox2: TListBox;
    ListBox1: TListBox;
    ActionManager1: TActionManager;
    ImageList1: TImageList;
    FileExit1: TFileExit;
    ActionToolBar1: TActionToolBar;
    ActionMainMenuBar1: TActionMainMenuBar;
    Panel1: TPanel;
    lbMonth: TLabel;
    lbYear: TLabel;
    ListBox8: TListBox;
    ListBox9: TListBox;
    ListBox10: TListBox;
    ListBox11: TListBox;
    ListBox12: TListBox;
    ListBox13: TListBox;
    ListBox14: TListBox;
    ListBox15: TListBox;
    ListBox16: TListBox;
    ListBox17: TListBox;
    ListBox18: TListBox;
    ListBox19: TListBox;
    ListBox20: TListBox;
    ListBox21: TListBox;
    ListBox22: TListBox;
    ListBox23: TListBox;
    ListBox24: TListBox;
    ListBox25: TListBox;
    ListBox26: TListBox;
    ListBox27: TListBox;
    ListBox28: TListBox;
    ListBox29: TListBox;
    ListBox30: TListBox;
    ListBox31: TListBox;
    ListBox32: TListBox;
    ListBox33: TListBox;
    ListBox34: TListBox;
    ListBox35: TListBox;
    ListBox36: TListBox;
    ListBox37: TListBox;
    ListBox38: TListBox;
    ListBox39: TListBox;
    ListBox40: TListBox;
    ListBox41: TListBox;
    ListBox42: TListBox;
    sbtnMDown: TSpeedButton;
    sbtnMUp: TSpeedButton;
    spbtnYear: TSpinButton;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    edtYear: TEdit;
    btnToday: TButton;
    DBGrid1: TDBGrid;
    testlist: TListBox;
    Button1: TButton;
    Edit1: TEdit;
    DBGrid2: TDBGrid;
    TodayPanel: TPanel;
    ListEdit: TAction;
    TopAction: TAction;
    PopupMenu1: TPopupMenu;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    QueryTimer: TTimer;
    popAddAction: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    AddAction: TAction;
    DBGrid3: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure DrawCalrendar(Sender: TObject; year, month: integer);
    procedure ShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure spbtnYearUpClick(Sender: TObject);
    procedure spbtnYearDownClick(Sender: TObject);
    procedure sbtnMUpClick(Sender: TObject);
    procedure sbtnMDownClick(Sender: TObject);
    procedure lbYearClick(Sender: TObject);
    procedure edtYearChange(Sender: TObject);
    procedure edtYearKeyPress(Sender: TObject; var Key: Char);
    procedure edtYearMouseLeave(Sender: TObject);
    procedure lbYearMouseEnter(Sender: TObject);
    procedure btnTodayClick(Sender: TObject);
    procedure ListBoxAllMouseLeave(Sender: TObject);
    procedure ListBoxAllMouseEnter(Sender: TObject);
    procedure ListBoxAllDblClick(Sender: TObject);
    procedure DrawSchedule(Sender: TObject; year, month, day: integer);
    procedure Button1Click(Sender: TObject);
    procedure AllScheduleClear(Sender: TObject);
    procedure ListBoxAllDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure RefreshSchedule(Sender: TObject);
    procedure TodayPanelClick(Sender: TObject);
    procedure TodayPanelMouseEnter(Sender: TObject);
    procedure TodayPanelMouseLeave(Sender: TObject);
    procedure ListEditExecute(Sender: TObject);
    procedure TopActionExecute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure QueryTimerTimer(Sender: TObject);
    procedure AlarmMessage(Sender: TObject; Day_data: String);
    procedure AddActionExecute(Sender: TObject);
    procedure ListBox9MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBoxAllClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Is_LeapYear(year: integer): boolean;
    function Get_DaysInMonth(year, month: integer): integer;
    function Get_TotalDays(year, month, day: integer): integer;
    function Get_DayOfTheWeek(year, month, day: integer): integer;
  end;

var
  MainForm: TMainForm;
  DayListBox: array [1..42] of TListBox;
  aFontColor: TColor;
  aDelDay: string;
  aBeforeTitle: string;
implementation

uses UDataInput, UDataModule, UList, Usplash;

{$R *.dfm}

{ TMainForm }

procedure TMainForm.ListEditExecute(Sender: TObject);
var
  i:byte;
begin
  for i := 0 to Application.ComponentCount-1 do
  begin
    if Application.Components[i] is TListEditForm then
    begin
      (Application.Components[i] as TForm).Show;
      exit; //2010 ���ķ� ���ϰ� ����
    end;
  end;
  ListEditForm := TListEditForm.Create(Application);
  ListEditForm.Show;
end;

procedure TMainForm.QueryTimerTimer(Sender: TObject);
var
  i: integer;
  SQLQuery, tmpAlramStr: string;
begin
  SQLQuery := 'select * from schedule where alarm_data = :pday_data';
  with DM.AlarmQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLQuery);
    Params[0].AsString :='T';
    Open;
  end;
  //ShowMessage(inttostr(DM.AlarmQuery.RecordCount));
  if DM.AlarmQuery.RecordCount > 0 then
  begin
    for i := 1 to DM.AlarmQuery.RecordCount do
    begin
      tmpAlramStr := DM.AlarmQuery.FieldByName('day_data').AsString
        + DM.AlarmQuery.FieldByName('timeH_data').AsString
        + DM.AlarmQuery.FieldByName('timeM_data').AsString;
      //ShowMessage( tmpAlramStr +'='+ FormatDateTime('YYYYMMDDhhmm',now));
      if tmpAlramStr = FormatDateTime('YYYYMMDDhhmm',now) then
      begin
        DM.ScheduleTable.Edit;
        DM.ScheduleTable.FieldByName('alarm_data').AsString := 'F';
        DM.ScheduleTable.Post;

        ShowMessage('['+DM.AlarmQuery.FieldByName('title').AsString+'] ���� �˶� �Դϴ�.');

        //AlarmMessage(Sender, DM.AlarmQuery.FieldByName('day_data').AsString);
      end;
      DM.AlarmQuery.Next;
    end;
  end;
                                                                           {
  if RecordCount > 0 then
    begin
      DayListBox[FirstDayNum+day-1].Hint:='';
      for i := 1 to RecordCount do
      begin
        DayListBox[FirstDayNum+day-1].Items.Strings[i] :=FieldByName('title').AsString;
        DayListBox[FirstDayNum+day-1].Hint := DayListBox[FirstDayNum+day-1].Hint+ IntToStr(i) +'. '+FieldByName('title').AsString + ''#13#10'';
          //showmessage('hi');
        Next;
      end;
    end;   }
end;

procedure TMainForm.TopActionExecute(Sender: TObject);
begin
  //���÷��� ȭ��
  SplashForm := TSplashForm.Create(Application);
  SplashForm.Show;
  SplashForm.Refresh;
  Sleep(3000);
  //���÷��� ȭ��
  SplashForm.Hide;
  SplashForm.Free;
end;

procedure TMainForm.AddActionExecute(Sender: TObject);
begin
  ListBoxAllDblClick(Sender);
end;

procedure TMainForm.AlarmMessage(Sender: TObject; Day_data: String);
var
  i: integer;
  SQLQuery, tmpAlramStr: string;
begin
  {
  //���γ��� ���� ��������
  SQLQuery := 'select * from schedule where alarm_data = :pday_data';
  with DM.AlarmQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLQuery);
    Params[0].AsBoolean:=True;
    Open;
  end;
  }
end;

procedure TMainForm.AllScheduleClear(Sender: TObject);
var
  i, j: integer;
begin
  for i := 1 to 42 do
  begin
   // for j := 1 to DayListBox[i].Count do
   DayListBox[i].Items.Clear;
  end;
end;

procedure TMainForm.btnTodayClick(Sender: TObject);
var
  nowY, nowM: integer;
begin
  nowY := StrToInt(FormatDateTime('yyyy',now));
  nowM := StrToInt(FormatDateTime('mm',now));
  //nowD := StrToInt(FormatDateTime('dd',now));
  DrawCalrendar(Sender, nowY, nowM);
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
{showmessage(edit1.Text);
dm.SimpleDataSet1.DataSet.Close;
  dm.SimpleDataSet1.DataSet.Params[0].AsString := '11';
         dm.SimpleDataSet1.DataSet.Open;

         showmessage(dm.SimpleDataSet1.FieldByName('title').AsString);
      }

     DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
   //   showmessage(IntToStr(DaysInMonth));
    //testlist.Items.Delete(1);
  {dm.ScheduleQuery.Close;
  dm.ScheduleQuery.Params[0].AsString:=edit1.Text;
   DM.ScheduleQuery.Open;
  testlist.Items.Strings[0]:=dm.ScheduleQuery.FieldByName('title').AsString;
   }
 { DM.SQLQuery1.Active := false;
  DM.SQLQuery1.Close;
  DM.SQLQuery1.SQL.Clear;
  DM.SQLQuery1.SQL.Add('Select ''title'' From schedule Where ''title'' =''11''' );
  DM.SQLQuery1.Active := True;
  DM.SQLQuery1.Open;
  }
 // dm.d.Close;
 // dm.d.Params[0].AsString := '11';
  //dm.d.Params[0].AsString := Edit1.Text;
  //dm.d.Open;
  //dm.d.ParamByName('temp').AsString := Edit1.Text;
 /// dm.d.Open;
end;

procedure TMainForm.DrawSchedule(Sender: TObject; year, month, day: integer);
var
  i, FirstDayNum: integer;
  tmpDate, SQLQuery: string;
begin

  if month < 10 then
    tmpDate:= IntToStr(year)+'0'+IntToStr(month)
  else
    tmpDate:= IntToStr(year)+IntToStr(month);

  if day < 10 then
    tmpDate:= tmpDate +'0'+IntToStr(day)
  else
    tmpDate:= tmpDate +IntToStr(day);
  SQLQuery := 'select title, grade from schedule where day_data = :pday_data';
  with DM.FindDayDataQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add(SQLQuery);
    Params[0].AsString:=tmpDate;
    Open;
  end;

  for i := 1 to 42 do
  begin
    if DayListBox[i].Items.Strings[0] = '1' then
       FirstDayNum := i;
  end;
  with DM.FindDayDataQuery do
  begin
    First;
    case FieldByName('grade').AsInteger of
      1: aFontColor:= clBlack;
      2: aFontColor:= clBlue;
      3: aFontColor:= clRed;
    end;
    if RecordCount > 0 then
    begin
      DayListBox[FirstDayNum+day-1].Hint :='';
      for i := 1 to RecordCount do
      begin
        DayListBox[FirstDayNum+day-1].Items.Strings[i] :=FieldByName('title').AsString;
        DayListBox[FirstDayNum+day-1].Hint := DayListBox[FirstDayNum+day-1].Hint+ IntToStr(i) +'. '+FieldByName('title').AsString + ''#13#10'';
          //showmessage('hi');
        Next;
      end;
    end;
  end;
  //dm.Scheduletable.FieldByName('')
 // dm.ScheduelQuerry.Params[0].AsString := FormatDateTime('yyyy-MM-dd',);
end;


procedure TMainForm.DrawCalrendar(Sender: TObject; year, month: integer);
var
  i, tmpWeek, DaysInMonth, DayOfTheWeek: integer;
begin
  // �ش���� ��¥���� ����Ѵ�
  DaysInMonth := Get_DaysInMonth(year, month);
  // day���� ������ �˾Ƴ���
  DayOfTheWeek := Get_DayOfTheWeek(year, month, 1);

// showmessage('��:'+IntToStr(cmbMonth.ItemIndex + 1)+', ����:'+IntToStr(DayOfTheWeek)+', ��¥:'+IntToStr(DaysInMonth));
  //  tmpStr:= 'Panel' + IntToStr(DayOfTheWeek);

  //�޷¿� ������ ��� �������� �����
  AllScheduleClear(Sender);

  tmpWeek:= DayOfTheWeek + 1;
  for i := 1 to 42 do
  begin
  DayListBox[i].Hint :='';  // ��Ʈ �ʱ�ȭ
    if i mod 7 = 1 then
      DayListBox[i].Color := RGB(255,146,177)
    else
      DayListBox[i].Color := clWhite;

    if i < tmpWeek then DayListBox[i].Items.Strings[0] :=''
    else if i >= (DaysInMonth + tmpWeek) then DayListBox[i].Items.Strings[0] :=''
    else
    begin

      //��¥ ǥ��
      DayListBox[i].Canvas.Font.Style:= [fsBold];
      DayListBox[i].Items.Strings[0]:= IntToStr(i-DayOfTheWeek);
      //Today �� ����
      if (year = StrToInt(FormatDateTime('yyyy',now))) and
      (month = StrToInt(FormatDateTime('mm',now))) and
      (DayListBox[i].Items.Strings[0] = FormatDateTime('dd',now)) then
         DayListBox[i].Color := RGB(130,240,240);
    end;
  end;
  lbYear.Caption := IntToStr(year);
  if month < 10 then
    lbMonth.Caption:= '0' + IntToStr(month)
  else
    lbMonth.Caption:= IntToStr(month);

  //DaysInMonth := Get_DaysInMonth(StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
 // Showmessage(intToStr(DayOfTheWeek));
  for i := 1 to DaysInMonth do
  begin
    DrawSchedule(Sender,StrToInt(lbYear.Caption),StrToInt(lbMonth.Caption),i);
  end;
end;

procedure TMainForm.edtYearChange(Sender: TObject);
begin
  lbYear.Caption:= edtYear.Text;
  if not (edtYear.Text = '') then
    DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
end;

procedure TMainForm.edtYearKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then edtYear.Visible := False;
  // ���ڸ� �Է� ����
  if (key <> #8) and ((key < #46) or (key > #57)) then abort;
end;



procedure TMainForm.edtYearMouseLeave(Sender: TObject);
begin
  edtYear.Visible := False;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
i, DaysInMonth : Integer;
begin
  Application.OnShowHint := ShowHint;
  Application.HintPause := 50;
  Application.HintHidePause := 10000;// .HintColor := clred;
  TodayPanel.Color := RGB(130,240,240);

  for i := 1 to 42 do
  begin
    DayListBox[i] := (FindComponent('ListBox' + IntToStr(i)) as TListBox);
    if i mod 7 = 1 then
      DayListBox[i].Color := RGB(255,146,177)
    else
      DayListBox[i].Color := clWhite;
  end;
  //����������������������������������������������������������������������������������������������������������������������������������
  //MainForm.editYear.Hint := '������������'#13'��������';

  //MainForm.editYear.Text := FormatDateTime('yyyy', now);
  //MainForm.cmbMonth.ItemIndex := StrToInt(FormatDateTime('mm',now)) - 1;
  // DrawCalrendar(�⵵, ��) �Է��ϸ� �޷��� �׸���
  lbYear.Caption:= FormatDateTime('yyyy',now);
  lbMonth.Caption:= FormatDateTime('mm',now);
  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
{
  DaysInMonth := Get_DaysInMonth(StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
  for i := 1 to DaysInMonth do
    DrawSchedule(Sender,StrToInt(lbYear.Caption),StrToInt(lbMonth.Caption),i);
 }
end;

function TMainForm.Get_DayOfTheWeek(year, month, day: integer): integer;
// �ش��ϱ����� �� ��¥���� ����Ͽ� 7�� ���� �������� ������ �ε���
begin
  // 0:�Ͽ���, 1:������, 2:ȭ����, ... 6:�����
  result:= ((Get_TotalDays(year, month, day)) mod 7);
end;

function TMainForm.Get_DaysInMonth(year, month: integer): integer;
// ������ ���� ��¥�� ��ȯ
const
  // �� ���� ��¥���� �̸� ������ �д�
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  md: integer;
begin
  // �ش���� ��¥���� �����´�
  md := DaysInMonth[month];

  // �����̰� 2���̸� �Ϸ縦 ���Ѵ�
  if(Is_LeapYear(year) and (month = 2)) then md := md + 1;
  result:= md;
end;

function TMainForm.Get_TotalDays(year, month, day: integer): integer;
// ���� 1�� 1�� 1�Ϻ��� ����Ͽ� �Է� ���� ������ �� ��¥���� ���
var
  M, lastYear , total: integer;
begin
  // �۳������ �� ��¥���� ���
  lastYear:= year - 1;
  total:= 365 * lastYear;

  // �׵��� ������ Ƚ����ŭ ��¥�� ����
  total:= total + ((lastYear div 400) - (lastYear div 100) + (lastYear div 4));

  // �ش��, ���� ������ ���� ��¥���� �� ���Ѵ�
  for M := 1 to (month - 1) do
    total:= total + Get_DaysInMonth(year, M);

  // �ش����� ���Ѵ�
  total:= total + day;

  result:= total;
end;

function TMainForm.Is_LeapYear(year: integer): boolean;
// �����̸� True, �ƴϸ� False�� ����
begin
  // 400���� ������ �������� ����
  // 100���� ������ �������� �ʰ� 4�� ������ �������� ����
  if (((year mod 400) = 0) or (((year mod 100) <> 0) and ((year mod 4) = 0))) then
    result:= True
  else
    result:= false;
end;


procedure TMainForm.lbYearClick(Sender: TObject);
begin
  edtYear.Visible :=True;
  edtYear.SetFocus;
  edtYear.Text := lbYear.Caption;
end;

procedure TMainForm.lbYearMouseEnter(Sender: TObject);
begin
  lbYear.Cursor:= crHandPoint;
end;


procedure TMainForm.ListBoxAllMouseLeave(Sender: TObject);
var
  i: integer;
  tmpListBox: TListBox;
begin
  tmpListBox:= TListBox(Sender);

  for i := 1 to 42 do
  begin
    DayListBox[i].ItemIndex:= -1;

    if i mod 7 = 1 then
      DayListBox[i].Color := RGB(255,146,177)
    else
      DayListBox[i].Color := clWhite;
    if (lbYear.Caption = (FormatDateTime('yyyy',now))) and
      (lbMonth.Caption = (FormatDateTime('mm',now))) and
      (DayListBox[i].Items.Strings[0] = FormatDateTime('dd',now)) then
         DayListBox[i].Color := RGB(130,240,240)
  end;
end;



procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  StatusBar1.Panels[1].Text := FormatDateTime('YYYY��MM��DD�� HH:MM:SS',now);
end;

procedure TMainForm.TodayPanelClick(Sender: TObject);
var
  nowY, nowM: integer;
begin
  nowY := StrToInt(FormatDateTime('yyyy',now));
  nowM := StrToInt(FormatDateTime('mm',now));
  //nowD := StrToInt(FormatDateTime('dd',now));
  DrawCalrendar(Sender, nowY, nowM);
end;

procedure TMainForm.TodayPanelMouseEnter(Sender: TObject);
var
  nowY, nowM: string;
begin
  nowY := FormatDateTime('yyyy',now);
  nowM := FormatDateTime('mm',now);

 // Showmessage(nowY+', '+lbYear.Caption );
  //Showmessage(nowM+', '+lbMonth.Caption );
  if (nowY = lbYear.Caption) and (nowM = lbMonth.Caption) then
    //TodayPanel.Color := clCream
  else
    TodayPanel.Color := RGB(130,240,240);
  TodayPanel.Cursor:= crHandPoint;
end;

procedure TMainForm.TodayPanelMouseLeave(Sender: TObject);
var
  nowY, nowM: string;
begin
  nowY := FormatDateTime('yyyy',now);
  nowM := FormatDateTime('mm',now);

  if (nowY = lbYear.Caption) and (nowM = lbMonth.Caption) then
    TodayPanel.Color := RGB(130,240,240)
  else
    TodayPanel.Color := clCream;
end;

procedure TMainForm.RefreshSchedule(Sender: TObject);
begin
  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
end;

procedure TMainForm.ListBoxAllDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  TextBuff : String;
  tmpListBox: TListBox;
begin
  tmpListBox:= TListBox(Control);
  with tmpListBox do
  begin
    Canvas.FillRect(Rect);

    //ù ��° ���� �޷� ǥ���� �̴ϱ� ������, �β���
    if index = 0 then
    begin

      Canvas.Font.Color:= clBlack;
      Canvas.Font.Style:= [fsBold];
    end
    else
    begin
      Canvas.Font.Color := aFontColor; // FontColor ��������
      Canvas.Font.Style := [];
    end;
    Canvas.TextOut(Rect.Left,Rect.Top,Items.Strings[index]);
    //inc(0,TextWidth(Items.Strings[index]));
  end;
end;

procedure TMainForm.ListBoxAllClick(Sender: TObject);
var
  i: integer;
  tmpListBox: TListBox;
begin
  {tmpListBox:= TListBox(Sender);

  if tmpListBox.Count > 1 then
  begin
    DM.ScheduleTable.First;
    for i := 1 to DM.ScheduleTable.RecordCount do
    if DM.ScheduleTable.FieldByName('title').AsString <> tmpListBox.Items.Strings[tmpListBox.ItemIndex] then
      DM.ScheduleTable.Next;
  end;
 }    // DM.ScheduleTable.FindField('title').AsString := SelectdItem;
     // DM.ScheduleTable.First;
end;

procedure TMainForm.ListBox9MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
cX,cY: integer;
mP: TPoint;
tmpListBox: TListBox;
begin
  tmpListBox:= TListBox(Sender);
  if Button = mbRight then // ���콺 ������ư�� ������
  begin
  //  if tmpListBox.Items.Strings[0] <> '' then
    if tmpListBox.Items.Strings[tmpListBox.ItemIndex] <> '' then
    begin
      // ��¥ Ŭ�� �� ��� �ű� �Է�
      if tmpListBox.ItemIndex <= 0 then
      begin
       // tmpListBox.Selected[tmpListBox.ItemIndex]:= Ture;
        GetCursorPos(mP); // ȭ����� ���콺 ��ġ
      //if (cX=3) and (cy=3) then // (3,3)������ �������� �˾�~
        PopupMenu1.Popup(mP.X, mP.Y);
       // DataInputForm :=TDataInputForm.Create(Application);

        // ������ �ð� ����
        //tmpDate:=lbYear.Caption + '-' + lbMonth.Caption + '-' + tmpListBox.Items.Strings[0];
        //DataInputForm.DateTimePicker1.Date :=StrToDate(tmpDate);

      end
      // ���� Ŭ�� �� ��� ���� ȭ������
      else
    end;


    //showmessage(tmpListBox.Items.Strings[tmpListBox.ItemIndex]);
    //StringGrid1.MouseToCell(X, Y, cX, cY); // ���콺�� ��ġ�� ���� �÷��� �ο�
    //GetCursorPos(mP); // ȭ����� ���콺 ��ġ
    //if (cX=3) and (cy=3) then // (3,3)������ �������� �˾�~
    //PopupMenu1.Popup(mP.X, mP.Y);
  end;
end;

procedure TMainForm.ListBoxAllDblClick(Sender: TObject);
var
  tmpListBox: TListBox;
  SelectdDay, SelectdItem, tmpDate, SQLQuery: string;
begin
  tmpListBox:= TListBox(Sender);
  if tmpListBox.Items.Strings[0] <> '' then
  begin
    // ��¥ Ŭ�� �� ��� �ű� �Է�
    if tmpListBox.ItemIndex <= 0 then
    begin
      // �� �����
      DataInputForm :=TDataInputForm.Create(Application);

      // ������ �ð� ����
      tmpDate:=lbYear.Caption + '-' + lbMonth.Caption + '-' + tmpListBox.Items.Strings[0];
      DataInputForm.DateTimePicker1.Date :=StrToDate(tmpDate);

    end
    // ���� Ŭ�� �� ��� ���� ȭ������
    else
    begin
      //�޷¿��� ���õ� ����(=���̺��� ����)
      SelectdItem:= tmpListBox.Items.Strings[tmpListBox.ItemIndex];

      if StrToInt(tmpListBox.Items.Strings[0]) >= 10 then
        SelectdDay:=lbYear.Caption+lbMonth.Caption+tmpListBox.Items.Strings[0]
      else
        SelectdDay:=lbYear.Caption+lbMonth.Caption+'0'+tmpListBox.Items.Strings[0];

      //�ڷ� �˻��ϱ� ���ؼ� ���̺� �� ���Ĵ�� ��¥ �����ְ�
      tmpDate:=lbYear.Caption + lbMonth.Caption + tmpListBox.Items.Strings[0];

      //������ �ۼ� �� ����                              Params[1].AsString:= and day_data = :pday_data
      SQLQuery := 'select * from schedule where title = :ptitle and day_data = :pday_data';
      with DM.SelectDataQuery do
      begin
        Close;
        SQL.Clear;
        SQL.Add(SQLQuery);
        Params[0].AsString:=SelectdItem;
        Params[1].AsString:=SelectdDay;
        Open;
      end;

      // �� �����
      DataInputForm :=TDataInputForm.Create(Application);

      // ���� �ϴ� �Ŵϱ� ��ư�� �������� �ٲٰ�
      DataInputForm.bbtnOk.Caption := '����';

      // ���� ��ư�� �����ְ�
      DataInputForm.bbtnDelete.Visible := True;

      // ������ �ð� ����
      tmpDate:=lbYear.Caption + '-' + lbMonth.Caption + '-' + tmpListBox.Items.Strings[0];
      DataInputForm.DateTimePicker1.Date :=StrToDate(tmpDate);

      // �˻��� ������ �Է� ���� �� �ʵ忡 �����Ѵ�
      with DM.SelectDataQuery do
      begin
        DataInputForm.edtTitle.Text:= FieldByName('title').AsString;
        aBeforeTitle := FieldByName('title').AsString;
        //DataInputForm.edtTitle.Enabled:= False; //������ ���� ����
        DataInputForm.cmbGrade.ItemIndex:= FieldByName('grade').AsInteger - 1;
        if FieldByName('alarm_data').AsString = 'T' then
          DataInputForm.cbxAlram.Checked:= True
        else
          DataInputForm.cbxAlram.Checked:= False;
        DataInputForm.redtText.Text:= FieldByName('text').AsString;
      end;
    end;

    //��� �� �ݱ�, onClose�� �ߺ��ؼ� �ϸ� ���� ���� �� �ִ� (å�� ���ֳ�)
    if DataInputForm.ShowModal = mrOk then
    begin
      // �� �޸� ����
      DataInputForm.Free;

      // ������ �ٽ� �ѷ��ְ�
      RefreshSchedule(Sender);
    end;

    // �˻��� ���� Ŭ����
    DM.SelectDataQuery.Close;
  end;
end;

procedure TMainForm.ListBoxAllMouseEnter(Sender: TObject);
var
  tmpListBox: TListBox;
  strHint: string;
begin
  tmpListBox:= TListBox(Sender);
  if tmpListBox.Items.Strings[0] <> '' then
    //tmpListBox.ItemIndex :=0;
    tmpListBox.Color := clBtnFace;
  //showmessage(inttostr(tmpListBox.Count));
end;

procedure TMainForm.ShowHint(var HintStr: string; var CanShow: Boolean;
  var HintInfo: THintInfo);
begin
  //StatusBar.SimpleText := HintStr;
  CanShow := True;

end;

procedure TMainForm.spbtnYearDownClick(Sender: TObject);
var
  tmpYear: integer;
begin
  tmpYear:= StrToInt(lbYear.Caption)-1;
  lbYear.Caption:= IntToStr(tmpYear);
  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));

end;



procedure TMainForm.spbtnYearUpClick(Sender: TObject);
var
  tmpYear: integer;
begin
  tmpYear:= StrToInt(lbYear.Caption)+1;
  lbYear.Caption:= IntToStr(tmpYear);
  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));

end;

procedure TMainForm.sbtnMDownClick(Sender: TObject);
var
  tmpMonth: integer;
  nowY, nowM: string;
begin
  if StrToInt(lbMonth.Caption) > 1 then
  begin
    tmpMonth:= StrToInt(lbMonth.Caption)-1;
    if tmpMonth < 10 then
      lbMonth.Caption:= '0' + IntToStr(tmpMonth)
    else
      lbMonth.Caption:= IntToStr(tmpMonth);
  end
  else if StrToInt(lbMonth.Caption) = 1 then
  begin
    lbMonth.Caption:= '12';
    spbtnYearDownClick(Sender);
  end;

  nowY := FormatDateTime('yyyy',now);
  nowM := FormatDateTime('mm',now);
  if (nowY = lbYear.Caption) and (nowM = lbMonth.Caption) then
    TodayPanel.Color := RGB(130,240,240)
  else
    TodayPanel.Color := clCream;

  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
end;


procedure TMainForm.sbtnMUpClick(Sender: TObject);
var
  tmpMonth: integer;
  nowY, nowM: string;
begin
  if StrToInt(lbMonth.Caption) < 12 then
  begin
    tmpMonth:= StrToInt(lbMonth.Caption)+1;
    if tmpMonth < 10 then
      lbMonth.Caption:= '0' + IntToStr(tmpMonth)
    else
      lbMonth.Caption:= IntToStr(tmpMonth)
  end
  else if StrToInt(lbMonth.Caption) = 12 then
  begin
    lbMonth.Caption:= '01';
    spbtnYearUpClick(Sender);
  end;

  nowY := FormatDateTime('yyyy',now);
  nowM := FormatDateTime('mm',now);
  if (nowY = lbYear.Caption) and (nowM = lbMonth.Caption) then
    TodayPanel.Color := RGB(130,240,240)
  else
    TodayPanel.Color := clCream;

  DrawCalrendar(Sender, StrToInt(lbYear.Caption), StrToInt(lbMonth.Caption));
end;



end.
