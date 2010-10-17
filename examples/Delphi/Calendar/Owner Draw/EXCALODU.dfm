object Form1: TForm1
  Left = 278
  Top = 180
  Caption = 'Owner-Draw Calendar Example'
  ClientHeight = 268
  ClientWidth = 498
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Default'
  Font.Style = []
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 13
  object Calendar: TOvcCalendar
    Left = 8
    Top = 8
    Width = 489
    Height = 265
    BorderStyle = bsNone
    Colors.ActiveDay = clRed
    Colors.ColorScheme = cscalCustom
    Colors.DayNames = clMaroon
    Colors.Days = clBlack
    Colors.InactiveDays = clGray
    Colors.MonthAndYear = clBlue
    Colors.Weekend = clRed
    DayNameWidth = 3
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Default'
    Font.Style = []
    Options = [cdoShortNames, cdoShowYear, cdoShowInactive]
    ParentFont = False
    TabOrder = 0
    OnDrawItem = CalendarDrawItem
  end
end
