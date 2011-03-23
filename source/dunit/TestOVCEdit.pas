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
  TestFramework, ClipBrd,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovceditu, ovcedit, ovceditp, ovceditn;

type
  TForm1 = class(TForm)
    OvcEditor: TOvcEditor;
    OvcTextFileEditor: TOvcTextFileEditor;
  end;

  TTestOVCEdit = class(TTestCase)
  published
    procedure TestUndo;
    procedure TestInsert;
    procedure TestCopy;
    procedure TestCopyRect;
    procedure TestDeleteRect;
{$IFDEF UNICODE}
    procedure TestsuggestEncoding;
{$ENDIF}
    procedure TestLoadFromFile;
    procedure TestSaveToFile;
    procedure TestUndoBufferFull;
    procedure TestUndoBufferFail;
    procedure TestUndoBufferCopyPaste;
    procedure TestUndoBufferTyping;
    procedure TestAttachWordwrapBug;
    procedure TestDisplayLastLineBug;
  end;

implementation

{$R *.dfm}

{ Test inserting text into an TOvcEditor }

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

{ test copying text from an TOvcEditor }

type
  TCopytestRec = record
    l1,c1,l2,c2: Integer;
    s: string;
  end;
  TPOvcEditor = class(TOvcEditor);

const
  Content: array[1..9] of string =
    ('123456781234567812345678123456781234567812345678',
     'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRTSUVWXYZ',
     '12345678'#9+   '12345678'#9+   '12345678',
     '1234'#9'1234'#9'1234'#9'1234'#9'1234'#9'1234',
     '12'#9+ '12'#9+ '12'#9+ '12'#9+ '12'#9+ '12',
     '+-------+-------+-------+-------+-------+-------',
     '+-------+-------+-------',
     '',
     '12345678123456781234567812345678');

{ test for "normal" copy-mode }

