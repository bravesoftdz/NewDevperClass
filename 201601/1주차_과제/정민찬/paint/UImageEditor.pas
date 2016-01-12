unit UImageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ColorGrd, Vcl.ExtCtrls, Vcl.Menus, Vcl.CustomizeDlg;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Clear1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    Image1: TImage;
    ColorGrid1: TColorGrid;
    ListBox1: TListBox;
    New1: TMenuItem;
    procedure Clear1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Clear1Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Assign(nil); //�۾� ���� �����
FormCreate(Self); // �ʱ�ó���� ȣ���մϴ�.
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
{ ���� �����ϴ� ������ ũ��� Image1�� �����ϴ� }
Image1.Picture.Bitmap.Width := Image1.Width;
Image1.Picture.Bitmap.Height := Image1.Height;
ListBox1.ItemIndex := 0;
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{ ���콺�� �����ӿ� ���� ĵ������ �׸��� �׷����ϴ�.}
Image1.Picture.Bitmap.Canvas.MoveTo(X,Y);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{���콺 ���� ��ư�� �̿��Ͽ� �׸��� �׸��ϴ�.}
if Shift=[sSleft] then
// [sSleft], [sSright], [sSAlt], [sSCtrl] �� ���ϴ� Ű�� ������ �� �ֽ��ϴ�.
{ ������ ���� ����� ���� ���� ĵ������ �׸��� �׷����ϴ�.}
begin
  //���� ���� ���� : LIstBox ���� ���õ� ũ�⸸ŭ ���Ⱑ ���մϴ�.
  Image1.Picture.Bitmap.Canvas.Pen.Width :=
  StrToint(ListBox1.Items [ListBox1.ItemIndex]);

  //���� ���� ���� : COlorGrid ���� ���õ� �������� ���մϴ�.
  Image1.Picture.Bitmap.Canvas.Pen.Color := ColorGrid1.ForegroundColor;

  // ĵ������ �׷��� ���ο� ���� Image1 ȭ�鿡 ��Ÿ���ϴ�.
  Image1.Picture.Bitmap.Canvas.LineTo(X,Y);
end;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
OD:TOpenDialog;  // TOpenDialog ���� OD�� �����մϴ�.
begin
OD := TOpenDialog.Create(self);
OD.Filter:= 'Bitmap File(*.bmp) | *.bmp'; //{*.BMP ������ ������ �ҷ��ɴϴ�.}
if od.Execute then
Image1.Picture.Bitmap.LoadFromFile(Od.FileName);
OD.Free; //OD ����
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
var
SD:TSaveDialog;
begin
SD := TSaveDialog.Create(Self);
{*.bmp �������� �����մϴ�.}
SD.Filter := 'Bitmap Files(*.bmp) | *.bmp';
if SD.Execute then
Image1.Picture.Bitmap.SaveToFile(SD.Filename);
Sd.Free; //SD�� �����մϴ�.
end;

end.
