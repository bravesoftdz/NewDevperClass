unit UMTClient;

interface

uses
  ItemSQLUnit,
  Generics.collections,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ImgList, ComCtrls,
  DBCtrls, Grids, StdCtrls, ExtCtrls, ToolWin, ActnCtrls, ActnMenus, SqlExpr,
  DBGrids, DBTables, DB, FMTBcd;

type
  TClientForm = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    AC_Exit: TAction;
    AC_Items: TAction;
    AC_Cost: TAction;
    AC_Message: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    DBImage2: TDBImage;
    Panel6: TPanel;
    DBImage3: TDBImage;
    Panel7: TPanel;
    DBImage4: TDBImage;
    Panel8: TPanel;
    DBImage5: TDBImage;
    Panel9: TPanel;
    DBImage6: TDBImage;
    Panel10: TPanel;
    DBImage7: TDBImage;
    Panel11: TPanel;
    DBImage8: TDBImage;
    StringGrid1: TStringGrid;
    Button1: TButton;
    DBImage1: TDBImage;
    SqlServerMethod: TSqlServerMethod;
    procedure AC_ItemsExecute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AC_ExitExecute(Sender: TObject);
    procedure DBImage2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Img;
  public
    { Public declarations }
  end;

var
  ClientForm: TClientForm;

implementation

uses UItemForm, ClientModuleUnit1, JPEG, ClientClassesUnit1;

var
  Bun : integer = 0;      //StringGird ��ȣ �ʱ�ȭ
  Gae : integer = 1;      //StringGrid ���� �ʱ�ȭ
  je : integer = 0;
{$R *.dfm}

//���� -> ����� �� ����
procedure TClientForm.AC_ExitExecute(Sender: TObject);
begin
  Application.Terminate;
end;

//��ǰ���� �� ����
procedure TClientForm.AC_ItemsExecute(Sender: TObject);
begin
  ItemForm := TItemForm.Create(Application);
  ItemForm.Show;
end;

//StringGrid �Է� �� History�Է�, StringGrid �ʱ�ȭ
procedure TClientForm.Button1Click(Sender: TObject);
//var
//  a, b : integer;
//  DTag : integer;
begin
//  for b := 1 to StringGrid1.RowCount do
//  begin
//    DTag :=
//    ClientModule1.History.FieldByName('H_COUNT').AsString := StringGrid1.Cells[3,b];
//    StringGrid1.Cells[a,b] := '';
//  end;
end;

//DB�� ȣ��� �̹��� Ŭ���� StringGrid�� �Է�
procedure TClientForm.DBImage2Click(Sender: TObject);
var
  STag1, STag2, i, j, Count : integer;
  NumStr, CoStr, IName : string;
  begin
  i := 1;
  j := 1;
  Inc(Bun);         //�� �ڵ� ����
  STag1 := (Sender as TDBImage).Tag;
  if ClientModule1.Item.Locate('I_ID', STag1, []) then
  begin
    NumStr := IntToStr(Bun) + '��';
    CoStr := IntToStr(Gae) + '��';
    for i := 1 to StringGrid1.RowCount do
    begin
        if (StringGrid1.Cells[0,i] = '') then
        begin
          StringGrid1.Cells[0,i] := NumStr;
          StringGrid1.Cells[1,i] := ClientModule1.Item.FieldByName('I_NAME').AsString;
          StringGrid1.Cells[2,i] := ClientModule1.Item.FieldByName('I_COST').AsString + '��';
          StringGrid1.Cells[3,i] := CoStr;
          break;
        end;

//        else if StringGrid1.Cells[2,i] = ClientModule1.Item.FieldByName('I_NAME').AsString then
//        begin
//          Gae := Gae + 1;
//          StringGrid1.Cells[3,i] := CoStr;
//          break;
//      end;
    end;
  end;
end;

//�� Active�� DBimage ȣ��
procedure TClientForm.FormActivate(Sender: TObject);
begin
   Img;
end;

//�� ����
procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//StringGrid �ʱ�ȭ
procedure TClientForm.FormCreate(Sender: TObject);
var
  i:Byte;
begin
  With StringGrid1 do
  begin
    RowCount := ClientModule1.Item.RecordCount + 2;
    Cells[0,0] := '��    ȣ'; // Ÿ��Ʋ ���� ����ϴ�.
    Cells[1,0] := '�� ǰ ��';
    Cells[2,0] := '��ǰ����';
    Cells[3,0] := '��ǰ����';
  end;
end;

//DBImage �ε�
procedure TClientForm.Img;
var
  S:TField;
  Co, i, j : integer;
begin

//  if ((Components[Co] as TDBImage).Picture.Graphic = nil) then
//  begin
//    raise Exception.Create('��ǰ�� ��ϵǾ� ���� �ʽ��ϴ�.');
//  end
//  else
//    begin
    ClientModule1.Item.Close;
    ClientModule1.Item.Open;
    S:= ClientModule1.Item.FieldByName('I_IMAGE');
    DBImage1.Picture.Assign(S);
    DBImage1.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage2.Picture.Assign(S);
    DBImage2.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage3.Picture.Assign(S);
    DBImage3.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage4.Picture.Assign(S);
    DBImage4.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage5.Picture.Assign(S);
    DBImage5.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage6.Picture.Assign(S);
    DBImage6.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage7.Picture.Assign(S);
    DBImage7.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
    ClientModule1.Item.Next;
    DBImage8.Picture.Assign(S);
    DBImage8.Tag := ClientModule1.Item.FieldByName('I_ID').AsInteger;
//  end;
end;

procedure TClientForm.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  pos:integer;
  oldalign :word;
  s:string;
begin
  with stringgrid1.canvas do
  begin
    fillrect(rect);

    if arow = 0 then
    begin
       font.Size := font.Size + 4;
       font.Color := clblue;
       brush.Color := clyellow;
    end;

    if (ACol = 3) and (arow <>0)then
    begin
      font.Color := clred;
      font.Size := font.Size + 4;
      oldalign := settextalign(handle, ta_right);
      textrect(rect, rect.right, rect.Top+3, s);
      settextalign(handle, oldalign);
    end
    else
    begin
      pos := ((rect.right - rect.Left) - textwidth(s)) div 2;
      textrect(rect, rect.Left+pos, rect.Top+3, s);
    end;
  end;
end;

end.