procedure TTestOVCEdit.TestCopy;
const
  Copies: array[1..6] of TCopytestRec =
      // text from a single line
    ((l1:1; c1: 9; l2:1; c2:17; s:'12345678'),
      // text from two lines
     (l1:1; c1:41; l2:2; c2: 4; s:'12345678'#13#10'abc'),
      // text from a single line containing a <tab> character
     (l1:3; c1: 5; l2:3; c2:10; s:'5678'#9),
     // a complete line
     (l1:7; c1: 1; l2:8; c2: 1; s:'+-------+-------+-------'#13#10),
     // a complete line containing <tab> characters
     (l1:4; c1: 1; l2:5; c2: 1; s:'1234'#9'1234'#9'1234'#9'1234'#9'1234'#9'1234'#13#10),
     // an empty  line
     (l1:8; c1: 1; l2:9; c2: 1; s:#13#10));
var
  i: Integer;
  s: string;
  Form1: TForm1;
begin
  Form1 := TForm1.Create(nil);
  try
    { Initialise the Editor and add 'Content'. As we are going to copy text containing
      <tb>-characters, we need to set 'TOvcEditor.ClipboardChars' (otherwise <tab>-
      characters would be converted into (single) spaces) }
    Form1.OvcEditor.WordWrap := False;
    Form1.Ovceditor.KeepClipboardChars := True;
    Form1.OvcEditor.ClipboardChars := Form1.OvcEditor.ClipboardChars + [#9];
    for i := Low(Content) to High(Content) do
      Form1.OvcEditor.AppendPara(PChar(Content[i]));

    { copy some texts from the editor and check the results }
    for i := Low(Copies) to High(Copies) do begin
      with Copies[i] do
        Form1.OvcEditor.SetSelection(l1,c1,l2,c2,true);
      Form1.OvcEditor.CopyToClipboard;
      s := Clipboard.AsText;
      CheckEqualsString(s, Copies[i].s);
    end;
  finally
    Form1.Free;
  end;
end;

{ test for "rectangular" copy-mode }

procedure TTestOVCEdit.TestCopyRect;
const
  Copies: array[1..7] of TCopytestRec =
     // text from a singe line
    ((l1:1; c1: 9; l2:1; c2:17; s:'12345678'),
     // block of text containing two lines
     (l1:1; c1: 5; l2:2; c2:11; s:'567812'#13'efghij'),
     // rectangular blocks containing <tab> characters
     (l1:3; c1: 1; l2:6; c2:10; s:'12345678 '#13'1234    1'#13'12      1'#13'+-------+'),
     (l1:4; c1: 5; l2:5; c2: 5; s:'    1'#13'    1'),
     (l1:4; c1: 5; l2:6; c2: 13; s:'    1234'#13'    12  '#13'----+---'),
     // rectangular block containing lines that are "too short"
     (l1:6; c1:20; l2:9; c2:30; s:'-----+----'#13'-----     '#13'          '#13'4567812345'),
     // a single column of text
     (l1:2; c1:17; l2:9; c2: 18; s:'q'#13'1'#13'1'#13'1'#13'+'#13'+'#13' '#13'1'));

var
  i: Integer;
  s: string;
  Form1: TForm1;
begin
  Form1 := TForm1.Create(nil);
  try
    { Initialise the editor and add 'Content'. As we are going to copy text containing
      <tab>-characters, we need to set 'TOvcEditor.ClipboardChars' (otherwise <tab>-
      characters would be converted into (single) spaces) }
    Form1.OvcEditor.WordWrap := False;
    Form1.Ovceditor.KeepClipboardChars := True;
    Form1.OvcEditor.ClipboardChars := Form1.OvcEditor.ClipboardChars + [#9];
    for i := Low(Content) to High(Content) do
      Form1.OvcEditor.AppendPara(PChar(Content[i]));

    { copy some texts from the editor using "rectangular mode" and check the results. }
    for i := Low(Copies) to High(Copies) do begin
      with Copies[i] do
        Form1.OvcEditor.SetSelection(l1,c1,l2,c2,true);
      TPOvcEditor(Form1.OvcEditor).edRectSelect := True;
      Form1.OvcEditor.CopyToClipboard;
      s := Clipboard.AsText;
      CheckEqualsString(s, Copies[i].s);
    end;
  finally
    Form1.Free;
  end;
end;


{ test for "rectangular"-mode delete }

const
  content2: array[1..6] of string =
    ('abcdefghijklmnopqrstuvwxyz',
     '12345678'#9+   '12345678',
     '12'#9+ '12'#9+ '12',
     '+-------+-------',
     '',
     '123456781234567812345678');

procedure TTestOVCEdit.TestDeleteRect;
var
  i, j: Integer;
  Form1: TForm1;
  P: array[0..2048] of Char;
const
  remainders: array[1..6] of TCopytestRec =
     // delete all text from column 2 to (and including) column 23
    ((l1:1; c1: 2; l2:6; c2:24; s:'axyz'#13#10'18'#13#10'1'#13#10'+'#13#10#13#10'18'#13#10#13#10),
     // delete all text starting from (effective) column 19 in lines 2-6
     (l1:2; c1:12; l2:6; c2:48; s:'abcdefghijklmnopqrstuvwxyz'#13#10+
                                  '12345678'#9+   '12'#13#10+
                                  '12'#9+ '12'#9+ '12'#13#10+
                                  '+-------+-------'#13#10+
                                  #13#10+
                                  '123456781234567812'#13#10#13#10),
     // delete the first 16 columns from lines 2-4
     (l1:2; c1: 1; l2:4; c2:17; s:'abcdefghijklmnopqrstuvwxyz'#13#10+
                                  '12345678'#13#10+
                                  '12'#13#10+
                                  #13#10+
                                  #13#10+
                                  '123456781234567812345678'#13#10#13#10),
     // test deleting text when start/end columns and lines are given in the "wrong" order
     // here delete the first 16 columns from lines 1-3
     (l1:3; c1: 7; l2:1; c2: 1; s:'qrstuvwxyz'#13#10+
                                  '12345678'#13#10+
                                  '12'#13#10+
                                  '+-------+-------'#13#10+
                                  #13#10+
                                  '123456781234567812345678'#13#10#13#10),
     // test deleting "parts of tabs"
     // delete columns 6 to (and including) column 11
     (l1:1; c1: 6; l2:6; c2:12; s:'abcdelmnopqrstuvwxyz'#13#10+
                                  '12345     12345678'#13#10+
                                  '12        12'#13#10+
                                  '+---------'#13#10+
                                  #13#10+
                                  '123454567812345678'#13#10#13#10),
     // test deleting "parts of tabs" (2)
     // delete column 5 from lines 2-4 (removing a single space from the <tab> in line 3)
     (l1:4; c1: 5; l2:2; c2: 6; s:'abcdefghijklmnopqrstuvwxyz'#13#10+
                                  '1234678'#9+   '12345678'#13#10+
                                  '12     12'#9+ '12'#13#10+
                                  '+------+-------'#13#10+
                                  #13#10+
                                  '123456781234567812345678'#13#10#13#10));
begin
  Form1 := TForm1.Create(nil);
  try
    Form1.OvcEditor.WordWrap := False;
    Form1.OvcEditor.ScrollPastEnd := True;
    for i := Low(remainders) to High(remainders) do begin
      { Initialise the editor and add 'Content2'. }
      Form1.OvcEditor.Clear;
      for j := Low(content2) to High(content2) do
        Form1.OvcEditor.AppendPara(PChar(content2[j]));
      { Delete some text as defined in 'remainders'. }
      with remainders[i] do
        Form1.OvcEditor.SetSelection(l1,c1,l2,c2,true);
      TPOvcEditor(Form1.OvcEditor).edRectSelect := True;
      TPOvcEditor(Form1.OvcEditor).edDeleteSelection;
      { check whether we have the predicted remainder }
      Form1.OvcEditor.GetText(@P[0],High(P));
      CheckEqualsString(remainders[i].s, P);
    end;
  finally
    Form1.Free;
  end;
end;


{ test undo operation }

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
    { 2. Ansi-Textfile containing <tab>-characters }
    SL := TStringList.Create;
    Form1.OvcTextFileEditor.AppendPara(line+#9+line+#9);
    Form1.OvcTextFileEditor.SaveToFile(FileName);
    SL.LoadFromFile(FileName{$IFDEF UNICODE},TEncoding.Default{$ENDIF});
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
{$IFDEF UNICODE}
    { 3. UTF-8 Textfile }
    Form1.OvcTextFileEditor.AppendPara(unicodeline);
    Form1.OvcTextFileEditor.SaveToFile(FileName);
    SL.LoadFromFile(FileName,TEncoding.UTF8);
    Form1.OvcTextFileEditor.GetText(@Buf[0],SizeOf(Buf));
    CheckEqualsString(SL.Text+#13#10, Buf);
    { 4. Unicode Textfile }
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


{ Test the integrity of the undo-buffer
  The undo-buffer is a block of memory that contains undo-records of variable size. The
  size of a record in bytes is given by UndoRecSize + SizeOf(Char)*DSize.
  To get the next record, you have do add this value to the records address.
  The number of records in the buffer is given by 'Undos'.
  The following test are performed:
  - The difference between 'BufSize' and the overall size of the records must be 'BufAvail'.
  - The size of a record must coincide with the value of the next record's 'PrevSize'-field.
  - 'Last' must point to the last record in the buffer. }

function TestUndoBuffer(UBuf: TOvcUndoBuffer): Boolean;
var
  j, s, SizeInBytes: Word;
  PUR : PUndoRec;
begin
  result := False;
  PUR := UBuf.Buffer;
  s := 0;
  for j := 1 to UBuf.Undos do begin
    SizeInBytes := PUR^.DSize * SizeOf(Char) + UndoRecSize;
    Inc(s, SizeInBytes);
    if j<UBuf.Undos then begin
      Inc(PAnsiChar(PUR), SizeInBytes);
      if PUR^.PrevSize<>SizeInBytes then Exit;
    end;
  end;
  if (UBuf.BufAvail + s = UBuf.BufSize) and
     (PUR = UBuf.Last) then
    result := True;
end;


{ test undo-buffer-overflow
  specific test for a former bug in the handling of the undo-buffer:
  When typing characters a single undo-record will be put in the undo-buffer and will be
  extended for each character that is typed. However, if the undo-buffer is full, this
  record will be deleted an further attempts to extend the (now non-existent) undo-record
  will lead to a corrupt buffer - an eventually to a crash.
  Due to it's nature, this effect will only show up if the undo-buffer is relatively
  small. }

procedure TTestOVCEdit.TestUndoBufferFull;
var
  Form1: TForm1;
  i: Integer;
begin
  Form1 := TForm1.Create(nil);
  Form1.OvcEditor.UndoBufferSize := 64;
  try
    for i := 1 to 128 do begin
      Form1.OvcEditor.Perform(WM_CHAR, 65, 0);
      CheckTrue(TestUndoBuffer(TPOvcEditor(Form1.OvcEditor).edParas.UndoBuffer),
                'Undo-Buffer corrupt');
    end;
  finally
    Form1.Free;
  end;
end;

{ test undo-buffer-failure
  test for a unicode-bugfix (13.01.2011): Replacing characters led to a corruption of the
  undo-buffer }

procedure TTestOVCEdit.TestUndoBufferFail;
var
  Form1: TForm1;
begin
  Form1 := TForm1.Create(nil);
  try
    with Form1.OvcEditor do begin
      InsertMode := True;
      Perform(WM_char, 65, 0);
      Perform(WM_char, 65, 0);
      Perform(WM_char, 65, 0);
      Perform(WM_KEYDOWN, 8, 0); // delete third 'A'
      SetSelection(1,1,1,1,false);
      InsertMode := False;
      Perform(WM_char, 66, 0);  // replace first 'A'
      Undo;
      Undo;
    end;
    CheckEqualsString('AAA',Form1.OvcEditor.GetCurrentWord);
  finally
    Form1.Free;
  end;
end;


{ test undo-buffer integrity when copying&pasting text }

procedure TTestOVCEdit.TestUndoBufferCopyPaste;
const
  Content: array[1..9] of string = (
     '+-------+-------+-------+-------+-------+-------+',
     '|1234567|1234567|1234567|1234567|1234567|1234567|',
     '|       |       |       |       |       |       |',
     '+-------+-------+-------+-------+-------+-------+',
     '|abcdefg|abcdefg|abcdefg|abcdefg|abcdefg|abcdefg|',
     '|'#9+  '|'#9+  '|'#9+  '|'#9+  '|'#9+  '|'#9+  '|',
     '+-------+-------+-------+-------+-------+-------+',
     '|123'#9'|123'#9'|123'#9'|123'#9'|123'#9'|123'#9'|',
     '+-------+-------+-------+-------+-------+-------+');
var
  i, c1, c2, l1, l2: Integer;
  Form1: TForm1;
  Editor: TPOvcEditor;
  UBuf: TOvcUndoBuffer;
  extBuffer: array[0..10000] of Byte;
  orgBuffer: PByte;

  { Extended test for the undo-Buffer: In addition to the basic test we make sure that
    not "overflow" of the buffer has occurred. }
  function TestUndoBufferExt: Boolean;
  var
    i: Integer;
  begin
    result := TestUndoBuffer(UBuf);
    i := 0;
    while result and (i<8) do begin
      result := (extBuffer[i] = $AA) and
                (extBuffer[UBuf.BufSize-i+15] = $AA);
      Inc(i);
    end;
  end;

begin
  { To make sure we always use the same sequence of copy & paste operations, we
    need to set RandSeed to a fix value. }
  RandSeed := 42;
  { create the editor an insert the test-content }
  Form1 := TForm1.Create(nil);
  Editor := TPOvcEditor(Form1.OvcEditor);

  try
    { We want to make sure that the undo-buffer works fine; due to the implementation, there
      is a certain risk that TOvcUndoBuffer accesses memory "outside" the buffer. We try to
      detect these flaws by placing some bytes before an behind the actual buffer. }
    UBuf := Editor.edParas.UndoBuffer;
    for i := 0 to 7 do begin
      extBuffer[i] := $AA;
      extBuffer[UBuf.BufSize-i+15] := $AA;
    end;
    orgBuffer := UBuf.Buffer;
    UBuf.Buffer := @extBuffer[8];
    UBuf.Last := UBuf.Buffer;

    for i := Low(Content) to High(Content) do
      Editor.AppendPara(PChar(Content[i]));

    try
      for i := 1 to 1000 do begin
        l1 := Random(Editor.LineCount) + 1;
        c1 := Random(50) + 1;
        l2 := l1 + Random(100);
        c2 := Random(50) + 1;
        Editor.edRectSelect := Random(2)=0;
        Editor.SetSelection(l1, c1, l2, c2, true);
        Editor.CopyToClipboard;
        l1 := Random(Editor.LineCount) + 1;
        c1 := Random(40) + 1;
        l2 := Random(Editor.LineCount) + 1;
        c2 := Random(40) + 1;
        Editor.SetSelection(l1, c1, l2, c2, true);
        Editor.PasteFromClipboard;
        CheckTrue(TestUndoBufferExt,
                  Format('Undobuffer corrupt after copy/paste #%d', [i]));
        if i mod 4 = 0 then begin
          Editor.Undo;
          Editor.Undo;
          Editor.Undo;
          Editor.Undo;
          CheckTrue(TestUndoBufferExt,
                    Format('Undobuffer corrupt after undo following copy/paste #%d', [i]));
        end;
      end;

    finally
      UBuf.Last := PUndoRec(Cardinal(orgBuffer) + (Cardinal(UBuf.Last) - Cardinal(UBuf.Last)));
      UBuf.Buffer := orgBuffer;
      Move(extBuffer[8], UBuf.Buffer^, UBuf.BufSize);
    end;
  finally
    Form1.Free;
  end;
end;


{ test undo-buffer integrity when typing text }

procedure TTestOVCEdit.TestUndoBufferTyping;
var
  l1, c1, ch, i: Integer;
  Form1: TForm1;
  Editor: TPOvcEditor;
  UBuf: TOvcUndoBuffer;
  extBuffer: array[0..10000] of Byte;
  orgBuffer: PByte;

  { Extended test for the undo-Buffer: In addition to the basic test we make sure that
    not "overflow" of the buffer has occurred. }
  function TestUndoBufferExt: Boolean;
  var
    i: Integer;
  begin
    result := TestUndoBuffer(UBuf);
    i := 0;
    while result and (i<8) do begin
      result := (extBuffer[i] = $AA) and
                (extBuffer[UBuf.BufSize-i+15] = $AA);
      Inc(i);
    end;
  end;

begin
  { To make sure we always use the same sequence of copy & paste operations, we
    need to set RandSeed to a fix value. }
  RandSeed := 42;
  { create the editor an insert the test-content }
  Form1 := TForm1.Create(nil);
  Editor := TPOvcEditor(Form1.OvcEditor);

  try
    { We want to make sure that the undo-buffer works fine; due to the implementation, there
      is a certain risk that TOvcUndoBuffer accesses memory "outside" the buffer. We try to
      detect these flaws by placing some bytes before an behind the actual buffer. }
    UBuf := Editor.edParas.UndoBuffer;
    for i := 0 to 7 do begin
      extBuffer[i] := $AA;
      extBuffer[UBuf.BufSize-i+15] := $AA;
    end;
    orgBuffer := UBuf.Buffer;
    UBuf.Buffer := @extBuffer[8];
    UBuf.Last := UBuf.Buffer;

    try
      for i := 0 to 10000 do begin
        if Random(10)=0 then begin
          ch := 32;
          Editor.perform(WM_char, ch, 0);
        end else if Random(80)=0 then begin
          ch := 13;
          Editor.perform(WM_keydown, ch, 0);
        end else begin
          ch := Random(190);
          if ch<=93 then ch := ch + 33 else ch := ch + 66;
          Editor.perform(WM_char, ch, 0);
        end;
        if ch mod 200 = 0 then begin
          l1 := Random(Editor.LineCount) + 1;
          c1 := Random(50) + 1;
          Editor.SetSelection(l1, c1, l1, c1, true);
        end;
        CheckTrue(TestUndoBufferExt,
                  Format('Undobuffer corrupt after loop #%d', [i]));
      end;

    finally
      UBuf.Last := PUndoRec(Cardinal(orgBuffer) + (Cardinal(UBuf.Last) - Cardinal(UBuf.Last)));
      UBuf.Buffer := orgBuffer;
      Move(extBuffer[8], UBuf.Buffer^, UBuf.BufSize);
    end;
  finally
    Form1.Free;
  end;
end;


{ Test for a fixed bug that caused the application to crash when attaching one editor
  to another. }

procedure TTestOVCEdit.TestAttachWordwrapBug;
var
  Form1: TForm1;
begin
  { create the editor an insert the test-content }
  Form1 := TForm1.Create(nil);
  try
    Form1.show;
    Form1.OvcEditor.WordWrap := True;
    Form1.OvcEditor.WrapToWindow := True;
    Form1.OvcEditor.Align := alTop;
    Form1.OvcEditor.RightMargin := 5;
    Form1.OvcTextFileEditor.WordWrap := True;
    Form1.OvcTextFileEditor.WrapToWindow := True;
    Form1.OvcTextFileEditor.Align := alClient;
    Form1.OvcTextFileEditor.RightMargin := 20;
    { this will crash the application (up to rev 198) due to an infinite recursion }
    Form1.OvcEditor.Attach(Form1.OvcTextFileEditor);
  finally
    Form1.Free;
  end;
end;


{ Test for a fixed bug that caused the editor to hide the last line }

procedure TTestOVCEdit.TestDisplayLastLineBug;
var
  Form1: TForm1;
  Editor: TPOvcEditor;
begin
  { create the editor an insert the test-content }
  Form1 := TForm1.Create(nil);
  Editor := TPOvcEditor(Form1.OvcEditor);
  try
    Editor.edCalcRowColInfo;
    Editor.ClientHeight := 3*Editor.edGetRowHt + 1;
    { There is enough space for 3 rows... Let's see what OvcEditor thinks... }
    CheckEquals(3, Editor.edRows);
  finally
    Form1.Free;
  end;
end;


initialization
  RegisterTest(TTestOVCEdit.Suite);
end.
