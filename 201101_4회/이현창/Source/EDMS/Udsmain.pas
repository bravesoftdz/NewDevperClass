unit Udsmain;

interface

uses
	Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
	Dialogs, StdCtrls, FMTBcd, DB, SqlExpr, ExtCtrls, ActnCtrls, ComCtrls,
	PlatformDefaultStyleActnCtrls, ActnList, ActnMan, ToolWin, ActnMenus, Grids,
	DBGrids, DBCtrls, ShellAPI, SHDocVw, HTTPApp, DBWeb, ImgList;

type
	TMainForm = class(TForm)
		ActionMainMenuBar1: TActionMainMenuBar;
		CoolBar1: TCoolBar;
		ActionManager1: TActionManager;
		StatusBar1: TStatusBar;
		ActionToolBar2: TActionToolBar;
		Panel1: TPanel;
		Panel4: TPanel;
		Panel5: TPanel;
		Label1: TLabel;
		Label2: TLabel;
		Label3: TLabel;
		Label4: TLabel;
		IdLabel: TLabel;
		NameLabel: TLabel;
		ClassLabel: TLabel;
		DeptLabel: TLabel;
		LogoutBtn: TButton;
		PageControl1: TPageControl;
		TabControl1: TTabControl;
		MainGrid: TStringGrid;
		Splitter1: TSplitter;
		Panel2: TPanel;
		Splitter2: TSplitter;
		act_close: TAction;
		act_logout: TAction;
		act_WriteRep: TAction;
		act_ModifyFlist: TAction;
		act_Find: TAction;
		act_chart: TAction;
		ImageList1: TImageList;
		SettleButton: TButton;
		returnButton: TButton;
		Panel6: TPanel;
		Panel7: TPanel;
		GroupBox2: TGroupBox;
		sendInfoGrid: TStringGrid;
		GroupBox3: TGroupBox;
		RecvInfoGrid: TStringGrid;
		Panel8: TPanel;
		ScrollBox1: TScrollBox;
		ContPanel: TPanel;
		Shape1: TShape;
		Shape2: TShape;
		Shape5: TShape;
		Shape7: TShape;
		Label9: TLabel;
		WriteDateLAbel: TLabel;
		Label10: TLabel;
		TitleLable: TLabel;
		Shape8: TShape;
		Shape9: TShape;
		Shape3: TShape;
		Label11: TLabel;
		Label12: TLabel;
		Label13: TLabel;
		SenderNameLabel: TLabel;
		SenderDeptLabel: TLabel;
		SenderClassLabel: TLabel;
		Label14: TLabel;
		Label15: TLabel;
		Label16: TLabel;
		RecvClassLabel: TLabel;
		RecvDeptLabel: TLabel;
		recvNameLabel: TLabel;
		Label17: TLabel;
		Shape4: TShape;
		ContEdit: TRichEdit;
		Panel3: TPanel;
		GroupBox1: TGroupBox;
		LogGrid: TDBGrid;
		Edit_Btn: TButton;
		procedure RestartApplication;//���α׷� �����
		procedure DrawGrid(TabIndex: Integer);//���� ��� ��Ʈ�� �׸��� �׸���
		procedure FormCreate(Sender: TObject);
		procedure MainGridDrawCell(Sender: TObject; ACol, ARow: Integer;
			Rect: TRect; State: TGridDrawState); //���� ��� ��Ʈ�� �׸��� ���
		procedure MainGridSelectCell(Sender: TObject; ACol, ARow: Integer;
			var CanSelect: Boolean); // ���� ��� ���ý� �̺�Ʈ �ڵ鷯
		procedure TabControl1Change(Sender: TObject);  // �� ���͸�
		procedure act_logoutExecute(Sender: TObject); // �α׾ƿ� Ŀ�ǵ�
		procedure act_closeExecute(Sender: TObject); // ���� Ŀ�ǵ�
		procedure act_WriteRepExecute(Sender: TObject); // ���� �ۼ� ȭ�� �̵� Ŀ�ǵ�
		procedure setContent(flag: Boolean); // ���� ���� ��� ���� �޼ҵ�
		procedure SettleButtonClick(Sender: TObject); // ����/�ݷ� ó�� Ŀ�ǵ�
		procedure DrawInfoGrid; // ���� ��Ȳ �׸��� Draw �޼ҵ�
		procedure act_FindExecute(Sender: TObject); // ���� ���� ��ȸ ȭ�� �̵� Ŀ�ǵ�
		procedure Edit_BtnClick(Sender: TObject); // �ӽ����� �Ǵ� �ݷ� ���� ���� Ŀ�ǵ�
	private
		{ Private declarations }
	public
		{ Public declarations }
		procedure SetLogo; // �α��� ����� ���� ���
	end;

