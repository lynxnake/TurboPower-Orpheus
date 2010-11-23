program OrpheusTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  //FastMM4,
  MidasLib,
  Forms,
  TestFramework,
  GUITestRunner,
  TextTestRunner,
  TestOVCEditU in 'TestOVCEditU.pas',
  TestOVCIntl in 'TestOVCIntl.pas',
  TestOVCPlb in 'TestOVCPlb.pas',
  TestOvcFormatSettings in 'TestOvcFormatSettings.pas',
  TestOvcDbPictureField in 'TestOvcDbPictureField.pas',
  TestOvcDbSimpleField in 'TestOvcDbSimpleField.pas',
  TestOvcPictureField in 'TestOvcPictureField.pas' {frmTestOvcPictureField},
  TestOVCStr in 'TestOVCStr.pas',
  TestOVCEdit in 'TestOVCEdit.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

