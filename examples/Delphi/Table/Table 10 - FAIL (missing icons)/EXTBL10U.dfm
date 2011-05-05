object Form1: TForm1
  Left = 384
  Top = 212
  Caption = 'Form1'
  ClientHeight = 326
  ClientWidth = 290
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object OvcTable1: TOvcTable
    Left = 16
    Top = 12
    Width = 269
    Height = 304
    Controller = OvcController1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = []
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
    Options = [otoThumbTrack]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnActiveCellChanged = OvcTable1ActiveCellChanged
    OnActiveCellMoving = OvcTable1ActiveCellMoving
    OnGetCellData = OvcTable1GetCellData
    OnLockedCellClick = OvcTable1LockedCellClick
    CellData = (
      'Form1.OvcTCColHead1'
      'Form1.OvcTCString2'
      'Form1.OvcTCString1')
    RowData = (
      30)
    ColData = (
      72
      False
      False
      102
      False
      True
      'Form1.OvcTCString1'
      91
      False
      True
      'Form1.OvcTCString2')
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
    Left = 199
    Top = 122
  end
  object OvcTCColHead1: TOvcTCColHead
    ShowLetters = False
    OnOwnerDraw = OvcTCColHead1OwnerDraw
    Left = 37
    Top = 165
  end
  object OvcTCString1: TOvcTCString
    MaxLength = 10
    Table = OvcTable1
    Left = 83
    Top = 164
  end
  object OvcTCString2: TOvcTCString
    MaxLength = 10
    Table = OvcTable1
    Left = 128
    Top = 163
  end
end
