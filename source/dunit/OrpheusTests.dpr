program OrpheusTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  {$IFNDEF WIN64}
  MidasLib,
  {$ENDIF}
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
  TestOvcTable in 'TestOvcTable.pas' {frmTestOvcPictureField},
  TestOVCStr in 'TestOVCStr.pas',
  TestOVCEdit in 'TestOVCEdit.pas' {Form1},
  TestOvcUtils in 'TestOvcUtils.pas',
  TestOvcFileViewer in 'TestOvcFileViewer.pas' {OvcFileViewerForm},
  TestOvcDate in 'TestOvcDate.pas',
  TestOvcTransfer in 'TestOvcTransfer.pas' {TestOvcTransferForm},
  TestOvcSpinner in 'TestOvcSpinner.pas' {TestOvcSpinnerForm},
  TestOvcMisc in 'TestOvcMisc.pas',
  TestOvcComboBox in 'TestOvcComboBox.pas' {TfrmTestOvcComboBox},
  TestOvcDlm in 'TestOvcDlm.pas';

{$R *.RES}

begin
  Application.Initialize;
  if IsConsole then
    TextTestRunner.RunRegisteredTests
  else
    GUITestRunner.RunRegisteredTests;
end.

