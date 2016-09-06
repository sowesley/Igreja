unit Utils.Types;

interface

uses Classes, DB, SysUtils, System.Types, Math;

type
  TSituacoesCheque = (FscAReceber, FscAguardandoCompensacao, FscCancelado, FscCompensado, FscDevolvido, FscPassadoTerceiros, FscRenegociado);

  TOrdem = (oAscendente, oDescendente, oNenhuma);

  TChaveTabela = (FctEstrangeira, FctPrimaria);

  TTipoString = AnsiString;
  TTipoChar = AnsiChar;
  TTipoPChar = PAnsiChar;

  TTipoLog = (tlErro, tlConexoes);

  TTipoSQL = (tsInsert, tsUpdate);

  TDataHora = (dhData, dhHora, dhDataHora);

  TTipoAcesso = (taAluno, taProfessor, taResponsavel);

  TNivelLog = (nlBaixo, nlNormal, nlAlto, nlCritico);

  TDiaSemana = (Segunda, Terca, Quarta, Quinta, Sexta, Sabado);

  TOrelha = (oDireita, oEsquerda);

  TOreHelper = record Helper for TOrelha
  public
    function ToString: string;
    class function FromString(AValue: string): TOrelha; static;
  end;

  TEstimulo = (eVA, eVO, eVAM, eVOM);

  TEstHelper = record Helper for TEstimulo
  public
    function ToString: string;
    class function FromString(AValue: string): TEstimulo; static;
  end;

  TFrequencia = (f125, f250, f500, f750, f1K, f1K5, f2K, f3K, f4K, f6K, f8K, f10K, fInvalido);

  TFreqHelper = record Helper for TFrequencia
  public
    function X: Integer;
    function ToInteger: Integer;
    class function FromRange(AXValue: Integer): TFrequencia; static;
    class function FromInteger(AValue: Integer): TFrequencia; static;
  end;

  TIntensidade = (iNeg10, iNeg5, i0, i5, i10, i15, i20, i25, i30, i35, i40, i45, i50, i55, i60, i65, i70, i75, i80,
    i85, i90, i95, i100, i105, i110, i115, i120, iInvalido);

  TIntensiHelper = record Helper for TIntensidade
  public
    function Y: Integer;
    function Value: Integer;
    class function FromRange(AYValue: Integer): TIntensidade; static;
    class function FromInteger(AValue: Integer): TIntensidade; static;
  end;

  TPontoGrafico = record
    Frequencia: TFrequencia;
    Intensidade: TIntensidade;
    Local: TPoint;
  end;

  TTipoReflexo = (trNulo, trLimiar, trAFContra, trDifer, trAFIpsi, trDecay);

  TTipoReflexoHelper = record Helper for TTipoReflexo
  public
    function ToString: string;
  end;

  TTipoDadoImit = (tdmPressaoNegativa, tdmPressaoPositiva, tdmComplascencia);

  TTipoDadoImitHelper = record Helper for TTipoDadoImit
  public
    function ToString: string;
    class function FromString(AValue: string): TTipoDadoImit; static;
  end;

  TDadosExame = class
  private
    FPonto: TPontoGrafico;
    FEstimulo: TEstimulo;
    FOrelha: TOrelha;
    procedure SetEstimulo(const Value: TEstimulo);
    procedure SetOrelha(const Value: TOrelha);
    procedure SetPonto(const Value: TPontoGrafico);
  public
    property Orelha: TOrelha read FOrelha write SetOrelha;
    property Estimulo: TEstimulo read FEstimulo write SetEstimulo;
    property Ponto: TPontoGrafico read FPonto write SetPonto;
  end;

  TPosicoes = array[0..334] of TPontoGrafico;

  TCheques = class
  public
    class function Situacoes(Value: TSituacoesCheque): string; overload;
    class function Situacoes: TStrings; overload;
    class function AReceber: string;
  end;

implementation

{ TCheques }

class function TCheques.Situacoes(Value: TSituacoesCheque): string;
begin
  case Value of
    FscAReceber              : Result := 'A Receber';
    FscAguardandoCompensacao : Result := 'Aguardando Compensação';
    FscCancelado             : Result := 'Cancelado';
    FscCompensado            : Result := 'Compensado';
    FscDevolvido             : Result := 'Devolvido';
    FscPassadoTerceiros      : Result := 'Passado p/ Terceiros';
    FscRenegociado           : Result := 'Renegociado';
  end;
end;

class function TCheques.AReceber: string;
begin
  Result := QuotedStr(TCheques.Situacoes(FscAReceber))+','+QuotedStr(TCheques.Situacoes(FscDevolvido))+','+
    QuotedStr(TCheques.Situacoes(FscAguardandoCompensacao));
end;

class function TCheques.Situacoes: TStrings;
var
  I: TSituacoesCheque;
begin
  Result := TStringList.Create;

  for I := Low(TSituacoesCheque) to High(TSituacoesCheque) do
    Result.Add(Situacoes(I));
