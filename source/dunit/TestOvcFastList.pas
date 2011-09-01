{******************************************************************************}
{*                   TestOvcFastList.pas 4.08                                 *}
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
{* The Initial Developer of the Original Code is Armin Biernaczyk             *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*    Armin Biernaczyk                                                        *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit TestOvcFastList;

interface

uses
  TestFramework;

type
  TTestOvcFastList = class(TTestCase)
  published
    procedure TestDateStringToDate;
    procedure TestDateToDateString;
    procedure TestInternationalTime;
    procedure TestMonthStringToMonth;
    procedure TestisMergeIntoPicture;
    procedure TestDateTimeToDatePChar;
  end;

implementation

uses
  OvcDlm, SysUtils, StrUtils;

implementation

end.

