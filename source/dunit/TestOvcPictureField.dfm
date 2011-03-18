object frmTestOvcPictureField: TfrmTestOvcPictureField
  Left = 0
  Top = 0
  Caption = 'Test'
  ClientHeight = 131
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OvcTable1: TOvcTable
    Left = 18
    Top = 16
    Width = 623
    Height = 79
    LockedRows = 0
    TopRow = 0
    ActiveRow = 0
    RowLimit = 2
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
      'frmTestOvcPictureField.OvcTCSimpleField1'
      'frmTestOvcPictureField.OvcTCPictureField2'
      'frmTestOvcPictureField.OvcTCNumericField1'
      'frmTestOvcPictureField.OvcTCString1'
      'frmTestOvcPictureField.OvcTCPictureField1')
    RowData = (
      30)
    ColData = (
      100
      False
      True
      'frmTestOvcPictureField.OvcTCString1'
      100
      False
      True
      'frmTestOvcPictureField.OvcTCPictureField1'
      100
      False
      True
      'frmTestOvcPictureField.OvcTCPictureField2'
      150
      False
      True
      'frmTestOvcPictureField.OvcTCNumericField1'
      100
      False
      True
      'frmTestOvcPictureField.OvcTCSimpleField1')
  end
  object OvcTCString1: TOvcTCString
    Table = OvcTable1
    Left = 52
    Top = 34
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
    Left = 156
    Top = 32
    RangeHigh = {00000000000000000000}
    RangeLow = {00000000000000000000}
  end
  object OvcTCPictureField2: TOvcTCPictureField
    DataType = pftLongInt
    PictureMask = 'iiiiiiiiiii'
    MaxLength = 11
    CaretOvr.Shape = csBlock
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    Table = OvcTable1
    Left = 256
    Top = 32
    RangeHigh = {FFFFFF7F000000000000}
    RangeLow = {00000080000000000000}
  end
  object OvcTCNumericField1: TOvcTCNumericField
    DataType = nftDouble
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    PictureMask = '#,###.##'
    Table = OvcTable1
    Left = 370
    Top = 32
    RangeHigh = {73B2DBB9838916F2FE43}
    RangeLow = {73B2DBB9838916F2FEC3}
  end
  object OvcTCSimpleField1: TOvcTCSimpleField
    CaretOvr.Shape = csBlock
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    MaxLength = 20
    Table = OvcTable1
    Left = 504
    Top = 34
    RangeHigh = {00000000000000000000}
    RangeLow = {00000000000000000000}
  end
end
