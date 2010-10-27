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
    OvcTextFileEditor: TOvcTextFileEditor;
  end;

  TTestOVCEdit = class(TTestCase)
  published
    procedure TestUndo;
    procedure TestInsert;
{$IFDEF UNICODE}
    procedure TestsuggestEncoding;
{$ENDIF}
    procedure TestLoadFromFile;
    procedure TestSaveToFile;
  end;

implementation

{$R *.dfm}

{ TTestOVCEdit }

procedure TTestOVCEdit.TestInsert;
var
  Form1: TForm1;
  s: string;
begin
  Form1 := TForm1.Create(nil);
  try
    Form1.OvcEditor.ScrollPastEnd := True;
    Form1.OvcEditor.AppendPara('Test');
    Form1.OvcEditor.SetSelection(1,1,1,5,True);
    Form1.OvcEditor.CopyToClipboard;
    Form1.OvcEditor.SetCaretPosition(1,9);
    Form1.OvcEditor.PasteFromClipboard;
    SetLength(s, 15);
    s := Form1.OvcEditor.GetLine(1,@s[1],15);
    { Fails in 4.07 (unicode) }
    CheckEqualsString(s, 'Test    Test');
  finally
    Form1.Free;
  end;
end;

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
    CheckEqualsString(s, line);

    Form1.OvcEditor.SetSelection(1,10,1,25,True);
    Form1.OvcEditor.CutToClipboard;
    Form1.OvcEditor.Undo;
    SetLength(s, 44);
    s := Form1.OvcEditor.GetLine(1,@s[1],44);
    CheckEqualsString(s, line);

    Form1.OvcEditor.SetSelection(1,10,2,10,True);
    Form1.OvcEditor.CutToClipboard;
    Form1.OvcEditor.Undo;
    SetLength(s, 44);
    s := Form1.OvcEditor.GetLine(1,@s[1],44);
    { Fails in 4.07 (unicode) }
    CheckEqualsString(s, line);
  finally
    Form1.Free;
  end;
end;

{$IFDEF UNICODE}

procedure TTestOVCEdit.TestsuggestEncoding;
var
  SL       : TStringList;
  Form1    : TForm1;
  TMPDir   : array[0..255] of Char;
  FileName : string;
const
  line = 'The quick brown fox jumps over the lazy fox';
  unicodeline = 'АБВГДЕЖЗИКЛМНОПРСТУФХЦЧШЩЪЫЬ';
begin
  Form1 := TForm1.Create(nil);
  try
    { 1. suggestEncoding when editor ist empty }
    CheckEqualsString(TEncoding.Default.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);

    { 2. suggestEncoding should suggest TEncoding.Default if there are no
         characters with Ord(c)>255 in the text. }
    Form1.OvcTextFileEditor.AppendPara(line);
    Form1.OvcTextFileEditor.AppendPara(line);
    CheckEqualsString(TEncoding.Default.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);

    { 3. suggestEncoding should suggest TEncoding.UTF8 otherwise }
    Form1.OvcTextFileEditor.AppendPara(unicodeline);
    CheckEqualsString(TEncoding.UTF8.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);

    { 4. suggestEncoding should (normally) suggest the encoding of the textfile that has
         been read. }
    GetTempPath(255,TMPDir);
    FileName := TMPDir+'OrpheusTests.txt';
    SL := TStringList.Create;
    try
      { 4.1 ANSI-Textfile }
      SL.Add(line);
      SL.Add(unicodeline);
      SL.SaveToFile(FileName,TEncoding.Default);
      Form1.OvcTextFileEditor.LoadFromFile(FileName);
      CheckEqualsString(TEncoding.Default.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);

      { 4.2 UTF8-Textfile }
      SL.SaveToFile(FileName,TEncoding.UTF8);
      Form1.OvcTextFileEditor.LoadFromFile(FileName);
      CheckEqualsString(TEncoding.UTF8.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);

      { 4.3 ANSI-Textfile with unicode characters added after loading }
      SL.SaveToFile(FileName,TEncoding.Default);
      Form1.OvcTextFileEditor.LoadFromFile(FileName);
      Form1.OvcTextFileEditor.AppendPara(unicodeline);
      CheckEqualsString(TEncoding.UTF8.EncodingName, Form1.OvcTextFileEditor.suggestEncoding.EncodingName);
    finally
      SL.Free;
      DeleteFile(FileName)
    end;
  finally
    Form1.Free;
  end;
