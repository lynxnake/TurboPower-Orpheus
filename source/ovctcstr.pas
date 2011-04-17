{*********************************************************}
{*                  OVCTCSTR.PAS 4.06                    *}
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
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctcstr;
  {-Orpheus Table Cell - base string type}

interface

uses
  Windows, SysUtils, Messages, Graphics, Classes, OvcTCmmn, OvcTCell;

type
  TOvcTCBaseString = class(TOvcBaseTableCell)
    protected {private}
      {.Z+}
      FDataStringType : TOvcTblStringtype;
      FUseWordWrap    : boolean;
      FShowEllipsis   : Boolean;
      FOnChange       : TNotifyEvent;
      {.Z-}

    protected
      {.Z+}
      procedure SetDataStringType(ADST : TOvcTblStringtype);
      procedure SetUseWordWrap(WW : boolean);

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;
      procedure tcPaintStrZ(TblCanvas : TCanvas;
                      const CellRect  : TRect;
                      const CellAttr  : TOvcCellAttributes;
                            StZ       : string);
      {.Z-}

      {properties}
      property DataStringType : TOvcTblStringtype
         read FDataStringType write SetDataStringType default tstString;

      property UseWordWrap : boolean
         read FUseWordWrap write SetUseWordWrap;

      property ShowEllipsis: Boolean read FShowEllipsis write FShowEllipsis;

      {events}
      property OnChange : TNotifyEvent
         read FOnChange write FOnChange;
    public
      constructor Create(AOwner : TComponent); override;
  end;


implementation


{===TOvcTCBaseString==========================================}
constructor TOvcTCBaseString.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  FShowEllipsis := True;
  FDataStringType := tstString;
end;

procedure TOvcTCBaseString.tcPaint(TableCanvas : TCanvas;
                             const CellRect    : TRect;
                                   RowNum      : TRowNum;
                                   ColNum      : TColNum;
                             const CellAttr    : TOvcCellAttributes;
                                   Data        : pointer);
  {-Changes
    04/2011 AB: replaced UsePString by FDataStringType }
  var
    sBuffer: string;
  begin
    {blank out the cell}
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, Data);
    {if the cell is invisible or the passed data is nil and we're not
     designing, all's done}
    if (CellAttr.caAccess = otxInvisible) or
       ((Data = nil) and not (csDesigning in ComponentState)) then
      Exit;

    if Data = nil then
      sBuffer := Format('%d:%d', [RowNum, ColNum])
    else
      case FDataStringType of
        tstShortString: sBuffer := string(POvcShortString(Data)^);
        tstPChar:       sBuffer := string(PChar(Data));
        tstString:      sBuffer := PString(Data)^;
      end;

    tcPaintStrZ(TableCanvas, cellRect, CellAttr, sBuffer);
  end;

{--------}
procedure TOvcTCBaseString.tcPaintStrZ(TblCanvas : TCanvas;
                               const CellRect  : TRect;
                               const CellAttr  : TOvcCellAttributes;
                                     StZ       : string);
  var
    Size   : TSize;
  var
    Wd     : integer;
    LenStZ : integer;
    DTOpts : Cardinal;
    R      : TRect;
    OurAdjust : TOvcTblAdjust;
  begin
    TblCanvas.Font := CellAttr.caFont;
    TblCanvas.Font.Color := CellAttr.caFontColor;

    LenStZ := Length(StZ);

    R := CellRect;
    InflateRect(R, -Margin div 2, -Margin div 2);

    if FUseWordWrap then
      begin
        DTOpts:= DT_NOPREFIX or DT_WORDBREAK;
        case CellAttr.caAdjust of
          otaTopLeft, otaCenterLeft, otaBottomLeft    :
             DTOpts := DTOpts or DT_LEFT;
          otaTopRight, otaCenterRight, otaBottomRight :
             DTOpts := DTOpts or DT_RIGHT;
        else
          DTOpts := DTOpts or DT_CENTER;
        end;{case}
      end
    else
      begin
        DTOpts:= DT_NOPREFIX or DT_SINGLELINE;

        {make sure that if the string doesn't fit, we at least see
         the first few characters}
        GetTextExtentPoint32(TblCanvas.Handle, PChar(StZ), LenStZ, Size);
        Wd := Size.cX;
        OurAdjust := CellAttr.caAdjust;
        if Wd > (R.Right - R.Left) then
          case CellAttr.caAdjust of
            otaTopCenter, otaTopRight : OurAdjust := otaTopLeft;
            otaCenter, otaCenterRight : OurAdjust := otaCenterLeft;
            otaBottomCenter, otaBottomRight : OurAdjust := otaBottomLeft;
          end;

        case OurAdjust of
          otaTopLeft, otaCenterLeft, otaBottomLeft    :
             DTOpts := DTOpts or DT_LEFT;
          otaTopRight, otaCenterRight, otaBottomRight :
             DTOpts := DTOpts or DT_RIGHT;
        else
          DTOpts := DTOpts or DT_CENTER;
        end;{case}
        case OurAdjust of
          otaTopLeft, otaTopCenter, otaTopRight :
             DTOpts := DTOpts or DT_TOP;
          otaBottomLeft, otaBottomCenter, otaBottomRight :
             DTOpts := DTOpts or DT_BOTTOM;
        else
          DTOpts := DTOpts or DT_VCENTER;
        end;{case}
      end;

  if FShowEllipsis and (CellAttr.caAccess = otxReadOnly) then
    DTOpts := DTOpts or DT_END_ELLIPSIS;

    case CellAttr.caTextStyle of
      tsFlat :
        DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
      tsRaised :
        begin
          OffsetRect(R, -1, -1);
          TblCanvas.Font.Color := CellAttr.caFontHiColor;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          OffsetRect(R, 1, 1);
          TblCanvas.Font.Color := CellAttr.caFontColor;
          TblCanvas.Brush.Style := bsClear;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          TblCanvas.Brush.Style := bsSolid;
        end;
      tsLowered :
        begin
          OffsetRect(R, 1, 1);
          TblCanvas.Font.Color := CellAttr.caFontHiColor;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          OffsetRect(R, -1, -1);
          TblCanvas.Font.Color := CellAttr.caFontColor;
          TblCanvas.Brush.Style := bsClear;
          DrawText(TblCanvas.Handle, PChar(StZ), LenStZ, R, DTOpts);
          TblCanvas.Brush.Style := bsSolid;
        end;
      end;
  end;
{--------}
procedure TOvcTCBaseString.SetDataStringType(ADST : TOvcTblStringtype);
  begin
    if ADST <> FDataStringType then begin
      FDataStringType := ADST;
      tcDoCfgChanged;
    end;
  end;

{--------}
procedure TOvcTCBaseString.SetUseWordWrap(WW : boolean);
  begin
    if (WW <> FUseWordWrap) then
      begin
        FUseWordWrap := WW;
        tcDoCfgChanged;
      end;
  end;
{====================================================================}


end.
