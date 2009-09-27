unit TestOVCEditU;

interface

uses
  TestFramework, OvcEditU;

type
  TestOvcEditUClass = class(TTestCase)
  published
    procedure TestedScanToEnd;
  end;

implementation

{ TestOvcEditUClass }

procedure TestOvcEditUClass.TestedScanToEnd;
const
  cSomeString = 'Orpheus';
var
  sString: string;
  iScan: Word;
begin
  sString := cSomeString;
  iScan := edScanToEnd(PChar(sString), Length(sString));
  Check(iScan = Length(sString));
end;

initialization
  RegisterTest(TestOvcEditUClass.Suite);
end.

