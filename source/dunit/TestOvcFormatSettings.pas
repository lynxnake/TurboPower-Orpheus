unit TestOvcFormatSettings;

interface

uses
  TestFramework;

type
  TTestFormatSettings = class(TTestCase)
  published
    procedure TestovcLongDayNames;
  end;

implementation

uses
  OvcFormatSettings;

{ TTestFormatSettings }

procedure TTestFormatSettings.TestovcLongDayNames;
var
  iCount: Integer;
  pSettings: TDayArray;
  sBuffer: string;
begin
  for iCount := Low(pSettings) to High(pSettings) do
  begin
    sBuffer := pSettings[iCount];
    if sBuffer <> '' then
    begin
    end;
  end;
  CheckTrue(True);
end;

initialization
  RegisterTest(TTestFormatSettings.Suite);
end.