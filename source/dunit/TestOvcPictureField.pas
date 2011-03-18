unit TestOvcPictureField;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, OvcData,
  Dialogs, ovctcbef, ovctcpic, ovctcmmn, ovctcell, ovctcstr, ovctcedt, ovcbase, ovcef,
  ovctable, TestFramework, ovctcnum, ovctcsim;

type
  TfrmTestOvcPictureField = class(TForm)
    OvcTable1: TOvcTable;
    OvcTCString1: TOvcTCString;
    OvcTCPictureField1: TOvcTCPictureField;
    OvcTCPictureField2: TOvcTCPictureField;
    OvcTCNumericField1: TOvcTCNumericField;
    OvcTCSimpleField1: TOvcTCSimpleField;
    procedure FormCreate(Sender: TObject);
    procedure OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer; var Data: Pointer;
      Purpose: TOvcCellDataPurpose);
  private
    { Fields for storing the data being displayed in the table. To detect a possible
      "buffer-overflow" (that might occur when data is written back from the table)
      "Overflow"-Field are used. }
    Data_OvcTCString1: string;
    Data_Overflow_OvcTCString1: Integer;
    Data_OvcTCPictureField1: string;
    Data_Overflow_OvcTCPictureField1: Integer;
    Data_OvcTCPictureField2: Integer;
    Data_Overflow_OvcTCPictureField2: Integer;
    Data_OvcTCNumericField1: Double;
    Data_Overflow_OvcTCNumericField1: Integer;
    Data_OvcTCSimpleField1: string;
    Data_Overflow_OvcTCSimpleField1: Integer;
  end;

  TTestOvcPictureField = class(TTestCase)
  private
    FForm: TfrmTestOvcPictureField;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestOvcTCPictureField_pftString;
    procedure TestOvcTCPictureField_pftLongInt;
    procedure TestOvcTCNumericField_nftDouble;
    procedure TestOvcTCSimpleField_sftString;
    procedure TestOvcTCSimpleField_sftString_DataNIL;
  end;

implementation

{$R *.dfm}


type
  TPOvcTCString = class(TOvcTCString);
  TPOvcTCPictureField = class(TOvcTCPictureField);
  TPOvcTCNumericField = class(TOvcTCNumericField);
  TPOvcTCSimpleField  = class(TOvcTCSimpleField);
  TPOvcBaseEntryField = class(TOvcBaseEntryField);

procedure TfrmTestOvcPictureField.FormCreate(Sender: TObject);
begin
  Data_OvcTCString1                := '';
  Data_Overflow_OvcTCString1       := -1;
  Data_OvcTCPictureField1          := '';
  Data_Overflow_OvcTCPictureField1 := -1;
  Data_OvcTCPictureField2          :=  0;
  Data_Overflow_OvcTCPictureField2 := -1;
  Data_OvcTCNumericField1          := 0;
  Data_Overflow_OvcTCNumericField1 := -1;
  Data_OvcTCSimpleField1           := '';
  Data_Overflow_OvcTCSimpleField1  := -1;
end;

procedure TfrmTestOvcPictureField.OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer;
  var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  if RowNum=0 then begin
    case ColNum of
      0: data := @Data_OvcTCString1;
      1: data := @Data_OvcTCPictureField1;
      2: data := @Data_OvcTCPictureField2;
      3: data := @Data_OvcTCNumericField1;
      4: data := @Data_OvcTCSimpleField1;
      else
        data := nil;
    end;
  end else
    { special case for 'TestOvcTCSimpleField_sftString_DataNIL' }
    data := nil;
end;

{ TTestOvcPictureField }

procedure TypeText(F:TPOvcBaseEntryField; const s:string);
var
  i: Integer;
begin
  for i := 1 to Length(s) do begin
    Include(F.sefOptions, sefAcceptChar);
    Include(F.sefOptions, sefCharOK);
    F.Perform(WM_CHAR, Ord(s[i]), 0);
  end;
end;


procedure TTestOvcPictureField.TestOvcTCPictureField_pftString;
  {- test OvcTCPictureField with datatype 'pftString' }
begin
  { Test reading data }
  FForm.Data_OvcTCPictureField1 := 'OvcTCField1';
  FForm.OvcTable1.Repaint;
  CheckEquals('OvcTCField1', Trim(TPOvcTCPictureField(FForm.OvcTCPictureField1).FEditDisplay.Text));

  { Test typing data }
  FForm.OvcTable1.SetFocus;
  FForm.OvcTable1.SetActiveCell(0,1);
  FForm.OvcTable1.StartEditingState;
  TypeText(TPOvcBaseEntryField(TPOvcTCPictureField(FForm.OvcTCPictureField1).FEdit), 'another test');
  FForm.OvcTable1.StopEditingState(True);
  CheckEquals('another test', Trim(FForm.Data_OvcTCPictureField1));
  CheckEquals(-1, FForm.Data_Overflow_OvcTCPictureField1, 'Data overflow for OvcTCPictureField1');