end;

{ TDadosExame }

procedure TDadosExame.SetEstimulo(const Value: TEstimulo);
begin
  FEstimulo := Value;
end;

procedure TDadosExame.SetOrelha(const Value: TOrelha);
begin
  FOrelha := Value;
end;

procedure TDadosExame.SetPonto(const Value: TPontoGrafico);
begin
  FPonto := Value;
end;

{ TIntensiHelper }

class function TIntensiHelper.FromInteger(AValue: Integer): TIntensidade;
begin
  case AValue of
    -10: Result := iNeg10;
    -5 : Result := iNeg5;
    0  : Result := i0;
    5  : Result := i5;
    10 : Result := i10;
    15 : Result := i15;
    20 : Result := i20;
    25 : Result := i25;
    30 : Result := i30;
    35 : Result := i35;
    40 : Result := i40;
    45 : Result := i45;
    50 : Result := i50;
    55 : Result := i55;
    60 : Result := i60;
    65 : Result := i65;
    70 : Result := i70;
    75 : Result := i75;
    80 : Result := i80;
    85 : Result := i85;
    90 : Result := i90;
    95 : Result := i95;
    100: Result := i100;
    105: Result := i105;
    110: Result := i110;
    115: Result := i115;
    120: Result := i120;
  else
    Result := iInvalido;
  end;
end;

class function TIntensiHelper.FromRange(AYValue: Integer): TIntensidade;
begin
  if InRange(AYValue, 5, 17) then
    Result := iNeg10
  else
  if InRange(AYValue, 18, 29) then
    Result := iNeg5
  else
  if InRange(AYValue, 30, 42) then
    Result := i0
  else
  if InRange(AYValue, 43, 55) then
    Result := i5
  else
  if InRange(AYValue, 56, 69) then
    Result := i10
  else
  if InRange(AYValue, 70, 82) then
    Result := i15
  else
  if InRange(AYValue, 83, 96) then
    Result := i20
  else
  if InRange(AYValue, 97, 109) then
    Result := i25
  else
  if InRange(AYValue, 110, 123) then
    Result := i30
  else
  if InRange(AYValue, 124, 136) then
    Result := i35
  else
  if InRange(AYValue, 137, 150) then
    Result := i40
  else
  if InRange(AYValue, 151, 163) then
    Result := i45
  else
  if InRange(AYValue, 164, 177) then
    Result := i50
  else
  if InRange(AYValue, 178, 190) then
    Result := i55
  else
  if InRange(AYValue, 191, 203) then
    Result := i60
  else
  if InRange(AYValue, 204, 216) then
    Result := i65
  else
  if InRange(AYValue, 217, 230) then
    Result := i70
  else
  if InRange(AYValue, 231, 243) then
    Result := i75
  else
  if InRange(AYValue, 244, 257) then
    Result := i80
  else
  if InRange(AYValue, 258, 270) then
    Result := i85
  else
  if InRange(AYValue, 271, 284) then
    Result := i90
  else
  if InRange(AYValue, 285, 297) then
    Result := i95
  else
  if InRange(AYValue, 298, 312) then
    Result := i100
  else
  if InRange(AYValue, 313, 325) then
    Result := i105
  else
  if InRange(AYValue, 326, 338) then
    Result := i110
  else
  if InRange(AYValue, 339, 351) then
    Result := i115
  else
  if InRange(AYValue, 351, 366) then
    Result := i120
  else
    Result := iInvalido;
end;

function TIntensiHelper.Value: Integer;
begin
  case Self of
    iNeg10: Result := -10;
    iNeg5 : Result := -5;
    i0    : Result := 0;
    i5    : Result := 5;
    i10   : Result := 10;
    i15   : Result := 15;
    i20   : Result := 20;
    i25   : Result := 25;
    i30   : Result := 30;
    i35   : Result := 35;
    i40   : Result := 40;
    i45   : Result := 45;
    i50   : Result := 50;
    i55   : Result := 55;
    i60   : Result := 60;
    i65   : Result := 65;
    i70   : Result := 70;
    i75   : Result := 75;
    i80   : Result := 80;
    i85   : Result := 85;
    i90   : Result := 90;
    i95   : Result := 95;
    i100  : Result := 100;
    i105  : Result := 105;
    i110  : Result := 110;
    i115  : Result := 115;
    i120  : Result := 120;
  else
    Result := -1;
  end;
end;

function TIntensiHelper.Y: Integer;
begin
  case Self of
    iNeg10: Result := 10;
    iNeg5 : Result := 23;
    i0    : Result := 32;
    i5    : Result := 47;
    i10   : Result := 59;
    i15   : Result := 72;
    i20   : Result := 84;
    i25   : Result := 98;
    i30   : Result := 110;
    i35   : Result := 124;
    i40   : Result := 136;
    i45   : Result := 148;
    i50   : Result := 161;
    i55   : Result := 174;
    i60   : Result := 188;
    i65   : Result := 199;
    i70   : Result := 212;
    i75   : Result := 224;
    i80   : Result := 236;
    i85   : Result := 250;
    i90   : Result := 263;
    i95   : Result := 275;
    i100  : Result := 288;
    i105  : Result := 301;
    i110  : Result := 314;
    i115  : Result := 327;
    i120  : Result := 340;
  end;
