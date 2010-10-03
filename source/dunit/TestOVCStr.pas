{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOVCStr;

interface

uses
  TestFramework;

type
  TTestOVCStr = class(TTestCase)
  published
    procedure TestBMSearch;
    procedure TestBMSearchUC;
  end;

implementation

uses
  OvcStr;

{ TTestOVCStr }

procedure TTestOVCStr.TestBMSearch;
var
  BT: BTable;
  Buffer: array[0..255] of Char;
  iPos, i: Integer;
  Pos: Cardinal;
const
  MatchStrings: array[0..6] of string =
    ('DELPHI XE', // Match at the beginning of the Buffer
     'Delphi XE', // Match in the middle of the Buffer
     'PASCAL',    // Match at the end of the Buffer
     'foo',       // No Match
     'D',         // Match at the beginning (single character)
     'X',         // Match in the middle (single character)
     '9');        // No Match
  Results: array[0..6] of Integer =
    (0, 19, 33, -1, 0, 7, -1);
begin
  { Test BMSearch:
    First set up a Buffer, in which some strings are going to be searched. }
  for i := Low(Buffer) to High(Buffer) do
    Buffer[i] := #0;
  Buffer := 'DELPHI XEaelphi XEqDelphi XEaqsdePASCAL';
  { BMSearch needs a Booyer-Moore Table that has to be computed from the
    MatchString, so we need to call 'BMMakeTable' before searching for
    'MatchStrings[i]'. }
  for i := Low(MatchStrings) to High(MatchStrings) do begin
    BMMakeTable(@MatchStrings[i][1], BT);
    if not BMSearch(Buffer,Length(Buffer), BT, @MatchStrings[i][1], Pos) then
      iPos := -1
    else
      iPos := Pos;
    CheckTrue(iPos=Results[i]);
  end;
end;

procedure TTestOVCStr.TestBMSearchUC;
var
  BT: BTable;
  Buffer: array[0..255] of Char;
  iPos, i: Integer;
  Pos: Cardinal;
const
  { Note: 'BMSearchUC' requires the MatchString to be uppercase. }
  MatchStrings: array[0..6] of string =
    ('DELPHI XE', // Match at the beginning of the Buffer
     'EAELP',     // Match in the middle of the Buffer
     'PASCAL',    // Match at the end of the Buffer
     'FOO',       // No Match
     'D',         // Match at the beginning (single character)
     'X',         // Match in the middle (single character)
     '9');        // No Match
  Results: array[0..6] of Integer =
    (0, 8, 33, -1, 0, 7, -1);
begin
  { Test BMSearchUC:
    First set up a Buffer, in which some strings are going to be searched. }
  for i := Low(Buffer) to High(Buffer) do
    Buffer[i] := #0;
  Buffer := 'DELPHI XEaelphi XEqDelphi XEaqsdePASCAL';
  { BMSearchUC needs a Booyer-Moore Table that has to be computed from the
    MatchString, so we need to call 'BMMakeTable' before searching for
    'MatchStrings[i]'. }
  for i := Low(MatchStrings) to High(MatchStrings) do begin
    BMMakeTable(@MatchStrings[i][1], BT);
    if not BMSearchUC(Buffer,Length(Buffer), BT, @MatchStrings[i][1], Pos) then
      iPos := -1
    else
      iPos := Pos;
    CheckTrue(iPos=Results[i]);
  end;
end;

initialization
  RegisterTest(TTestOVCStr.Suite);

end.
