unit UImageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ColorGrd,
  Vcl.ExtCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    FIle1: TMenuItem;
    Clear1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    Image1: TImage;
    ColorGrid1: TColorGrid;
    ListBox1: TListBox;
    procedure Clear1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
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
  Image1.Picture.Bitmap.Assign(Nil); //�۾��� ���� �����
  FormCreate(Self); // �ʱ�ó����ȣ��
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
{���� �����ϴ� ������ ũ��� Image1�� �����ϴ�.}
  Image1.Picture.Bitmap.Width := Image1.Width;
  Image1.Picture.Bitmap.Height := Image1.Height;
  ListBox1.ItemIndex := 0;

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
{���콺�� �����ӿ� ���� ĵ������ �׸��� �׷����ϴ�.}
  Image1.Picture.Bitmap.Canvas.MoveTo(X,Y);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
{���콺 ���� ��ư�� �̿��Ͽ� �׸��� �׸��ϴ�.}
if  Shift = [sSleft] then
//���� ���� ���� : ListBox ���� ���õ� ũ�⸸ŭ ���Ⱑ ���մϴ�.
  Image1.Picture.Bitmap.Canvas.Pen.Width :=
  StrToInt(ListBox1.Items [ListBox1.ItemIndex]);
//���� ���� ���� : ColorGrid���� ���õ� �������� ���մϴ�.
  Image1.Picture.Bitmap.Canvas.Pen.Color :=
  ColorGrid1.ForegroundColor;
// ĵ������ �׷��� ���ο� ���� Image1 ȭ�鿡 ��Ÿ���ϴ�.
  Image1.Picture.Bitmap.Canvas.LineTo(X,y);

end;

procedure TForm1.Open1Click(Sender: TObject);
var
  OD : TOpenDialog; // TOpenDialog ���� OD����
begin
  OD := TOpenDialog.Create(Self);
  OD.Filter := 'Bitmap Files( *.bmp) | *.bmp';
  if OD.Execute then
  Image1.Picture.Bitmap.LoadFromFile(OD.FileName);
  OD.Free; //oD�� �����մϴ�.
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
var
  SD : TSaveDialog;
begin
  SD := TSaveDialog.Create(Self);
  {*.bmp ��Ʈ��������������}
  SD.Filter := 'Bitmap Files(*.bmp)|*.bmp';
  if SD.Execute then
    Image1.Picture.Bitmap.SaveToFile(SD.FileName);
    Sd.Free;
end;

end.
