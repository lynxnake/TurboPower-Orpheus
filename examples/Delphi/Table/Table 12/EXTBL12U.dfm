object Form1: TForm1
  Left = 200
  Top = 108
  Caption = 'ExTable12 - Saving and restoring column settings'
  ClientHeight = 253
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OvcTable1: TOvcTable
    Left = 8
    Top = 8
    Width = 230
    Height = 195
    Controller = OvcController1
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
    Options = [otoNoRowResizing, otoNoColResizing, otoNoSelection, otoAllowColMoves]
    TabOrder = 0
    OnColumnsChanged = OvcTable1ColumnsChanged
    OnExit = OvcTable1Exit
    OnGetCellData = OvcTable1GetCellData
    CellData = ()
    RowData = (
      30)
    ColData = (
      44
      False
      False
      32
      False
      False
      83
      False
      False
      50
      False
      False)
  end
  object Button1: TButton
    Left = 64
    Top = 215
    Width = 89
    Height = 33
    Caption = '&Save'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 247
    Top = 7
    Width = 284
    Height = 195
    TabStop = False
    Lines.Strings = (
      'The primary purpose of this example is to show how to'
      'store column settings, i.e., the default cell, width, and'
      'original design position, in an INI file so that the values'
      'can be read back at startup and the table restored to'
      'the same settings.'
      ''
      'This is a *very basic* example in that it depends on'
      'a fixed number of columns, does not store the data,'
      'nor allow for values to be missing from the INI file,'
      'i.e., the default cell is not assigned in these cases.'
      'These and other details are left up to you.')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
    WordWrap = False
  end
  object OvcController1: TOvcController
    EntryCommands.TableList = (
      'Default'
      True
      ()
      'WordStar'
      False
      ()
      'Grid'
      False
      ())
    Epoch = 1900
    Left = 154
    Top = 66
  end
  object CB1: TOvcTCCheckBox
    CellGlyphs.IsDefault = True
    CellGlyphs.GlyphCount = 3
    CellGlyphs.ActiveGlyphCount = 2
    Table = OvcTable1
    OnClick = CB1Click
    Left = 59
    Top = 10
  end
  object SF1: TOvcTCString
    MaxLength = 10
    Table = OvcTable1
    Left = 106
    Top = 10
  end
  object PF1: TOvcTCPictureField
    DataType = pftTime
    PictureMask = 'hh:mm'
    MaxLength = 5
    CaretOvr.Shape = csBlock
    EFColors.Disabled.BackColor = clWindow
    EFColors.Disabled.TextColor = clGrayText
    EFColors.Error.BackColor = clRed
    EFColors.Error.TextColor = clBlack
    EFColors.Highlight.BackColor = clHighlight
    EFColors.Highlight.TextColor = clHighlightText
    Table = OvcTable1
    Left = 179
    Top = 10
    RangeHigh = {7F510100000000000000}
    RangeLow = {00000000000000000000}
  end
end
