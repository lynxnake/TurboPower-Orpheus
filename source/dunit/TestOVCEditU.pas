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
  TestStrings: array[0..2] of string =
    ('1234567890123456789012345',
     #9'90123456789012345',
     'abcd'#9#9#9'abcd');
  Results: array[0..2] of Integer =
    (20, 13, 7);
var
  i, res: Integer;
begin
  for i := 0 to High(TestStrings) do begin
    res := edGetActualCol(@TestStrings[i][1],20,8);
    CheckTrue(res=Results[i],Format('edGetActualCol failed for "%s"',[TestStrings[i]]));
  end;
end;

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