end;
{$ENDIF}


procedure TTestOVCEdit.TestLoadFromFile;
var
  SL          : TStringList;
  Form1       : TForm1;
  TMPDir, Buf : array[0..255] of Char;
  FileName    : string;
const
  line = 'ASCII-Zeile';
{$IFDEF UNICODE}
  unicodeline = 'Unicode: АБВГДЕЖЗИК';
{$ENDIF}
begin
  SL    := nil;
  Form1 := TForm1.Create(nil);
  GetTempPath(255,TMPDir);
  FileName := TMPDir+'OrpheusTests.txt';
  try
    { To test LoadFromFile we create some textfiles using TStringList }
    { 1. Ansi-Textfile }
    SL := TStringList.Create;
    SL.Add(line);
    SL.Add(line);
    SL.SaveToFile(FileName);
    Form1.OvcTextFileEditor.LoadFromFile(FileName);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    { OvcTextFileEditor puts an extra #13#10 at the end of the text.
      Let's call this a feature, not a bug... }
    CheckEqualsString(SL.Text+#13#10, Buf);
{$IFDEF UNICODE}
    { 2. UTF-8 Textfile }
    SL.Clear;
    SL.Add(line);
    SL.Add(unicodeline);
    SL.SaveToFile(FileName,TEncoding.UTF8);
    Form1.OvcTextFileEditor.LoadFromFile(FileName);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
    { 3. Unicode Textfile }
    SL.Clear;
    SL.Add(line);
    SL.Add(unicodeline);
    SL.SaveToFile(FileName,TEncoding.Unicode);
    Form1.OvcTextFileEditor.LoadFromFile(FileName);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
{$ENDIF}
  finally
    Form1.Free;
    SL.Free;
    DeleteFile(FileName);
  end;
end;


procedure TTestOVCEdit.TestSaveToFile;
var
  SL          : TStringList;
  Form1       : TForm1;
  TMPDir, Buf : array[0..255] of Char;
  FileName    : string;
const
  line = 'ASCII-Zeile';
{$IFDEF UNICODE}
  unicodeline = 'Unicode: АБВГДЕЖЗИК';
{$ENDIF}
begin
  SL    := nil;
  Form1 := TForm1.Create(nil);
  GetTempPath(255,TMPDir);
  FileName := TMPDir+'OrpheusTests.txt';
  try
    { 1. Ansi-Textfile }
    SL := TStringList.Create;
    Form1.OvcTextFileEditor.AppendPara(line);
    Form1.OvcTextFileEditor.AppendPara(line);
    Form1.OvcTextFileEditor.SaveToFile(FileName);
    SL.LoadFromFile(FileName{$IFDEF UNICODE},TEncoding.Default{$ENDIF});
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
{$IFDEF UNICODE}
    { 2. UTF-8 Textfile }
    Form1.OvcTextFileEditor.AppendPara(unicodeline);
    Form1.OvcTextFileEditor.SaveToFile(FileName);
    SL.LoadFromFile(FileName,TEncoding.UTF8);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
    { 3. Unicode Textfile }
    Form1.OvcTextFileEditor.SaveToFile(FileName,TEncoding.Unicode);
    SL.LoadFromFile(FileName,TEncoding.Unicode);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
{$ENDIF}
  finally
    Form1.Free;
    SL.Free;
    DeleteFile(FileName);
  end;
end;


initialization
  RegisterTest(TTestOVCEdit.Suite);
end.
