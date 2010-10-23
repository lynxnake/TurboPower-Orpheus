// every PCHAR was PAnsiChar

{*********************************************************}
{*                   OVCSTR.PAS 4.06                     *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*   Armin Biernaczk   (unicode version of BMSearch & BMSearchUC)             *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovcstr;
  {-General string handling routines}

interface

uses
  SysUtils;

{ For unicode-strings, we have two options:
  a) Use a huge (64KB) BM-table for searches. This results in a larger overhead, but searching
     is faster, when the buffer being searched contains many 2-byte-characters.
  b) Use a small (256B) BM-Table. The overhead is smaller, but searching can be slower }
{$DEFINE HUGE_UNICODE_BMTABLE}

type
  BTable = array[0..{$IFDEF UNICODE}{$IFDEF HUGE_UNICODE_BMTABLE}$FFFF{$ELSE}$FF{$ENDIF}{$ELSE}$FF{$ENDIF}] of Byte;
  {table used by the Boyer-Moore search routines}

{$IFDEF UNICODE}
  TOvcCharSet = SysUtils.TSysCharSet;
{$ELSE}
  TOvcCharSet = set of AnsiChar;
{$ENDIF}


function BinaryBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return a binary PChar string for a byte}
function BinaryLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return the binary PChar string for a long integer}
function BinaryWPChar(Dest : PChar; W : Word) : PChar;
  {-Return the binary PChar string for a word}
procedure BMMakeTable(MatchString : PChar; var BT : BTable);
  {-Build a Boyer-Moore link table}
function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
                  MatchString : PChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string}
function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
                    MatchString : PChar ; var Pos : Cardinal) : Boolean;
  {-Use the Boyer-Moore search method to search a buffer for a string. This
    search is not case sensitive}
function CharStrPChar(Dest : PChar; C : Char; Len : Cardinal) : PChar;
  {-Return a PChar string filled with the specified character}
function DetabPChar(Dest : PChar; Src : PChar; TabSize : Byte) : PChar;
  {-Expand tabs in a PChar string to blanks}
function HexBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return hex PChar string for byte}
function HexLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return the hex PChar string for a long integer}
function HexPtrPChar(Dest : PChar; P : Pointer) : PChar;
  {-Return hex PChar string for pointer}
function HexWPChar(Dest : PChar; W : Word) : PChar;
  {-Return the hex PChar string for a word}
function LoCaseChar(C : Char) : Char;
  {-Convert C to lower case}
function OctalLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return the octal PChar string for a long integer}
function StrChDeletePrim(P : PChar; Pos : Cardinal) : PChar;
  {-Primitive routine to delete a character from a PChar string}
function StrChInsertPrim(Dest : PChar; C : Char; Pos : Cardinal) : PChar;
  {-Primitive routine to insert a character into a PChar string}
function StrChPos(P : PChar; C : Char; var Pos : Cardinal) : Boolean;
  {-Sets Pos to location of C in P, return is True if found}
procedure StrInsertChars(Dest : PChar; Ch : Char; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos}
function StrStCopy(Dest, S : PChar; Pos, Count : Cardinal) : PChar;
  {-Copy characters at a specified position in a PChar string}
function StrStDeletePrim(P : PChar; Pos, Count : Cardinal) : PChar;
  {-Primitive routine to delete a sub-string from a PChar string}
function StrStInsert(Dest, S1, S2 : PChar; Pos : Cardinal) : PChar;
  {-Insert a PChar string into another at a specified position}
function StrStInsertPrim(Dest, S : PChar; Pos : Cardinal) : PChar;
  {-Insert a PChar string into another at a specified position. This
    primitive version modifies the source directly}
function StrStPos(P, S : PChar; var Pos : Cardinal) : Boolean;
  {-Sets Pos to position of the S in P, returns True if found}
function StrToLongPChar(S : PChar; var I : LongInt) : Boolean;
  {-Convert a PChar string to a long integer}
procedure TrimAllSpacesPChar(P : PChar);
  {-Trim leading and trailing blanks from P}
function TrimEmbeddedZeros(const S : string) : string;
  {-Trim embedded zeros from a numeric string in exponential format}
procedure TrimEmbeddedZerosPChar(P : PChar);
  {-Trim embedded zeros from a numeric PChar string in exponential format}
function TrimTrailPrimPChar(S : PChar) : PChar;
  {-Return a PChar string with trailing white space removed}
function TrimTrailPChar(Dest, S : PChar) : PChar;
  {-Return a PChar string with trailing white space removed}
function TrimTrailingZeros(const S : string) : string;
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
procedure TrimTrailingZerosPChar(P : PChar);
  {-Trim trailing zeros from a numeric PChar string. It is assumed that
    there is a decimal point prior to the zeros. Also strips leading spaces.}
function UpCaseChar(C : Char) : Char;
  {-Convert a character to uppercase using the AnsiUpper API}

function ovcCharInSet(C: Char; const CharSet: TOvcCharSet): Boolean;

function ovc32StringIsCurrentCodePage(const S: WideString): Boolean;


implementation

uses
  Windows;

const
  Digits : array[0..$F] of Char = '0123456789ABCDEF';

function BinaryBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return binary string for byte}
var
  I : Word;