var
	MainForm: TMainForm;

implementation

uses Uds_dm, Uinsert, USearch;

{$R *.dfm}
{ TMainForm }

procedure TMainForm.act_closeExecute(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TMainForm.act_FindExecute(Sender: TObject);
begin
	SearchForm := TSearchForm.Create(Application);
	SearchForm.Show;
end;

procedure TMainForm.act_logoutExecute(Sender: TObject);
begin
	RestartApplication;
end;

procedure TMainForm.act_WriteRepExecute(Sender: TObject);
begin
	insertForm := TinsertForm.Create(Self);
	insertForm.senderLabel.Caption := Uds_dm.UserName;
	insertForm.IsUpdate := false;
	insertForm.Show;
end;

procedure TMainForm.DrawGrid(TabIndex: Integer);
var
	i: Integer;
begin
	dm.SettleTable.Close;
	dm.SettleTable.MasterSource := dm.MySource;
	if TabIndex = 0 then
	begin
		dm.SettleTable.IndexFieldNames := 'settle_recver';
		dm.SettleTable.Filtered := true;
		dm.SettleTable.Filter := 'not settle_yn = ''T'' ';
	end
	else if TabIndex = 1 then
	begin
		dm.SettleTable.IndexFieldNames := 'settle_sender';
		dm.SettleTable.Filtered := true;
		dm.SettleTable.Filter := 'not settle_yn = ''T'' ';
	end
	else if TabIndex = 2 then
	begin
		dm.SettleTable.IndexFieldNames := 'settle_sender';
		dm.SettleTable.Filtered := true;
		dm.SettleTable.Filter := 'settle_yn = ''T'' ';
	end
	else if TabIndex = 3 then
	begin
		dm.SettleTable.IndexFieldNames := 'settle_sender';
		dm.SettleTable.Filtered := true;
		dm.SettleTable.Filter := 'settle_yn = ''R'' ';
	end;
	dm.SettleTable.MasterFields := 'emp_no';
	dm.SettleTable.Open;
	with MainGrid do
	begin
		if not dm.SettleTable.IsEmpty then
		begin
			RowCount := dm.SettleTable.RecordCount + 1;
			ColCount := 9;
			cells[0, 0] := 'No';
			ColWidths[0] := 80;
			cells[1, 0] := '��    ��';
			ColWidths[1] := 80;
			cells[2, 0] := '��    ��';
			ColWidths[2] := 350;
			cells[3, 0] := '�ۼ�����';
			ColWidths[3] := 80;
			cells[4, 0] := '��    ��';
			ColWidths[4] := 100;
			cells[5, 0] := '��    ��';
			ColWidths[5] := 100;
			cells[6, 0] := '����';
			ColWidths[6] := 80;
			cells[7, 0] := '��������';
			ColWidths[7] := 80;
			cells[8, 0] := '��������';
			ColWidths[8] := 100;
			dm.SettleTable.First;
			for i := 1 to dm.SettleTable.RecordCount do
			begin
				cells[0, i] := dm.SettleTableSETTLE_NO.AsString;
				cells[1, i] := '��   ��';
				cells[2, i] := dm.SettleTableSETTLE_NM.AsString;
				cells[3, i] := dm.SettleTableSETTLE_WRITE_DT.AsString;
				cells[4, i] := dm.SettleTableSENDER_NM.AsString;
				cells[5, i] := dm.SettleTableRECVER_NM.AsString;
				cells[6, i] := dm.SettleTableREAD_YN_NM.AsString;
				cells[7, i] := dm.SettleTableSETTLE_YN_NM.AsString;
				cells[8, i] := dm.SettleTableSETTLE_DT.AsString;
				dm.SettleTable.Next;
			end;
		end
		else
		begin
			RowCount := 2;
			ColCount := 1;
			cells[0, 0] := '���� ����';
			if width > 100 then
				ColWidths[0] := 1000
			else
				ColWidths[0] := MainGrid.width;
			cells[0, 1] := '������ �����ϴ�';
		end;
	end;
	setContent(false);
end;

procedure TMainForm.DrawInfoGrid;
var
	sql_str: string;
	keystr: array [0 .. 3] of string;
	i: byte;
begin
	keystr[0] := 'Y';
	keystr[1] := 'N';
	keystr[2] := 'R';
	keystr[3] := 'T';

	sendInfoGrid.RowCount := 5;
	sendInfoGrid.cells[0, 0] := '����  �Ϸ�';
	sendInfoGrid.cells[0, 1] := '������û��';
	sendInfoGrid.cells[0, 2] := '��      ��';
	sendInfoGrid.cells[0, 3] := '�ӽ�  ����';
	sendInfoGrid.cells[0, 4] := '��ü  �߽�';
	sendInfoGrid.ColWidths[0] := 80;
	sendInfoGrid.ColWidths[1] := 120;

	sql_str := 'Select count(*) as cnt From settle Where settle_sender = ' +
		Uds_dm.UserID;
	dm.countQuery.Close;
	dm.countQuery.SQL.Clear;
	dm.countQuery.SQL.Add(sql_str);
	dm.countQuery.Open;
	sendInfoGrid.cells[1, 4] := dm.countQuery.FieldByName('cnt').AsString + ' ��';
	for i := 0 to 3 do
	begin
		dm.countQuery.Close;
		dm.countQuery.SQL.Clear;
		dm.countQuery.SQL.Add(sql_str);
		dm.countQuery.SQL.Add(' and settle_yn = ''' + keystr[i] + ''' ');
		dm.countQuery.Open;
		sendInfoGrid.cells[1, i] := dm.countQuery.FieldByName('cnt')
			.AsString + ' ��';
	end;

	RecvInfoGrid.RowCount := 4;
	RecvInfoGrid.cells[0, 0] := '����  ó��';
	RecvInfoGrid.cells[0, 1] := '���������';
	RecvInfoGrid.cells[0, 2] := '�ݷ�  ó��';
	RecvInfoGrid.cells[0, 3] := '��ü  ����';
	RecvInfoGrid.ColWidths[0] := 80;
	RecvInfoGrid.ColWidths[1] := 120;

	sql_str := 'Select count(*) as cnt From settle Where settle_recver = ' +
		Uds_dm.UserID;
	dm.countQuery.Close;
	dm.countQuery.SQL.Clear;
	dm.countQuery.SQL.Add(sql_str);
	dm.countQuery.SQL.Add('and not settle_yn = ''T''');
	dm.countQuery.Open;
	RecvInfoGrid.cells[1, 3] := dm.countQuery.FieldByName('cnt').AsString + ' ��';
	for i := 0 to 2 do
	begin
		dm.countQuery.Close;
		dm.countQuery.SQL.Clear;
		dm.countQuery.SQL.Add(sql_str);
		dm.countQuery.SQL.Add(' and settle_yn = ''' + keystr[i] + ''' ');
		dm.countQuery.Open;
		RecvInfoGrid.cells[1, i] := dm.countQuery.FieldByName('cnt')
			.AsString + ' ��';
	end;

end;

procedure TMainForm.Edit_BtnClick(Sender: TObject);
begin
	insertForm := TinsertForm.Create(Self);
	insertForm.IsUpdate := true;
	insertForm.senderLabel.Caption := Uds_dm.UserName;
	insertForm.settle_no := dm.SettleTableSETTLE_NO.AsString;
	insertForm.RecvEdit.Text := dm.SettleTableRECVER_NM.AsString;
	insertForm.recver_id := dm.SettleTableSETTLE_RECVER.AsString;
	insertForm.ContREdit.Lines.Text := dm.SettleTableSETTLE_CONT.AsString;
	insertForm.Show;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin

	Uds_dm.UserID := dm.MyQuery.FieldByName('emp_no').AsString;
	Uds_dm.UserName := dm.MyQuery.FieldByName('emp_nm').AsString;
	Uds_dm.UserDept := dm.MyQuery.FieldByName('dept_nm').AsString + ' - ' +
		dm.MyQuery.FieldByName('dept_section_nm').AsString;
	Uds_dm.UserClass := dm.MyQuery.FieldByName('class_nm').AsString;
	Uds_dm.UserStep := dm.MyQuery.FieldByName('class_step').AsInteger;

	SetLogo;

	DrawGrid(TabControl1.TabIndex);
	DrawInfoGrid;
end;

procedure TMainForm.RestartApplication;
var
	AppName: PChar;
begin
	AppName := PChar(Application.ExeName);
	shellExecute(Handle, 'open', AppName, nil, nil, SW_SHOWNORMAL);
	Application.Terminate;
end;

procedure TMainForm.setContent(flag: Boolean);
begin
	if flag then
	begin

		dm.LogTable.Close;
		dm.LogTable.Filtered := true;
		dm.LogTable.Filter := ' log_settle_no = ' +
			dm.SettleTableSETTLE_NO.AsString;
		dm.LogTable.Open;
		ContPanel.visible := true;
		TitleLable.Caption := dm.SettleTableSETTLE_NM.AsString;
		WriteDateLAbel.Caption :=
			DateTimeToStr(dm.SettleTableSETTLE_WRITE_DT.AsDateTime);
		SenderNameLabel.Caption := dm.SettleTableSENDER_NM.AsString;
		SenderDeptLabel.Caption := '';
		SenderClassLabel.Caption := '';
		recvNameLabel.Caption := dm.SettleTableRECVER_NM.AsString;
		RecvDeptLabel.Caption := '';
		RecvClassLabel.Caption := '';
		ContEdit.Lines.Text := dm.SettleTableSETTLE_CONT.AsString;
		if (TabControl1.TabIndex = 0) and
			(dm.SettleTableSETTLE_YN.AsString = 'N') then
		begin
			SettleButton.Enabled := true;
			returnButton.Enabled := true;
		end
		else if (dm.SettleTableSETTLE_YN.AsString = 'T') or
			(dm.SettleTableSETTLE_YN.AsString = 'R') then
		begin
			Edit_Btn.Enabled := true;
		end
		else
		begin
			SettleButton.Enabled := false;
			returnButton.Enabled := false;
		end;
	end
	else
	begin
		dm.LogTable.Close;
		dm.LogTable.Filtered := true;
		dm.LogTable.Filter := ' log_settle_no = -1 ';
		dm.LogTable.Open;
		ContPanel.visible := false;
		SettleButton.Enabled := false;
		returnButton.Enabled := false;
		Edit_Btn.Enabled := false;
	end;

end;

procedure TMainForm.SetLogo;
begin
	IdLabel.Caption := Uds_dm.UserID;
	NameLabel.Caption := Uds_dm.UserName;
	ClassLabel.Caption := Uds_dm.UserClass;
	DeptLabel.Caption := Uds_dm.UserDept;
end;

procedure TMainForm.SettleButtonClick(Sender: TObject);
var
	access_sign, access_string: string;
begin
	if (Sender as TButton).Tag = 1 then
	begin
		access_sign := 'Y';
		access_string := '�����Ϸ�';
	end
	else
	begin
		access_sign := 'R';
		access_string := '�ݷ�ó��';
	end;

	if (dm.SettleTableSETTLE_YN.AsString = 'N') and
		(TabControl1.TabIndex = 0) then
	begin
		dm.SettleTable.Edit;
		dm.SettleTableSETTLE_YN.AsString := access_sign;
		dm.SettleTableSETTLE_DT.AsDateTime := Now;
		try
			dm.SetSettleLog(dm.SettleTableSETTLE_NO.AsString, Uds_dm.UserID,
				access_string);
			dm.SettleTable.Post;
			dm.SettleTable.ApplyUpdates(-1);
		except
			on e: Exception do
				ShowMessage(e.Message);
		end;
		DrawGrid(TabControl1.TabIndex);
	end;
	setContent(true);
end;

procedure TMainForm.MainGridDrawCell(Sender: TObject; ACol, ARow: Integer;
	Rect: TRect; State: TGridDrawState);
var
	pos: Integer;
	s: string;
begin
	s := MainGrid.cells[ACol, ARow];
	with MainGrid.Canvas do
	begin
		FillRect(Rect);
		if (ARow <> 0) and (MainGrid.cells[6, ARow] = '��������') then
		begin
			Font.Style := [fsBold];
		end;
		pos := ((Rect.Right - Rect.Left) - TextWidth(s)) div 2;
		TextRect(Rect, Rect.Left + pos, Rect.Top + 3, s);
	end;
end;

procedure TMainForm.MainGridSelectCell(Sender: TObject; ACol, ARow: Integer;
	var CanSelect: Boolean);
begin
	if not dm.SettleTable.IsEmpty then
	begin
		dm.SettleTable.RecNo := ARow;

		if (dm.SettleTableSETTLE_READ_YN.AsString <> 'Y') and
			(TabControl1.TabIndex = 0) then
		begin
			dm.SettleTable.Edit;
			dm.SettleTableSETTLE_READ_YN.AsString := 'Y';
			try
				dm.SettleTable.Post;
				dm.SettleTable.ApplyUpdates(-1);
			except
				on e: Exception do
					ShowMessage(e.Message);
			end;
			DrawGrid(TabControl1.TabIndex);
		end;
		setContent(true);
	end;
end;

procedure TMainForm.TabControl1Change(Sender: TObject);
begin
	DrawGrid(TabControl1.TabIndex);
	if TabControl1.TabIndex > 1 then
	begin
		returnButton.visible := false;
		SettleButton.visible := false;
		Edit_Btn.visible := true;
	end
	else
	begin
		returnButton.visible := true;
		SettleButton.visible := true;
		Edit_Btn.visible := false;
	end;

end;

end.
