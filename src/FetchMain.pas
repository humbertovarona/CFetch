unit FetchMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, VGrid, Math, PrntComp;

type
  TFetchForm = class(TForm)
    ScrollBox: TScrollBox;
    Calcular: TBitBtn;
    BitBtn2: TBitBtn;
    Tabla: TVGrid;
    ResFetch: TEdit;
    Imprimir: TBitBtn;
    PrintDialog: TPrintDialog;
    Habitual: TVGrid;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    PeriodoExtremal: TEdit;
    AlturaExtremal: TEdit;
    LongitudExtremal: TEdit;
    procedure BitBtn2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CalcularClick(Sender: TObject);
    procedure ImprimirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FetchForm: TFetchForm;

implementation

{$R *.DFM}

function pow(x, a: real) : real;

begin
  pow := exp(a * ln(x))
end;

procedure TFetchForm.BitBtn2Click(Sender: TObject);
begin
  Close
end;

procedure TFetchForm.FormCreate(Sender: TObject);

var
  i, Alpha           : Integer;
  Resultado, Suma    : Real;

begin
  Alpha := 42;
  Suma := 0;
  Tabla.Cells[0, 0] := 'Alpha';
  Tabla.Cells[1, 0] := 'L(Km)';
  Tabla.Cells[2, 0] := 'Cos(Alpha)';
  Tabla.Cells[3, 0] := 'L*Cos(Alpha)';
  Tabla.Cells[0, 16] := 'Total';
  For i := 1 to 15 do
    begin
      Tabla.IntToCell(0, i, Alpha);
      Resultado := cos(DegToRad(Alpha));
      Suma := Suma + Resultado;
      Tabla.RealToCell(2, i, Resultado, 2, 3);
      Dec(Alpha,6)
    end;
  Tabla.RealToCell(2, 16, Suma, 4, 3);

  Habitual.Cells[0, 0] := 'U(m/s)';
  Habitual.Cells[1, 0] := 'H(m)';
  Habitual.Cells[2, 0] := 'T(s)';
  Habitual.Cells[3, 0] := 't(h)';

  For i := 1 to 10 do
    Habitual.RealToCell(0, i, 3*i, 1, 1);
end;

procedure TFetchForm.CalcularClick(Sender: TObject);

const
  g     = 9.8;

var
  i, Alpha            : Integer;
  Resultado, Suma,
  Fetch               : Real;
  T, L, H,
  Tp, th, Hmo         : Real;
  SFetch, sT, sL, sH  : String[5];

begin
  Alpha := 42;
  Suma := 0;
  For i := 1 to 15 do
    begin
      Tabla.IntToCell(0, i, Alpha);
      Resultado := Tabla.CellToReal(1,i)*cos(DegToRad(Alpha));
      Suma := Suma + Resultado;
      Tabla.RealToCell(3, i, Resultado, 2, 2);
      Dec(Alpha,6)
    end;
  Tabla.RealToCell(3, 16, Suma, 4, 2);

  Fetch := Suma / Tabla.CellToReal(2, 16);
  Str(Fetch:4:1, SFetch);
  ResFetch.Text := 'Fetch = ' + SFetch + ' Km';

  For i := 1 to 10 do
    begin
      Hmo := 5.112E-4*Habitual.CellToReal(0, i)*pow(Fetch,1/2);
      Habitual.RealToCell(1, i, Hmo, 1, 1);
      Tp := 6.238E-2*pow(Habitual.CellToReal(0, i)*Fetch,1/3);
      Habitual.RealToCell(2, i, Tp, 2, 1);
      th := 32.15*pow(pow(Fetch,2)/Habitual.CellToReal(0, i),1/3)/3600;
      Habitual.RealToCell(3, i, th, 3, 1);
    end;

    T := sqrt(62*pi/g)*pow(Fetch,1/6);
    Str(T:3:1,sT);
    AlturaExtremal.Text := 'Altura = ' + sT + ' m';

    L := 31*pow(Fetch,1/3);
    Str(L:3:1,sL);
    PeriodoExtremal.Text := 'Periodo = ' + sL + ' s';

    H := 1.2*pow(Fetch,1/4);
    Str(H:4:2,sH);
    LongitudExtremal.Text := 'Longitud = ' + sH + ' m';

    Imprimir.Enabled := True
end;

procedure TFetchForm.ImprimirClick(Sender: TObject);
begin
  If Not PrintDialog.Execute Then
    begin
      MessageDlg('Operación Imprimir Cancelada', mtInformation, [mbOK], 0);
      Exit;
    end
  Else
    begin
      PrintPage(ScrollBox, 'Tabla de Cálculo del Fetch',0);
    end
end;

end.