end;

{ TFreqHelper }

class function TFreqHelper.FromInteger(AValue: Integer): TFrequencia;
begin
  case AValue of
    125  : Result := f125;
    250  : Result := f250;
    500  : Result := f500;
    750  : Result := f750;
    1000 : Result := f1K;
    1500 : Result := f1K5;
    2000 : Result := f2K;
    3000 : Result := f3K;
    4000 : Result := f4K;
    6000 : Result := f6K;
    8000 : Result := f8K;
    10000: Result := f10K;
  end;
end;

class function TFreqHelper.FromRange(AXValue: Integer): TFrequencia;
begin
  if InRange(AXValue, 75, 87) then
    Result := f125
  else
  if InRange(AXValue, 88, 143) then
    Result := f250
  else
  if InRange(AXValue, 144, 198) then
    Result := f500
  else
  if InRange(AXValue, 199, 231) then
    Result := f750
  else
  if InRange(AXValue, 232, 254) then
    Result := f1K
  else
  if InRange(AXValue, 255, 286) then
    Result := f1K5
  else
  if InRange(AXValue, 287, 309) then
    Result := f2K
  else
  if InRange(AXValue, 310, 342) then
    Result := f3K
  else
  if InRange(AXValue, 343, 365) then
    Result := f4K
  else
  if InRange(AXValue, 366, 397) then
    Result := f6K
  else
  if InRange(AXValue, 398, 420) then
    Result := f8K
  else
  if InRange(AXValue, 421, 438) then
    Result := f10K
  else
    Result := fInvalido;
end;

function TFreqHelper.ToInteger: Integer;
begin
  case Self of
    f125     : Result := 125;
    f250     : Result := 250;
    f500     : Result := 500;
    f750     : Result := 750;
    f1K      : Result := 1000;
    f1K5     : Result := 1500;
    f2K      : Result := 2000;
    f3K      : Result := 3000;
    f4K      : Result := 4000;
    f6K      : Result := 6000;
    f8K      : Result := 8000;
    f10K     : Result := 10000;
    fInvalido: Result := -1;
  end;
end;

function TFreqHelper.X: Integer;
begin
  case Self of
    f125: Result := 83;
    f250: Result := 139;
    f500: Result := 194;
    f750: Result := 227;
    f1K : Result := 251;
    f1K5: Result := 283;
    f2K : Result := 306;
    f3K : Result := 340;
    f4K : Result := 363;
    f6K : Result := 396;
    f8K : Result := 418;
    f10K: Result := 437;
  end;
end;

{ TEstHelper }

class function TEstHelper.FromString(AValue: string): TEstimulo;
begin
  if AValue.ToUpper = 'VA' then
    Result := eVA
  else
  if AValue.ToUpper = 'VO' then
    Result := eVO
  else
  if AValue.ToUpper = 'VAM' then
    Result := eVAM
  else
  if AValue.ToUpper = 'VOM' then
    Result := eVOM;
end;

function TEstHelper.ToString: string;
begin
  case Self of
    eVA : Result := 'VA';
    eVO : Result := 'VO';
    eVAM: Result := 'VAM';
    eVOM: Result := 'VOM';
  end;
end;

{ TOreHelper }

class function TOreHelper.FromString(AValue: string): TOrelha;
begin
  if AValue = 'D' then
    Result := oDireita
  else
    Result := oEsquerda;
end;

function TOreHelper.ToString: string;
begin
  case Self of
    oDireita : Result := 'D';
    oEsquerda: Result := 'E';
  end;
end;

{ TTipoDadoImitHelper }

class function TTipoDadoImitHelper.FromString(AValue: string): TTipoDadoImit;
begin
  if AValue.ToUpper = 'PNG' then
    Result := tdmPressaoNegativa
  else
  if AValue.ToUpper = 'PPO' then
    Result := tdmPressaoPositiva
  else
    Result := tdmComplascencia;
end;

function TTipoDadoImitHelper.ToString: string;
begin
  case Self of
    tdmPressaoNegativa: Result := 'PNG';
    tdmPressaoPositiva: Result := 'PPO';
    tdmComplascencia  : Result := 'CMP';
  end;
end;

{ TTipoReflexoHelper }

function TTipoReflexoHelper.ToString: string;
begin
  case Self of
    trNulo    : Result := '';
    trLimiar  : Result := 'Limiar';
    trAFContra: Result := 'Contra';
    trDifer   : Result := 'Difer';
    trAFIpsi  : Result := 'Ipsi';
    trDecay   : Result := 'Decay';
  end;
end;

end.
