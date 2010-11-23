unit TestOvcPictureField;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovctcbef, ovctcpic, ovctcmmn, ovctcell, ovctcstr, ovctcedt, ovcbase,
  ovctable, TestFramework;

type
  TfrmTestOvcPictureField = class(TForm)
    OvcTable1: TOvcTable;
    OvcTCString1: TOvcTCString;
    OvcTCPictureField1: TOvcTCPictureField;
    procedure FormCreate(Sender: TObject);
    procedure OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer; var Data: Pointer;
      Purpose: TOvcCellDataPurpose);
  private
    FString1: string;
    FString2: string;
  end;

  TTestOvcPictureField = class(TTestCase)
  private
    FForm: TfrmTestOvcPictureField;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure GetCellData;
  end;

implementation

{$R *.dfm}


type
  TPOvcTCPictureField = class(TOvcTCPictureField);

procedure TfrmTestOvcPictureField.FormCreate(Sender: TObject);
begin
  FString1 := 'OvcTCString1';
  FString2 := 'OvcTCField1';
end;

procedure TfrmTestOvcPictureField.OvcTable1GetCellData(Sender: TObject; RowNum, ColNum: Integer;
  var Data: Pointer; Purpose: TOvcCellDataPurpose);
begin
  if ColNum = 0 then
    data := @FString1
  else
    data := @FString2;
end;

{ TTestOvcPictureField }

procedure TTestOvcPictureField.GetCellData;
begin
  FForm.Show;
  Application.ProcessMessages;
  CheckEquals(FForm.FString2, TPOvcTCPictureField(FForm.OvcTCPictureField1).FEditDisplay.Text);
end;

procedure TTestOvcPictureField.SetUp;
begin
  inherited SetUp;
  FForm := TfrmTestOvcPictureField.Create(nil);
end;

procedure TTestOvcPictureField.TearDown;
begin
  FForm.Free;
  inherited TearDown;
end;

initialization
  RegisterTest(TTestOvcPictureField.Suite);

end.
