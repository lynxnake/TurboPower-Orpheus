unit TestOvcPictureField;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovctcbef, ovctcpic, ovctcmmn, ovctcell, ovctcstr, ovctcedt, ovcbase, ovcef,
  ovctable, TestFramework, ovctcnum;

type
  TfrmTestOvcPictureField = class(TForm)
    OvcTable1: TOvcTable;
    OvcTCString1: TOvcTCString;
    OvcTCPictureField1: TOvcTCPictureField;
    OvcTCPictureField2: TOvcTCPictureField;
    OvcTCNumericField1: TOvcTCNumericField;
    procedure FormCreate(Sender: TObject);
    procedure OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer; var Data: Pointer;
      Purpose: TOvcCellDataPurpose);
  private
    FString1: string;
    FString2: string;
    FInteger1: Integer;
    FDouble1: Double;
  end;

  TTestOvcPictureField = class(TTestCase)
  private
    FForm: TfrmTestOvcPictureField;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure GetCellData_OvcTCPictureField_pftString;
    procedure GetCellData_OvcTCPictureField_pftLongInt;
    procedure GetCellData_OvcTCNumericField_nftDouble;
  end;

implementation

{$R *.dfm}


type
  TPOvcTCString = class(TOvcTCString);
  TPOvcTCPictureField = class(TOvcTCPictureField);
  TPOvcTCNumericField = class(TOvcTCNumericField);

procedure TfrmTestOvcPictureField.FormCreate(Sender: TObject);
begin
  FString1 := 'OvcTCString1';
  FString2 := 'OvcTCField1';
  FInteger1 := 123456;
  FDouble1 := 1234.5;
end;

procedure TfrmTestOvcPictureField.OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer;
  var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  case ColNum of
    0: data := @FString1;
    1: data := @FString2;
    2: data := @FInteger1;
    3: data := @FDouble1;
    else
      data := nil;
  end;
end;

{ TTestOvcPictureField }

procedure TTestOvcPictureField.GetCellData_OvcTCPictureField_pftString;
var
  s : string;
begin
  s := Trim(TPOvcTCPictureField(FForm.OvcTCPictureField1).FEditDisplay.Text);
  CheckEquals(FForm.FString2, s);
end;

procedure TTestOvcPictureField.GetCellData_OvcTCPictureField_pftLongInt;
var
  s : string;
begin
  s := Trim(TPOvcTCPictureField(FForm.OvcTCPictureField2).FEditDisplay.Text);
  CheckEquals(Inttostr(FForm.FInteger1), s);
end;

procedure TTestOvcPictureField.GetCellData_OvcTCNumericField_nftDouble;
var
  s : string;
begin
  s := Trim(TPOvcTCNumericField(FForm.OvcTCNumericField1).FEditDisplay.Text);
  CheckEquals(Format('%.2n',[FForm.FDouble1]), s);
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
