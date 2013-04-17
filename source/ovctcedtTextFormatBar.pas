{*********************************************************}
{*                  OVCTCEDT.PAS 4.08                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Sebastian Zierer                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit ovctcedtTextFormatBar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ovcbase, ovcspeed, ComCtrls, Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TovcTextFormatBar = class(TForm)
    Timer1: TTimer;
    btnBold: TSpeedButton;
    btnItalic: TSpeedButton;
    btnUnderline: TSpeedButton;
    procedure Timer1Timer(Sender: TObject);
    procedure btnBoldClick(Sender: TObject);
    procedure btnItalicClick(Sender: TObject);
    procedure btnUnderlineClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    FAllowedFontStyles: TFontStyles;
    procedure SetAllowedFontStyles(const Value: TFontStyles);
  protected
    procedure WMMouseActivate(var Message: TWMMouseActivate);
      message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
    { Private declarations }
  public
    { Public declarations }
    property AllowedFontStyles: TFontStyles read FAllowedFontStyles write SetAllowedFontStyles default [fsBold, fsItalic, fsUnderline];
  end;

var
  ovcTextFormatBar: TovcTextFormatBar;

implementation

{$R *.dfm}

uses
  ovctcedtHTMLText, ovcRTF_IText, Generics.Collections;

{ TovcTextFormatBar }

procedure TovcTextFormatBar.btnBoldClick(Sender: TObject);
var
  RE: TOvcTCHtmlTextEdit;
begin
  if Screen.ActiveControl is TOvcTCHtmlTextEdit then
    RE := TOvcTCHtmlTextEdit(Screen.ActiveControl)
  else
    RE := nil;

  if Assigned(RE) then
    RE.GetIDoc.Selection.Font.Bold := Integer(tomToggle);
end;

procedure TovcTextFormatBar.btnItalicClick(Sender: TObject);
var
  RE: TOvcTCHtmlTextEdit;
begin
  if Screen.ActiveControl is TOvcTCHtmlTextEdit then
    RE := TOvcTCHtmlTextEdit(Screen.ActiveControl)
  else
    RE := nil;

  if Assigned(RE) then
    RE.GetIDoc.Selection.Font.Italic := Integer(tomToggle);
end;

procedure TovcTextFormatBar.btnUnderlineClick(Sender: TObject);
var
  RE: TOvcTCHtmlTextEdit;
  Doc: ITextDocument;
begin
  if Screen.ActiveControl is TOvcTCHtmlTextEdit then
    RE := TOvcTCHtmlTextEdit(Screen.ActiveControl)
  else
    RE := nil;

  if Assigned(RE) then
  begin
    Doc := RE.GetIDoc;
    if Doc.Selection.Font.Underline <> tomNone then
      Doc.Selection.Font.Underline := tomNone
    else
      Doc.Selection.Font.Underline := tomSingle;
  end;
end;

procedure TovcTextFormatBar.CreateParams(var Params: TCreateParams);
begin
  inherited;

  with Params Do
  begin
    if CheckWin32Version(5, 1) then
      WindowClass.Style := WindowClass.Style or CS_DROPSHADOW;
  end;
end;

procedure TovcTextFormatBar.FormCreate(Sender: TObject);
begin
  FAllowedFontStyles := [fsBold, fsItalic, fsUnderline];
end;

procedure TovcTextFormatBar.FormPaint(Sender: TObject);
begin
  Canvas.Brush.Color := $A7ABB0;
  Canvas.Brush.Style := bsSolid;
  Canvas.FrameRect(ClientRect);
end;

procedure TovcTextFormatBar.SetAllowedFontStyles(const Value: TFontStyles);
var
  Buttons: TObjectList<TSpeedButton>;
  I: Integer;
begin
  FAllowedFontStyles := Value;
  btnBold.Visible := fsBold in FAllowedFontStyles;
  btnItalic.Visible := fsItalic in FAllowedFontStyles;
  btnUnderline.Visible := fsUnderline in FAllowedFontStyles;
  Buttons := TObjectList<TSpeedButton>.Create(False);
  try
    if btnBold.Visible then
      Buttons.Add(btnBold);
    if btnItalic.Visible then
      Buttons.Add(btnItalic);
    if btnUnderline.Visible then
      Buttons.Add(btnUnderline);

    for I := 0 to Buttons.Count - 1 do
      Buttons[I].Left := 4 + (24 * I);
    Width := 4 + (24 * Buttons.Count) + 4;
  finally
    Buttons.Free;
  end;
end;

procedure TovcTextFormatBar.Timer1Timer(Sender: TObject);
var
  RE: TOvcTCHtmlTextEdit;
begin
  if Screen.ActiveControl is TOvcTCHtmlTextEdit then
    RE := TOvcTCHtmlTextEdit(Screen.ActiveControl)
  else
    RE := nil;

  btnBold.Enabled := Assigned(RE);
  btnItalic.Enabled := Assigned(RE);
  btnUnderline.Enabled := Assigned(RE);
  if Assigned(RE) then
  begin
    btnBold.Down := fsBold in TOvcTCHtmlTextEdit(RE).SelAttributes.Style;
    btnItalic.Down := fsItalic in TOvcTCHtmlTextEdit(RE).SelAttributes.Style;
    btnUnderline.Down := fsUnderline in TOvcTCHtmlTextEdit(RE).SelAttributes.Style;
  end;
end;

procedure TovcTextFormatBar.WMMouseActivate(var Message: TWMMouseActivate);
begin
  Message.Result := MA_NOACTIVATE;
end;

end.
