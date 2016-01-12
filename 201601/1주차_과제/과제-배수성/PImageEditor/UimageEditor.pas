unit UimageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ColorGrd,
  Vcl.ExtCtrls, Vcl.Menus;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    clear1: TMenuItem;
    Clear2: TMenuItem;
    Open1: TMenuItem;
    Saveas1: TMenuItem;
    Exit1: TMenuItem;
    Image1: TImage;
    ColorGrid1: TColorGrid;
    ListBox1: TListBox;
    procedure Clear1click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
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

procedure TForm1.Clear1click(Sender: TObject);
begin
          Image1.Picture.Assign(nil);
          Formcreate(Self);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
 close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
// ���� �����ϴ� ������ ����� image�� ����
 image1.Picture.Bitmap.Width := image1.Width;
 image1.Picture.Bitmap.height := image1.height;
 Listbox1.ItemIndex := 0;

end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //���콺�� �����ӿ� ���� ĵ������ �׸��� �׷����ϴ�.
  Image1.Picture.Bitmap.Canvas.MoveTo(x,y);
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//���콺 ���� ��ư�� �̿��Ͽ� �׸��� �׸��ϴ�.

if shift = [Ssleft] then
// [sSlft], [sSright], [sSctrl]
//������ ���� ����� ���� ���� ĵ������ �׸��� �׷����ϴ�.

begin
  //���� ���� ���� : ListBox ���� ���õ� ũ�⸸ŭ ���Ⱑ ����
  Image1.Picture.Bitmap.Canvas.Pen.Width := StrToint(listbox1.Items [listbox1.ItemIndex]);

  //���� ���� ���� : colorGrid ���� ���õ� �������� ���մϴ�.

  Image1.picture.Bitmap.Canvas.Pen.color := ColorGrid1.ForegroundColor;

  //ĵ������ �׷��� ���ο� ���� Image1ȭ�鿡 ��Ÿ��

   Image1.Picture.Bitmap.Canvas.LineTo(x,y);


end;
end;

procedure TForm1.Open1Click(Sender: TObject);
var
  OD : Topendialog;

begin
   OD := Topendialog.Create(self);
   OD.Filter := 'bitmap Files(*.bmp)|*.bmp';
    if OD.execute then
      image1.Picture.Bitmap.LoadFromFile(od.Filename);
       OD.Free;


end;

procedure TForm1.Saveas1Click(Sender: TObject);
var
  SD:Tsavedialog;
begin
                 SD := Tsavedialog.Create(self);
                 // *.bmp �������� �����մϴ�.
                 SD.Filter := 'bitmap Files(*.bmp)|*bmp';
                 if SD.execute then
                   Image1.Picture.Bitmap.SaveToFile(Sd.FileName);
                   SD.Free;

end;

end.
