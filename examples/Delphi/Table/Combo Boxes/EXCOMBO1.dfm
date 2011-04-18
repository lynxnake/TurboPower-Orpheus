object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Table ComboBox Cell Example'
  ClientHeight = 248
  ClientWidth = 278
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 16
  object OvcTable1: TOvcTable
    Left = 8
    Top = 9
    Width = 261
    Height = 201
    ColorUnused = clBtnFace
    Controller = OvcController1
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    GridPenSet.NormalGrid.NormalColor = clBtnShadow
    GridPenSet.NormalGrid.Style = psSolid
    GridPenSet.NormalGrid.Effect = geBoth
    GridPenSet.LockedGrid.NormalColor = clBtnShadow
    GridPenSet.LockedGrid.Style = psSolid
    GridPenSet.LockedGrid.Effect = ge3D
    GridPenSet.CellWhenFocused.NormalColor = clBlack
    GridPenSet.CellWhenFocused.Style = psSolid
    GridPenSet.CellWhenFocused.Effect = geBoth
    GridPenSet.CellWhenUnfocused.NormalColor = clBlack
    GridPenSet.CellWhenUnfocused.Style = psSolid
    GridPenSet.CellWhenUnfocused.Effect = geBoth
    LockedRowsCell = OvcTCColHead1
    Options = [otoNoRowResizing, otoNoColResizing, otoNoSelection]
    ParentFont = False
    TabOrder = 0
    OnDoneEdit = OvcTable1DoneEdit
    OnGetCellData = OvcTable1GetCellData
    CellData = (
      'Form1.OvcTCColHead1'
      'Form1.OvcTCComboBox2'
      'Form1.OvcTCComboBox1'
      'Form1.OvcTCRowHead1')
    RowData = (
      25)
    ColData = (
      29
      False
      True
      'Form1.OvcTCRowHead1'
      97
      False
      True
      'Form1.OvcTCComboBox1'
      112
      False
      True
      'Form1.OvcTCComboBox2')
  end
  object Button1: TButton
    Left = 188
    Top = 215
    Width = 81
    Height = 25
    Caption = '&Close'
    TabOrder = 1
    OnClick = Button1Click
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
    Left = 12
    Top = 215
  end
  object OvcTCColHead1: TOvcTCColHead
    Headings.Strings = (
      ''
      'Combo1'
      'Combo2')
    ShowLetters = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Default'
    Font.Style = [fsBold]
    Table = OvcTable1
    TableFont = False
    TextStyle = tsRaised
    Left = 44
    Top = 215
  end
  object OvcTCComboBox1: TOvcTCComboBox
    Items.Strings = (
      'Fred'
      'Kent'
      'Lee'
      'Bob'
      'Julian'
      'Mike'
      'Tom'
      'Quentin'
      'Mabel'
      'Sue')
    MaxLength = 20
    Table = OvcTable1
    Left = 76
    Top = 215
  end
  object OvcTCComboBox2: TOvcTCComboBox
    Items.Strings = (
      'Sally'
      'Brenda'
      'Elizabeth'
      'Madeline'
      'Sam'
      'Laura'
      'Kelly'
      'Alicia'
      'Patricia'
      'Sharon'
      'Anton')
    MaxLength = 20
    Table = OvcTable1
    Left = 108
    Top = 215
  end
  object OvcTCRowHead1: TOvcTCRowHead
    Adjust = otaCenter
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Default'
    Font.Style = [fsBold]
    Table = OvcTable1
    TableFont = False
    TextStyle = tsRaised
    Left = 140
    Top = 215
  end
end
