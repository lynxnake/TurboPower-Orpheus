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

unit TestOVCEdit;

interface

uses
  TestFramework,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovceditu, ovcedit;

type
  TForm1 = class(TForm)
    OvcEditor: TOvcEditor;
  end;

  TTestOVCEdit = class(TTestCase)
  published
    procedure TestUndo;
  end;

implementation

{$R *.dfm}


{ TTestOVCEdit }

procedure TTestOVCEdit.TestUndo;
var
  Form1: TForm1;
  s: string;
const
  line = 'The quick brown fox jumps over the lazy fox';
begin
  Form1 := TForm1.Create(nil);
  try
    Form1.OvcEditor.AppendPara(line);
    Form1.OvcEditor.AppendPara(line);
    Form1.OvcEditor.AppendPara(line);
    SetLength(s, 44);
    s := Form1.OvcEditor.GetLine(1,@s[1],44);
    CheckTrue(s=line);

    Form1.OvcEditor.SetSelection(1,10,1,25,True);
    Form1.OvcEditor.CutToClipboard;
    Form1.OvcEditor.Undo;
    SetLength(s, 44);
    s := Form1.OvcEditor.GetLine(1,@s[1],44);
    CheckTrue(s=line);

    Form1.OvcEditor.SetSelection(1,10,2,10,True);
    Form1.OvcEditor.CutToClipboard;
    Form1.OvcEditor.Undo;
    SetLength(s, 44);
    s := Form1.OvcEditor.GetLine(1,@s[1],44);
    { Fails in 4.07 (unicode) }
    CheckTrue(s=line);
  finally
    Form1.Free;
  end;
end;


initialization
  RegisterTest(TTestOVCEdit.Suite);
end.