begin
  Result := Dest;
  for I := 7 downto 0 do begin
    Dest^ := Digits[Ord(B and (1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

function BinaryLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return binary string for LongInt}
var
  I : LongInt;
begin
  Result := Dest;
  for I := 31 downto 0 do begin
    Dest^ := Digits[Ord(L and LongInt(1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

function BinaryWPChar(Dest : PChar; W : Word) : PChar;
  {-Return binary string for word}
var
  I : Word;
begin
  Result := Dest;
  for I := 15 downto 0 do begin
    Dest^ := Digits[Ord(W and (1 shl I) <> 0)]; {0 or 1}
    Inc(Dest);
  end;
  Dest^ := #0;
end;

procedure BMMakeTable(MatchString : PChar; var BT : BTable); register;
  {Build Boyer-Moore link table
   BT contains one Byte for every possible character (256 Bytes for Ansi-Strings /
   65536 Bytes for Unicode-Strings. The procedure fills this array as follows
   - For characters c that are not present in the first n characters of
     'Matchstring', where n := min(255,Length(MatchString))-1, B[c] is set to
     min(255,Length(MatchString))
   - For other characters c the Position p of the last occurrence within the
     first n characters of MatchString is calculated and B[c] is set to
     Length(MatchString)-p

   Example: For MatchString='ABCABC' we get
            BT[65] = 2
            BT[66] = 1
            BT[67] = 3
            BT[c]  = 6 for c<65 or c>67

   Using BT, the search of Matchstring in a given Buffer can be accelarated, see
   'BMSearch'

   Important: MatchString must not be longer than 255 characters; otherwise the
     BM-table will not be constructed properly. }
{$IFDEF UNICODE}
asm
  push  esi             { Save registers because they will be changed }
  push  edi
  push  ebx

  cld                   { Ensure forward string ops }
  mov   edi, eax        { Move EAX to ESI & EDI }
  mov   esi, eax
  xor   eax, eax        { Zero EAX }
  or    ecx, -1
  repne scasw           { Search for null terminator }
  not   ecx
  dec   ecx             { ECX is length of search string }
  cmp   ecx, 0FFh       { If ECX > 255, force to 255 }
  jbe   @@1
  mov   ecx, 0FFh

@@1:
  mov   ch, cl          { Duplicate CL in CH }
  mov   eax, ecx        { Fill each byte in EAX with length }
  shl   eax, 16
  mov   ax, cx
  mov   edi, edx        { Point to the table }
{$IFDEF HUGE_UNICODE_BMTABLE}
  mov   ecx, 4000h      { Fill table bytes with length }
{$ELSE}
  mov   ecx, 40h        { Fill table bytes with length }
{$ENDIF}
  rep   stosd
  cmp   al, 1           { If length <= 1, we're done }
  jbe   @@MTDone
  mov   edi, edx        { Reset EDI to beginning of table }
  xor   ebx, ebx        { Zero EBX }
  mov   cl, al          { Restore CL to length of string }
  dec   ecx

@@MTNext:
  lodsw                 { Load table with positions of letters }
{$IFNDEF HUGE_UNICODE_BMTABLE}
  test  ah, ah
  jnz   @@MTDontfill
{$ENDIF}
  mov   bx, ax          { That exist in the search string }
  mov   [edi+ebx], cl
@@MTDontfill:
  loop  @@MTNext

@@MTDone:
  pop   ebx             { Restore registers }
  pop   edi
  pop   esi
end;
{$ELSE}
asm
  push  esi             { Save registers because they will be changed }
  push  edi
  push  ebx

  cld                   { Ensure forward string ops }
  mov   edi, eax        { Move EAX to ESI & EDI }
  mov   esi, eax
  xor   eax, eax        { Zero EAX }
  or    ecx, -1
  repne scasb           { Search for null terminator }
  not   ecx
  dec   ecx             { ECX is length of search string }
  cmp   ecx, 0FFh       { If ECX > 255, force to 255 }
  jbe   @@1
  mov   ecx, 0FFh

@@1:
  mov   ch, cl          { Duplicate CL in CH }
  mov   eax, ecx        { Fill each byte in EAX with length }
  shl   eax, 16
  mov   ax, cx
  mov   edi, edx        { Point to the table }
  mov   ecx, 64         { Fill table bytes with length }
  rep   stosd
  cmp   al, 1           { If length >= 1, we're done }
  jbe   @@MTDone
  mov   edi, edx        { Reset EDI to beginning of table }
  xor   ebx, ebx        { Zero EBX }
  mov   cl, al          { Restore CL to length of string }
  dec   ecx

@@MTNext:
  lodsb                 { Load table with positions of letters }
  mov   bl, al          { That exist in the search string }
  mov   [edi+ebx], cl
  loop  @@MTNext

@@MTDone:
  pop   ebx             { Restore registers }
  pop   edi
  pop   esi
end;
{$ENDIF}

function BMSearch(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PChar; var Pos : Cardinal) : Boolean; register;
{ This function searches 'MatchString' in 'Buffer' and returns True/False accordingly.
  If 'MatchString' is found, 'Pos' returns it's position within the 'Buffer'.

  'BufLength' is the size of 'Buffer' in characters (Unicode: not in bytes!). 'Pos'
  is character-based and zero-based.

  The procedure needs the BTable 'BT' which has to be computed via 'BMMakeTable'
  based on 'MatchString'.
  For Length(MatchString)>1, this table ist used to accelerate the search as follows:
  Assume 'MatchString' is NOT found at Position p. The procedure looks at the
  character c at Position p+Length(MatchString)-1. The next position that has to be
  checked is not p+1, but p+BT[c]. In many cases we have BT[c]=Length(MatchString)
  which results in a significant reduction in the number of necessary comparisons.

  (This is a simplyfied version of the Boyer-Moore search algorithm).

  The length of MatchString must not exceed 255 characters (n.b. 'BMMakeTable' fails
  to calculate the BM-Table for 'MatchString' properly in this case)

  At the beginning of the code, we have EAX=Buffer, EDX=BufLength and ECX=BT; MatchString
  and Pos are on the stack }
var
  BufPtr : Pointer;
{$IFDEF UNICODE}
                            { The Unicode-variant of this function has been derived from
                              the original non-Unicode version. }
  lenMS1: Word;
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BT (Pointer to Boyer-Moore-Table) to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasw               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString (in Characters) }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer (in characters) into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  cmp   dl, 1               { Check to see if we have a trivial case }
  ja    @@BMSInit           { If Length(MatchString) > 1 do BM search }
  jb    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

  mov   ax,[esi]            { If Length(MatchString) = 1 do a REPNE SCASW }
  mov   ebx, edi
  repne scasw               { search for ax, starting at edi }
  jne   @@BMSNotFound       { No match during REPNE SCASW }
  sub   edi, ebx            { Found, calculate position. EDI points to the
                              character after the matching character. }
  shr   edi, 1
  dec   edi
  mov   esi, Pos            { Set position in Pos }
  mov   [esi], edi
  mov   eax, 1              { Set result to True }
  jmp   @@BMSDone           { We're done }

@@BMSInit:
{ At this point we have: EAX = 0
                         EBX = Pointer to BT
                         EDI = Pointer to Buffer
                         ECX = Length of Buffer in characters
                         ESI = Pointer to MatchString
                         EDX = Length of MatchString in characters }

  dec   edx                 { Set up for BM Search }
  mov   lenMS1, dx          { lenMS1 := Length(MatchString)-1 }

  shl   edx, 1
  add   esi, edx            { Set ESI to end of MatchString }
  shl   ecx, 1
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dx, [esi]           { Set DX to character we'll be looking for }
  sub   esi, 2              { Dec ESI in prep for BMSFound loop }
  std                       { Backward string ops }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
{$IFNDEF HUGE_UNICODE_BMTABLE}
                            { Regarding the BM-Table there are two options:
                              a) Use a table with one entry for every character; this
                                 results in a 64K table. The following 4 lines of code
                                 can be omitted in this case.
                              b) Use a table with only 256 entries. The overhead for
                                 building the table is smaller, but for "real" 2-byte
                                 characters, you can only proceed one character. }
  test  ah,ah
  jz    @@UseBT
  add   edi, 2              { For 2-byte characters, the BM-Table is not used. }
  jmp   @@BMSComp
{$ENDIF}

@@UseBT:
  movzx ax, [ebx+eax]       { Look up skip distance from table }
  shl   ax, 1
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
{ At this point we have: EAX = 0
                         DX  = Last character of MatchString (the char we
                               are looking for in the Buffer)
                         EBX = Pointer to Boyer-Moore-Table
                         ESI = Pointer to the second last character of MatchString
                         EDI = Pointer to the character in the buffer, that has to
                               be compared with DX
                         ECX = Pointer to the end of the Buffer (points to the first
                               byte behind the Buffer) }

  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   ax, [edi]           { Move character from buffer into AX for comparison }
  cmp   dx, ax              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  sub   edi, 2              { EDI now points to the char corresponding to ESI }
  movzx ecx, lenMS1         { Move Length(MatchString)-1 to ECX }
  repe  cmpsw               { Compare MatchString to buffer }
  je    @@BMSFound          { If equal, string is found }

  mov   ax, lenMS1          { Move Length(MatchString)-1 to AX }
  sub   ax, cx              { Calculate offset that string didn't match }
  shl   ax, 1
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }
  add   edi, 2
  mov   ax, dx              { Move character back to AX }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to the char BEFORE the start of match }
  add   edi, 2
  sub   edi, BufPtr         { Calculate position of match }
  mov   eax, edi
  shr   eax,1
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  cld                       { Restore direction flag }
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;
{$ELSE}
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BufLength to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasb               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  cmp   dl, 1               { Check to see if we have a trivial case }
  ja    @@BMSInit           { If Length(MatchString) > 1 do BM search }
  jb    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

  mov   al,[esi]            { If Length(MatchString) = 1 do a REPNE SCASB }
  mov   ebx, edi
  repne scasb
  jne   @@BMSNotFound       { No match during REP SCASB }
  dec   edi                 { Found, calculate position }
  sub   edi, ebx
  mov   esi, Pos            { Set position in Pos }
  mov   [esi], edi
  mov   eax, 1              { Set result to True }
  jmp   @@BMSDone           { We're done }

@@BMSInit:
  dec   edx                 { Set up for BM Search }
  add   esi, edx            { Set ESI to end of MatchString }
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dh, [esi]           { Set DH to character we'll be looking for }
  dec   esi                 { Dec ESI in prep for BMSFound loop }
  std                       { Backward string ops }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
  mov   al, [ebx+eax]       { Look up skip distance from table }
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   al, [edi]           { Move character from buffer into AL for comparison }
  cmp   dh, al              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  dec   edi
  xor   ecx, ecx            { Zero ECX }
  mov   cl, dl              { Move Length(MatchString) to ECX }
  repe  cmpsb               { Compare MatchString to buffer }
  je    @@BMSFound          { If equal, string is found }

  mov   al, dl              { Move Length(MatchString) to AL }
  sub   al, cl              { Calculate offset that string didn't match }
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }
  inc   edi
  mov   al, dh              { Move character back to AL }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to start of match }
  mov   edx, BufPtr         { Move pointer to buffer into EDX }
  sub   edi, edx            { Calculate position of match }
  mov   eax, edi
  inc   eax
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  cld                       { Restore direction flag }
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;
{$ENDIF}

function BMSearchUC(var Buffer; BufLength : Cardinal; var BT : BTable;
  MatchString : PChar; var Pos : Cardinal) : Boolean; register;
  {- Case-insensitive search of Buffer for MatchString. Return indicates
     success or failure.  Assumes MatchString is already raised to
     uppercase (PRIOR to creating the table)

     For details see 'BMSearch'; the code is slightly different, because
     - we cannot use REPNE SCASB(W) when Length(MatchString)=1 and
     - we cannot use REPE CMPB(W) for comparing MatchString with
       a text in the buffer. -}
var
  BufPtr : Pointer;
{$IFDEF UNICODE}
  lenMS1: Word;
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BT (Pointer to Boyer-Moore-Table) to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasw               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString (in Characters) }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer (in characters) into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  or    dl, dl              { Check to see if we have a trivial case }
  jz    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

{ At this point we have: EAX = 0
                         EBX = Pointer to BT
                         EDI = Pointer to Buffer
                         ECX = Length of Buffer in characters
                         ESI = Pointer to MatchString
                         EDX = Length of MatchString in characters }

  dec   edx                 { Set up for BM Search }
  mov   lenMS1, dx          { lenMS1 := Length(MatchString)-1 }

  shl   edx, 1
  add   esi, edx            { Set ESI to end of MatchString }
  shl   ecx, 1
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dx, [esi]           { Set DX to character we'll be looking for }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
{$IFNDEF HUGE_UNICODE_BMTABLE}
  test  ah,ah
  jz    @@UseBT
  add   edi, 2              { For 2-byte characters, the BM-Table is not used. }
  jmp   @@BMSComp
{$ENDIF}

@@UseBT:
  movzx ax, [ebx+eax]       { Look up skip distance from table }
  shl   ax, 1
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
{ At this point we have: EAX = 0
                         DX  = Last character of MatchString (the character we
                               are looking for in the Buffer)
                         EBX = Pointer to Boyer-Moore-Table
                         ESI = Pointer to the last character of MatchString
                         EDI = Pointer to the character in the buffer that has to
                               be compared with DX
                         ECX = Pointer to the end of the Buffer (points to the first
                               byte behind the Buffer) }

  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   ax, [edi]           { Move character from buffer into AX for comparison }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  call  CharUpper
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  cmp   dx, ax              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  movzx ecx, LenMS1         { Move Length(MatchString)-1 to ECX }
  jcxz  @@BMSFound          { If CX is zero, string is found }

@@StringComp:
  sub   edi, 2              { Dec buffer index }
  mov   ax, [edi]           { Get char from buffer }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  call  CharUpper
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  sub   esi, 2
  cmp   ax, [esi]
  loope @@StringComp        { OK?  Get next character }
  je    @@BMSFound          { Matched! }

  mov   ax, lenMS1          { Move Length(MatchString)-1 to AX }
  sub   ax, cx              { Calculate offset that string didn't match }
  shl   ax, 1
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }

  mov   ax, dx              { Move character back to AX }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to the char BEFORE the start of match }
  sub   edi, BufPtr         { Calculate position of match }
  mov   eax, edi
  shr   eax,1
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;
{$ELSE}
asm
  push  edi                 { Save registers since we will be changing }
  push  esi
  push  ebx
  push  edx

  mov   BufPtr, eax         { Copy Buffer to local variable and ESI }
  mov   esi, eax
  mov   ebx, ecx            { Copy BufLength to EBX }

  cld                       { Ensure forward string ops }
  xor   eax, eax            { Zero out EAX so we can search for null }
  mov   edi, MatchString    { Set EDI to beginning of MatchString }
  or    ecx, -1             { We will be counting down }
  repne scasb               { Find null }
  not   ecx                 { ECX = length of MatchString + null }
  dec   ecx                 { ECX = length of MatchString }
  mov   edx, ecx            { Copy length of MatchString to EDX }

  pop   ecx                 { Pop length of buffer into ECX }
  mov   edi, esi            { Set EDI to beginning of search buffer }
  mov   esi, MatchString    { Set ESI to beginning of MatchString }

  or    dl, dl              { Check to see if we have a trivial case }
  jz    @@BMSNotFound       { If Length(MatchString) = 0 we're done }

@@BMSInit:
  dec   edx                 { Set up for BM Search }
  add   esi, edx            { Set ESI to end of MatchString }
  add   ecx, edi            { Set ECX to end of buffer }
  add   edi, edx            { Set EDI to first check point }
  mov   dh, [esi]           { Set DH to character we'll be looking for }
  dec   esi                 { Dec ESI in prep for BMSFound loop }
  std                       { Backward string ops }
  jmp   @@BMSComp           { Jump to first comparison }

@@BMSNext:
  mov   al, [ebx+eax]       { Look up skip distance from table }
  add   edi, eax            { Skip EDI ahead to next check point }

@@BMSComp:
  cmp   edi, ecx            { Have we reached end of buffer? }
  jae   @@BMSNotFound       { If so, we're done }
  mov   al, [edi]           { Move character from buffer into AL for comparison }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  cld
  call  CharUpper
  std
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  cmp   dh, al              { Compare }
  jne   @@BMSNext           { If not equal, go to next checkpoint }

  push  ecx                 { Save ECX }
  dec   edi
  xor   ecx, ecx            { Zero ECX }
  mov   cl, dl              { Move Length(MatchString) to ECX }
  jecxz @@BMSFound          { If ECX is zero, string is found }

@@StringComp:
  mov   al, [edi]           { Get char from buffer }
  dec   edi                 { Dec buffer index }

  push  ebx                 { Save registers }
  push  ecx
  push  edx
  push  eax                 { Push Char onto stack for CharUpper }
  cld
  call  CharUpper
  std
  pop   edx                 { Restore registers }
  pop   ecx
  pop   ebx

  mov   ah, al              { Move buffer char to AH }
  lodsb                     { Get MatchString char }
  cmp   ah, al              { Compare }
  loope @@StringComp        { OK?  Get next character }
  je    @@BMSFound          { Matched! }

  xor   ah, ah              { Zero AH }
  mov   al, dl              { Move Length(MatchString) to AL }
  sub   al, cl              { Calculate offset that string didn't match }
  add   esi, eax            { Move ESI back to end of MatchString }
  add   edi, eax            { Move EDI to pre-string compare location }
  inc   edi
  mov   al, dh              { Move character back to AL }
  pop   ecx                 { Restore ECX }
  jmp   @@BMSNext           { Do another compare }

@@BMSFound:                 { EDI points to start of match }
  mov   edx, BufPtr         { Move pointer to buffer into EDX }
  sub   edi, edx            { Calculate position of match }
  mov   eax, edi
  inc   eax
  mov   esi, Pos
  mov   [esi], eax          { Set Pos to position of match }
  mov   eax, 1              { Set result to True }
  pop   ecx                 { Restore ESP }
  jmp   @@BMSDone

@@BMSNotFound:
  xor   eax, eax            { Set result to False }

@@BMSDone:
  cld                       { Restore direction flag }
  pop   ebx                 { Restore registers }
  pop   esi
  pop   edi
end;
{$ENDIF}

function CharStrPChar(Dest : PChar; C : Char;
                      Len : Cardinal) : PChar; register;
//SZ: inserts char C Len times into Dest; adds #0 - Unicode verified 27.01.2010
{$IFDEF UNICODE}
begin
  Result := StrPCopy(Dest, StringOfChar(C, Len));
end;
{$ELSE}
asm
  push    edi            { Save EDI-about to change it }
  push    eax            { Save Dest pointer for return }
  mov     edi, eax       { Point EDI to Dest }

  mov     dh, dl         { Dup character 4 times }
  mov     eax, edx
  shl     eax, $10
  mov     ax, dx

  mov     edx, ecx       { Save Len }

  cld                    { Forward! }
  shr     ecx, 2         { Store dword char chunks first }
  rep     stosd
  mov     ecx, edx       { Store remaining characters }
  and     ecx, 3
  rep     stosb

  xor     al,al          { Add null terminator }
  stosb

  pop     eax            { Return Dest pointer }
  pop     edi            { Restore orig value of EDI }
end;
{$ENDIF}

function DetabPChar(Dest : PChar; Src : PChar; TabSize : Byte) : PChar; register;
  { -Expand tabs in a string to blanks on spacing TabSize- }
asm
  push    eax           { Save Dest for return value }
  push    edi           { Save EDI, ESI and EBX, we'll be changing them }
  push    esi
  push    ebx

  mov     esi, edx      { ESI -> Src }
  mov     edi, eax      { EDI -> Dest }
  xor     ebx, ebx      { Get TabSize in EBX }
  add     bl, cl
  jz      @@Done        { Exit if TabSize is zero }

  cld                   { Forward! }
  xor     edx, edx      { Set output length to zero }

{$IFDEF UNICODE}
@@Next:
  lodsw                 { Get next input character }
  or      ax, ax        { Is it a null? }
  jz      @@Done        { Yes-all done }
  cmp     ax, 09        { Is it a tab? }
  je      @@Tab         { Yes, compute next tab stop }
  stosw                 { No, store to output }
  inc     edx           { Increment output length }
  jmp     @@Next        { Next character }

@@Tab:
  push    edx           { Save output length }
  mov     eax, edx      { Get current output length in DX:AX }
  xor     edx, edx
  div     ebx           { Output length MOD TabSize in DX }
  mov     ecx, ebx      { Calc number of spaces to insert... }
  sub     ecx, edx      { = TabSize - Mod value }
  pop     edx
  add     edx, ecx      { Add count of spaces into current output length }

  mov     eax,$0020     { Blank in AX }
  rep     stosw         { Store blanks }
  jmp     @@Next        { Back for next input }

@@Done:
  xor     ax,ax         { Store final null terminator }
  stosw
{$ELSE}
@@Next:
  lodsb                 { Get next input character }
  or      al, al        { Is it a null? }
  jz      @@Done        { Yes-all done }
  cmp     al, 09        { Is it a tab? }
  je      @@Tab         { Yes, compute next tab stop }
  stosb                 { No, store to output }
  inc     edx           { Increment output length }
  jmp     @@Next        { Next character }

@@Tab:
  push    edx           { Save output length }
  mov     eax, edx      { Get current output length in DX:AX }
  xor     edx, edx
  div     ebx           { Output length MOD TabSize in DX }
  mov     ecx, ebx      { Calc number of spaces to insert... }
  sub     ecx, edx      { = TabSize - Mod value }
  pop     edx
  add     edx, ecx      { Add count of spaces into current output length }

  mov     eax,$2020     { Blank in AH, Blank in AL }
  shr     ecx, 1        { Store blanks }
  rep     stosw
  adc     ecx, ecx
  rep     stosb
  jmp     @@Next        { Back for next input }

@@Done:
  xor     al,al         { Store final null terminator }
  stosb
{$ENDIF}

  pop     ebx           { Restore caller's EBX, ESI and EDI }
  pop     esi
  pop     edi
  pop     eax           { Return Dest }
end;

function HexBPChar(Dest : PChar; B : Byte) : PChar;
  {-Return hex string for byte}
begin
  Result := Dest;
  Dest^ := Digits[B shr 4];
  Inc(Dest);
  Dest^ := Digits[B and $F];
  Inc(Dest);
  Dest^ := #0;
end;

function HexLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return the hex string for a long integer}
var
  T2 : Array[0..4] of Char;
begin
  Result := StrCat(HexWPChar(Dest, HIWORD(L)), HexWPChar(T2, LOWORD(L)));
end;

function HexPtrPChar(Dest : PChar; P : Pointer) : PChar;
  {-Return hex string for pointer}
var
  T2 : Array[0..4] of Char;
begin
  StrCat(HexWPChar(Dest, HIWORD(LongInt(P))), ':');
  Result := StrCat(Dest, HexWPChar(T2, LOWORD(LongInt(P))));
end;

function HexWPChar(Dest : PChar; W : Word) : PChar;
begin
  Result := Dest;
  Dest^ := Digits[Hi(W) shr 4];
  Inc(Dest);
  Dest^ := Digits[Hi(W) and $F];
  Inc(Dest);
  Dest^ := Digits[Lo(W) shr 4];
  Inc(Dest);
  Dest^ := Digits[Lo(W) and $F];
  Inc(Dest);
  Dest^ := #0;
end;

function LoCaseChar(C: Char) : Char; register;
//var
//  Tmp: string;
begin
  Result := AnsiUpperCase(C)[1];
end;
{asm
  mov   edx, eax
  xor   eax, eax
  mov   al, dl
  push  eax
  call  CharLower
end; }

function OctalLPChar(Dest : PChar; L : LongInt) : PChar;
  {-Return the octal PChar string for a long integer}
var
  I : LongInt;
begin
  Result := Dest;
  FillChar(Dest^, 12, '0');
  Dest[12] := #0;
  for I := 11 downto 0 do begin
    if L = 0 then
      Exit;

    Dest[I] := Digits[L and 7];
    L :=  L shr 3;
  end;
end;

function StrChDeletePrim(P : PChar; Pos : Cardinal) : PChar; register;
//SZ: deletes character at pos P; fixed result 27.01.2010
{$IFDEF UNICODE}
begin
  if Pos > StrLen(P) then
    Exit(P);
  StrCopy(P + Pos, P + Pos + 1);
  Result := P;
end;
{$ELSE}
asm
  push   edi             { Save because we will be changing them }
  push   esi
  push   ebx

  mov    ebx, eax        { Save P to EDI & EBX }
  mov    edi, eax

  xor    al, al          { Zero }
  or     ecx, -1         { Set ECX to $FFFFFFFF }
  cld
  repne  scasb           { Find null terminator }
  not    ecx
  jecxz  @@ExitPoint
  sub    ecx, edx        { Calc number to move }
  jb     @@ExitPoint     { Exit if Pos > StrLen }

  mov    edi, ebx
  add    edi, edx        { Point to position to adjust }
  mov    esi, edi
  inc    esi             { Offset for source string }
  inc    ecx             { One more to include null terminator }
  rep    movsb           { Adjust the string }
@@ExitPoint:

  mov    eax, ebx
  pop    ebx             { restore registers }
  pop    esi
  pop    edi
end;
{$ENDIF}

function StrChInsertPrim(Dest : PChar; C : Char;
                         Pos : Cardinal) : PChar; register;
//SZ Unicode verified 27.01.2010
{$IFDEF UNICODE}
var
  Tmp: String;
begin
  Tmp := Dest;
  Insert(C, Tmp, Pos+1);
  StrPCopy(Dest, Tmp);
  Result := Dest;
end;
{$ELSE}
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  xor    ebx, ebx        {zero}
  mov    ebx, ecx        {move POS to ebx}

  mov    esi, eax        {copy Dest to ESI and EDI}
  mov    edi, eax

  xor    al, al          {zero}
  or     ecx, -1         {set ECX to $FFFFFFFF}
  cld                    {ensure forward}
  repne  scasb           {find null terminator}

  not    ecx             {calc length (including null)}
  std                    {backwards string ops}
  add    esi, ecx
  dec    esi             {point to end of source string}
  sub    ecx, ebx        {calculate number to do}
  jae    @@1             {append if Pos greater than strlen + 1}
  mov    ecx, 1

@@1:
  rep    movsb           {adjust tail of string}
  mov    eax, edx
  stosb                  {insert the new character}

@@ExitPoint:

  cld                    {be a good neighbor}
  pop    ebx             {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;
{$ENDIF}

function StrChPos(P : PChar; C : Char;
                  var Pos : Cardinal): Boolean; register;
  {-Sets Pos to position of character C within string P returns True if found}
//SZ Unicode verified 27.01.2010
{$IFDEF UNICODE}
var
  Tmp: PChar;
begin
  Tmp := StrScan(P, C);
  Pos := 0;
  Result := Tmp <> nil;
  if Result then
    Pos := Tmp - P;
end;
{$ELSE}
asm
  push   esi               {save since we'll be changing}
  push   edi
  push   ebx
  mov    esi, ecx          {save Pos}

  cld                      {forward string ops}
  mov    edi, eax          {copy P to EDI}
  or     ecx, -1
  xor    eax, eax          {zero}
  mov    ebx, edi          {save EDI to EBX}
  repne  scasb             {search for NULL terminator}
  not    ecx
  dec    ecx               {ecx has len of string}

  test   ecx, ecx
  jz     @@NotFound        {if len of P = 0 then done}

  mov    edi, ebx          {reset EDI to beginning of string}
  mov    al, dl            {copy C to AL}
  repne  scasb             {find C in string}
  jne    @@NotFound

  mov    ecx, edi          {calculate position of C}
  sub    ecx, ebx
  dec    ecx               {ecx holds found position}

  mov    [esi], ecx        {store location}
  mov    eax, 1            {return true}
  jmp    @@ExitCode

@@NotFound:
  xor    eax, eax

@@ExitCode:

  pop    ebx               {restore registers}
  pop    edi
  pop    esi
end;
{$ENDIF}

procedure StrInsertChars(Dest : PChar; Ch : Char; Pos, Count : Word);
  {-Insert count instances of Ch into S at Pos}
var
  A : array[0..1024] of Char;
begin
  StrPCopy(A, StringOfChar(Ch, Count)); //  FillChar(A, Count, Ch);
  A[Count] := #0;
  StrStInsertPrim(Dest, A, Pos);
end;

function StrStCopy(Dest : PChar; S : PChar; Pos, Count : Cardinal) : PChar;
var
  Len : Cardinal;
begin
  Len := StrLen(S);
  if Pos < Len then begin
    if (Len-Pos) < Count then
      Count := Len-Pos;
    Move(S[Pos], Dest^, Count * SizeOf(Char));
    Dest[Count] := #0;
  end else
    Dest[0] := #0;
  Result := Dest;
end;

function StrStDeletePrim(P : PChar; Pos, Count : Cardinal) : PChar; register;
//SZ Unicode verified 27.01.2010
{$IFDEF UNICODE}
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move Count to BX}
  mov    esi, eax        {move P to ESI and EDI}
  mov    edi, eax

  xor    eax, eax        {null}
  or     ecx, -1
  cld
  repne  scasw           {find null terminator}
  not    ecx             {calc length}
  jecxz  @@ExitPoint

  sub    ecx, ebx        {subtract Count}
  sub    ecx, edx        {subtract Pos}
  jns    @@L1

  mov    edi,esi         {delete everything after Pos}
  add    edi,edx
  add    edi,edx
  stosw
  jmp    @@ExitPoint

@@L1:
  mov    edi,esi
  add    edi,edx         {point to position to adjust}
  add    edi,edx
  mov    esi,edi
  add    esi,ebx         {point past string to delete in src}
  add    esi,ebx
  inc    ecx             {one more to include null terminator}
  inc    ecx
  rep    movsw           {adjust the string}

@@ExitPoint:

  pop    ebx            {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;
{$ELSE}
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move Count to BX}
  mov    esi, eax        {move P to ESI and EDI}
  mov    edi, eax

  xor    eax, eax        {null}
  or     ecx, -1
  cld
  repne  scasb           {find null terminator}
  not    ecx             {calc length}
  jecxz  @@ExitPoint

  sub    ecx, ebx        {subtract Count}
  sub    ecx, edx        {subtract Pos}
  jns    @@L1

  mov    edi,esi         {delete everything after Pos}
  add    edi,edx
  stosb
  jmp    @@ExitPoint

@@L1:
  mov    edi,esi
  add    edi,edx         {point to position to adjust}
  mov    esi,edi
  add    esi,ebx         {point past string to delete in src}
  inc    ecx             {one more to include null terminator}
  rep    movsb           {adjust the string}

@@ExitPoint:

  pop    ebx            {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;
{$ENDIF}

function StrStInsert(Dest : PChar; S1, S2 : PChar; Pos : Cardinal) : PChar;
begin
  StrCopy(Dest, S1);
  Result := StrStInsertPrim(Dest, S2, Pos);
end;

function StrStInsertPrim(Dest : PChar; S : PChar;
                         Pos : Cardinal) : PChar; register;
{$IFDEF UNICODE}
//SZ Unicode verified 27.01.2010
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move POS to ebx}
  mov    esi, eax        {copy Dest to ESI, S to EDI}
  mov    edi, edx

  xor    ax, ax          {zero}
  or     ecx, -1         {set ECX to $FFFFFFFF}
  cld                    {ensure forward}
  repne  scasw           {find null terminator}
  not    ecx             {calc length of source string (including null)}
  dec    ecx             {length without null}
  jecxz  @@ExitPoint     {if source length = 0, exit}
  push   ecx             {save length for later}

  mov    edi, esi        {reset EDI to Dest}
  or     ecx, -1
  repne  scasw           {find null}
  not    ecx             {length of dest string}

  cmp    ebx, ecx
  jb     @@1
  mov    ebx, ecx
  dec    ebx

@@1:
  std                    {backwards string ops}
  pop    eax             {restore length of S from stack}
  add    edi, eax        {set EDI S beyond end of Dest}
  add    edi,eax //
  dec    edi             {back up one for null}
  dec    edi //

  add    esi, ecx        {set ESI to end of Dest}
  add    esi, ecx //
  dec    esi             {back up one for null}
  dec    esi //
  sub    ecx, ebx        {# of chars in Dest that are past Pos}
  rep    movsw           {adjust tail of string}

  mov    esi, edx        {set ESI to S}
  add    esi, eax        {set ESI to end of S}
  add    esi, eax //
  dec    esi             {back up one for null}
  dec    esi //
  mov    ecx, eax        {# of chars in S}
  rep    movsw           {copy S into Dest}

  cld                    {be a good neighbor}

@@ExitPoint:
  pop    ebx             {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;
{$ELSE}
asm
  push   eax             {save because we will be changing them}
  push   edi
  push   esi
  push   ebx

  mov    ebx, ecx        {move POS to ebx}
  mov    esi, eax        {copy Dest to ESI, S to EDI}
  mov    edi, edx

  xor    al, al          {zero}
  or     ecx, -1         {set ECX to $FFFFFFFF}
  cld                    {ensure forward}
  repne  scasb           {find null terminator}
  not    ecx             {calc length of source string (including null)}
  dec    ecx             {length without null}
  jecxz  @@ExitPoint     {if source length = 0, exit}
  push   ecx             {save length for later}

  mov    edi, esi        {reset EDI to Dest}
  or     ecx, -1
  repne  scasb           {find null}
  not    ecx             {length of dest string}

  cmp    ebx, ecx
  jb     @@1
  mov    ebx, ecx
  dec    ebx

@@1:
  std                    {backwards string ops}
  pop    eax             {restore length of S from stack}
  add    edi, eax        {set EDI S beyond end of Dest}
  dec    edi             {back up one for null}

  add    esi, ecx        {set ESI to end of Dest}
  dec    esi             {back up one for null}
  sub    ecx, ebx        {# of chars in Dest that are past Pos}
  rep    movsb           {adjust tail of string}

  mov    esi, edx        {set ESI to S}
  add    esi, eax        {set ESI to end of S}
  dec    esi             {back up one for null}
  mov    ecx, eax        {# of chars in S}
  rep    movsb           {copy S into Dest}

  cld                    {be a good neighbor}

@@ExitPoint:
  pop    ebx             {restore registers}
  pop    esi
  pop    edi
  pop    eax
end;
{$ENDIF}

function StrStPos(P, S : PChar; var Pos : Cardinal) : boolean; register;
//SZ Unicode verified 27.01.2010
{$IFDEF UNICODE}
var
  Q: PChar;
begin
  Q := StrPos(P, S);
  if Q = nil then
  begin
    Pos := 0;
    Result := False;
  end
  else
  begin
    Pos := Q - P;
    Result := True;
  end;
end;
{$ELSE}
asm
  push   edi                 { Save registers }
  push   esi
  push   ebx
  push   ecx

  mov    ebx, eax            { Move P to EBX }
  mov    edi, edx            { Move S to EDI & ESI }
  mov    esi, edx

  xor    eax, eax            { Zero EAX }
  or     ecx, -1             { Set ECX to FFFFFFFF }
  repne  scasb               { Find null at end of S }
  not    ecx

  mov    edx, ecx            { Save length to EDX }
  dec    edx                 { EDX has len of S }
  test   edx, edx
  jz     @@NotFound          { If len of S = 0 then done }

  mov    edi, ebx            { Set EDI to beginning of P }
  or     ecx, -1             { Set ECX to FFFFFFFF }
  repne  scasb               { Find null at end of P }
  not    ecx
  dec    ecx                 { ECX has len of P }
  jcxz   @@NotFound          { If len of P = 0 then done }

  dec    edx
  sub    ecx,edx             { Max chars to search }
  jbe    @@NotFound          { Done if len S > len P }
  lodsb                      { Get first char of S in AL }
  mov    edi,ebx             { Set EDI to beginning of EDI }

@@Next:
  repne  scasb               { Find first char of S in P }
  jne    @@NotFound          { If not found then done }
  test   edx, edx            { If length of S was one then found }
  jz     @@Found
  push   ecx
  push   edi
  push   esi
  mov    ecx,edx
  repe   cmpsb               { See if remaining chars in S match }
  pop    esi
  pop    edi
  pop    ecx
  je     @@Found             { Yes, so found }
  jmp    @@Next              { Look for next first char occurrence }

@@NotFound:
  pop    ecx
  xor    eax,eax             { Set return to False }
  jmp    @@ExitPoint

@@Found:
  dec    edi                 { Calc position of found string }
  mov    eax, edi
  sub    eax, ebx
  pop    ecx
  mov    [ecx], eax
  mov    eax, 1              { Set return to True }

@@ExitPoint:
  pop    ebx                 { Restore registers }
  pop    esi
  pop    edi
end;
{$ENDIF}

function StrToLongPChar(S : PChar; var I : LongInt) : Boolean;
  {-Convert a string to a longint, returning true if successful}
//SZ Unicode verified 27.01.2010
var
  Code : Cardinal;
  P    : array[0..255] of Char;
begin
  if StrLen(S)+1 > SizeOf(P) then begin
    Result := False;
    I := -1;
    Exit;
  end;
  StrCopy(P, S);
  TrimTrailPrimPChar(P);
  if StrStPos(P, '0x', Code) then begin
    StrStDeletePrim(P, Code, 2);
    StrChInsertPrim(P, '$', Code);
  end;
  Val(P, I, Code);
  if Code <> 0 then begin
    I := Code - 1;
    Result := False;
  end else
    Result := True;
end;

procedure TrimAllSpacesPChar(P : PChar);
  {-Trim leading and trailing blanks from P}
var
  I : Integer;
  PT : PChar;
begin
  I := StrLen(P);
  if I = 0 then
    Exit;

  {delete trailing spaces}
  Dec(I);
  while (I >= 0) and (P[I] = ' ') do begin
    P[I] := #0;
    Dec(I);
  end;

  {delete leading spaces}
  I := 0;
  PT := P;
  while PT^ = ' ' do begin
    Inc(I);
    Inc(PT);
  end;
  if I > 0 then
    StrStDeletePrim(P, 0, I);
end;

function TrimEmbeddedZeros(const S : string) : string;
  {-trim embedded zeros from a numeric string in exponential format}
var
  I, J : Integer;
begin
  I := Pos('E', S);
  if I = 0 then
    Exit;  {nothing to do}

  Result := S;

  {get rid of excess 0's after the decimal point}
  J := I;
  while (J > 1) and (Result[J-1] = '0') do
    Dec(J);
  if J <> I then begin
    System.Delete(Result, J, I-J);

    {get rid of the decimal point if that's all that's left}
    if (J > 1) and (Result[J-1] = '.') then
      System.Delete(Result, J-1, 1);
  end;

  {get rid of excess 0's in the exponent}
  I := Pos('E', Result);
  if I > 0 then begin
    Inc(I);
    J := I;
    while Result[J+1] = '0' do
      Inc(J);
    if J > I then
      System.Delete(Result, I+1, J-I);
  end;
end;

procedure TrimEmbeddedZerosPChar(P : PChar);
  {-Trim embedded zeros from a numeric string in exponential format}
var
  I, J : Cardinal;
begin
  if not StrChPos(P, 'E', I) then
    Exit;

  {get rid of excess 0's after the decimal point}
  J := I;
  while (J > 0) and (P[J-1] = '0') do
    Dec(J);
  if J <> I then begin
    StrStDeletePrim(P, J, I-J);

    {get rid of the decimal point if that's all that's left}
    if (J > 0) and (P[J-1] = '.') then
      StrStDeletePrim(P, J-1, 1);
  end;

  {Get rid of excess 0's in the exponent}
  if StrChPos(P, 'E', I) then begin
    Inc(I);
    J := I;
    while P[J+1] = '0' do
      Inc(J);
    if J > I then
      if P[J+1] = #0 then
        P[I-1] := #0
      else
        StrStDeletePrim(P, I+1, J-I);
  end;
end;

function TrimTrailingZeros(const S : string) : string;
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
var
  I : Integer;
begin
  if S = '' then
    Exit;

  Result := S;
  I := Length(Result);
  {delete trailing zeros}
  while (Result[I] = '0') and (I > 1) do
    Dec(I);
  {delete decimal point, if any}
  if Result[I] = '.' then
    Dec(I);
  Result := Trim(Copy(Result, 1, I));
end;

procedure TrimTrailingZerosPChar(P : PChar);
  {-Trim trailing zeros from a numeric string. It is assumed that there is
    a decimal point prior to the zeros. Also strips leading spaces.}
var
  PT : PChar;
begin
  PT := StrEnd(P);
  if Pointer(PT) = Pointer(P) then
    Exit;

  {back up to character prior to null}
  Dec(PT);

  {delete trailing zeros}
  while PT^ = '0' do begin
    PT^ := #0;
    Dec(PT);
  end;

  {delete decimal point, if any}
  if PT^ = '.' then
    PT^ := #0;

  TrimAllSpacesPChar(P);
end;

function TrimTrailPrimPChar(S : PChar) : PChar; register;
//SZ Unicode fixed and verified 27.01.2010
{$IFDEF UNICODE}
var
  Len: Integer;
  PEnd: PChar;
begin
  Len := StrLen(S);
  PEnd := S + Len - 1;
  while PEnd >= S do
  begin
    if PEnd^ = ' ' then
      PEnd^ := #0
    else
      Break;
    Dec(PEnd);
  end;
  Result := S;
end;
{$ELSE}
asm
   cld
   push   edi
   mov    edx, eax
   mov    edi, eax

   or     ecx, -1
   xor    al, al
   repne  scasb
   not    ecx
   dec    ecx
   jecxz  @@ExitPoint

   dec    edi

@@1:
   dec    edi
   cmp    byte ptr [edi],' '
   jbe    @@1
   mov    byte ptr [edi+1],00h
@@ExitPoint:
   mov    eax, edx
   pop    edi
end;
{$ENDIF}

function TrimTrailPChar(Dest, S : PChar) : PChar;
  {-Return a string with trailing white space removed}
begin
  StrCopy(Dest, S);
  Result := TrimTrailPrimPChar(Dest);
end;

function UpCaseChar(C : Char) : Char; register;
//SZ Unicode fixed and verified 27.01.2010  (incorrect Result for Unicode chars)
{$IFDEF UNICODE}
var
  S: String;
begin
  S := C;
  S := CharUpper(PChar(S));
  if Length(S) >= 1 then
    Result := S[1]
  else
    Result := C;
end;
{$ELSE}
asm
  and   eax, 0FFh
  push  eax
  call  CharUpper
end;
{$ENDIF}

function ovcCharInSet(C: Char; const CharSet: TOvcCharSet): Boolean;
begin
{$IFDEF UNICODE}
  Result := SysUtils.CharInSet(C, CharSet);
{$ELSE}
  Result := C in CharSet;
{$ENDIF}
end;

function ovc32StringIsCurrentCodePage(const S: WideString): Boolean;
// returns True if a string can be displayed using the current system codepage
const
  WC_NO_BEST_FIT_CHARS = $00000400;
  CP_APC = 0;
var
  UsedDefaultChar: BOOL;   // not Boolean!!
  Len: Integer;
begin
  UsedDefaultChar := False;
  Len := WideCharToMultiByte(CP_APC, WC_NO_BEST_FIT_CHARS, PWideChar(S), Length(S), nil, 0, nil, @UsedDefaultChar);
  if Len <> 0 then
    Result := not UsedDefaultchar
  else
    Result := False;
end;

end.
