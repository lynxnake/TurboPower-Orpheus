{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is Roman Kassebaum              *}
{*                                                                            *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Roman Kassebaum                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}
unit TestOVCEditU;

interface

uses
  TestFramework, OvcEditU;

type
  TestOvcEditUClass = class(TTestCase)
  published
    procedure TestedScanToEnd;
    procedure TestedGetActualCol;
  end;

implementation

uses
  SysUtils;

{ TestOvcEditUClass }

procedure TestOvcEditUClass.TestedGetActualCol;
const
  cSomeStrings: array[0..2] of string =
    ('1234567890123456789012345',
     #9'90123456789012345',
     'abcd'#9#9#9'abcd');
  cResults: array[0..2] of Integer =
    (20, 13, 7);
var
  i, res: Integer;
begin
  for i := 0 to High(cSomeStrings) do begin
    res := edGetActualCol(@cSomeStrings[i][1],20,8);
    CheckEquals(cResults[i], res, Format('edGetActualCol failed for "%s"',[cSomeStrings[i]]));
  end;
end;

procedure TestOvcEditUClass.TestedScanToEnd;
const
  cSomeStrings: array[0..4] of string =
    ('Orpheus',
     '123'#10'456',
     #10'abcdef',
     'xyzxyz'#10,
     '');
  cResults: array[0..4] of Word =
    (7,4,1,7,0);
var
  sString: string;
  iScan: Word;
  i: Integer;
begin
  for i := 0 to High(cSomeStrings) do begin
    sString := cSomeStrings[i];
    iScan := edScanToEnd(PChar(sString), Length(sString));
    CheckEquals(cResults[i], iScan, Format('edScanToEnd failed for "%s"',[cSomeStrings[i]]));
  end;
end;

initialization
  RegisterTest(TestOvcEditUClass.Suite);
end.

