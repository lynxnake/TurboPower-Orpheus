object frmTestOvcPictureField: TfrmTestOvcPictureField
  Left = 0
  Top = 0
  Caption = 'Test'
  ClientHeight = 112
  ClientWidth = 443
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 17
  object OvcTable1: TOvcTable
    Left = 24
    Top = 21
    Width = 401
    Height = 59
    Margins.Left = 4
    Margins.Top = 4
    Margins.Right = 4
    Margins.Bottom = 4
    LockedRows = 0
    TopRow = 0
    ActiveRow = 0
    RowLimit = 1
    LockedCols = 0
    LeftCol = 0
    GridPenSet.NormalGrid.NormalColor = clBtnShadow
    GridPenSet.NormalGrid.Style = psDot
    GridPenSet.NormalGrid.Effect = geBoth
    GridPenSet.LockedGrid.NormalColor = clBtnShadow
    GridPenSet.LockedGrid.Style = psSolid
    GridPenSet.LockedGrid.Effect = ge3D
    GridPenSet.CellWhenFocused.NormalColor = clBlack
    GridPenSet.CellWhenFocused.Style = psSolid
    GridPenSet.CellWhenFocused.Effect = geBoth
    GridPenSet.CellWhenUnfocused.NormalColor = clBlack
    GridPenSet.CellWhenUnfocused.Style = psDash
    GridPenSet.CellWhenUnfocused.Effect = geBoth
    TabOrder = 0
    OnGetCellData = OvcTable1GetCellData
    CellData = (
      'frmTestOvcPictureField.OvcTCPictureField1'
      'frmTestOvcPictureField.OvcTCString1')
    RowData = (
      39)
    ColData = (
      196
      False
      True
      'frmTestOvcPictureField.OvcTCString1'
      196
      False
      True
      'frmTestOvcPictureField.OvcTCPictureField1')
  end
  object OvcTCString1: TOvcTCString
    Table = OvcTable1
    Left = 72
    Top = 26
  end
  object OvcTCPictureField1: TOvcTCPictureField
    PictureMask = 'XXXXXXXXXXXXXXX'
    CaretOvr.Shape = csBlock
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    Table = OvcTable1
    Left = 214
    Top = 32
    RangeHigh = {00000000000000000000}
    RangeLow = {00000000000000000000}
  end
end
