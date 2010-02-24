{******************************************************************************}
{*                   TestOovcIintl.pas 4.07                                   *}
{******************************************************************************}

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
{* The Initial Developer of the Original Code is Roman Kassebaum              *}
{*                                                                            *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Roman Kassebaum                                                         *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}
unit TestOVCIntl;

interface

uses
  TestFramework;

type
  TTestOVCIntl = class(TTestCase)
  published
    procedure TestInternationalTime;
  end;

implementation

uses
  OvcIntl;

type
  TProtectedIntlSub = class(TOvcIntlSup);

{ TTestOVCIntl }

procedure TTestOVCIntl.TestInternationalTime;
var
  pIntlSup: TOvcIntlSup;
begin
  pIntlSup := TOvcIntlSup.Create;
  try
    //This test should also work on a German OS, that's why I'm doing
    //some tricks to simulate an English OS.
    TProtectedIntlSub(pIntlSup).w12Hour := True;
    TProtectedIntlSub(pIntlSup).w1159 := 'AM';
    TProtectedIntlSub(pIntlSup).w2359 := 'PM';

    CheckEquals(pIntlSup.InternationalTime(True), 'hh:mm:ss ttttt');
    CheckEquals(pIntlSup.InternationalTime(False), 'hh:mm ttttt');
  finally
    pIntlSup.Free;
  end;
end;

initialization
  RegisterTest(TTestOVCIntl.Suite);


end.
