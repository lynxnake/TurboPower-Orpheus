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