end;


procedure TTestOvcPictureField.TestOvcTCPictureField_pftLongInt;
  {- test OvcTCPictureField with datatype 'pftLongInt' }
begin
  { Test reading data }
  FForm.Data_OvcTCPictureField2 := 123456789;
  FForm.OvcTable1.Repaint;
  CheckEquals('123456789', Trim(TPOvcTCPictureField(FForm.OvcTCPictureField2).FEditDisplay.Text));

  { Test typing data }
  FForm.OvcTable1.SetFocus;
  FForm.OvcTable1.SetActiveCell(0,2);
  FForm.OvcTable1.StartEditingState;
  TypeText(TPOvcBaseEntryField(TPOvcTCPictureField(FForm.OvcTCPictureField2).FEdit), '987654321');
  FForm.OvcTable1.StopEditingState(True);
  CheckEquals(987654321, FForm.Data_OvcTCPictureField2);
  CheckEquals(-1, FForm.Data_Overflow_OvcTCPictureField2, 'Data overflow for OvcTCPictureField2');
end;


procedure TTestOvcPictureField.TestOvcTCNumericField_nftDouble;
  {- test OvcTCNumericField with datatype 'nftDouble' }
begin
  { Test reading data }
  FForm.Data_OvcTCNumericField1 := 1234.56;
  FForm.OvcTable1.Repaint;
  CheckEquals('1.234,56', Trim(TPOvcTCNumericField(FForm.OvcTCNumericField1).FEditDisplay.Text));

  { Test typing data }
  FForm.OvcTable1.SetFocus;
  FForm.OvcTable1.SetActiveCell(0,3);
  FForm.OvcTable1.StartEditingState;
  TypeText(TPOvcBaseEntryField(TPOvcTCNumericField(FForm.OvcTCNumericField1).FEdit), '6543,21');
  FForm.OvcTable1.StopEditingState(True);
  CheckEquals(Format('%.2n',[6543.21]), Format('%.2n',[FForm.Data_OvcTCNumericField1]));
  CheckEquals(-1, FForm.Data_Overflow_OvcTCNumericField1, 'Data overflow for OvcTCNumericField1');
end;


procedure TTestOvcPictureField.TestOvcTCSimpleField_sftString;
  {- test OvcTCSimpleField with datatype 'sftString' }
begin
  { Test reading data }
  FForm.Data_OvcTCSimpleField1 := 'OvcTCSimpleField1';
  FForm.OvcTable1.Repaint;
  CheckEquals('OvcTCSimpleField1', Trim(TPOvcTCSimpleField(FForm.OvcTCSimpleField1).FEditDisplay.Text));

  { Test typing data }
  FForm.OvcTable1.SetFocus;
  FForm.OvcTable1.SetActiveCell(0,4);
  FForm.OvcTable1.StartEditingState;
  TypeText(TPOvcBaseEntryField(TPOvcTCSimpleField(FForm.OvcTCSimpleField1).FEdit), 'sft field test');
  FForm.OvcTable1.StopEditingState(True);
  CheckEquals('sft field test', Trim(FForm.Data_OvcTCSimpleField1));
  CheckEquals(-1, FForm.Data_Overflow_OvcTCSimpleField1, 'Data overflow for OvcTCSimpleField1');
end;


procedure TTestOvcPictureField.TestOvcTCSimpleField_sftString_DataNIL;
  {- test for a corner case that was handled incorrectly in rev 191}
var
  s: string;
begin
  FForm.Data_OvcTCSimpleField1 := 'Cell(0,4)';
  { Go to cell (0,4) and start editing state to make sure the content of the cell ('Cell(0,4)')
    is transfered to the underlying TOvcBaseEntryField. }
  FForm.OvcTable1.SetActiveCell(0,4);
  FForm.OvcTable1.StartEditingState;
  FForm.OvcTable1.StopEditingState(False);
  { go to the next line an start editing again; OvcTable1GetCellData will provide no data
    here; the ovctable must take care to clear the contents of the edit field in this case }
  FForm.OvcTable1.SetActiveCell(1,4);
  FForm.OvcTable1.StartEditingState;
  FForm.OvcTCSimpleField1.SaveEditedData(@s);
  CheckEqualsString('', s);
end;


procedure TTestOvcPictureField.SetUp;
begin
  inherited SetUp;
  FForm := TfrmTestOvcPictureField.Create(nil);
  FForm.Show;
  Application.ProcessMessages;
end;

procedure TTestOvcPictureField.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcPictureField.Suite);

end.
