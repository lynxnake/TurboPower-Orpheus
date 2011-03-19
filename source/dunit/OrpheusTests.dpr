program OrpheusTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
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
  TestOvcTCPictureField in 'TestOvcTCPictureField.pas' {frmTestOvcPictureField},
  TestOVCStr in 'TestOVCStr.pas',
  TestOVCEdit in 'TestOVCEdit.pas' {Form1},
  OvcStr in '..\OvcStr.pas',
  TestOvcUtils in 'TestOvcUtils.pas',
  TestOvcFileViewer in 'TestOvcFileViewer.pas' {OvcFileViewerForm},
  TestOvcPictureField in 'TestOvcPictureField.pas' {TestOvcPictureFieldForm};

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

