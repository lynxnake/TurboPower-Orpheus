unit ovctccustomedt;

interface

uses
  Messages, Types, Classes, Controls, StdCtrls, ExtCtrls, Graphics, ovctcmmn,
  ovctcstr, ovctCell;

type
  TAfterCreateControlEvent = procedure(const AControl: TWinControl) of object;

  TOVCTCCustomEdt = class(TCustomEdit)
  private
    FCellOwner: TOvcBaseTableCell;
  protected
    procedure WMGetDlgCode(var Msg: TMessage);
    message WM_GETDLGCODE;
    procedure WMKeyDown(var Msg: TWMKey);
    message WM_KEYDOWN;
    procedure WMKillFocus(var Msg: TWMKillFocus);
    message WM_KILLFOCUS;
    procedure WMSetFocus(var Msg: TWMSetFocus);
    message WM_SETFOCUS;
  public
    property CellOwner: TOvcBaseTableCell read FCellOwner write FCellOwner;
  end;

  TOvcTCCustomControl = class(TOvcTCBaseString)
  private
    FAfterCreateControl: TAfterCreateControlEvent;
    FCellEditorBuffer: TObject;
    FTimer: TTimer;
    procedure OnTimer(Sender: TObject);
  protected
    function DoCreateControl: TWinControl; virtual; abstract;
    procedure DoDataToControl(const AControl: TWinControl; Data: Pointer); virtual; abstract;
    procedure NilCellEditor; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function EditHandle: THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect: TRect); override;
    procedure StartEditing(RowNum: TRowNum; ColNum: TColNum; CellRect: TRect; const CellAttr: TOvcCellAttributes; CellStyle: TOvcTblEditorStyle; Data: Pointer); override;
    procedure StopEditing(SaveValue: Boolean; Data: Pointer); override;
    property AfterCreateControl: TAfterCreateControlEvent read FAfterCreateControl write FAfterCreateControl;
  published
    property UseASCIIZStrings;
  end;

  TOvcTCCustomStr = class(TOvcTCCustomControl)
  private
    FCharCase: TEditCharCase;
    FEdit: TOVCTCCustomEdt;
    FMaxLength: Integer;
    FNurZiffern: Boolean;
    FPasswordChar: Char;
    FString: string;
  protected
    function DoCreateControl: TWinControl; override;
    procedure DoDataToControl(const AControl: TWinControl; Data: Pointer); override;
    function GetCellEditor: TControl; override;
    function get_PasswordChar: Char;
    procedure NilCellEditor; override;
    procedure set_PasswordChar(const Value: Char);
  public
    constructor Create(AOwner: TComponent); override;
    procedure SaveEditedData(Data: Pointer); override;
    procedure StringToData(const AValue: string; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    property StringValue: string read FString;
  published
    property CharCase: TEditCharCase read FCharCase write FCharCase;
    property MaxLength: Integer read FMaxLength write FMaxLength;
    property NurZiffern: Boolean read FNurZiffern write FNurZiffern;
    property PasswordChar: Char read get_PasswordChar write set_PasswordChar;
  end;

implementation

uses
  SysUtils, Windows, Forms, ovctcedt;

type
  TProtectedWinControl = class(TWinControl)
  end;

  TPOvcTCCustomString = class(TOvcTCCustomString)
  end;

{ TOVCTCCustomEdt }

procedure TOVCTCCustomEdt.WMGetDlgCode(var Msg: TMessage);
begin
  if CellOwner = nil then
    inherited
  else
  begin
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
    if CellOwner.TableWantsEnter then
      Msg.Result := Msg.Result or DLGC_WANTALLKEYS;
    inherited;
  end;
end;

procedure TOVCTCCustomEdt.WMKeyDown(var Msg: TWMKey);
  procedure GetSelection(var S, E: word);

  type
    LH = packed record
      L, H: word;
    end;

  var
    GetSel: longint;
  begin
    GetSel := SendMessage(Handle, EM_GETSEL, 0, 0);
    S := LH(GetSel).L;
    E := LH(GetSel).H;
  end;

var
  GridReply: TOvcTblKeyNeeds;
  GridUsedIt: Boolean;
  SStart, SEnd: word;
begin
  if CellOwner = nil then
    inherited
  else
  begin
    GridUsedIt := False;
    GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave:
        begin
          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := True;
        end;
      otkWouldLike:
        case Msg.CharCode of
          VK_PRIOR, VK_NEXT, VK_UP, VK_DOWN:
            begin
              CellOwner.SendKeyToTable(Msg);
              GridUsedIt := True;
            end;
          VK_LEFT:
            if TPOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if (SStart = SEnd) and (SStart = 0) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := True;
              end;
            end;
          VK_RIGHT:
            if TPOvcTCCustomString(CellOwner).AutoAdvanceLeftRight then
            begin
              GetSelection(SStart, SEnd);
              if ((SStart = SEnd) or (SStart = 0)) and (SEnd = GetTextLen) then
              begin
                CellOwner.SendKeyToTable(Msg);
                GridUsedIt := True;
              end;
            end;
        end;
    end; { case }

    if not GridUsedIt then
      inherited;
  end;
end;

procedure TOVCTCCustomEdt.WMKillFocus(var Msg: TWMKillFocus);
begin
  inherited;
  if CellOwner <> nil then
    CellOwner.PostMessageToTable(ctim_KillFocus, Msg.FocusedWnd, 0);
end;

procedure TOVCTCCustomEdt.WMSetFocus(var Msg: TWMSetFocus);
begin
  inherited;
  if CellOwner <> nil then
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
end;

{ TOvcTCCustomControl }

constructor TOvcTCCustomControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTimer := TTimer.Create(nil);
  FTimer.Enabled := False;
  FTimer.Interval := 100;
  FTimer.OnTimer := OnTimer;
  UseASCIIZStrings := True;
end;

destructor TOvcTCCustomControl.Destroy;
begin
  FreeAndNil(FTimer);
  inherited Destroy;
end;

function TOvcTCCustomControl.EditHandle: THandle;
begin
  if Assigned(CellEditor) then
    Result := (CellEditor as TWinControl).Handle
  else
    Result := 0;
end;

procedure TOvcTCCustomControl.EditHide;
begin
  if Assigned(CellEditor) then
    with CellEditor as TWinControl do
      SetWindowPos(Handle, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
end;

procedure TOvcTCCustomControl.EditMove(CellRect: TRect);

var
  iHandle: HWND;
  NewTop: Integer;
begin
  if Assigned(CellEditor) then
  begin
    iHandle := EditHandle;
    with CellRect do
    begin
      NewTop := Top;
      if TProtectedWinControl(CellEditor).Ctl3D then
        InflateRect(CellRect, -1, -1);
      SetWindowPos(iHandle, HWND_TOP, Left, NewTop, Right - Left, Bottom - Top, SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
    end;
    InvalidateRect(iHandle, nil, False);
    UpdateWindow(iHandle);
  end;
end;

procedure TOvcTCCustomControl.OnTimer(Sender: TObject);
begin
  FTimer.Enabled := False;
  FreeAndNil(FCellEditorBuffer);
end;

procedure TOvcTCCustomControl.StartEditing(RowNum: TRowNum; ColNum: TColNum; CellRect: TRect; const CellAttr: TOvcCellAttributes; CellStyle: TOvcTblEditorStyle; Data: Pointer);

var
  pControl: TWinControl;
begin
  pControl := DoCreateControl;
  if pControl = nil then
    Exit;
  if Assigned(FAfterCreateControl) then
    FAfterCreateControl(pControl);

  with TProtectedWinControl(pControl) do
  begin
    Parent := FTable;
    Color := CellAttr.caColor;
    case CellStyle of
      tes3D:
        Ctl3D := True;
    else
      Ctl3D := False;
    end;
    AutoSize := False;
    Left := CellRect.Left;
    Top := CellRect.Top;
    Width := CellRect.Right - CellRect.Left;
    Font := CellAttr.caFont;
    Font.Color := CellAttr.caFontColor;
    Hint := Self.Hint;
    ShowHint := Self.ShowHint;
    Visible := True;
    TabStop := False;
    DoDataToControl(pControl, Data);
  end;
end;

procedure TOvcTCCustomControl.StopEditing(SaveValue: Boolean; Data: Pointer);

var
  pControl: TWinControl;
  pForm: TCustomForm;
begin
  if SaveValue and Assigned(Data) then
  begin
    TProtectedWinControl(CellEditor).DoExit;
    SaveEditedData(Data);
  end;

  pControl := Table;
  pForm := GetParentForm(Table);
  if pForm <> nil then
    pControl := pForm.ActiveControl;
  if pControl = CellEditor then
    pControl := Table;

  FCellEditorBuffer := CellEditor;
  FTimer.Enabled := True;
  NilCellEditor;
  pControl.SetFocus;
end;

{ TOvcTCCustomStr }

constructor TOvcTCCustomStr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCharCase := ecNormal;
end;

function TOvcTCCustomStr.DoCreateControl: TWinControl;
begin
  FEdit := TOVCTCCustomEdt.Create(Table);
  FEdit.CellOwner := Self;
  FEdit.MaxLength := MaxLength;
  FEdit.CharCase := CharCase;
  FEdit.PasswordChar := FPasswordChar;
  Result := FEdit;
end;

procedure TOvcTCCustomStr.DoDataToControl(const AControl: TWinControl; Data: Pointer);
begin
  if Data <> nil then
    FEdit.Text := PChar(Data)
  else
    FEdit.Text := '';
end;

function TOvcTCCustomStr.GetCellEditor: TControl;
begin
  Result := FEdit;
end;

function TOvcTCCustomStr.get_PasswordChar: Char;
begin
  Result := FPasswordChar;
end;

procedure TOvcTCCustomStr.NilCellEditor;
begin
  FEdit := nil;
end;

procedure TOvcTCCustomStr.SaveEditedData(Data: Pointer);
begin
  if FEdit <> nil then
    FString := FEdit.Text
  else
    FString := '';
end;

procedure TOvcTCCustomStr.set_PasswordChar(const Value: Char);
begin
  FPasswordChar := Value;
end;

procedure TOvcTCCustomStr.StringToData(const AValue: string; var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  FString := AValue;
  Data := PChar(FString);
end;

end.
