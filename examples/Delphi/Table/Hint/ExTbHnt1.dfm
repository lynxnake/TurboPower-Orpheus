object Form1: TForm1
  Left = 490
  Top = 246
  Width = 337
  Height = 291
  Caption = 'ExTblHints'
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object OvcTable: TOvcTable
    Left = 8
    Top = 8
    Width = 313
    Height = 193
    LockedRows = 1
    TopRow = 1
    ActiveRow = 1
    RowLimit = 5
    LockedCols = 1
    LeftCol = 1
    ActiveCol = 1
    Access = otxNormal
    Adjust = otaCenterLeft
    BorderStyle = bsSingle
    ColorUnused = clWindow
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
    Options = []
    ParentColor = False
    ParentShowHint = False
    ScrollBars = ssBoth
    ShowHint = True
    TabOrder = 0
    TabStop = True
    OnMouseMove = OvcTableMouseMove
    CellData = ()
    RowData = (
      30)
    ColData = (
      51
      False
      False
      64
      False
      False
      55
      False
      False
      48
      False
      False)
  end
  object Panel1: TPanel
    Left = 16
    Top = 208
    Width = 289
    Height = 49
    Font.Color = clNavy
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    object Label1: TLabel
      Left = 5
      Top = 8
      Width = 276
      Height = 16
      Caption = 'Table uses OnMouseMove to display hint when '
    end
    object Label2: TLabel
      Left = 8
      Top = 25
      Width = 244
      Height = 16
      Caption = 'cursor is in the otrInMain area of the table.'
    end
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
    EntryOptions = [efoAutoSelect, efoBeepOnError, efoInsertPushes]
    Epoch = 1900
    Left = 199
    Top = 122
  end
  object Timer: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerTimer
    Left = 248
    Top = 120
  end
end
