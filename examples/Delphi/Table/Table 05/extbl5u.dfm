object Form1: TForm1
  Left = 195
  Top = 110
  Width = 199
  Height = 250
  Caption = 'Form1'
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OvcTable1: TOvcTable
    Left = 17
    Top = 8
    Width = 158
    Height = 195
    RowLimit = 10
    Colors.ActiveFocused = clHighlight
    Colors.ActiveFocusedText = clHighlightText
    Colors.ActiveUnfocused = clHighlight
    Colors.ActiveUnfocusedText = clHighlightText
    Colors.Locked = clBtnFace
    Colors.LockedText = clWindowText
    Colors.Editing = clBtnFace
    Colors.EditingText = clWindowText
    Colors.Selected = clHighlight
    Colors.SelectedText = clHighlightText
    Controller = OvcController1
    GridPenSet.NormalGrid.NormalColor = clBtnShadow
    GridPenSet.NormalGrid.SecondColor = clBtnHighlight
    GridPenSet.NormalGrid.Style = psDot
    GridPenSet.NormalGrid.Effect = geBoth
    GridPenSet.LockedGrid.NormalColor = clBtnShadow
    GridPenSet.LockedGrid.SecondColor = clBtnHighlight
    GridPenSet.LockedGrid.Style = psSolid
    GridPenSet.LockedGrid.Effect = ge3D
    GridPenSet.CellWhenFocused.NormalColor = clBlack
    GridPenSet.CellWhenFocused.SecondColor = clBtnHighlight
    GridPenSet.CellWhenFocused.Style = psSolid
    GridPenSet.CellWhenFocused.Effect = geBoth
    GridPenSet.CellWhenUnfocused.NormalColor = clBlack
    GridPenSet.CellWhenUnfocused.SecondColor = clBtnHighlight
    GridPenSet.CellWhenUnfocused.Style = psDash
    GridPenSet.CellWhenUnfocused.Effect = geBoth
    Options = [otoNoRowResizing, otoNoColResizing, otoAlwaysEditing, otoNoSelection]
    ScrollBars = ssVertical
    TabOrder = 0
    OnGetCellData = OvcTable1GetCellData
    CellData = (
      'Form1.TblCB1'
      'Form1.TblCB2'
      'Form1.TblCB3')
    RowData = (
      30
      1
      False
      31)
    ColData = (
      38
      False
      False
      32
      False
      True
      'Form1.TblCB1'
      37
      False
      True
      'Form1.TblCB2'
      31
      False
      True
      'Form1.TblCB3')
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
    Left = 5
    Top = 10
  end
  object TblCB1: TOvcTCCheckBox
    AcceptActivationClick = True
    AllowGrayed = False
    CellGlyphs.IsDefault = True
    CellGlyphs.GlyphCount = 3
    CellGlyphs.ActiveGlyphCount = 2
    ShowHint = False
    Table = OvcTable1
    OnClick = TblCB1Click
    Left = 41
    Top = 10
  end
  object TblCB2: TOvcTCCheckBox
    AcceptActivationClick = True
    AllowGrayed = False
    CellGlyphs.IsDefault = True
    CellGlyphs.GlyphCount = 3
    CellGlyphs.ActiveGlyphCount = 2
    ShowHint = False
    Table = OvcTable1
    Left = 77
    Top = 10
  end
  object TblCB3: TOvcTCCheckBox
    AcceptActivationClick = True
    AllowGrayed = False
    CellGlyphs.IsDefault = True
    CellGlyphs.GlyphCount = 3
    CellGlyphs.ActiveGlyphCount = 2
    ShowHint = False
    Table = OvcTable1
    Left = 113
    Top = 11
  end
end
