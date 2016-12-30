unit Chat_Room;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.DBCtrls,
  Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, W_Main_Class, DBXJSON;

type
  TForm4 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Button1: TButton;
    edt_Room_Name: TEdit;
    DBGrid1: TDBGrid;
    edt_JoinRoom: TDBEdit;
    btn_Join: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btn_JoinClick(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure unRegist();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  room: string;

implementation

{$R *.dfm}

uses W_Main, W_DataModule;

procedure TForm4.btn_JoinClick(Sender: TObject); // ä�ù� ����
begin
  room := edt_JoinRoom.Text;
  DataModule2.ChannelManager.ChannelName := room;
  DataModule2.ChannelManager.RegisterCallback(room, TClient_Callback.create());
  Form1 := TForm1.create(self);
  Form1.Show;
end;

procedure TForm4.Button1Click(Sender: TObject); // ä�ù� ��� �� ����
begin
  if edt_Room_Name.Text <> '' then
  begin
    room := edt_Room_Name.Text;
    try
      dm.Create_Room(edt_Room_Name.Text);
      DataModule2.ChannelManager.ChannelName := room;
      DataModule2.ChannelManager.RegisterCallback(room,
        TClient_Callback.create());
      Form1 := TForm1.create(self);
      Form1.Show;
    except
      showmessage('�� ������ �����߽��ϴ�.');
      raise;
    end;
  end
  else
    showmessage('�� �̸��� �Է��ϼ���!');
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction); // �κ� ����
begin
  Form4.Destroy;
end;

procedure TForm4.FormCreate(Sender: TObject);     // �κ� ����
var
  LGuid: TGuid;
begin
  CreateGuid(LGuid);
  DataModule2.ChannelManager.ManagerId := GuidToString(LGuid);
  PageControl1.ActivePageIndex := 0;
  DataModule2.W_SQLConnection.Connected := true;
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  Form4.Free;
end;

procedure TForm4.PageControl1Changing(Sender: TObject; // ä�ù� ����Ʈ ����
  var AllowChange: Boolean);
begin
  DataModule2.Insert_ChatRoom.Active := false;
  DataModule2.ChatRoom.Enabled := true;
  DataModule2.Insert_ChatRoom.Active := true;
end;

procedure TForm4.unRegist; //ä�� ���� ����
begin
  DataModule2.ChannelManager.UnregisterCallback(room);
end;

end.
