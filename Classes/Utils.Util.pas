unit Utils.Util;

interface

uses
  {$IFDEF WEB}
  IWBaseForm, IWAppForm, IWApplication, IWTypes,
  {$ENDIF}
  Windows, Forms, Graphics, SysUtils, Variants, Classes, System.Character, System.IOUtils, System.Types,
  Controls, Dialogs, DB, Winsock, Registry, Printers, Messages, IniFiles, JclDebug,
  Urlmon, jpeg, StdCtrls, ComCtrls, JvToolEdit, DBClient, DBGrids, Json,
  JvDBControls, IdTCPConnection, IdTCPClient,
  IdSMTP, IdBaseComponent, IdMessage,
  Shellapi, Wininet, JvComponentBase, JvZlibMultiple,
  JvExDBGrids, JvDBGrid, StrUtils, {$IFDEF Windows} FileCtrl, {$ENDIF}
  Utils.md5, ShlObj, ActiveX, ComObj, Provider, SqlExpr,
  Generics.Collections, DBXJSON, DBXJSONReflect, IWDBGrids,
  {$IF CompilerVersion > 21} IWSystem {$ELSE} SwSystem {$IFEND},JvDBCombobox,
  tlhelp32, IdHashMessageDigest, Utils.Types, Vcl.CheckLst, DBAdvGrid;

//-----Procedures e Funções-----------------------------------------------------
type
  TArg<T> = reference to procedure(const Arg: T);
  TNumeroStr = string;
  TMesStr = string;
  TTipoConexaoInternet = (FtciNaoConectado,FtciModem,FtciLAN,FtciProxy,FtciModemOcupado);
  TTipoInfWindows = (FVersao, FCompilacao, FOsName, FInfAdicionais);
  TChars = set of WideChar;
  TFormatoImagem = (FiJpeg, FiBmp, FiDesconhecido);
  TDadosPopular = (FdpAno, FdpMes);
  TCamposData = (FDia,FMes,FAno);
  TArrayString = array of string;
  TPastaSistema = (psDesktop, psIniciar, psProgramasIniciar);

  TEstadosBrasileiros = (ebAcre, ebAlagoas, ebAmazonas, ebAmapa, ebBahia, ebCeara,
    ebDistritoFederal, ebEspiritoSanto, ebGoias, ebMaranhao, ebMinasGerais,
    ebMatoGrosso, ebMatoGrossoSul, ebPara, ebParaiba, ebParana, ebPiaui,
    ebPernambuco, ebRioJaneiro, ebRioGrandeNorte, ebRioGrandeSul, ebRondonia,
    ebRoraima, ebSantaCatarina, ebSergipe, ebSaoPaulo, ebTocantins, ebExterior);

  TItemCheckList = class
  private
    fCodigo: string;
    fDescricao: string;
  public
    property Codigo: string read fCodigo write fCodigo;
    property Descricao: string read fDescricao write fDescricao;
  end;

  TLayoutCidade = (lcNomeUF, lcUFNome);

  TUteis = class
  public
    //Conversões
    class function MSecToTime(AMSec: Int64): TDateTime;
    class function DiasToHoras(AFormato: string; ADias, AMinutos: Double): string;
    class function SafeFloat(AValue: string): Double;

    //DataSet
    class function FieldExist(DataSet: TDataSet; FieldName: string): Boolean;
    class procedure Select(pDataSet: TClientDataSet; pSQL: string);
    class procedure SaveDataToFile(pData: OleVariant; pPath: string);
    class procedure SaveDataToStream(pData: OleVariant; var pStream: TMemoryStream);
    class function LoadDataFromFile(pPath: string): OleVariant;
    class function LoadDataFromStream(pStream: TMemoryStream): OleVariant;

    //Banco Dados
    class function GetFirebirdBinPach: string;

    //JSON
    class function JSONToObj<T: class>(pJSON: TJSONValue): T; overload;
    class function JSONToObj<T: class>(pUnMarshal: TJSONUnMarshal;
      pJSON: TJSONValue): T; overload;
    class function ObjToJSON<T : class>(pObj: T): TJSONValue; overload;
    class function ObjToJSON<T : class>(pMarshal: TJSONMarshal;
      pObj: T): TJSONValue; overload;
    class function GetJSONValue(pJSONObj: TJSONObject;
      pFieldName: string): TJSONValue;

    //Geradores de Informação
    class function GeraCaracteres(pDigitos: Integer): string; overload;
    class function GeraCaracteres(pDigitos: Integer;
      pCaracteres: string): string; overload;
    class function GeraChave(pItem, pValor1, pValor2: Integer): string;
    class function GeraCodigoBarras(const pMunicipio, pCodLib: string): string;
    class function ValidarDigitoVerificador(const pChaveAcesso: string): Boolean;

    //Outros
    class procedure FreeAndNil(var Obj);
    class procedure AddLIstInOther(ListSource, ListDestino: TStrings);
    class procedure VersaoApp(var pMajor, pMinor, pRelease, pBuild: Integer);

    class function ValidaEmail(const AMailIn: string):Boolean;
    class function Between(AValor, AValorInicial, AValorFinal: Double): Boolean;
    class function CorInvertida(Color: TColor): TColor;

    //Datas
    class function PrimeiroDiaMes(aData: TDateTime): TDateTime;
    class function UltimoDiaMes(aData: TDateTime): TDateTime; overload;
    class function UltimoDiaMes(AMes, AAno: Integer): Integer; overload;
    class function TempoEntre(pDias: Integer): string;
    class function Mes(AMes: Integer; AShort: Boolean = False): string;
    class function ValidarHora(Ahora:string):Boolean;

    class function DataSQL(AData: TDateTime; AHora: Boolean = True): string; overload;
    class function DataSQL(AData: string; AHora: Boolean = True): string; overload;

    //Arquivos e Diretórios
    class function ListarArquivos(pDiretorio, pMascara: string): TStrings;
    class function ListarAtahos(pDiretorio, pMascara: string): Tstrings;
    class function ListarDiretorios(pDiretorio: string): TStrings;
    class function CaminhoAplicacao: string;
    class function CaminhoTempDir: string;
    class function NomeExecutavel: string;
    class function ListarAplicativos: TStrings;
    class function ExisteAplicativo(AApp: string): Boolean;
    class function ListaUnidades: TStrings;
    class function ExisteUnidade(ALetra: string): Boolean;

    //Formatações
    class procedure FormataGrid(pComponent: TIWDBGrid); overload;
    class procedure FormataGrid(var AJvDBGrid: TJvDBGrid); overload;
    class function FormataTelefone(pTelefone: string): string;
    class function DataTracoToDataBarra(pData: string): string;

    //Strings
    class function PMaiuscula(Value: string): string; overload;
    class function PMaiuscula(AValue: string; AExcludeList: TStrings): string; overload;
    class function DuasDatasToStr(pDataIni, pDataFin: TDate; ASimples: Boolean = False): string;
    class function CollateBr(pStr: string; AUpper: Boolean = True): string;
    class function CollateBrCaracter(AStr: string; AUpper: Boolean = True): string;
    class function LowerCase(pValue: string): string;
    class function LowCase(pVAlue: Char): Char;
    class function UpperCase(pVAlue: string): string;
    class function UpCase(pVAlue: Char): Char;
    class function UpperNome(const Nome: String): String;
    class function BoolToChar(Value: Boolean): Char;
    class function FNV1aHash(const s: AnsiString): LongWord;
    class function SomenteLetras(aStr: string): string;
    class function SomenteLetrasComAcentos(aStr: string):string;
    class function SomenteNumeros(aStr: string): string;
    class function SomenteLetrasNumeros(AValue: string): string;
    class function SeparaPalavras(pTexto: string): TStringList; overload;
    class function SeparaPalavras(ATexto, ASeparador: string): TStringList; overload;
    class function SepararPalavras(const AValue: string): string;
    class function ContemLetra(const AValor: string): Boolean;
    class function PrimeiraPalavra(const AValor: string): string;
    class function ObjetoString(const AField, AValue: string): string; overload;
    class function ObjetoString(const AField: string; const AValue: Integer): string; overload;
    class function ArrayString(const AValues: array of string): string;
    class function ListaMeses(AQtde: Integer; AShort: Boolean; AAno: string = ''): TStrings;
    class function GetPrimeiraLetra(AValue: string; AComEspeciais: Boolean = False): string;
    class function ToRomanos(const AValue: string): string;
    class function AddEspacoDireita(const AValue: string; const AQtde: Integer): string;
    class procedure SaveToFile(const ASQL: string; AFilename: string);
    class procedure DebugSQL(const ASQL: string; AFilename: string = '');
    class function MethodName(const AMethod: string): string;

    class function StrToEstado(ANome: string): TEstadosBrasileiros;
    class function EstadoToStr(aEstado: TEstadosBrasileiros): string;
    class function EstadoToUF(aEstado: TEstadosBrasileiros): string;

    //Segurança
    class function EncriptaMD5(const pValor: string): string;
    class function MD5File(const AFilePath: string): string;

    //Cálculos
    class function DescontoRateado(ValorTotal, Valor, ValorDescontado: Real): Real;
    class function Porcentagem(const ATotal, AParte: Double): Double;

    //Hardware
    class function GetHDNumber: string;
    class function SetDataSystem(pDataHora: TDateTime): Boolean;
    class function FindProcess(ProcessName: string): DWORD;

    //Sistema Operacional
    class function CaminhoPastaWindows(pTipoPasta: TPastaSistema): string;
    class function CriaAtalho(pArquivo, pParametros, pNomeAtalho,
      pPastaDestino: string): Boolean;

    //Sistema
    class procedure CaptureConsoleOutput(const ACommand, AParameters: string;
      ACallBack: TArg<PAnsiChar>);
    class function GetDosOutput(const CommandLine:string): string;

    //Validações
    class function IsNumber(pValue: string): Boolean;
    class function ValidaCNS_PROV(pNumero: string): Boolean;
    class function ValidarNIS(pNIS: string): Boolean;
    class function ValidaCNS(ACNS: string; var AErro: string): Boolean;
    class function PISValido(pPIS: string): Boolean;
  end;

var
  Romans: array[1..7] of char = ('I','V','X','L','C','D','M');

const
  _Semana : Array[1..7] of String = ('Domingo', 'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira', 'Sexta-feira', 'Sábado');
  _SemanaShort : Array[1..7] of String = ('DOM', 'SEG', 'TER', 'QUA', 'QUI', 'SEX', 'SAB');
  _Unidades: array[1..19] of TNumeroStr = ('Um', 'Dois', 'Três', 'Quatro','Cinco', 'Seis', 'Sete', 'Oito', 'Nove', 'Dez', 'Onze', 'Doze',
    'Treze', 'Quatorze', 'Quinze', 'Dezesseis', 'Dezessete', 'Dezoito', 'Dezenove');
  _Dezenas: array[1..9] of TNumeroStr = ('Dez', 'Vinte', 'Trinta', 'Quarenta','Cinqüenta', 'Sessenta', 'Setenta', 'Oitenta', 'Noventa');
  _Centenas: array[1..9] of TNumeroStr = ('Cem', 'Duzentos', 'Trezentos','Quatrocentos', 'Quinhentos', 'Seiscentos', 'Setecentos', 'Oitocentos', 'Novecentos');
  _MesString: ARRAY [1..12] OF TMesStr = ('Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');
  _ScreenWidth: LongInt = 1024;
  _ScreenHeight: LongInt = 768;
  _ErrorString = 'Valor fora da faixa';
  _Min = 0.01;
  _Max = 4294967295.99;
  _Moeda = ' Real ';
  _Moedas = ' Reais ';
  _Centesimo = ' Centavo ';
  _Centesimos = ' Centavos ';
  _Minuto = 0.00069444444445;
  _Hora = 0.041666666667;

function NumeroParaExtenso(pNumero:Real): string;

function ConversaoRecursiva(pN:LongWord): string;

function DataExtenso(AData: TDateTime; ADiaSemana: Boolean; APMaiuscula: Boolean = False): String;
function DataDiaExtenso(pData:TDateTime;pDiaSemana:Boolean): String;

function SubData(pData : TDateTime): Real;

procedure InfoSis(GB_INFO,LB_INFO:String);

function StrFloat(pValor: string): Real;

function ConverterData(pData:String): String;

function DataSemBarras(pData:String): String;

function HoraSemPontos(pHora:String) : String;

function ZeroEsq(AValor: String; AQtde: Integer; AVirgula: Boolean = False; ACortar: Boolean = False): String;

function ZeroDir(pValor:String;pQtde:Integer): String;

function EspEsq(pValor:String;pQtde:Integer): String;

function EspDir(pValor:String;pQtde:Integer): String;

function DiskInDrive(Const _Drive:Char): Boolean;

function DiaVen(pData:TDate;pDiaVen,pDiaInt:Integer): String;

function Nulo(pValor:Variant): Integer;

function Encripta(const pValor: string): string;

function Decripta(const pValor: string): string;

function FatorVencimento(pFator,pVencimento: TDateTime): Real;

function RetornoTXT(pValor: String; pQtde: INTEGER): String;

function GetComputer: String;

function GetIP: String;

function SysComputerName: string;

function GeraCaracter(Const _v: variant): string;

function Bissexto(pAno: Integer): Boolean;

function DiadaSemana(pData: String; AShort: Boolean = False): String; overload;

function DiadaSemana(ADia: Integer; AShort: Boolean = False): String; overload;

procedure Compactar(pOrigem, pDestino: string);

function DecimalECF(pValor: Real): String;

function DescontoRateado(pValorTotal, pValor, pValorDescontado: Real): Real;

function RetirarMasc(pValor: string): string;

function VirgulaToPonto(pValor: String): String;

function ScsToKG(pSacas,pQuilos: Real): Real;

function KGToScs(pQtde: Real; pTipo: Integer): Real;

function IntToBin(pValue: LongInt; pSize: Integer): String;

function HexToInt(const _HexStr: string): longint;

function LimitarStr(pValor:String; pQtde:Integer): String;

function Maiuscula(pTexto: String): String;

function SystemDateTime(pDate:TDateTime; pTime:TDateTime): Boolean;

function ExtractSystemDir: String;

procedure SetDefaultPrinter(pPrinterName: String);

function GetDefaultPrinterName: string;

function GetIndexPrinter(pNome: String): Integer;

function UltimoDiaMes(pData: TDate): Integer;

function SQLData(pDate : TDateTime; pComQuoted: Boolean = True; pComHoras: Boolean = True): String;

function SQLDataStr(pData: string; pComQuoted: Boolean = True): string;

procedure GravaIni(pParam, pValor: array of string; pArquivo, pNome: String; pCriptografado: Boolean);

procedure LeIni(Var Param, Valor: array of string; pArquivo, pNome: String; pCriptografado: Boolean; pParams: Integer);

Procedure LeIni2(Var Versao: Longint; var Arquivo, NomeZip, Extrair: String; pTipo, pCaminho, pNome: String; Var Compactado: Boolean);

Procedure GravaIni2(pVersao: Longint; pArquivo, pNomeZip, pExtrair, pTipo, pCaminho, pNome:String; pCompactado: Boolean);

function DownloadFile(pOrigem, pDestino: string): Boolean;

procedure EncryptDecryptFile(pArqEntrada, pArqSaida: String; pChave: Word);

procedure ExtrairArquivos(pOrigem, pExtensao, pDiretorio: string);

procedure ApagarArquivos(pDiretorio, pCuringa: String);

function CopyEntyreString(pFrase,pInicio,pFim:String): String;

function ArredondarValor(pValor:Double): Double;

function CaptureScreenRect(pARect: TRect): TBitmap;

function JpgToBmp(pImage: String): Boolean;

function BmpToJpg(pImage: String): Boolean;

procedure SalvaImagensTela(pArquivo: String);

function RGDecimal(pValor: String; pParte: Integer): Integer;

function RGDecimal2(pValor: String; pParte: Integer): Integer;

function ExtractName(const _Filename: String): String;

procedure Resolucao(pForm: TForm);

function CentraTexto(pValor: String; pLarguraTexto: Integer): Ansistring;

function InverterStr (pString: ShortString): ShortString;

procedure SetJPGCompression(pCompression: integer; const _AInFile: string; const _AOutFile: string; pAltura, pLargura: Integer; pTipo, pTipoS: String);

procedure Idade(ANascimento: TDate; var ADias, AMeses, AAnos: Integer); overload;

function Idade(pNascimento: TDate; pComDia, pComMes: Boolean): string; overload;

function Idade(pNascimento, pDataRef: TDate): Real; overload;

function Idade(pNascimento: TDate): Real; overload;

function IdadeMeses(pNascimento, pDataRef: TDate): Integer; overload;

function IdadeMeses(pNascimento: TDate): Integer; overload;

procedure MyShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);

function EliminaCaracteres(pTexto: String; pCaracter: String):String;

function CasasDec(pValor: Real; pCasas: Integer): string;

function CasasDecimais(pValor:Real; pCasas:Integer): Real;

function PreencheEspDir(pValor, pPreencher:String; pQtde:Integer): String;

function NumToExtenso(pNumero: Real): String;

procedure LogErros(pTela,pLog: String);

function MenorDataValida(pAno,pMes,pDia: Word): TDateTime;

function CodigoIniFin(pComponenteIni,pComponenteFin: TJvComboEdit; Var ValorIni, ValorFin: String): Boolean;

function DataIniFin(pComponenteIni,pComponenteFin: TJvCustomDateEdit; Var ValorIni, ValorFin: String): Boolean;

function JvDataIniFin(pComponenteIni,pComponenteFin: TJvCustomDateEdit; Var ValorIni, ValorFin: String): Boolean;

function SetDataSystem(pData,pHora: TDateTime): Boolean;

procedure OrdenaGrid(var ACDS: TClientDataSet; AGrid: TObject; AColumn: TColumn) overload;

procedure OrdenaGrid(var ACDS: TClientDataSet; AGrid: TDBAdvGrid; AColumn: TDBGridColumnItem; AColumnHeaderColor : TColor = clHighlight ; AColumnHeaderColorTo: TColor = clSkyBlue) overload;

function ValidaHora(pHorario:String; pTipo:String): Boolean;

procedure SetMes(pComponenteDataIni,pComponenteDataFin: TjvCustomDateEdit);

function VerificaCST(pCodCST: string): Boolean;

function VerificaCFOP(pCFOP: SmallInt): Boolean;

function VerificaUF(pUF: string): Boolean;

function VerificaCEP(pCep: string; pEstado: string): Boolean;

function VerificaInscEstadual(pInscricao, pTipo: string): Boolean;

function VerificaCPF_CNPJ(ANumero: string): Boolean;

function ReplaceStr(pText,pOldString,pNewString:string): string;

function GetBuildInfo(PBuild: Boolean = True):string;

function RemoveCaracter(pValor,pCaracter: string): string;

function RemoveAcentos(pStr:String): String;

function UpperCaseComAcentos(pStr:String): String;

function DataSemBarrasFor(pData,pFormato: String): String;

function TColorToHex(pColor : TColor) : string;

function HexToTColor(pColor : string) : TColor;

function ArredondarDEC(pValor: Double; pDec: Integer): Double;

function EnviaEmail(pSMTPServer, pUsuario, pSenha, pNomeOri, pEmailResp, pNomeDest,
                    pEmailDest, pAssunto, pTexto, pAnexo: string): Boolean;

function DeleteFolder(pFolderName: String; pLeaveFolder: Boolean): Boolean;

function ConectadoInternet: TTipoConexaoInternet;

function VersaoWindows(pTipo: TTipoInfWindows): string;

function HMStoSecs(pTempo:String):Integer;

function HoraToMin(pHora: String): Integer;

function FilterChars(const _Str: string; const _ValidChars: TChars): string;

function FloatToSQL(pValue: Real): string;

function MontarFiltroData(pDataInicial,pDataFinal: TDate; pCondicao: string;
  pIncluirHora: Boolean = True): string;

function MontarFiltroInteiro(aCodIni,aCodFin: Integer; aCondicao: string): string;

function ConvertImagemField(var Field: TBlobField): TMemoryStream;

function JpegToBmp(pFileName: TFileName): TFileName;

function CarregaForm(const _Pacote: String; const _Classe: String): TFormClass;

function Substituir(pTexto, pEncontrar, pSubstituir: string;
                    pTirarAcentos: Boolean = False): string;

function GeraGUID: string;

function GetValueFromProperty(pProperty: TStrings; pItem: string): string;

function ApenasNumeros(pValue: string): string;

function CharToHex(pChar: Char): string;

function StrToHex(pText: string): string;

function GetDesktopFolder: string;

procedure CriarAtalho(pFileName, pParameters, pInitialDir, pShortcutName,
                      pShortcutFolder : string);

function QtdeToMascara(pQtde: Integer): string;

procedure PopularCompoBox(pComponent: TCustomComboBox; pPopularCom:TDadosPopular; pTamanhoIntervaloAno: Integer = 20);

function VersaoSistema: string;

procedure CreateDataSet(pDataSet: TClientDataSet);

function KeyIsDown(const _Key: Integer): Boolean;

function VarToIntDef(const _Var: Variant; pDefault: Integer): Integer;

function VarToInt(const _Var: Variant): Integer;

function VarToRealDef(const _Var: Variant; pDefault: Real): Real;

function VarToReal(const _Var: Variant): Real;

function LengthArrayVar(pArray: Variant): Integer;

function ChecaHora(pHora: string): Boolean;

function RetornaSoNumero(pNumero: string): string;

function SetValueText(pText, pValue, pAntesDe: string): string;

function GetCampoDate(pData: TDate; pCampo: TCamposData): Word;

function GetDescMes(pMes: Word): string;

function NomeFile(pPath: string): string;

function TempPath: string;

function TempPathDelOnExit: string;

procedure DeletaDir(const _RootDir:string);

procedure OrdenaDataSet(var CDS: TClientDataSet; pField: TField;
                        pOrdem: TOrdem = oNenhuma); overload;

procedure OrdenaDataSet(var aCDS: TClientDataSet; pFields: Variant;
                        pOrdem: TOrdem = oNenhuma); overload;

function FieldExiste(pDataSet: TDataSet; pFieldName: string): Boolean;

procedure RemoveIndex(pCDS: TClientDataSet);

function ValueForSQL(pValue: Variant): string;

function ExecAndWait(const _FileName, _Params: string; const _WindowState: Word): Boolean;

function DateTimeToDate(pValue: TDateTime): TDate;

function LastPos(const pValue, pStr: string): Integer;

function SQLNoWhere(const pSQL: string): string;

function InsertWhereSQL(pSQL, pSQLInserir: string;
                        pTrazerOrderOuGroup: Boolean = True): string;

function Explode(pStr, pSeparador: string): TStringList;

function ExplodeToArray(pStr, pSeparador: string): TArrayString;

procedure ChaveQuery(pDataset: TDataSet; pChave: string);

function GetSQLDataSet(pOwner: TComponent; pProviderName: string): string;

function ValidarDataSet(CDS: TClientDataSet): Boolean;

function GetCamposDataset(CDS: TClientDataSet): string;

function TempoToTempoFormatado(Tempo: TDateTime):string;

function TempoToStr(Tempo: TDateTime):string;

function MontarFiltroBetween(pValorInicial,pValorFinal: string; pCondicao: string): string;

var TipoArquivoUpdate: String;

procedure MarcarTodos(aCheckList: TCheckListBox);

procedure DesmarcarTodos(aCheckList: TCheckListBox);

procedure InverterSelecao(aCheckList: TCheckListBox);

function ItensSelecionados(aCheckList: TCheckListBox): string;

function EntreDatas(DataInicial, DataFinal: TDateTime): string; //LAC

//-----Fim das Procedures e Funções---------------------------------------------

implementation

uses DateUtils, Utils.Message;

function DataExtenso(AData: TDateTime; ADiaSemana, APMaiuscula: Boolean): string;
{Retorna uma data por extenso}
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of string;
  Meses : array [1..12] of string;
  Dia, Mes, Ano : Word;
begin
  //Dias da Semana
  DiaDasemana [1] := 'domingo';
  DiaDasemana [2] := 'segunda-feira';
  DiaDasemana [3] := 'terça-feira';
  DiaDasemana [4] := 'quarta-feira';
  DiaDasemana [5] := 'quinta-feira';
  DiaDasemana [6] := 'sexta-feira';
  DiaDasemana [7] := 'sábado';

  //Meses do ano
  Meses [1]  := 'janeiro';
  Meses [2]  := 'fevereiro';
  Meses [3]  := 'março';
  Meses [4]  := 'abril';
  Meses [5]  := 'maio';
  Meses [6]  := 'junho';
  Meses [7]  := 'julho';
  Meses [8]  := 'agosto';
  Meses [9]  := 'setembro';
  Meses [10] := 'outubro';
  Meses [11] := 'novembro';
  Meses [12] := 'dezembro';

  DecodeDate (AData, Ano, Mes, Dia);

  if ADiaSemana then
  begin
    NoDia := DayOfWeek(AData);

    Result := IfThen(APMaiuscula, TUteis.PMaiuscula(DiaDaSemana[NoDia]), DiaDaSemana[NoDia]) + ', ' +
      FormatFloat('00', Dia) + ' de ' + IfThen(APMaiuscula, TUteis.PMaiuscula(Meses[Mes]), Meses[Mes]) + ' de ' + IntToStr(Ano);
  end
  else
    Result := FormatFloat('00', Dia) + ' de ' + IfThen(APMaiuscula, TUteis.PMaiuscula(Meses[Mes]), Meses[Mes]) + ' de ' + IntToStr(Ano);
end;

function DataDiaExtenso(pData:TDateTime; pDiaSemana:Boolean): string;
{Retorna uma data por extenso}
var
  NoDia : Integer;
  DiaDaSemana : array [1..7] of string;
  Meses : array [1..12] of string;
  Dia, Mes, Ano : Word;
begin
  //Dias da Semana
  DiaDasemana [1]:= 'Domingo';
  DiaDasemana [2]:= 'Segunda-Feira';
  DiaDasemana [3]:= 'Terça-Feira';
  DiaDasemana [4]:= 'Quarta-Feira';
  DiaDasemana [5]:= 'Quinta-Feira';
  DiaDasemana [6]:= 'Sexta-Feira';
  DiaDasemana [7]:= 'Sábado';
  //Meses do ano
  Meses [1] := 'Janeiro';
  Meses [2] := 'Fevereiro';
  Meses [3] := 'Março';
  Meses [4] := 'Abril';
  Meses [5] := 'Maio';
  Meses [6] := 'Junho';
  Meses [7] := 'Julho';
  Meses [8] := 'Agosto';
  Meses [9] := 'Setembro';
  Meses [10]:= 'Outubro';
  Meses [11]:= 'Novembro';
  Meses [12]:= 'Dezembro';
  DecodeDate (pData, Ano, Mes, Dia);
  if pDiaSemana then
  begin
    NoDia := DayOfWeek (pData);
    Result := DiaDaSemana[NoDia] + ', ' + NumeroParaExtenso(Dia) + ' de ' + Meses[Mes]+ ' de ' + NumeroParaExtenso(Ano);
  end
  else
    Result := NumeroParaExtenso(Dia) + ' de ' + Meses[Mes]+ ' de ' + NumeroParaExtenso(Ano);
end;

function SubData(pData : TDateTime): Real;
begin
  Result := Date-pData;
end;

procedure InfoSis(GB_INFO,LB_INFO:String);
//GB_INFO - Máximo de 1 Linha de 65 Caracteres cada
//LB_INFO - Máximo de 16 Linhas de 75 caracteres cada
begin
//Application.CreateForm(TFGER_INFSIS,FGER_INFSIS);
//FGER_INFSIS.GB_INFO.Caption := GB_INFO;
//FGER_INFSIS.LB_INFO.Caption := LB_INFO;
//FGER_INFSIS.ShowModal;
end;

function NumeroParaExtenso(pNumero:Real): string;
begin
  if pNumero <= 0 then
  begin
    Result := 'Valor Menor ou Igual a "0"';
    Exit;
  end;

  if (pNumero >= _Min) and (pNumero <= _Max) then
  begin
    {Tratar reais}
    Result := ConversaoRecursiva(Round(Int(pNumero)));
    if Round(Int(pNumero)) = 1 then
      Result := Result + _Moeda
    else
    if Round(Int(pNumero)) <> 0 then
      Result := Result + _Moedas;

    {Tratar centavos}
    if Not(Frac(pNumero) = 0.00) then
    begin
      if Round(Int(pNumero)) <> 0 then
        Result := Result + ' e ';

      Result := Result + ConversaoRecursiva(Round(Frac(pNumero) * 100));

      if (Round(Frac(pNumero) * 100) = 1) then
        Result := Result + _Centesimo
      else
        Result := Result + _Centesimos;
    end;
  end
  else
    Raise ERangeError.CreateFmt('%g ' + _ErrorString + ' %g..%g',[pNumero, _Min, _Max]);
end;

function ConversaoRecursiva(pN: LongWord): string;
begin
  case pN of
    1..19: begin
             Result := _Unidades[pN];
           end;
    20, 30, 40, 50, 60, 70, 80, 90: begin
                                      Result := _Dezenas[pN div 10] + ' ';
                                    end;
    21..29, 31..39, 41..49, 51..59, 61..69, 71..79, 81..89, 91..99: begin
                                                                      Result := _Dezenas[pN div 10] +
                                                                                ' e '+
                                                                                ConversaoRecursiva(pN mod 10);
                                                                    end;
    100, 200, 300, 400, 500, 600, 700, 800, 900: begin
                                                   Result := _Centenas[pN div 100] + ' ';
                                                 end;
    101..199: begin
                Result := ' Cento e ' + ConversaoRecursiva(pN mod 100);
              end;
    201..299, 301..399, 401..499, 501..599, 601..699, 701..799, 801..899, 901..999: begin
                                                                                      Result := _Centenas[pN div 100] +
                                                                                                ' e '+
                                                                                                ConversaoRecursiva(pN mod 100);
                                                                                    end;
    1000..999999: begin
                    Result := ConversaoRecursiva(pN div 1000) +
                              ' Mil '+
                              ConversaoRecursiva(pN mod 1000);
                  end;
    1000000..1999999: begin
                        Result := ConversaoRecursiva(pN div 1000000) +
                                  ' Milhão '+
                                  ConversaoRecursiva(pN mod 1000000);
                      end;
    2000000..999999999: begin
                          Result := ConversaoRecursiva(pN div 1000000) +
                                    ' Milhões '+
                                    ConversaoRecursiva(pN mod 1000000);
                        end;
    1000000000..1999999999: begin
                              Result := ConversaoRecursiva(pN div 1000000000) +
                                        ' Bilhão '+
                                        ConversaoRecursiva(pN mod 1000000000);
                            end;
    2000000000..4294967295: begin
                              Result := ConversaoRecursiva(pN div 1000000000) +
                                        ' Bilhões '+
                                        ConversaoRecursiva(pN mod 1000000000);
                            end;
  end;
end;

function StrFloat(pValor:String): Real;
var
  Texto : String;
  I : Integer;
begin
  Texto := '';
  for I := 1 to Length(pValor) do
  begin
    if Copy(pValor,I,1) <> '.' then
      Texto := Texto + Copy(pValor,I,1);
  end;

  Result := StrToFloatDef(Texto,0);
end;

function ConverterData(pData:String): String;
  var I : Integer;
begin
  try
    Result := '';
    //StrToDate(pData);
    for I := 1 to Length(pData) do
    begin
      if Copy(pData,I,1) = '/' then
        Result := Result + '.'
      else
        Result := Result + Copy(pData,I,1);
    end;
  except
    on EConvertError do
    begin
      TMensagens.ShowMessage('Erro na Conversão da data "'+pData+'", verifique!',tmAtencao);
    end;
  end;
end;

function DataSemBarras(pData:String): String;
  var I : Integer;
begin
  Result := '';
  for I := 1 to Length(pData) do
  begin
    if Copy(pData,I,1) <> '/' then
      Result := Result + Copy(pData,I,1);
  end;
end;

function HoraSemPontos(pHora:String): String;
  VAR I : Integer;
begin
  Result := '';
  for I := 1 to Length(pHora) do
  begin
    if Copy(pHora,I,1) <> ':' then
      Result := Result + Copy(pHora,I,1);
  end;
end;

function ZeroEsq(AValor: String; AQtde: Integer; AVirgula, ACortar: Boolean): String;
var
  I : Integer;
begin
  Result := '';
  if not AVirgula then
  begin
    for I := 1 to Length(AValor) do
    begin
      if (Copy(AValor,I,1) <> ',') and (Copy(AValor,I,1) <> '.') and (Copy(AValor,I,1) <> '-') and
         (Copy(AValor,I,1) <> '/') and (Copy(AValor,I,1) <> '\') and (Copy(AValor,I,1) <> '_') then
      begin
        Result := Result + Copy(AValor,I,1);
      end;
    end;
  end
  else
    Result := AValor;

  if ACortar then
  begin
    if Length(Result) > AQtde then
      Result := Copy(Result, 1, AQtde);
  end;

  while Length(Result) < AQtde do
    Result := '0'+Result;
end;

function ZeroDir(pValor:String;pQtde:Integer) : String;
begin
  Result := '';
  Result := Copy(pValor,1,pQtde);

  while Length(Result) < pQtde do
    Result := Result+'0';
end;

function EspEsq(pValor:String;pQtde:Integer) : String;
begin
  Result := '';
  Result := Copy(pValor,1,pQtde);

  while Length(Result) < pQtde do
    Result := ' '+Result;
end;

function EspDir(pValor:String;pQtde:Integer) : String;
begin
  Result := '';
  Result := Copy(pValor,1,pQtde);

  while Length(Result) < pQtde do
    Result := Result+' ';
end;

function DiskInDrive(const _Drive:char) : Boolean;
  var DrvNum: byte;
      EMode: Word;
begin
  Result := False;
  DrvNum := Ord(_Drive);
  if DrvNum >= Ord('a') then
    Dec(DrvNum,$20);

  EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    if DiskSize(DrvNum-$40) <> -1 then
      Result := True
    else
      MessageBeep(0);
  finally
    SetErrorMode(EMode);
  end;
end;

function DiaVen(pData:TDate;pDiaVen,pDiaInt:Integer) : String;
  var ANO,MES,DIA : Word;
begin
  DecodeDate(pData,ANO,MES,DIA);
  Result := IntToStr(pDiaVen)+'/'+IntToStr(MES)+'/'+IntToStr(ANO);
end;

function Nulo(pValor:Variant) : Integer;
begin
  if (VarType(pValor) = VarEmpty) or (VarType(pValor) = VarNull) then
    Result := 0
  else
    Result := pValor;
end;

function Encripta(const pValor : string) : string;
var
  I: Byte;
  StartKey : Integer;
  MultKey : Integer;
  AddKey : Integer;
  Value, Resultado: AnsiString;
begin
  StartKey := 981;
  MultKey := 12674;
  AddKey := 35891;
  Resultado := '';
  Value := pValor;

  for I := 1 to Length(Value) do
  begin
    Resultado := Resultado+AnsiChar(Byte(Value[I]) xor (StartKey shr 8));
    StartKey := (Byte(Resultado[I])+StartKey)*MultKey+AddKey;
  end;

  Result := Resultado;
end;

function Decripta(const pValor : string) : string;
  var I : Byte;
      StartKey : Integer;
      MultKey : Integer;
      AddKey : Integer;
      Value, Resultado: AnsiString;
begin
  StartKey := 981;
  MultKey := 12674;
  AddKey := 35891;
  Resultado := '';
  Value := pValor;

  for I := 1 to Length(Value) do
  begin
    Resultado := Resultado+AnsiChar(Byte(Value[i]) xor (StartKey shr 8));
    StartKey := (Byte(Value[i])+StartKey)*MultKey+AddKey;
  end;

  Result := Resultado;
end;

function FatorVencimento(pFator,pVencimento: TDateTime): Real;
begin
  Result := pVencimento-pFator;
end;

function RetornoTXT(pValor: String;pQtde: INTEGER): String;
  var I,Casa,Posicao: Integer;
begin
  Result := '';
  Posicao := 1;
  Casa := Length(pValor)-pQtde;

  for I := 1 to Length(pValor)+1 do
  begin
    if I = Casa+1 then
    begin
      Result := Result+',';
    end
    else
    begin
      Result := Result+Copy(pValor,Posicao,1);
      Inc(Posicao);
    end;
  end;
end;

function GetComputer: String;
  var
      I: DWord;
//  VAR REGISTRO: TRegistry;
begin
  I := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, I);
  Windows.GetComputerName(PWideChar(Result), I);
  Result := string(PWideChar(Result));

//  registro:=tregistry.create;
//  registro.RootKey:=HKEY_LOCAL_MACHINE;
//  registro.openkey('SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName',false);
//  //registro.openkey('System\CurrentControlSet\Services\VXD\VNETSUP',false);
//  result:= registro.readstring('ComputerName');
end;

function GetIP: String;
var
  StrAux: string;
  {$IFDEF WEB}
  WebForm: TIWAppForm;
  {$ELSE}
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
  {$ENDIF}
begin
  {$IFDEF WEB}
  WebForm := TIWAppForm.Create(nil);
  try
    if Assigned(WebForm.WebApplication) then
      StrAux := WebForm.WebApplication.IP
    else
      StrAux := '127.0.0.1';
  finally
    FreeAndNil(WebForm);
  end;
  repeat
    I := Pos(',',StrAux);
    if I > 0 then
    begin
      StrAux := Copy(StrAux,I+1,Length(StrAux));
      StrAux := Trim(StrAux);
    end;
  until I = 0;
  Result := StrAux;
  {$ELSE}
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PAnsiChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PAnsiChar(Name));

  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d',
    [Byte(h_addr^[0]),Byte(h_addr^[1]),
    Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;

  WSACleanup;
  {$ENDIF}
end;

function SysComputerName: string;
var
  I: DWord;
begin
  I := MAX_COMPUTERNAME_LENGTH + 1;
  SetLength(Result, I);
  Windows.GetComputerName(PChar(Result), I);
  Result := string(PChar(Result));
end;


function GeraCaracter(Const _v: variant): string;
begin
  case TVarData(_v).vType of
    varEmpty:    result := 'Empty';
    varNull:     result := 'Null';
    varSmallInt: result := IntToStr(_v);
    varInteger:  result := IntToStr(_v);
    varSingle:   result := FloatToStr(_v);
    varDouble:   result := FloatToStr(_v);
    varCurrency: result := FloatToStr(_v);
    varDate:     result := DateToStr(_v);
    varVariant:  result := FloatToStr(_v);
    varUnknown:  result := '?';
    varByte:     result := IntToStr(_v);
    varString:   result := _v;
  end;
end;

function Bissexto(pAno: Integer): Boolean;
begin
  Result := (pAno Mod 4 = 0) and ((pAno Mod 100 <> 0) or (pAno Mod 400 = 0));
end;

Function DiadaSemana(pData: String; AShort: Boolean): String;
begin
  Result := IfThen(AShort, _SemanaShort[DayOfWeek(StrToDate(pData))], _Semana[DayOfWeek(StrToDate(pData))]);
end;

function DiadaSemana(ADia: Integer; AShort: Boolean = False): String; overload;
begin
  Result := IfThen(AShort, _SemanaShort[ADia], _Semana[ADia]);
end;

procedure Compactar(pOrigem, pDestino: String);
var
  Zip : TJvZlibMultiple;
  Arquivos: TStringList;
  procedure GetArquivos;
    var I: Integer;
        TmpText: string;
  begin
    TmpText := pOrigem;
    I := 0;
    repeat
      if Trim(TmpText) = EmptyStr then
      begin
        Break;
      end;

      I := Pos(',',TmpText);
      if I > 0 then
      begin
        Arquivos.Add(Copy(TmpText,1,I-1));
        Delete(TmpText,1,I);
      end
      else
        Arquivos.Add(TmpText);
    until(I = 0);
  end;
begin
  Zip := TJvZlibMultiple.Create(nil);
  Arquivos := TStringList.Create;
  GetArquivos;
  Screen.Cursor := crHourGlass;
  try
    Zip.CompressFiles(Arquivos,pDestino);
  finally
    Zip.Free;
    Arquivos.Free;
    Screen.Cursor := crDefault;
  end;
end;

function DecimalECF(pValor: Real): String;
begin
  Result := '';
  if pValor > 99.99 then
    Result := FormatFloat('#,#0.0',pValor)
  else
    Result := FormatFloat('#,##0.00',pValor);
end;

function RetirarMasc(pValor: string): string;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(pValor) do
  begin
    if pValor[I] in ['0'..'9'] then
      Result := Result + pValor[I];
  end;
end;

function VirgulaToPonto(pValor: String): String;
var
  I : Integer;
begin
  Result := '';
  for I := 1 to Length(pValor) do
  begin
    if Copy(pValor,I,1) = ',' then
      Result := Result+'.'
    else
      Result := Result+Copy(pValor,I,1);
  end;
end;

function ScsToKG(pSacas,pQuilos: Real): Real;
begin
  Result := ((pSacas*60)+pQuilos);
end;

function KGToScs(pQtde: Real;pTipo: Integer): Real;
begin
  pQtde := ArredondarValor(pQtde);
  if pTipo = 1 then
  begin
    Result :=  pQtde/60;
    Result := RGDecimal2(FloatToStr(Result),1);
  end
  else
  begin
    Result := Frac(pQtde/60)*60;
    if Result = 60 then
      Result := 0;

    if Result < 0 then
      Result := 0;
  end;
end;

function HexToInt(const _HexStr: string): longint;
  var iNdx: integer;
      cTmp: Char;
begin
  Result := 0;

  for iNdx := 1 to Length(_HexStr) do
  begin
    cTmp := _HexStr[iNdx];
    case cTmp of
      '0'..'9': Result := 16*Result+(Ord(cTmp)-$30);
      'A'..'F': Result := 16*Result+(Ord(cTmp)-$37);
      'a'..'f': Result := 16*Result+(Ord(cTmp)-$57);
    else
      Raise EConvertError.Create('Illegal character in hex string');
    end;
  end;
end;

function IntToBin(pValue: LongInt;pSize: Integer): String;
  var I: Integer;
begin
  Result := '';
  for I := pSize Downto 0 do
  begin
    if pValue and (1 shl I) <> 0 then
      Result := Result+'1'
    else
      Result:=Result+'0';
  end;
end;

function LimitarStr(pValor:String;pQtde:Integer): String;
  var I: Integer;
begin
  Result := '';
  if Length(pValor) > pQtde then
  begin
    for I := 1 to pQtde do
      Result := Result+Copy(pValor,I,1);
  end
  else
    Result := Trim(pValor);
end;

function Maiuscula(pTexto: String): String;
  var I: Integer;
      ANT: String;
begin
  ANT := '';
  Result := '';
  for I := 1 to Length(pTexto) do
  begin
    if I > 1 then
      ANT := Copy(pTexto,I-1,1);

    if (ANT = ' ') or (I = 1) then
      Result := Result+AnsiUpperCase(Copy(pTexto,I,1))
    else
      Result := Result+AnsiLowerCase(Copy(pTexto,I,1));
  end;
end;

function SystemDateTime(pDate:TDateTime;pTime:TDateTime):Boolean;
  var
      tSetDate:TDateTime;
      vDateBias:Variant;
      tSetTime:TDateTime;
      vTimeBias:Variant;
      tTZI:TTimeZoneInformation;
      tST:TSystemTime;
begin
  GetTimeZoneInformation(tTZI);
  vDateBias:=tTZI.Bias/1440;
  tSetDate:=pDate+vDateBias;
  vTimeBias:=tTZI.Bias/1440;
  tSetTime:=pTime+vTimeBias;

  with tST do
  begin
    wYear:=StrToInt(FormatDateTime('yyyy',tSetDate));
    wMonth:=StrToInt(FormatDateTime('mm',tSetDate));
    wDay:=StrToInt(FormatDateTime('dd',tSetDate));
    wHour:=StrToInt(FormatDateTime('hh',tSettime));
    wMinute:=StrToInt(FormatDateTime('nn',tSettime));
    wSecond:=StrToInt(FormatDateTime('ss',tSettime));
    wMilliseconds:=0;
  end;

  SystemDateTime:=SetSystemTime(tST);
end;

function ExtractSystemDir : String;
  var
    Buffer : Array[0..144] of Char;
begin
  GetSystemDirectory(Buffer,144);
  Result := StrPas(Buffer);
end;

procedure SetDefaultPrinter(pPrinterName: String);
  var
      I: Integer;
      Device : PChar;
      Driver : Pchar;
      Port : Pchar;
      HdeviceMode: Thandle;
      aPrinter : TPrinter;
begin
  Printer.PrinterIndex := -1;
  getmem(Device, 255);
  getmem(Driver, 255);
  getmem(Port, 255);
  aPrinter := TPrinter.create;

  for I := 0 to Printer.printers.Count-1 do
  begin
    if Printer.printers[i] = pPrinterName then
    begin
      aprinter.printerindex := i;
      aPrinter.getprinter
      (device, driver, port, HdeviceMode);
      StrCat(Device, ',');
      StrCat(Device, Driver );
      StrCat(Device, Port );
      WriteProfileString('windows', 'device', Device);
      StrCopy( Device, 'windows' );
      SendMessage(HWND_BROADCAST, WM_WININICHANGE,
      0, Longint(@Device));
    end;
  end;

  Freemem(Device, 255);
  Freemem(Driver, 255);
  Freemem(Port, 255);
  aPrinter.Free;
end;

function GetDefaultPrinterName : string;
// Retorna o nome da impressora padrão do Windows
begin
  if (Printer.PrinterIndex >= 0) then
  begin
    Result := Printer.Printers[Printer.PrinterIndex];
  end
  else
    Result := '';
end;

function GetIndexPrinter(pNome: String): Integer;
  var I: Integer;
begin
  for I:= 0 to Printer.Printers.Count-1 do
  begin
    if Printer.Printers[I] = pNome then
    begin
      Result := I;
      Exit;
    end;
  end;

  Result := 0;
end;

function UltimoDiaMes(pData: TDate): Integer;
begin
  Result := DaysInMonth(pData);
end;

function SQLData(pDate : TDateTime; pComQuoted: Boolean; pComHoras: Boolean): string;
var
  Ano, Mes, Dia, Hora, Minuto, Segundo, MileSegundo: Word;
begin
  DecodeDate(pDate, Ano, Mes, Dia);

  Result := IntToStr(Dia) + '.'+
            IntToStr(Mes) + '.'+
            IntToStr(Ano);

  DecodeTime(pDate,Hora,Minuto,Segundo, MileSegundo);

  if ((Hora + Minuto + Segundo) > 0) and (pComHoras) then
  begin
    Result := Result + ' '+
              IntToStr(Hora) + ':'+
              IntToStr(Minuto) + ':'+
              IntToStr(Segundo);
  end;

  if pComQuoted then
  begin
    Result := QuotedStr(Result);
  end;
end;

function SQLDataStr(pData: string; pComQuoted: Boolean) : string;
begin
  try
    Result := SQLData(StrToDateTime(pData),pComQuoted);
  except
    Result := SQLData(0,pComQuoted);
  end;
end;


procedure GravaIni(pParam, pValor: array of string; pArquivo, pNome: String; pCriptografado: Boolean);
var
ArqIni : TIniFile;
  I: Integer;
begin
ArqIni := TIniFile.Create(pArquivo);
Try
  FOR I := 0 TO Length(pParam)-1 DO
    BEGIN
    IF pParam[I] <> '' THEN
      IF pCriptografado THEN
        BEGIN
        pValor[I] := Encripta(pValor[I]);
        ArqIni.WriteString(pNome, pParam[I], pValor[I]);
        END
      ELSE
        ArqIni.WriteString(pNome, pParam[I], pValor[I]);
    END;
Finally
  ArqIni.Free;
end;
end;

procedure LeIni( Var Param, Valor: ARRAY OF STRING; pArquivo, pNome: String; pCriptografado: Boolean; pParams: Integer);
  var
      ArqIni : TIniFile;
      I: Integer;
begin
  ArqIni := TIniFile.Create(pArquivo);
  try
    for I := 0 to pParams do
    begin
      if Param[I] <> '' then
      begin
        if pCriptografado then
        begin
          Valor[I] := ArqIni.ReadString(pNome, Param[I], Valor[I]);
          Valor[I] := Decripta(Valor[I]);
        end
        else
          Valor[I] := ArqIni.ReadString(pNome, Param[I], Valor[I]);
      end;
    end;
  finally
    ArqIni.Free;
  end;
end;

Procedure GravaIni2( pVersao: Longint ; pArquivo, pNomeZip, pExtrair, pTipo, pCaminho, pNome: String ; pCompactado: Boolean);
  var
      ArqIni : TIniFile;
begin
  ArqIni := TIniFile.Create(pCaminho);
  try
    ArqIni.WriteInteger(pNome, 'Versão', pVersao);
    ArqIni.WriteString (pNome, 'Arquivo', pArquivo);
    ArqIni.WriteString (pNome, 'NomeZip', pNomeZip);
    ArqIni.WriteString (pNome, 'Extrair', pExtrair);
    ArqIni.WriteString (pNome, 'Tipo', pTipo);
    ArqIni.WriteBool   (pNome, 'Compactado', pCompactado);
  finally
    ArqIni.Free;
  end;
end;

Procedure LeIni2( Var Versao: Longint ; var Arquivo, NomeZip, Extrair : String; pTipo, pCaminho, pNome: String ; Var Compactado: Boolean);
  var
      ArqIni : tIniFile;
begin
  ArqIni := tIniFile.Create(pCaminho);
  try
    Versao            := ArqIni.ReadInteger(pNome, 'Versão', Versao );
    Arquivo           := ArqIni.ReadString(pNome, 'Arquivo', Arquivo );
    NomeZip           := ArqIni.ReadString(pNome, 'NomeZip', NomeZip );
    Extrair           := ArqIni.ReadString(pNome, 'Extrair', Extrair );
    pTipo             := ArqIni.ReadString(pNome, 'Tipo', pTipo );
    TipoArquivoUpdate := pTipo;
    Compactado        := ArqIni.ReadBool(pNome, 'Compactado', Compactado );
  finally
    ArqIni.Free;
  end;
end;

function DownloadFile(pOrigem, pDestino: string): Boolean;
begin
  try
    Result:= UrlDownloadToFile(nil, PChar(pOrigem),PChar(pDestino), 0, nil) = 0;
  except
    Result:= False;
  end;
end;

procedure EncryptDecryptFile(pArqEntrada, pArqSaida : String; pChave : Word);
  var
    InMS, OutMS : TMemoryStream;
    I : Integer;
    C : byte;
begin
  InMS := TMemoryStream.Create;
  OutMS := TMemoryStream.Create;
  try
    InMS.LoadFromFile(pArqEntrada);
    InMS.Position := 0;
    for I := 0 to InMS.Size - 1 do
    begin
      InMS.Read(C, 1);
      C := (C xor not(ord(pChave shr I)));
      OutMS.Write(C,1);
    end;
    OutMS.SaveToFile(pArqSaida);
  finally
    InMS.Free;
    OutMS.Free;
  end;
end;

procedure ExtrairArquivos(pOrigem, pExtensao, pDiretorio: string);
  var Zip: TJvZlibMultiple;
begin
  Zip := TJvZlibMultiple.Create(nil);
  Screen.Cursor := crHourGlass;
  try
    ForceDirectories(pDiretorio);
    Zip.DecompressFile(pOrigem,pDiretorio,true);
  finally
    Zip.Free;
    Screen.Cursor := crDefault;
  end;
end;


procedure ApagarArquivos(pDiretorio, pCuringa: String);
  var
    SR: TSearchRec;
    I: integer;
begin
  I := FindFirst(pDiretorio+pCuringa, faAnyFile, SR);
  while I = 0 do
  begin
    if (SR.Attr and faDirectory) <> faDirectory then
    begin
      if not DeleteFile(pDiretorio + SR.Name) then
        TMensagens.ShowMessage('Não foi possivel excluir o arquivo ' + SR.Name);
    end;
    I := FindNext(SR);
  end;
end;

function CopyEntyreString(pFrase,pInicio,pFim:String):String;
  var
    iAux,kAux:Integer;
begin
  Result:='';
  if (Pos(pFim,pFrase) <> 0) and (Pos(pInicio,pFrase)<>0) then
  begin
    iAux := Pos(pInicio,pFrase)+length(pInicio);
    kAux := Pos(pFim,pFrase);
    Result := Copy(pFrase,iAux,kAux-iAux);
  end;
end;

function ArredondarVAlor(pValor:Double): Double;
  var DECIMAL : Double;
begin
  Result := 0;

  DECIMAL := Frac(pValor)*100;
  if DECIMAL = 50 then
    Result := pValor
  else
  if DECIMAL < 25 then
    Result := Int(pValor)
  else
  if (DECIMAL >= 25) And (DECIMAL < 50) then
    Result := Int(pValor)+0.5
  else
  if (DECIMAL < 75) And (DECIMAL > 50) then
    Result := Int(pValor)+0.5
  else
  if DECIMAL >= 75 then
    Result := Int(pValor)+1;
end;

function CaptureScreenRect( pARect: TRect ): TBitmap;
  var
    ScreenDC: HDC;
begin
  Result := TBitmap.Create;
  with Result, pARect do
  begin
    Width := Right - Left;
     Height := Bottom - Top;
     ScreenDC := GetDC( 0 );
    try
      BitBlt( Canvas.Handle, 0, 0, Width, Height, ScreenDC, Left, Top, SRCCOPY );
    finally
      ReleaseDC( 0, ScreenDC );
    end;
    // Palette := GetSystemPalette;
  end;
end;

function ExtractName(const _Filename: String): String;
{Retorna o nome do Arquivo sem extensão}
  var
    aExt : String;
    aPos : Integer;
begin
  aExt := ExtractFileExt(_Filename);
  Result := ExtractFileName(_Filename);
  if aExt <> '' then
  begin
    aPos := Pos(aExt,Result);
    if aPos > 0 then
    begin
      Delete(Result,aPos,Length(aExt));
    end;
  end;
end;


function JpgToBmp(pImage: String): Boolean;
// Requer a Jpeg declarada na clausula uses da unit
  var
    MyJPEG : TJPEGImage;
    MyBMP : TBitmap;
begin
  Result := False;
  if fileExists(pImage+'.jpg') then
  begin
    MyJPEG := TJPEGImage.Create;
    with MyJPEG do
    begin
      try
        LoadFromFile(pImage+'.jpg');
        MyBMP := TBitmap.Create;
        with MyBMP do
        begin
          Width := MyJPEG.Width;
          Height := MyJPEG.Height;
          Canvas.Draw(0,0,MyJPEG);
          if FileExists(pImage+'.bmp') then
            DeleteFile(pImage+'.bmp');

          SaveToFile(pImage+'.bmp');
          Free;
          Result := True;
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function BmpToJpg(pImage: String): Boolean;
// Requer a Jpeg declarada na clausula uses da unit
  var
    MyJPEG : TJPEGImage;
    MyBMP : TBitmap;
begin
  Result := False;
  if fileExists(pImage+'.bmp') then
  begin
    MyBMP := TBitmap.Create;
    with MyBMP do
    begin
      try
        LoadFromFile(pImage+'.bmp');
        MyJPEG := TJPEGImage.Create;
        with MyJPEG do
        begin
          assign(MyBMP);
          if FileExists(pImage+'.jpeg') then
            DeleteFile(pImage+'.jpeg');

          SaveToFile(pImage+'.jpeg');
          Free;
          Result := True;
        end;
      finally
        Free;
      end;
    end;
  end;
end;

procedure SalvaImagensTela(pArquivo: String);
  var BitMap: TBitmap;
      Data: String;
begin
  Data := ConverterData(DateToStr(Date));

  if not DirectoryExists(ExtractFilePath(Application.ExeName)+'\Erros') then
    MkDir(ExtractFilePath(Application.ExeName)+'\Erros');

  //...Captura e salva a tela atual do erro.
  BitMap := CaptureScreenRect(Bounds(0, 0, Screen.Width, Screen.Height));
  BitMap.SaveToFile(ExtractFilePath(Application.ExeName)+'\Erros\'+pArquivo+'_'+Data+'_erro.bmp');
  if BmpToJpg(ExtractFilePath(Application.ExeName)+'\Erros\'+pArquivo+'_'+Data+'_erro') then
    DeleteFile(ExtractFilePath(Application.ExeName)+'\Erros\'+pArquivo+'_'+Data+'_erro.bmp');

  BitMap.Free;
end;

function RGDecimal(pValor: String;pParte: Integer): Integer;
  var I: Integer;
      CDECIMAL: String;
begin
  if STRFLOAT(pValor) < 0 then
    Result := 0
  else
  begin
    I := POS(',',pValor);
    if I = 0 then
      Result := StrToInt(pValor)
    else
    begin
      if pParte = 1 then
        Result := StrToInt(COPY(pValor,1,I-1));
      if pParte = 2 then
      begin
        CDECIMAL := COPY(pValor,I+1,9);
        if COPY(CDECIMAL,1,1) = '0' then
          Result := 1
        else
          Result := StrToInt(COPY(pValor,I+1,9));
      end;
    end;

    Result := Result;
  end;
end;

function RGDecimal2(pValor: String;pParte: Integer): Integer;
  var I: Integer;
      CDECIMAL: String;
begin
  I := POS(',',pValor);
  if I = 0 then
    Result := StrToInt(pValor)
  else
  begin
    if pParte = 1 then
      Result := StrToInt(COPY(pValor,1,I-1));
    if pParte = 2 then
    begin
      CDECIMAL := COPY(pValor,I+1,9);
      if COPY(CDECIMAL,1,1) = '0' then
        Result := 1
      else
        Result := StrToInt(COPY(pValor,I+1,9));
    end;
  end;

  Result := Result;
end;

procedure Resolucao(pForm: TForm);
  var I : Integer;
begin
  if pForm <> nil then
  begin
    pForm.Scaled := True;
    if (Screen.Width <> _ScreenWidth) then
    begin
      pForm.Height := Longint(pForm.Height) * Longint(Screen.Height) DIV _ScreenHeight;
      pForm.Width := Longint(pForm.Width) * Longint(Screen.Width) DIV _ScreenWidth;
      if Screen.Width < _ScreenWidth then
      begin
        pForm.ScaleBy(Screen.Width, _ScreenWidth);
        pForm.Font.Name := 'Times New Roman'; //'Arial';
      end;
      pForm.Font.Size := 8; // 7; //(FORM.Width DIV ScreenWidth) * FORM.Font.Size;
    end;

    for I := pForm.ComponentCount - 1 downto 0 do
    begin
      with pForm.Components[I] do
      begin
        {IF GetPropInfo(ClassInfo,'Font') <> Nil THEN
          BEGIN
          FORM.Font.Name := 'Arial';
          FORM.Font.Size := (FORM.Width DIV ScreenWidth) * FORM.Font.Size;
          END;}
        if (pForm.Components[I] is TLabel) and (Screen.Width < _ScreenWidth) then
        begin
          TLabel(pForm.Components[I]).Font.Name := 'Times New Roman'; //'Arial';
          TLabel(pForm.Components[I]).Font.Size := 8; // 7;
        end;
      end;
    end;
  end;
end;

function CentraTexto(pValor: string; pLarguraTexto: Integer): Ansistring;
//  var METADE,QTDEESP,I: Integer;
//begin
//  QTDEESP := pQtde-Length(pValor);
//  METADE := Trunc(QTDEESP/2);
//  Result := '';
//  for I := 1 to METADE do
//    Result := Result+' ';
//
//  Result := Result+pValor;
//  for I := 1 to METADE do
//    Result := Result+' ';
var
  TamanhoTexto: Integer;
  AComplementar: Integer;
  Texto, Linha, Palavra: string;
  I: Integer;
  SL: TStringList;
begin
  TamanhoTexto := Length(pValor);
//  AComplementar := pLarguraTexto - TamanhoTexto;
//
//  if AComplementar < 0 then
//    AComplementar := 0;

  Texto := pValor;
  Result := '';
  Linha := '';

  SL := TStringList.Create;
  try
    //Quebra textos em linha
    while Length(Texto) > 0 do
    begin
      I := Pos(' ',Texto);
      if I = 0 then
      begin
        Palavra := Texto;
        Texto := '';
      end
      else
      begin
        Palavra := Copy(Texto,1,I);
        Delete(Texto,1,I);
      end;

      Palavra := Trim(Palavra);

      if Length(Linha+' '+Palavra) <= pLarguraTexto then
      begin
        if Linha = '' then
          Linha := Palavra
        else
          Linha := Linha + ' '+ Palavra;
      end
      else
      begin
        SL.Add(Linha);
        Linha := Palavra;
      end;

      Texto := Trim(Texto);
    end;

    if Trim(Linha) <> '' then
      SL.Add(Linha);

    //Centraliza Textos
    for I := 0 to SL.Count - 1 do
    begin
      Linha := SL.Strings[I];
      if Length(Linha) < pLarguraTexto then
      begin
        AComplementar := pLarguraTexto - Length(Linha);
        Texto := StringOfChar(' ',AComplementar);
        Texto := Copy(Texto,1,AComplementar div 2);
        Linha := Texto + Linha + Texto;
        SL.Strings[I] := Linha;
      end;
    end;

    Result := SL.Text;
  finally
    FreeAndNil(SL);
  end;
end;

function InverterStr (pString : ShortString) : ShortString;
  var
    I : Integer;
begin
  Result := '';
  for I := Length(pString) downto 1 do
    Result := Result + pString[I];
end;

procedure SetJPGCompression(pCompression: integer; const _AInFile: string; const _AOutFile: string; pAltura, pLargura: Integer; pTipo, pTipoS: String);
  var
    iCompression: integer;
    oJPG: TJPegImage;
    oBMP: TBitMap;
begin
  { Forcar a Compressão para a faixa entre 1..100 }
  iCompression := abs(pCompression);
  if iCompression = 0 then
    iCompression := 1;
  if iCompression > 100 then
    iCompression := 100;

  { Cria as classes de trabalho Jpeg e Bmp }
  oJPG := TJPegImage.Create;
  oBMP := TBitMap.Create;
  if pTipo = 'jpg' then
  begin
    oJPG.LoadFromFile(_AInFile);
    oBMP.Assign(oJPG);
    oBMP.Width := pLargura;
    oBMP.Height := pAltura;
    oBMP.Canvas.StretchDraw(oBMP.Canvas.ClipRect,oJPG);
    oJPG.Assign(oBMP);
    oBMP.Assign(oJPG);
    if pTipoS = 'bmp' then
      oBMP.SaveToFile(_AOutFile+'.bmp');

    if pTipoS = 'jpg' then
    begin
      { Fazer a Compressão e salva o novo arquivo }
      oJPG.CompressionQuality := iCompression;
      oJPG.Compress;
      oJPG.SaveToFile(_AOutFile+'.jpg');
    end;
  end;

  if pTipo = 'bmp' then
  begin
    oBMP.LoadFromFile(_AInFile);
    oJPG.Assign(oBMP);
    oBMP.Width := pLargura;
    oBMP.Height := pAltura;
    oBMP.Canvas.StretchDraw(oBMP.Canvas.ClipRect,oJPG);
    oJPG.Assign(oBMP);
    oBMP.Assign(oJPG);
    if pTipoS = 'bmp' then
      oBMP.SaveToFile(_AOutFile+'.bmp');

    if pTipoS = 'jpg' then
    begin
      { Fazer a Compressão e salva o novo arquivo }
      oJPG.CompressionQuality := iCompression;
      oJPG.Compress;
      oJPG.SaveToFile(_AOutFile+'.jpg');
    end;
  end;

  { Limpar }
  oJPG.Free;
  oBMP.Free;
end;

procedure Idade(ANascimento: TDate; var ADias, AMeses, AAnos: Integer);
var
  AnoAtual, MesAtual, DiaAtual : Word;
  AnoData, MesData, DiaData : Word;
  Anos, Meses, Dias : Integer;
begin
  AAnos := 0;
  AMeses := 0;
  ADias := 0;

  if ANascimento > Date then
    Exit;

  if ANascimento = 0 then
    Exit;

  DecodeDate(Date, AnoAtual, MesAtual, DiaAtual);
  DecodeDate(ANascimento, AnoData, MesData, DiaData);

  // Obtendo as diferenças de cada parte da data //
  Anos := AnoAtual - AnoData;
  Meses := MesAtual - MesData;
  Dias := DiaAtual - DiaData;

  // Calculando os meses //
  if Meses < 0 then
  begin
    Dec(Anos);
    Meses := 12 + Meses;
  end;

  if Dias < 0 then
  begin
    Meses := Meses - 1;

    if MesAtual - 1 in [4,6,9,11] then
      Dias := DiaAtual + 30 - DiaData
    else if MesAtual - 1 = 0 then // Janeiro
      Dias := DiaAtual + 31 - DiaData
    else if MesAtual - 1 = 2 then
    begin
      if AnoAtual mod 4 = 0 then // bissexto
        Dias := DiaAtual + 29 - DiaData
      else
        Dias := DiaAtual + 28 - DiaData;
    end
    else if Dias < 0 then
    begin
      Dias := DaysInAMonth(AnoData,MesData) - (Dias * -1);
    end;
  end;

  AAnos := Anos;
  AMeses := Meses;
  ADias := Dias;
end;

function Idade(pNascimento: TDate; pComDia, pComMes: Boolean): string;
var
  Dias, Meses, Anos: Integer;
  NDia, NMes, NAno, DDia, DMes, DAno: Word;
  DataAux: TDate;
begin
  Result := '';

  if pNascimento > Date then
  begin
    Result := 'Data superior a atual';
    Exit;
  end;

  if pNascimento = Date then
  begin
    Result := 'Nascido hoje';
    Exit;
  end;

  Idade(pNascimento,Dias,Meses,Anos);

  if Anos > 0 then
  begin
    if Anos > 1 then
      Result := IntToStr(Anos) + ' Anos '
    else
      Result := IntToStr(Anos) + ' Ano ';
  end;

  if (pComMes) and (Meses > 0) then
  begin
    if Meses > 1 then
      Result := Result + IntToStr(Meses) + ' Mêses '
    else
      Result := Result + IntToStr(Meses) + ' Mês ';
  end;

  if (pComDia) and (Dias > 0) then
  begin
    if Dias > 1 then
      Result := Result + IntToStr(Dias) + ' Dias '
    else
      Result := Result + IntToStr(Dias) + ' Dia ';
  end;
end;

function Idade(pNascimento, pDataRef: TDate): Real;
begin
  Result := YearsBetween(pDataRef,pNascimento-1);
end;

function Idade(pNascimento: TDate): Real;
begin
  Result := Idade(pNascimento,Date);
end;

function IdadeMeses(pNascimento, pDataRef: TDate): Integer;
begin
  Result := MonthsBetween(pDataRef,pNascimento);
end;

function IdadeMeses(pNascimento: TDate): Integer; overload;
begin
  Result := IdadeMeses(pNascimento,Date);
end;

// Procedure que irá alterar a fonte do Hint
procedure MyShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  var i : integer;
begin
  for i := 0 to Application.ComponentCount - 1 do
  begin
    if Application.Components[i] is THintWindow then
    begin
      with THintWindow(Application.Components[i]).Canvas do
      begin
        Font.Name := 'Arial';
        Font.Size := 12;
        Font.Style := [fsBold];
        HintInfo.HintColor := clWhite;
      end;
    end;
  end;
end;

function EliminaCaracteres (pTexto: String; pCaracter: String):String;
  var I: Integer;
begin
  Result := '';
  for I := 1 to Length(pTexto) do
  begin
    if COPY(pTexto,I,1) = pCaracter then
      Result := Result
    else
      Result := Result+COPY(pTexto,I,1);
  end;
end;

function CasasDec(pValor: Real; pCasas: Integer): string;
  var VlrInt, VlrQueb, StrAux: string;
      I: Integer;
      VlrAux: Real;
begin
  StrAux := FloatToStr(pValor);
  I := Pos(',',StrAux);
  if I > 0 then
  begin
    VlrInt  := Copy(StrAux,1,I-1);
    Delete(StrAux,1,I);
    VlrQueb := StrAux;
  end
  else
  begin
    VlrInt := StrAux;
    VlrQueb := '0';
  end;

  VlrQueb := Copy(VlrQueb,1,pCasas);
  VlrAux  := StrFloat(VlrInt+','+VlrQueb);

  case pCasas of
    1: begin
         Result := FormatFloat('#,#0.0',VlrAux);
       end;
    2: begin
         Result := FormatFloat('#,##0.00',VlrAux);
       end;
    3: begin
         Result := FormatFloat('#,###0.000',VlrAux);
       end;
  else
    Result := FormatFloat('#,##0.00',VlrAux);
  end;

  Result := EliminaCaracteres(Result,'.');
end;

function CasasDecimais(pValor:Real; pCasas:Integer):Real;
begin
  Result := StrToFloatDef(CasasDec(pValor,pCasas),0);
end;

function PreencheEspDir(pValor,pPreencher:String;pQtde:Integer) : String;
begin
  Result := '';
  Result := Copy(pValor,1,pQtde);
  while Length(Result) < pQtde do
    Result := Result+pPreencher;
end;

function NumToExtenso(pNumero: Real): String;
begin
  if (pNumero >= _Min) and (pNumero <= _Max) then
  begin
    {Tratar reais}
    Result := ConversaoRecursiva(Round(Int(pNumero)));
    if Round(Int(pNumero)) = 1 then
      Result := Result
    else
    if Round(Int(pNumero)) <> 0 then
      Result := Result;

    {Tratar centavos}
    if not(Frac(pNumero) = 0.00) then
    begin
      if Round(Int(pNumero)) <> 0 then
        Result := Result + ' e ';

      Result := Result + ConversaoRecursiva(Round(Frac(pNumero) * 100));
      if (Round(Frac(pNumero) * 100) = 1) then
        Result := Result + _Centesimo
      else
        Result := Result + _Centesimos;
    end;
  end
  else
    Raise ERangeError.CreateFmt('%g ' + _ErrorString + ' %g..%g',[pNumero, _Min, _Max]);
end;

procedure LogErros(pTela,pLog: String);
  var loArquivo, loTexto: string;
      loSL: TStringList;
begin
  loArquivo := TUteis.CaminhoAplicacao + '\Erros.log';

  loTexto := ' ->  Data: '+DateTimeToStr(Now) + '  Tela: '+pTela + #13#10 +
             '     Erro: '+pLog + #13#10;

  loSL := TStringList.Create;
  try
    if FileExists(loArquivo) then
      loSL.LoadFromFile(loArquivo);
    loSL.Add(loTexto);
    loSL.SaveToFile(loArquivo);
  finally
    loSL.Free;
  end;
end;

function MenorDataValida(pAno,pMes,pDia: Word): TDateTime;
  var DataAux: TDateTime;
begin
  pDia := DaysInAMonth(pAno,pMes);
  DataAux := EncodeDate(pAno,pMes,pDia);
  MenorDataValida := DataAux;
end;

function CodigoIniFin(pComponenteIni,pComponenteFin: TjvComboEdit; Var ValorIni, ValorFin: String): Boolean;
begin
  try
    Result := True;
    if pComponenteIni.Text = '' then
      ValorIni := '0'
    else
      ValorIni := pComponenteIni.Text;

    if pComponenteFin.Text = '' then
      ValorFin := '9999999'
    else
      ValorFin := pComponenteFin.Text;

    try
      if STRFLOAT(ValorIni) > STRFLOAT(ValorFin) then
      begin
        Application.MessageBox('Valor Inicial Maior que o Valor Final, Verifique!','Informação',MB_OK+MB_ICONINFORMATION);
        Result := False;
      end;
    except

    end;

  except
    Result := True;
    ValorIni := '0';
    ValorFin := '9999999';
  end;
end;

function DataIniFin(pComponenteIni,pComponenteFin: TjvCustomDateEdit; Var ValorIni, ValorFin: String): Boolean;
begin
  try
    Result := True;

    if pComponenteIni.Date = 0 then
      ValorIni := '01/01/1500'
    else
      ValorIni := pComponenteIni.Text;

    if pComponenteFin.Date = 0 then
      ValorFin := '01/01/3000'
    else
      ValorFin := pComponenteFin.Text;

    if StrToDate(ValorIni) > StrToDate(ValorFin) then
    begin
      Application.MessageBox('A Data Inicial não pode ser Maior que a Data Final!','Informação',MB_OK+MB_ICONINFORMATION);
      Result := False;
      Exit;
    end;
  except
    ValorIni := '01/01/1500';
    ValorFin := '01/01/3000';
    Result := False;
  end;
end;

function JvDataIniFin(pComponenteIni,pComponenteFin: TJvCustomDateEdit; Var ValorIni, ValorFin: String): Boolean;
begin
  try
    Result := True;

    if pComponenteIni.Text = '  /  /    ' then
      ValorIni := '01/01/1500'
    else
      ValorIni := pComponenteIni.Text;

    if pComponenteFin.Text = '  /  /    ' then
      ValorFin := '01/01/3000'
    else
      ValorFin := pComponenteFin.Text;

    if StrToDate(ValorIni) > StrToDate(ValorFin) then
    begin
      Application.MessageBox('A Data Inicial não pode ser Maior que a Data Final!','Informação',MB_OK+MB_ICONINFORMATION);
      Result := False;
      Exit;
    end;
  except
    ValorIni := '01/01/1500';
    ValorFin := '01/01/3000';
    Result := False;
  end;
end;

function SetDataSystem(pData,pHora: TDateTime): Boolean;
  var
  DataHora: TSystemTime;
  Ano, Mes, Dia, H, M, S, Mil: word;
begin
  try
    DecodeDate(pData, Ano, Mes, Dia);
    DecodeTime(pHora, H, M, S, Mil);
    with DataHora do
    begin
      wYear := Ano;
      wMonth := Mes;
      wDay := Dia;
      wHour := H;
      wMinute := M;
      wSecond := S;
      wMilliseconds := Mil;
    end;
    if SetLocalTime(DataHora) then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

procedure OrdenaGrid(var ACDS: TClientDataSet; AGrid: TObject; AColumn: TColumn);
const
  idxDefault = 'DEFAULT_ORDER';
var
  StrColumn : string;
  I         : integer;
  BolUsed   : boolean;
  IdOptions : TIndexOptions;
begin
  StrColumn := idxDefault;
  IdOptions := [];

  if AColumn.Field.FieldKind in [fkCalculated, fkLookup, fkAggregate] then Exit;
  if AColumn.Field.DataType in [ftBlob, ftMemo] then Exit;

  if AGrid is TJvDBGrid then
  begin
    for I := 0 to TJvDBGrid(AGrid).Columns.Count - 1 do
      TJvDBGrid(AGrid).Columns[I].Title.Font.Style := [];

    TJvDBGrid(AGrid).Columns[AColumn.Index].Title.Font.Style := [fsBold];
  end
  else
  if AGrid is TDBGrid then
  begin
    for I := 0 to TDBGrid(AGrid).Columns.Count - 1 do
      TDBGrid(AGrid).Columns[I].Title.Font.Style := [];

    TDBGrid(AGrid).Columns[AColumn.Index].Title.Font.Style := [fsBold];
  end;

  BolUsed := (AColumn.Field.FieldName = ACDS.IndexName);

  ACDS.IndexDefs.Update;
  for I := 0 to ACDS.IndexDefs.Count - 1 do
  begin
    if ACDS.IndexDefs.Items[I].Name = AColumn.Field.FieldName then
    begin
      StrColumn := AColumn.Field.FieldName;

      if ACDS.IndexDefs.Items[I].Options = [ixDescending] then
        IdOptions := []
      else
        IdOptions := [ixDescending];

    end;
  end;

  if (StrColumn = idxDefault) or (BolUsed) then
  begin
    if BolUsed then
      ACDS.DeleteIndex(AColumn.Field.FieldName);
    try
      ACDS.AddIndex(AColumn.Field.FieldName, AColumn.Field.FieldName, IdOptions);

      StrColumn := AColumn.Field.FieldName;
    except
      if BolUsed then
        StrColumn := idxDefault;
    end;
  end;

  try
    ACDS.IndexName := StrColumn;
  except
    ACDS.IndexName := idxDefault;
  end;
end;

procedure OrdenaGrid(var ACDS: TClientDataSet; AGrid: TDBAdvGrid; AColumn: TDBGridColumnItem; AColumnHeaderColor : TColor = clHighlight ; AColumnHeaderColorTo: TColor = clSkyBlue);
const
  idxDefault = 'DEFAULT_ORDER';
var
  StrColumn : string;
  I         : integer;
  BolUsed   : boolean;
  IdOptions : TIndexOptions;
begin
  StrColumn := idxDefault;
  IdOptions := [];

  if AColumn.Field.FieldKind in [fkCalculated, fkLookup, fkAggregate] then Exit;
  if AColumn.Field.DataType in [ftBlob, ftMemo] then Exit;

  if AGrid is TDBAdvGrid then
  begin
    for I := 0 to AGrid.Columns.Count - 1 do
    begin
      AGrid.CellProperties[I,0].FontStyle := [];
      AGrid.CellProperties[I,0].BrushColor := clNone;
      AGrid.CellProperties[I,0].BrushColorTo := clNone;
    end;

    AGrid.CellProperties[AColumn.Index,0].FontStyle := [fsBold,fsUnderline];
    AGrid.CellProperties[AColumn.Index,0].BrushColor := AColumnHeaderColor;
    AGrid.CellProperties[AColumn.Index,0].BrushColorTo := AColumnHeaderColorTo;

  end;

  BolUsed := (AColumn.Field.FieldName = ACDS.IndexName);

  ACDS.IndexDefs.Update;
  for I := 0 to ACDS.IndexDefs.Count - 1 do
  begin
    if ACDS.IndexDefs.Items[I].Name = AColumn.FieldName then
    begin
      StrColumn := AColumn.FieldName;

      if ACDS.IndexDefs.Items[I].Options = [ixDescending] then
        IdOptions := []
      else
        IdOptions := [ixDescending];
    end;
  end;

  if (StrColumn = idxDefault) or (BolUsed) then
  begin
    if BolUsed then
      ACDS.DeleteIndex(AColumn.FieldName);
    try
      ACDS.AddIndex(AColumn.FieldName, AColumn.FieldName, IdOptions);

      StrColumn := AColumn.FieldName;
    except
      if BolUsed then
        StrColumn := idxDefault;
    end;
  end;

  try
    ACDS.IndexName := StrColumn;
  except
    ACDS.IndexName := idxDefault;
  end;

end;

function ValidaHora(pHorario:String;pTipo:String): Boolean;
var
  //datAux : TDateTime;
  intAux : Integer;
begin
  try
    if (trim(pHorario)='')or(trim(pTipo)='') or (length(trim(pHorario))<>5) then
    begin
      result := false;
      exit;
    end;

    //datAux := StrToDateTime(FormatDateTime('dd/mm/yyyy',Now)+' ' + pHorario);

    if UpperCase(pTipo) = '12H' then
    begin
      intAux := StrtoInt(Copy(pHorario,1,2));
      if (intAux>=0)and(intAux<=12) then
        result := true
      else
        result := false;
    end
    else
    if UpperCase(pTipo) = '24H' then
      result := true
    else
      result := false;
  except
    result := false;
  end;
end;

procedure SetMes(pComponenteDataIni,pComponenteDataFin: TjvCustomDateEdit);
  var DIA, MES, ANO: Word;
begin
  try
    DecodeDate(Date,ANO,MES,DIA);
    pComponenteDataIni.Date := StrToDate('01/'+ ZeroEsq(IntToStr(MES),2,False)+'/'+IntToStr(ANO));
    pComponenteDataFin.Date := StrToDate(IntToStr(UltimoDiaMes(Date))+'/'+ ZeroEsq(IntToStr(MES),2,False)+'/'+IntToStr(ANO));
  except

  end;
end;

function VerificaCST(pCodCST: string): Boolean;
  const
    _ListaCST: array[0..32] of string = (
      '000', '010', '020', '030', '040', '041', '050', '051',
      '060', '070', '090', '100', '110', '120', '130', '140',
      '141', '150', '151', '160', '170', '190', '200', '210',
      '220', '230', '240', '241', '250', '251', '260', '270',
      '290');
  var
    i: integer;
    Encontrado: Boolean;
begin
  i := 0;
  Encontrado := False;
  while (not (Encontrado)) and (i <= 32) do
  begin
    Encontrado := _ListaCST[i] = pCodCST;
    inc(i);
  end;

  Result := Encontrado;
end;

function VerificaCFOP(pCFOP: SmallInt): Boolean;
  const
    _ListaCFOP: array[0..522] of string = (
      '1101', '1102', '1111', '1113', '1116', '1117', '1118', '1120', '1121', '1122', '1124', '1125', '1126', '1151', '1152', '1153', '1154', '1201',
      '1202', '1203', '1204', '1205', '1206', '1207', '1208', '1209', '1251', '1252', '1253', '1254', '1255', '1256', '1257', '1301', '1302', '1303',
      '1304', '1305', '1306', '1351', '1352', '1353', '1354', '1355', '1356', '1401', '1403', '1406', '1407', '1408', '1409', '1410', '1411', '1414',
      '1415', '1451', '1452', '1501', '1503', '1504', '1551', '1552', '1553', '1554', '1555', '1556', '1557', '1601', '1602', '1603', '1604', '1650',
      '1651', '1652', '1653', '1658', '1659', '1660', '1661', '1662', '1663', '1664', '1901', '1902', '1903', '1904', '1905', '1906', '1907', '1908',
      '1909', '1910', '1911', '1912', '1913', '1914', '1915', '1916', '1917', '1918', '1919', '1920', '1921', '1922', '1923', '1924', '1925', '1926',
      '1949', '2101', '2102', '2111', '2113', '2116', '2117', '2118', '2120', '2121', '2122', '2124', '2125', '2126', '2151', '2152', '2153', '2154',
      '2201', '2202', '2203', '2204', '2205', '2206', '2207', '2208', '2209', '2251', '2252', '2253', '2254', '2255', '2256', '2257', '2301', '2302',
      '2303', '2304', '2305', '2306', '2351', '2352', '2353', '2354', '2355', '2356', '2401', '2403', '2406', '2407', '2408', '2409', '2410', '2411',
      '2414', '2415', '2501', '2503', '2504', '2551', '2552', '2553', '2554', '2555', '2556', '2557', '2603', '2651', '2652', '2653', '2658', '2659',
      '2660', '2661', '2662', '2663', '2664', '2901', '2902', '2903', '2904', '2905', '2906', '2907', '2908', '2909', '2910', '2911', '2912', '2913',
      '2914', '2915', '2916', '2917', '2918', '2919', '2920', '2921', '2922', '2923', '2924', '2925', '2949', '3101', '3102', '3126', '3127', '3201',
      '3202', '3205', '3206', '3207', '3211', '3251', '3301', '3351', '3352', '3353', '3354', '3355', '3356', '3503', '3551', '3553', '3556', '3650',
      '3651', '3652', '3653', '3930', '3949', '5101', '5102', '5103', '5104', '5105', '5106', '5109', '5110', '5111', '5112', '5113', '5114', '5115',
      '5116', '5117', '5118', '5119', '5120', '5122', '5123', '5124', '5125', '5151', '5152', '5153', '5155', '5156', '5201', '5202', '5205', '5206',
      '5207', '5208', '5209', '5210', '5251', '5252', '5253', '5254', '5255', '5256', '5257', '5258', '5301', '5302', '5303', '5304', '5305', '5306',
      '5307', '5351', '5352', '5353', '5354', '5355', '5356', '5357', '5401', '5402', '5403', '5405', '5408', '5409', '5410', '5411', '5412', '5413',
      '5414', '5415', '5451', '5501', '5502', '5503', '5551', '5552', '5553', '5554', '5555', '5556', '5557', '5601', '5602', '5603', '5650', '5651',
      '5652', '5653', '5654', '5655', '5656', '5657', '5658', '5659', '5660', '5661', '5662', '5663', '5664', '5665', '5666', '5901', '5902', '5903',
      '5904', '5905', '5906', '5907', '5908', '5909', '5910', '5911', '5912', '5913', '5914', '5915', '5916', '5917', '5918', '5919', '5920', '5921',
      '5922', '5923', '5924', '5925', '5926', '5927', '5928', '5929', '5931', '5932', '5949', '6101', '6102', '6103', '6104', '6105', '6106', '6107',
      '6108', '6109', '6110', '6111', '6112', '6113', '6114', '6115', '6116', '6117', '6118', '6119', '6120', '6122', '6123', '6124', '6125', '6151',
      '6152', '6153', '6155', '6156', '6201', '6202', '6205', '6206', '6207', '6208', '6209', '6210', '6251', '6252', '6253', '6254', '6255', '6256',
      '6257', '6258', '6301', '6302', '6303', '6304', '6305', '6306', '6307', '6351', '6352', '6353', '6354', '6355', '6356', '6357', '6401', '6402',
      '6403', '6404', '6408', '6409', '6410', '6411', '6412', '6413', '6414', '6415', '6501', '6502', '6503', '6551', '6552', '6553', '6554', '6555',
      '6556', '6557', '6603', '6650', '6651', '6652', '6653', '6654', '6655', '6656', '6657', '6658', '6659', '6660', '6661', '6662', '6663', '6664',
      '6665', '6666', '6901', '6902', '6903', '6904', '6905', '6906', '6907', '6908', '6909', '6910', '6911', '6912', '6913', '6914', '6915', '6916',
      '6917', '6918', '6919', '6920', '6921', '6922', '6923', '6924', '6925', '6929', '6931', '6932', '6949', '7101', '7102', '7105', '7106', '7127',
      '7201', '7202', '7205', '7206', '7207', '7210', '7211', '7251', '7301', '7358', '7501', '7551', '7553', '7556', '7650', '7651', '7654', '7930',
      '7949');
  var
    i: Integer;
    Encontrado: Boolean;
begin
  i := 0;
  Encontrado := False;
  while (not (Encontrado)) and (i <= 522) do
  begin
    Encontrado := _ListaCFOP[i] = IntToStr(pCFOP);
    inc(i);
  end;

  Result := Encontrado;
end;

function VerificaUF(pUF: string): Boolean;
  const
    _ListaUF: array[0..27] of string = (
      'AC', 'AL', 'AM', 'AP', 'BA', 'CE', 'DF',
      'ES', 'GO', 'MA', 'MG', 'MS', 'MT', 'PA',
      'PB', 'PE', 'PI', 'PR', 'RJ', 'RN', 'RO',
      'RR', 'RS', 'SC', 'SE', 'SP', 'TO', 'EX');
  var
    i: integer;
    Encontrado: Boolean;
begin
  i := 0;
  Encontrado := False;
  while (not (Encontrado)) and (i <= 27) do
  begin
    Encontrado := _ListaUF[i] = pUF;
    inc(i);
  end;

  Result := Encontrado;
end;

function VerificaCEP(pCep: string; pEstado: string): Boolean;
var
  cCEP1: Integer;
begin
  if pCep = '' then
  begin
    Result := False;
    Exit;
  end;

  cCEP1 := StrToInt(copy(pCep, 1, 3));

  if Length(trim(pCep)) > 0 then
  begin
    if Length(trim(copy(pCep, 6, 3))) < 3 then
      Result := False
    else
    if (pEstado = 'SP') and (cCEP1 >= 10) and (cCEP1 <= 199) then
      Result := True
    else
    if (pEstado = 'RJ') and (cCEP1 >= 200) and (cCEP1 <= 289) then
      Result := True
    else
    if (pEstado = 'ES') and (cCEP1 >= 290) and (cCEP1 <= 299) then
      Result := True
    else
    if (pEstado = 'MG') and (cCEP1 >= 300) and (cCEP1 <= 399) then
      Result := True
    else
    if (pEstado = 'BA') and (cCEP1 >= 400) and (cCEP1 <= 489) then
      Result := True
    else
    if (pEstado = 'SE') and (cCEP1 >= 490) and (cCEP1 <= 499) then
      Result := True
    else
    if (pEstado = 'PE') and (cCEP1 >= 500) and (cCEP1 <= 569) then
      Result := True
    else
    if (pEstado = 'AL') and (cCEP1 >= 570) and (cCEP1 <= 579) then
      Result := True
    else
    if (pEstado = 'PB') and (cCEP1 >= 580) and (cCEP1 <= 589) then
      Result := True
    else
    if (pEstado = 'RN') and (cCEP1 >= 590) and (cCEP1 <= 599) then
      Result := True
    else
    if (pEstado = 'CE') and (cCEP1 >= 600) and (cCEP1 <= 639) then
      Result := True
    else
    if (pEstado = 'PI') and (cCEP1 >= 640) and (cCEP1 <= 649) then
      Result := True
    else
    if (pEstado = 'MA') and (cCEP1 >= 650) and (cCEP1 <= 659) then
      Result := True
    else
    if (pEstado = 'PA') and (cCEP1 >= 660) and (cCEP1 <= 688) then
      Result := True
    else
    if (pEstado = 'AM') and ((cCEP1 >= 690) and (cCEP1 <= 692) or (cCEP1 >= 694) and (cCEP1 <= 698)) then
      Result := True
    else
    if (pEstado = 'AP') and (cCEP1 = 689) then
      Result := True
    else
    if (pEstado = 'RR') and (cCEP1 = 693) then
      Result := True
    else
    if (pEstado = 'AC') and (cCEP1 = 699) then
      Result := True
    else
    if ((pEstado = 'DF') or (pEstado = 'GO')) and (cCEP1 >= 700) and (cCEP1 <= 769) then
      Result := True
    else
    if (pEstado = 'TO') and (cCEP1 >= 770) and (cCEP1 <= 779) then
      Result := True
    else
    if (pEstado = 'MT') and (cCEP1 >= 780) and (cCEP1 <= 788) then
      Result := True
    else
    if (pEstado = 'MS') and (cCEP1 >= 790) and (cCEP1 <= 799) then
      Result := True
    else
    if (pEstado = 'RO') and (cCEP1 = 789) then
      Result := True
    else
    if (pEstado = 'PR') and (cCEP1 >= 800) and (cCEP1 <= 879) then
      Result := True
    else
    if (pEstado = 'SC') and (cCEP1 >= 880) and (cCEP1 <= 899) then
      Result := True
    else
    if (pEstado = 'RS') and (cCEP1 >= 900) and (cCEP1 <= 999) then
      Result := True
    else
      Result := False
  end
  else
    Result := True;
end;

{ Valida a inscrição estadual }
function VerificaInscEstadual(pInscricao, pTipo: string): Boolean;
  var
    Contador: ShortInt;
    Casos: ShortInt;
    Digitos: ShortInt;

    Tabela_1: string;
    Tabela_2: string;
    Tabela_3: string;

    Base_1: string;
    Base_2: string;
    Base_3: string;

    Valor_1: ShortInt;

    Soma_1: Integer;
    Soma_2: Integer;

    Erro_1: ShortInt;
    Erro_2: ShortInt;
    Erro_3: ShortInt;

    Posicao_1: string;
    Posicao_2: string;

    Tabela: string;
    Rotina: string;
    Modulo: ShortInt;
    Peso: string;

    Digito: ShortInt;

    Resultado: string;
    Retorno: Boolean;
begin
  { Isento ja e aceito }
  if (pInscricao = 'ISENTO') or (Trim(pInscricao) = '') then
  begin
    Result := True;
    Exit;
  end;

  { Inscrição de produtor rural, não validar }
  if (Copy(pInscricao, 1, 2) = 'PR') then
  begin
    Result := True;
    Exit;
  end;

  try
    Tabela_1 := ' ';
    Tabela_2 := ' ';
    Tabela_3 := ' ';

    {                                                                               }
    {                                                                               }
    {         Valores possiveis para os digitos (j)                                 }
    {                                                                               }
    { 0 a 9 = Somente o digito indicado.                                            }
    {     N = Numeros 0 1 2 3 4 5 6 7 8 ou 9                                        }
    {     A = Numeros 1 2 3 4 5 6 7 8 ou 9                                          }
    {     B = Numeros 0 3 5 7 ou 8                                                  }
    {     C = Numeros 4 ou 7                                                        }
    {     D = Numeros 3 ou 4                                                        }
    {     E = Numeros 0 ou 8                                                        }
    {     F = Numeros 0 1 ou 5                                                      }
    {     G = Numeros 1 7 8 ou 9                                                    }
    {     H = Numeros 0 1 2 ou 3                                                    }
    {     I = Numeros 0 1 2 3 ou 4                                                  }
    {     J = Numeros 0 ou 9                                                        }
    {     K = Numeros 1 2 3 ou 9                                                    }
    {                                                                               }
    { ----------------------------------------------------------------------------- }
    {                                                                               }
    {         Valores possiveis para as rotinas (d) e (g)                           }
    {                                                                               }
    { A a E = Somente a Letra indicada.                                             }
    {     0 = B e D                                                                 }
    {     1 = C e E                                                                 }
    {     2 = A e E                                                                 }
    {                                                                               }
    { ----------------------------------------------------------------------------- }
    {                                                                               }
    {                                  C T  F R M  P  R M  P                        }
    {                                  A A  A O O  E  O O  E                        }
    {                                  S M  T T D  S  T D  S                        }
    {                                                                               }
    {                                  a b  c d e  f  g h  i  jjjjjjjjjjjjjj        }
    {                                  0000000001111111111222222222233333333        }
    {                                  1234567890123456789012345678901234567        }

    if pTipo = 'AC'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     01NNNNNNX.14.00';
    if pTipo = 'AC'   then Tabela_2 := '2.13.0.E.11.02.E.11.01. 01NNNNNNNNNXY.13.14';
    if pTipo = 'AL'   then Tabela_1 := '1.09.0.0.11.01. .  .  .     24BNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_1 := '1.09.0.1.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_2 := '2.09.1.1.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AP'   then Tabela_3 := '3.09.0.E.11.01. .  .  .     03NNNNNNX.14.00';
    if pTipo = 'AM'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0CNNNNNNX.14.00';
    if pTipo = 'BA'   then Tabela_1 := '1.08.0.E.10.02.E.10.03.      NNNNNNYX.14.13';
    if pTipo = 'BA'   then Tabela_2 := '2.08.0.E.11.02.E.11.03.      NNNNNNYX.14.13';
    if pTipo = 'CE'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0NNNNNNNX.14.13';
    if pTipo = 'DF'   then Tabela_1 := '1.13.0.E.11.02.E.11.01. 07DNNNNNNNNXY.13.14';
    if pTipo = 'ES'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     0ENNNNNNX.14.00';
    if pTipo = 'GO'   then Tabela_1 := '1.09.1.E.11.01. .  .  .     1FNNNNNNX.14.00';
    if pTipo = 'GO'   then Tabela_2 := '2.09.0.E.11.01. .  .  .     1FNNNNNNX.14.00';
    if pTipo = 'MA'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     12NNNNNNX.14.00';
    if pTipo = 'MT'   then Tabela_1 := '1.11.0.E.11.01. .  .  .   NNNNNNNNNNX.14.00';
    if pTipo = 'MS'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     28NNNNNNX.14.00';
    if pTipo = 'MG'   then Tabela_1 := '1.13.0.2.10.10.E.11.11. NNNNNNNNNNNXY.13.14';
    if pTipo = 'PA'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     15NNNNNNX.14.00';
    if pTipo = 'PB'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     16NNNNNNX.14.00';
    if pTipo = 'PR'   then Tabela_1 := '1.10.0.E.11.09.E.11.08.    NNNNNNNNXY.13.14';
    if pTipo = 'PE'   then Tabela_1 := '1.14.1.E.11.07. .  .  .18ANNNNNNNNNNX.14.00';
    if pTipo = 'PI'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     19NNNNNNX.14.00';
    if pTipo = 'RJ'   then Tabela_1 := '1.08.0.E.11.08. .  .  .      GNNNNNNX.14.00';
    if pTipo = 'RN'   then Tabela_1 := '1.09.0.0.11.01. .  .  .     20HNNNNNX.14.00';
    if pTipo = 'RS'   then Tabela_1 := '1.10.0.E.11.01. .  .  .    INNNNNNNNX.14.00';
    if pTipo = 'RO'   then Tabela_1 := '1.09.1.E.11.04. .  .  .     ANNNNNNNX.14.00';
    if pTipo = 'RO'   then Tabela_2 := '2.14.0.E.11.01. .  .  .NNNNNNNNNNNNNX.14.00';
    if pTipo = 'RR'   then Tabela_1 := '1.09.0.D.09.05. .  .  .     24NNNNNNX.14.00';
    if pTipo = 'SC'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    if pTipo = 'SP'   then Tabela_1 := '1.12.0.D.11.12.D.11.13.  NNNNNNNNXNNY.11.14';
    if pTipo = 'SP'   then Tabela_2 := '2.12.0.D.11.12. .  .  .  NNNNNNNNXNNN.11.00';
    if pTipo = 'SE'   then Tabela_1 := '1.09.0.E.11.01. .  .  .     NNNNNNNNX.14.00';
    if pTipo = 'TO'   then Tabela_1 := '1.11.0.E.11.06. .  .  .   29JKNNNNNNX.14.00';
    if pTipo = 'CNPJ' then Tabela_1 := '1.14.0.E.11.21.E.11.22.NNNNNNNNNNNNXY.13.14';
    if pTipo = 'CPF'  Then Tabela_1 := '1.11.0.E.11.31.E.11.32.   NNNNNNNNNXY.13.14';

    { Deixa somente os numeros }
    Base_1 := '';

    for Contador := 1 to 30 do
    begin
      if Pos(Copy(pInscricao, Contador, 1), '0123456789') <> 0 then
        Base_1 := Base_1 + Copy(pInscricao, Contador, 1);
    end;

    { Repete 3x - 1 para cada caso possivel }
    Casos := 0;

    Erro_1 := 0;
    Erro_2 := 0;
    Erro_3 := 0;

    while Casos < 3 do
    begin

      Casos := Casos + 1;

      IF Casos = 1 Then Tabela := Tabela_1;
      IF Casos = 2 Then Erro_1 := Erro_3  ;
      IF Casos = 2 Then Tabela := Tabela_2;
      IF Casos = 3 Then Erro_2 := Erro_3  ;
      IF Casos = 3 Then Tabela := Tabela_3;

      Erro_3 := 0;

      if Copy(Tabela, 1, 1) <> ' ' then
      begin

        { Verifica o Tamanho }
        if Length(Trim(Base_1)) <> (StrToInt(Copy(Tabela, 3, 2))) then
          Erro_3 := 1;

        if Erro_3 = 0 then
        begin

          { Ajusta o Tamanho }
          Base_2 := Copy('              ' + Base_1, Length('              ' + Base_1) - 13, 14);

          { Compara com valores possivel para cada uma da 14 posições }
          Contador := 0;

          while (Contador < 14) and (Erro_3 = 0) do
          begin

            Contador := Contador + 1;

            Posicao_1 := Copy(Copy(Tabela, 24, 14), Contador, 1);
            Posicao_2 := Copy(Base_2, Contador, 1);

            if ( Posicao_1  = ' '        ) and (      Posicao_2                 <> ' ' ) then Erro_3 := 1;
            if ( Posicao_1  = 'N'        ) and ( Pos( Posicao_2, '0123456789' )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'A'        ) and ( Pos( Posicao_2, '123456789'  )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'B'        ) and ( Pos( Posicao_2, '03578'      )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'C'        ) and ( Pos( Posicao_2, '47'         )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'D'        ) and ( Pos( Posicao_2, '34'         )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'E'        ) and ( Pos( Posicao_2, '08'         )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'F'        ) and ( Pos( Posicao_2, '015'        )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'G'        ) and ( Pos( Posicao_2, '1789'       )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'H'        ) and ( Pos( Posicao_2, '0123'       )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'I'        ) and ( Pos( Posicao_2, '01234'      )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'J'        ) and ( Pos( Posicao_2, '09'         )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1  = 'K'        ) and ( Pos( Posicao_2, '1239'       )  =   0 ) then Erro_3 := 1;
            if ( Posicao_1 <>  Posicao_2 ) and ( Pos( Posicao_1, '0123456789' )  >   0 ) then Erro_3 := 1;

          end;

          { Calcula os Digitos }
          Rotina := ' ';
          Digitos := 000;
          Digito := 000;

          while (Digitos < 2) and (Erro_3 = 0) do
          begin

            Digitos := Digitos + 1;

            { Carrega peso }
            Peso := Copy(Tabela, 5 + (Digitos * 8), 2);

            if Peso <> '  ' then
            begin

              Rotina := Copy(Tabela, 0 + (Digitos * 8), 1);
              Modulo := StrToInt(Copy(Tabela, 2 + (Digitos * 8), 2));

              if Peso = '01' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              if Peso = '02' then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              if Peso = '03' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.00.02';
              if Peso = '04' then Peso := '00.00.00.00.00.00.00.00.06.05.04.03.02.00';
              if Peso = '05' then Peso := '00.00.00.00.00.01.02.03.04.05.06.07.08.00';
              if Peso = '06' then Peso := '00.00.00.09.08.00.00.07.06.05.04.03.02.00';
              if Peso = '07' then Peso := '05.04.03.02.01.09.08.07.06.05.04.03.02.00';
              if Peso = '08' then Peso := '08.07.06.05.04.03.02.07.06.05.04.03.02.00';
              if Peso = '09' then Peso := '07.06.05.04.03.02.07.06.05.04.03.02.00.00';
              if Peso = '10' then Peso := '00.01.02.01.01.02.01.02.01.02.01.02.00.00';
              if Peso = '11' then Peso := '00.03.02.11.10.09.08.07.06.05.04.03.02.00';
              if Peso = '12' then Peso := '00.00.01.03.04.05.06.07.08.10.00.00.00.00';
              if Peso = '13' then Peso := '00.00.03.02.10.09.08.07.06.05.04.03.02.00';
              if Peso = '21' then Peso := '05.04.03.02.09.08.07.06.05.04.03.02.00.00';
              if Peso = '22' then Peso := '06.05.04.03.02.09.08.07.06.05.04.03.02.00';
              if Peso = '31' then Peso := '00.00.00.10.09.08.07.06.05.04.03.02.00.00';
              if Peso = '32' then Peso := '00.00.00.11.10.09.08.07.06.05.04.03.02.00';

              { Multiplica }
              Base_3 := Copy(('0000000000000000' + Trim(Base_2)), Length(('0000000000000000' + Trim(Base_2))) - 13, 14);

              Soma_1 := 0;
              Soma_2 := 0;

              for Contador := 1 to 14 do
              begin

                Valor_1 := (StrToInt(Copy(Base_3, Contador, 01)) * StrToInt(Copy(Peso, Contador * 3 - 2, 2)));

                Soma_1 := Soma_1 + Valor_1;

                if Valor_1 > 9 then
                  Valor_1 := Valor_1 - 9;

                Soma_2 := Soma_2 + Valor_1;

              end;

              { Ajusta valor da soma }
              if Pos( Rotina, 'A2'  ) > 0 then Soma_1 := Soma_2;
              if Pos( Rotina, 'B0'  ) > 0 then Soma_1 := Soma_1 * 10;
              if Pos( Rotina, 'C1'  ) > 0 then Soma_1 := Soma_1 + ( 5 + 4 * StrToInt( Copy( Tabela, 6, 1 ) ) );

              { Calcula o Digito }
              if Pos( Rotina, 'D0'  ) > 0 then Digito := Soma_1 Mod Modulo;
              if Pos( Rotina, 'E12' ) > 0 then Digito := Modulo - ( Soma_1 Mod Modulo);

              if Digito < 10 then Resultado := IntToStr( Digito );
              if Digito = 10 then Resultado := '0';
              if Digito = 11 then Resultado := Copy( Tabela, 6, 1 );

              { Verifica o Digito }
              if (Copy(Base_2, StrToInt(Copy(Tabela, 36 + (Digitos * 3), 2)), 1) <> Resultado) then
                Erro_3 := 1;
            end;
          end;
        end;
      end;
    end;

    { Retorna o resultado da Verificação }
    Retorno := FALSE;

    if (Trim(Tabela_1) <> '') and (ERRO_1 = 0) then Retorno := TRUE;
    if (Trim(Tabela_2) <> '') and (ERRO_2 = 0) then Retorno := TRUE;
    if (Trim(Tabela_3) <> '') and (ERRO_3 = 0) then Retorno := TRUE;

    if Trim(pInscricao) = 'ISENTO' then Retorno := TRUE;

    Result := Retorno;
  except
    Result := False;
  end;
end;

{ Verifica se o CPF/CNPJ e Valido }
function VerificaCPF_CNPJ(ANumero: string): Boolean;
var
  n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12: integer;
  d1, d2: integer;
  Digitado, Calculado: string;
begin
  Result := False;

  ANumero := TUteis.SomenteNumeros(ANumero);

  if Length(ANumero) = 11 then
  begin
    n1 := StrToInt(ANumero[1]);
    n2 := StrToInt(ANumero[2]);
    n3 := StrToInt(ANumero[3]);
    n4 := StrToInt(ANumero[4]);
    n5 := StrToInt(ANumero[5]);
    n6 := StrToInt(ANumero[6]);
    n7 := StrToInt(ANumero[7]);
    n8 := StrToInt(ANumero[8]);
    n9 := StrToInt(ANumero[9]);

    d1 := n9 * 2 + n8 * 3 + n7 * 4 + n6 * 5 + n5 * 6 + n4 * 7 + n3 * 8 + n2 * 9 + n1 * 10;
    d1 := 11 - (d1 mod 11);

    if d1 >= 10 then
      d1 := 0;

    d2 := d1 * 2 + n9 * 3 + n8 * 4 + n7 * 5 + n6 * 6 + n5 * 7 + n4 * 8 + n3 * 9 + n2 * 10 + n1 * 11;
    d2 := 11 - (d2 mod 11);

    if d2 >= 10 then
      d2 := 0;

    Calculado := IntToStr(d1) + IntToStr(d2);
    Digitado  := ANumero[10] + ANumero[11];

    if Calculado = Digitado then
      Result := True;
  end;

  if Length(ANumero) = 14 then
  begin
    n1 := StrToInt(ANumero[1]);
    n2 := StrToInt(ANumero[2]);
    n3 := StrToInt(ANumero[3]);
    n4 := StrToInt(ANumero[4]);
    n5 := StrToInt(ANumero[5]);
    n6 := StrToInt(ANumero[6]);
    n7 := StrToInt(ANumero[7]);
    n8 := StrToInt(ANumero[8]);
    n9 := StrToInt(ANumero[9]);
    n10 := StrToInt(ANumero[10]);
    n11 := StrToInt(ANumero[11]);
    n12 := StrToInt(ANumero[12]);

    d1 := n12 * 2 + n11 * 3 + n10 * 4 + n9 * 5 + n8 * 6 + n7 * 7 + n6 * 8 + n5 * 9 + n4 * 2 + n3 * 3 + n2 * 4 + n1 * 5;
    d1 := 11 - (d1 mod 11);

    if d1 >= 10 then
      d1 := 0;

    d2 := d1 * 2 + n12 * 3 + n11 * 4 + n10 * 5 + n9 * 6 + n8 * 7 + n7 * 8 + n6 * 9 + n5 * 2 + n4 * 3 + n3 * 4 + n2 * 5 + n1 * 6;
    d2 := 11 - (d2 mod 11);

    if d2 >= 10 then
      d2 := 0;

    Calculado := IntToStr(d1) + IntToStr(d2);
    Digitado := ANumero[13] + ANumero[14];

    if Calculado = Digitado then
      Result := True;
  end;
end;

function ReplaceStr (pText,pOldString,pNewString:string):string;
  var atual, strtofind, originalstr:pchar;
      NewText:string;
      lenoldstring,lennewstring,m,index:integer;
begin //ReplaceStr
  NewText:=pText;
  originalstr:=pchar(pText);
  strtofind:=pchar(pOldString);
  lenoldstring:=length(pOldString);
  lennewstring:=length(pNewString);
  Atual:=StrPos(OriginalStr,StrtoFind);
  index:=0;

  while Atual <> nil do
  begin //Atual<>nil
  m:=Atual - OriginalStr - index + 1;
  Delete(NewText,m,lenoldstring);
  Insert(pNewString,NewText,m);
  inc(index,lenoldstring-lennewstring);
  Atual:=StrPos(Atual+lenoldstring,StrtoFind);
  end; //Atual<>nil

  Result:=NewText;
end; //ReplaceStr

function GetBuildInfo(PBuild: Boolean ):string;
  var
    VerInfoSize: DWORD;
    VerInfo: Pointer;
    VerValueSize: DWORD;
    VerValue: PVSFixedFileInfo;
    Dummy: DWORD;
    V1, V2, V3, V4: Word;
    Prog : string;
begin
  try
    Prog := Application.Exename;
    VerInfoSize := GetFileVersionInfoSize(PChar(prog), Dummy);
    GetMem(VerInfo, VerInfoSize);
    GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);

    with VerValue^ do
    begin
      V1 := dwFileVersionMS shr 16;
      V2 := dwFileVersionMS and $FFFF;
      V3 := dwFileVersionLS shr 16;
      V4 := dwFileVersionLS and $FFFF;
    end;

    FreeMem(VerInfo, VerInfoSize);
    result := IntToStr(v1) + '.' +
              IntToStr(v2) + '.' +
              IntToStr(v3);
    if PBuild then
      Result := Result + '.' +IntToStr(v4);

  except
    Result := 'ND';
  end;
end;

function RemoveCaracter(pValor,pCaracter: string):string;
var
  I: Integer;
begin
  repeat
    I := Pos(pCaracter,pValor);
    if I > 0 then
    begin
      Delete(pValor,I,Length(pCaracter));
      Result := pValor;
    end
    else
    begin
      Result := pValor;
    end;
  until I = 0;
end;

function RemoveAcentos(pStr:String): String;
{Remove caracteres acentuados de uma string}
  Const _ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
        _SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
  var x: Integer;
begin
  for x := 1 to Length(pStr) do
    begin
      if Pos(pStr[x],_ComAcento)<>0 Then
      begin
        pStr[x] := _SemAcento[Pos(pStr[x],_ComAcento)];
      end;
    end;
  Result := pStr;
end;

function UpperCaseComAcentos(pStr:String): String;
  {Remove caracteres acentuados de uma string}
  Const _Minusculo = 'àâêôûãõáéíóúçü';
        _Maiusculo = 'ÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
  var x : Integer;
begin
  pStr := UpperCase(pStr);
  for x := 1 to Length(pStr) do
  Begin
    if Pos(pStr[x],_Minusculo) <> 0 Then
    begin
      pStr[x] := _Maiusculo[Pos(pStr[x],_Minusculo)];
    end;
  end;
  Result := pStr;
end;

function DataSemBarrasFor(pData,pFormato: String): String;
  var DATASEMB: String;
begin
  DATASEMB := DataSemBarras(pData);
  if pFormato = 'ddmmyyyy' then
    Result := DATASEMB
  else
  if pFormato = 'ddmmyy' then
    Result := Trim(Copy(DATASEMB,1,4))+Trim(Copy(DATASEMB,7,2))
  else
  if pFormato = 'yyyymmdd' then
    Result := Trim(Copy(DATASEMB,5,4))+Trim(Copy(DATASEMB,3,2))+Trim(Copy(DATASEMB,1,2));
end;

function TColorToHex(pColor : TColor) : string;
begin
   Result :=
     IntToHex(GetRValue(pColor), 2) +
     IntToHex(GetGValue(pColor), 2) +
     IntToHex(GetBValue(pColor), 2) ;
end;

function HexToTColor(pColor : string) : TColor;
begin
   Result :=
     RGB(
       StrToInt('$'+Copy(pColor, 1, 2)),
       StrToInt('$'+Copy(pColor, 3, 2)),
       StrToInt('$'+Copy(pColor, 5, 2))
     ) ;
end;

function ArredondarDEC(pValor: Double; pDec: Integer): Double;
  var Valor1, Numero1, Numero2, Numero3: Double;
begin
  Valor1:=Exp(Ln(10) * (pDec + 1));
  Numero1:=Int(pValor * Valor1);
  Numero2:=(Numero1 / 10);
  Numero3:=Round(Numero2);
  Result:=(Numero3 / (Exp(Ln(10) * pDec)));
end;

function EnviaEmail(pSMTPServer, pUsuario, pSenha, pNomeOri, pEmailResp, pNomeDest,
                    pEmailDest, pAssunto, pTexto, pAnexo: string): Boolean;
  var IdMessage: TIdMessage;
      IdSMTP: TIdSMTP;
      X: Integer;
      ListaEmail: TStringList;

  function GetListaEmail: String;
    var I: Integer;
        sl: TStringList;
        TmpText: string;
  begin
    I := 0;
    sl := nil;
    try
      sl := TStringList.Create;
      TmpText := pEmailDest;
      repeat
        if Trim(TmpText) = EmptyStr then
        begin
          Break;
        end;

        I := Pos(',',TmpText);
        if I > 0 then
        begin
          sl.Add(Copy(TmpText,1,I-1));
          Delete(TmpText,1,I);
        end
        else
          sl.Add(TmpText);
      until(I = 0);
    finally
      Result := sl.Text;
      sl.Free;
    end;
  end;

begin
  IdMessage := nil;
  IdSMTP := nil;
  ListaEmail  := nil;
  try
    try
      IdMessage := TIdMessage.Create(Application);
      IdMessage.Name := 'IdMessageUteis';

      IdSMTP := TIdSMTP.Create(Application);
      IdSMTP.Name := 'IdSMTPUteis';

      ListaEmail := TStringList.Create;

      with IdSMTP do
      begin
        Host     := Trim(pSMTPServer);
        Username := Trim(pUsuario);
        Password := pSenha;
        //AuthenticationType := atLogin;
        Port := 25;
        ReadTimeout := 0;
      end;

      with IdMessage do
      begin
        AttachmentEncoding := 'MIME';
        Encoding := meMIME;
        From.Name := pNomeOri;
        From.Address := pEmailResp;
        ListaEmail.Text := GetListaEmail;
        for X := 0 to ListaEmail.Count - 1 do
        begin
          Recipients.Add.Address := ListaEmail.Strings[X];
          Recipients.Items[X].Name := pNomeDest;
        end;
        Subject := pAssunto;
        Body.Add(pTexto);
        //TIdAttachment.Create(IdMessage.MessageParts,Anexo);
      end;

      IdSMTP.Connect();
      if IdSMTP.Connected then
      begin
        IdSMTP.Send(IdMessage);
        Result := True;
      end
      else
        Result := False;
    except
      on E: Exception do
      begin
        Result := False;
        TMensagens.ShowMessage(E.Message);
      end;
    end;
  finally
    IdMessage.Free;
    IdSMTP.Free;
    ListaEmail.Free;
  end;
end;

function DeleteFolder(pFolderName: String; pLeaveFolder: Boolean): Boolean;
  var r: TshFileOpStruct;
begin
  Result := False;
  if not DirectoryExists(pFolderName) then
  begin
    Exit;
  end;
  if pLeaveFolder then
  begin
    pFolderName := pFolderName + ' *.* ';
  end
  else
  begin
    if pFolderName[Length(pFolderName)] = ' \ ' then
    begin
      Delete(pFolderName,Length(pFolderName), 1);
    end;
  end;
  FillChar(r, SizeOf(r), 0);
  r.wFunc := FO_DELETE;
  r.pFrom := PChar(pFolderName);
  r.fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMATION;
  Result := ((ShFileOperation(r) = 0) and (not r.fAnyOperationsAborted));
end;

function ConectadoInternet: TTipoConexaoInternet;
var
  flags: DWORD;
begin
  if InternetGetConnectedState(@flags, 0) then
  begin
    if (flags and INTERNET_CONNECTION_MODEM) = INTERNET_CONNECTION_MODEM then
      Result := FtciModem
    else
    if (flags and INTERNET_CONNECTION_LAN) = INTERNET_CONNECTION_LAN then
      Result := FtciLAN
    else
    if (flags and INTERNET_CONNECTION_PROXY) = INTERNET_CONNECTION_PROXY then
      Result := FtciProxy
    else
    if (flags and INTERNET_CONNECTION_MODEM_BUSY) = INTERNET_CONNECTION_MODEM_BUSY then
      Result := FtciModemOcupado
    else
      Result := FtciNaoConectado;
  end
  else
  begin
    Result := FtciNaoConectado;
  end;
end;

function VersaoWindows(pTipo: TTipoInfWindows): string;
  var str: String;
      verInfo : TOsVersionInfo;
      I : Word;
begin
  verInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(verInfo) then
  begin
    case pTipo of
      FVersao : Result := IntToStr(verInfo.dwMajorVersion) + '.' +
                          IntToStr(verInfo.dwMinorVersion);
      FCompilacao : Result := IntToStr(verInfo.dwBuildNumber);
      FOsName : begin
                  case verInfo.dwPlatformId of
                    VER_PLATFORM_WIN32s : Result := 'Windows 95';
                    VER_PLATFORM_WIN32_WINDOWS : Result := 'Windows 95 Osr2 / 98';
                    VER_PLATFORM_WIN32_NT : Result := 'Windows NT';
                  end;
                end;
      FInfAdicionais : begin
                         str := '';
                         for I := 0 to 127 do
                           str := str + verInfo.szCSDVersion[I];

                         Result := str;
                       end;
    end;
  end;
end;

function HMStoSecs(pTempo:String):Integer;
  var h,m,s,x:Integer;
begin
  X := 0;
  if Length(pTempo) = 9 then
  begin
    h:=StrtoInt(Copy(pTempo,1,3));
    m:=StrtoInt(Copy(pTempo,5,2));
    s:=StrtoInt(Copy(pTempo,8,2));
    x:=(s+(m*60)+(h*3600));
  end
  else
  if Length(pTempo) <= 8 then
  begin
    h:=StrtoInt(Copy(pTempo,1,2));
    m:=StrtoInt(Copy(pTempo,4,2));
    s:=StrtoInt(Copy(pTempo,7,2));
    x:=(s+(m*60)+(h*3600));
  end;

  Result:=x;
end;

Function HoraToMin(pHora: String): Integer;
begin
  Result := (StrToInt(Copy(pHora,1,2))*60) + StrToInt(Copy(pHora,4,2));
end;

function FilterChars(const _Str: string; const _ValidChars: TChars): string;
  var
    I: integer;
begin
  Result := '';
  for I := 1 to Length(_Str) do
  begin
    if _Str[I] in _ValidChars then
      Result := Result + _Str[I];
  end;
end;

function FloatToSQL(pValue: Real): string;
  var StrAux: string;
begin
  StrAux := FloatToStr(pValue);

  StrAux := AnsiReplaceStr(StrAux,'.','');
  StrAux := AnsiReplaceStr(StrAux,',','.');

  Result := StrAux;
end;

function MontarFiltroData(pDataInicial,pDataFinal: TDate; pCondicao: string;
  pIncluirHora: Boolean): string;
begin
  if (pDataInicial > 0) and (pDataFinal > 0) then
  begin
    if pIncluirHora then
    begin
      Result := pCondicao+' BETWEEN '+ QuotedStr(SQLDATA(pDataInicial,False,False)+' 00:00:00')+
                ' AND '+QuotedStr(SQLDATA(pDataFinal,False,False)+' 23:59:59');
    end
    else
    begin
      Result := pCondicao+' BETWEEN '+SQLDATA(pDataInicial,True,False)+
                ' AND '+SQLDATA(pDataFinal,True,False);
    end;
  end
  else
  if (pDataInicial > 0) and (pDataFinal = 0) then
    Result := pCondicao + ' >= ' + SQLDATA(pDataInicial,True,False)
  else
  if (pDataInicial = 0) and (pDataFinal > 0) then
  begin
    if pIncluirHora then
    begin
      Result := pCondicao+' <= '+ QuotedStr(SQLDATA(pDataFinal,False,False)+' 23:59:59');
    end
    else
    begin
      Result := pCondicao+' <= '+ SQLDATA(pDataFinal,True,False);
    end;
  end
  else
    Result := '';
end;

function MontarFiltroInteiro(aCodIni,aCodFin: Integer; aCondicao: string): string;
begin
  if (aCodIni > 0) and (aCodFin > 0) then
  begin
    Result := aCondicao+' BETWEEN '+IntToStr(aCodIni)+' AND '+IntToStr(aCodFin);
  end
  else
  if (aCodIni > 0) and (aCodFin = 0) then
  begin
    Result := aCondicao+' >= '+IntToStr(aCodIni);
  end
  else
  if (aCodIni = 0) and (aCodFin > 0) then
  begin
    Result := aCondicao+' <= '+IntToStr(aCodFin);
  end
  else
  begin
    Result := '';
  end;
end;

function ConvertImagemField(var Field: TBlobField): TMemoryStream;
  var pJpeg: TJPEGImage;
      pBmp: TBitmap;
      //Caminho: string;
      TipoImagem: TFormatoImagem;
      Stream: TMemoryStream;
begin
  Result := nil;
  if (not Field.IsNull) then
  begin
    pBmp := TBitmap.Create;
    pJpeg := TJPEGImage.Create;
    Stream := TMemoryStream.Create;
    try
      TipoImagem := FiDesconhecido;
      {Caminho := TUteis.CaminhoTempDir + 'foto.tmp';

      if FileExists(Caminho) then
        DeleteFile(Caminho);}

      //TBlobField(Field).SaveToFile(Caminho);
      TBlobField(Field).SaveToStream(Stream);
      Stream.Position := 0;

      try
        pJpeg.LoadFromStream(Stream);
        TipoImagem := FiJpeg;
      except
        TipoImagem := FiDesconhecido;
      end;

      if TipoImagem = FiDesconhecido then
      begin
        try
          pBmp.LoadFromStream(Stream);
          TipoImagem := FiBmp;
        except
          TipoImagem := FiDesconhecido;
        end;
      end;

      //DeleteFile(Caminho);

      if TipoImagem = FiDesconhecido then
        Exit;

      if TipoImagem = FiJpeg then
      begin
        pJpeg.DIBNeeded;
        pBmp.Assign(pJpeg);
      end;

      Stream.Position := 0;

      pBmp.SaveToStream(Stream);

      Stream.Position := 0;

      Field.DataSet.Edit;
      TBlobField(Field).LoadFromStream(Stream);
      Field.DataSet.Post;

      Result := Stream;

      //DeleteFile(Caminho);
    finally
      pBmp.Free;
      pJpeg.Free;
      Stream.Free;
    end;
  end;
end;

function JpegToBmp(pFileName: TFileName): TFileName;
  var pJpeg: TJPEGImage;
      pBmp:  TBitmap;
begin
  pJpeg := TJPEGImage.Create;
  try
    pJpeg.CompressionQuality := 100; {Default Value}
    pJpeg.LoadFromFile(pFileName);
    pBmp := TBitmap.Create;
    try
      pBmp.Assign(pJpeg);
      Result := ChangeFileExt(pFileName, '.bmp');
      pBmp.SaveTofile(Result);
    finally
      pBmp.Free
    end;
  finally
    pJpeg.Free
  end;
end;

function CarregaForm(const _Pacote, _Classe: String): TFormClass;
var
  AClass: TPersistentClass;
  FormClass: TFormClass;
  HandlePack: HModule;
begin
  Result := nil;

  //tenta carregar o pacote
  HandlePack := LoadPackage(TUteis.CaminhoAplicacao + _Pacote);
  if HandlePack > 0 then
  begin
    try
      try
        AClass := FindClass(_Classe);

        if Assigned(AClass) then
        begin
          Result := TFormClass(AClass);
        end;
      except

      end;
    finally
      //UnloadPackage(HandlePack);
    end;
  end;
end;

function Substituir(pTexto, pEncontrar, pSubstituir: string;
                    pTirarAcentos: Boolean = False): string;
begin
  pSubstituir := RemoveAcentos(pSubstituir);
  Result := ReplaceStr(pTexto,pEncontrar,pSubstituir);
end;

function GeraGUID: string;
var
  Guid: TGUID;
begin
  CreateGUID(Guid);
  Result := GUIDToString(Guid);
end;

function GetValueFromProperty(pProperty: TStrings; pItem: string): string;
begin
  Result := pProperty.Values[pItem];
end;

function ApenasNumeros(pValue: string): string;
const
  _Numeros = '0123456789';
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(pValue) do
  begin
    if Pos(pValue[I],_Numeros) > 0 then
    begin
      Result := Result + pValue[I];
    end;
  end;
end;

function CharToHex(pChar: Char): string;
  const
    _Escala = '0123456789ABCDEF';
  var
    Res, Num: Integer;
begin
  Num := Ord(pChar);
  Res := (Num div 16);
  Result := _Escala[Res + 1];
  Res := (Num - (Res * 16));
  Result := Result+_Escala[Res + 1];
end;

function StrToHex(pText: string): string;
  var I: Integer;
begin
  Result := '';
  for I := 0 to Length(pText)-1 do
  begin
    Result := Result + CharToHex(pText[I]);
  end;
end;

function GetDesktopFolder: string;
  var
    MyReg : TRegIniFile;
begin
  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  try
    Result := MyReg.ReadString ('Shell Folders','Desktop','');
    if not DirectoryExists(Result) then
      Result := TUteis.CaminhoAplicacao;
  finally
    MyReg.Free;
  end;
end;

procedure CriarAtalho(pFileName, pParameters, pInitialDir, pShortcutName,
                      pShortcutFolder : string);
  var
    MyObject : IUnknown;
    MySLink : IShellLink;
    MyPFile : IPersistFile;
    Directory : String;
    WFileName : WideString;
    MyReg : TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
    SetArguments(PWideChar(pParameters));
    SetPath(PWideChar(pFileName));
    SetWorkingDirectory(PWideChar(pInitialDir));
  end;

  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  try
    Directory := MyReg.ReadString ('Shell Folders','Desktop','');
    WFileName := Directory + '\' + pShortcutName + '.lnk';
    MyPFile.Save (PWideChar (WFileName), False);
  finally
    MyReg.Free;
  end;
end;

function QtdeToMascara(pQtde: Integer): string;
begin
  case pQtde of
    1: Result := '#,#0.0';
    2: Result := '#,##0.00';
    3: Result := '#,###0.000';
  else
    Result := '#,#0.0';
  end;
end;

procedure PopularCompoBox(pComponent: TCustomComboBox;
                          pPopularCom:TDadosPopular; pTamanhoIntervaloAno: Integer = 20);
  var
    I: Integer;
begin
  pComponent.Items.Clear;

  case pPopularCom of
    FdpAno: begin
              for I := YearOf(Date) - pTamanhoIntervaloAno to YearOf(Date) + 1  do
              begin
                pComponent.Items.Add(IntToStr(I));
              end;
              pComponent.ItemIndex := pComponent.Items.IndexOf(IntToStr(YearOf(Date)));
            end;
    FdpMes: begin
              with pComponent.Items do
              begin
                Add('Janeiro');
                Add('Fevereiro');
                Add('Março');
                Add('Abril');
                Add('Maio');
                Add('Junho');
                Add('Julho');
                Add('Agosto');
                Add('Setembro');
                Add('Outubro');
                Add('Novembro');
                Add('Dezembro');
              end;

              if pComponent is TJvDBComboBox then
              begin
                with pComponent as TJvDBComboBox do
                begin
                  Values.Add('1');
                  Values.Add('2');
                  Values.Add('3');
                  Values.Add('4');
                  Values.Add('5');
                  Values.Add('6');
                  Values.Add('7');
                  Values.Add('8');
                  Values.Add('9');
                  Values.Add('10');
                  Values.Add('11');
                  Values.Add('12');
                end;
              end;

              pComponent.ItemIndex := MonthOf(Date) -1;
            end;
  end;
end;

function VersaoSistema: string;
var
  StrAux: string;
  I: Integer;
begin
  Result := 'ND';
  StrAux := GetBuildInfo;
  I := Pos('.',StrAux);
  if I > 0 then
  begin
    Result := Copy(StrAux,1,I);

    if Length(Result) = 2 then
      Result := '0' + Result;

    Delete(StrAux,1,I);

    I := Pos('.',StrAux);
    if I > 0 then
      Result := Result + Copy(StrAux,1,I-1);
  end;
end;

procedure CreateDataSet(pDataSet: TClientDataSet);
begin
  with pDataSet do
  begin
    if FieldCount = 0 then
      Exit;

    IndexName := '';
    IndexFieldNames := '';
    Filter := '';
    Filtered := False;
    Close;
    CreateDataSet;
    Open;
  end;
end;

function KeyIsDown(const _Key: Integer): Boolean;
begin
  Result := GetKeyState(_Key) and 128 > 0;
end;

function VarToIntDef(const _Var: Variant; pDefault: Integer): Integer;
begin
  try
    if not VarIsNull(_Var) then
      Result := _Var
    else
      Result := pDefault;
  except
    Result := pDefault;
  end;
end;

function VarToInt(const _Var: Variant): Integer;
begin
  Result := VarToIntDef(_Var,0);
end;

function VarToRealDef(const _Var: Variant; pDefault: Real): Real;
begin
  try
    if not VarIsNull(_Var) then
      Result := _Var
    else
      Result := pDefault;
  except
    Result := pDefault;
  end;
end;

function VarToReal(const _Var: Variant): Real;
begin
  Result := VarToRealDef(_Var,0);
end;

function LengthArrayVar(pArray: Variant): Integer;
begin
  Result := 0;

  if VarIsArray(pArray) then
  begin
    Result := VarArrayHighBound(pArray,1) - VarArrayLowBound(pArray,1) + 1;
  end;
end;

function ChecaHora(pHora: string): Boolean;
begin
  try
    StrToTime(pHora);
    Result := True;
  except
    Result := False;
  end;
end;

function RetornaSoNumero(pNumero: string): string;
  var
    i: integer;
begin
  Result := '';
  for i := 1 to Length(pNumero) do
  begin
    if pNumero[i] in ['0'..'9'] then
      Result := Result + pNumero[i];
  end;
end;

function SetValueText(pText, pValue, pAntesDe: string): string;
  var Text01, Text02: string;
      I: Integer;
begin
  I := Pos(pAntesDe,pText);
  if I > 0 then
  begin
    Text01 := Copy(pText,1,I-1);
    Text02 := Copy(pText,I,Length(pText));
    Result := Text01 + ' ' + pValue + ' ' + Text02;
  end
  else
    Result := pText;
end;

function DescontoRateado(pValorTotal, pValor, pValorDescontado: Real): Real;
begin
  Result := 0;
  try
    Result := (pValorDescontado/pValorTotal)*pValor;
//    Result := (pValorDescontado*((pValor*100)/pValorTotal))/100;
  except
    Application.MessageBox('Erro ao Calcular Desconto! Verifique se os dados estão corretos.','Erro',MB_OK+MB_ICONERROR);
  end;
end;

function GetCampoDate(pData: TDate; pCampo: TCamposData): Word;
  var Dia,Mes,Ano: Word;
begin
  DecodeDate(pData,Ano,Mes,Dia);
  case pCampo of
    FDia: Result := Dia;
    FMes: Result := Mes;
    FAno: Result := Ano;
  else
    Result := Dia;
  end;
end;

function GetDescMes(pMes: Word): string;
begin
  if (pMes < 1) or (pMes > 12) then
    Result := 'Mês Inválido'
  else
    Result := _MesString[pMes];
end;

function NomeFile(pPath: string): string;
  var
    StrAux: string;
    I: Integer;
begin
  Result := '';
  StrAux := ReverseString(pPath);

  for I := 1 to Length(StrAux) do
  begin
    if (StrAux[I] = '\') or (StrAux[I] = '/') then
      Break;

    Result := Result + StrAux[I];
  end;

  Result := ReverseString(Result);
end;

function TempPath: string;
begin
  Result := ExtractFileName(Application.ExeName);
  Result := AnsiReplaceStr(Result,'.exe','');
  if Trim(Result) = '' then
    Result := 'RG';

  Result := TUteis.CaminhoTempDir + Result + '\';
end;

function TempPathDelOnExit: string;
begin
  Result := TempPath + 'Tmp\';
end;

procedure DeletaDir(const _RootDir:string);
  var
    SearchRec: tSearchREC;
    Erc:Integer;
begin
  try
    {$I-}
    ChDir(_RootDir);
    if IOResult <> 0 then
      Exit;

    FindFirst('*.*', faAnyFile, SearchRec);
    Erc:=0;
    while Erc=0 do
    begin
      if ((searchRec.Name <> '.') and (searchrec.Name<>'..')) then
      begin
        if (SearchRec.Attr and faDirectory>0) then
          DeletaDir(SearchRec.Name)
        else
         DeleteFile(Searchrec.Name);
      end;
      Erc:=FindNext ( SearchRec);
      Application.ProcessMessages;
    end;
  finally
    if Length (_RootDir)>3 then
      Chdir('..');
  end;
  RmDir(_RootDir);
  {$I+}
End;

procedure OrdenaDataSet(var CDS: TClientDataSet; pField: TField; pOrdem: TOrdem);
  const
    _idxDefault = 'DEFAULT_ORDER';
  var
    vStrColumn : string;
    vI         : Integer;
    vBolUsed   : Boolean;
    vIdOptions : TIndexOptions;
    I: Integer;
begin
  vStrColumn := _idxDefault;
//  RemoveIndex(CDS);

  if pField.FieldKind in [fkCalculated, fkLookup, fkAggregate] then
    Exit;

  if pField.DataType in [ftBlob, ftMemo] then
    Exit;

  vBolUsed := (pField.FieldName = CDS.IndexName);

  CDS.IndexDefs.Update;
  for vI := 0 to CDS.IndexDefs.Count - 1 do
  begin
    if CDS.IndexDefs.Items[vI].Name = pField.FieldName then
    begin
      vStrColumn := pField.FieldName;
    end;
  end;

  case pOrdem of
    oAscendente: vIdOptions := [];
    oDescendente: vIdOptions := [ixDescending];
  end;

  if (vStrColumn = _idxDefault) or (vBolUsed) then
  begin
    if vBolUsed then
    begin
      if pOrdem = oNenhuma then
      begin
        for I := 0 to CDS.IndexDefs.Count - 1 do
        begin
          if CDS.IndexDefs.Items[I].Name = pField.FieldName then
          begin
            case (CDS.IndexDefs.Items[I].Options = [ixDescending]) of
              True  : vIdOptions := [];
              False : vIdOptions := [ixDescending];
            end;
          end;
        end;
      end;

      CDS.DeleteIndex(pField.FieldName);
    end;
    try
      CDS.AddIndex(pField.FieldName,
                   pField.FieldName,
                   vIdOptions,
                   '',
                   '',
                   0);
      vStrColumn := pField.FieldName;
    except
      if vBolUsed then
        vStrColumn := _idxDefault;
    end;
  end;

  try
    CDS.IndexName := vStrColumn;
  except
    CDS.IndexName := _idxDefault;
  end;
end;

procedure OrdenaDataSet(var aCDS: TClientDataSet; pFields: Variant;
  pOrdem: TOrdem = oNenhuma);
var
  I: Integer;
  Fields: string;
  IdOptions : TIndexOptions;
begin
  while aCDS.IndexDefs.Count > 0 do
    aCDS.IndexDefs.Delete(0);

  if (aCDS.IndexFieldCount > 0) and (aCDS.IndexName <> '') then
  begin
    aCDS.DeleteIndex(aCDS.IndexName);
  end;

  Fields := '';

  if VarIsArray(pFields) then
  begin
    for I := 0 to LengthArrayVar(pFields) -1 do
    begin
      if Fields = '' then
        Fields := pFields[I]
      else
        Fields := Fields + ';' + pFields[I];
    end;
  end
  else
  if VarIsStr(pFields) then
  begin
    Fields := VarToStr(pFields);
  end;

  if Fields <> '' then
  begin
    IdOptions := [];

    if pOrdem = oDescendente then
      IdOptions := [ixDescending];

    aCDS.FieldDefs.Update;
    aCDS.AddIndex('IDX_ORDEM',Fields,IdOptions);
    aCDS.IndexName := 'IDX_ORDEM';
    aCDS.FieldDefs.Update;
  end;
end;

function FieldExiste(pDataSet: TDataSet; pFieldName: string): Boolean;
  var
    I: Integer;
begin
  Result := False;
  if pDataSet <> nil then
  begin
    for I := 0 to pDataSet.FieldCount - 1 do
    begin
      if pDataSet.Fields[I].FieldName = pFieldName then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
end;

procedure RemoveIndex(pCDS: TClientDataSet);
begin
  if pCDS.IndexFieldCount > 0 then
    pCDS.DeleteIndex(pCDS.IndexName);

  pCDS.IndexFieldNames := '';
  pCDS.IndexName := '';
end;

function IsValidDateTime(Value: Variant): Boolean;
begin
  Result := False;
  try
    if VarIsStr(Value) then
    begin
      StrToDateTime(VarToStr(Value));
    end
    else
    if VarIsType(Value,VT_DATE) then
    begin
      VarToDateTime(Value);
    end;
    Result := True;
  except

  end;
end;

function ValueForSQL(pValue: Variant): string;
begin
  Result := 'null';

  if (VarIsNull(pValue)) or (VarIsEmpty(pValue)) then
    Exit;

  if VarIsArray(pValue) then
    Result := QuotedStr(pValue)
  else
  if (VarIsFloat(pValue)) or (VarIsNumeric(pValue)) then
  begin
    Result := FloatToSQL(pValue);
  end
  else
  if VarIsStr(pValue) then
  begin
    if pValue <> '' then
    begin
      Result := QuotedStr(pValue);
    end;
  end
  else
  if VarIsOrdinal(pValue) then
  begin
    Result := IntToStr(pValue);
  end
  else
  if VarIsType(pValue,VT_DATE) then
  begin
    Result := SQLDATA(pValue);
  end
  else
  if IsValidDateTime(pValue) then
  begin
    Result := SQLDATA(pValue);
  end
  else
  begin
    Result := VarToStr(pValue);
  end;
end;

function ExecAndWait(const _FileName, _Params: string;
                     const _WindowState: Word): Boolean;
  var
    SUInfo: TStartupInfo;
    ProcInfo: TProcessInformation;
    CmdLine: string;
begin
  { Coloca o nome do arquivo entre aspas. Isto é necessário devido
    aos espaços contidos em nomes longos }
  CmdLine := '"' + _FileName + '" ' + _Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := _WindowState;
  end;

  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
            CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
            PChar(ExtractFilePath(_FileName)), SUInfo, ProcInfo);

  { Aguarda até ser finalizado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function DateTimeToDate(pValue: TDateTime): TDate;
begin
  Result := StrToDate(DateToStr(pValue));
end;

function LastPos(const pValue, pStr: string): Integer;
var
  StrAux: string;
  I: Integer;
begin
  StrAux := pStr;
  Result := 0;

  while Length(StrAux) > 0 do
  begin
    I := Pos(pValue,StrAux);
    if I > 0 then
    begin
      Result := Result + I;
      Delete(StrAux,1,I + Length(pValue));
    end;

    if I = 0 then
      Break;
  end;
end;

function SQLNoWhere(const pSQL: string): string;
  var
    StrAux: string;
    SQL1: string;
    SQL2: string;
    I: Integer;
begin
  StrAux := pSQL;

  //Ultimo From do SQL
  I := LastPos('from',LowerCase(StrAux));
  if I > 0 then
  begin
    I := I + 4; //Posição + Tamanho fo From
    SQL1 := Copy(StrAux,1,I);
    Delete(StrAux,1,I);

    //Verifica a posição do WHERE
    I := Pos('where',LowerCase(StrAux));
    if I > 0 then
    begin
      //Copia o resto do SQL para o SQL1
      SQL1 := SQL1 + Copy(StrAux,1,I-1);
      Delete(StrAux,1,I-1);
    end
    else
    begin
      //Copia o resto do sql para o SQL1
      SQL1 := SQL1 + StrAux;
      StrAux := '';
    end;

    if StrAux <> '' then
    begin
      I := Pos('group',LowerCase(StrAux));
      if I > 0 then
      begin
        SQL2 := Copy(StrAux,I,Length(StrAux));
      end
      else
      begin
        I := Pos('order',LowerCase(StrAux));
        if I > 0 then
        begin
          SQL2 := Copy(StrAux,I,Length(StrAux));
        end
        else
        begin
          I := Pos('having',LowerCase(StrAux));
          if I > 0 then
          begin
            SQL2 := Copy(StrAux,I,Length(StrAux));
          end;
        end;
      end;
    end;
  end;

  Result := SQL1 + ' ' + SQL2;
end;

function InsertWhereSQL(pSQL, pSQLInserir: string;
                        pTrazerOrderOuGroup: Boolean = True): string;
var
  I: Integer;
begin
  Result := pSQL;

  if not pTrazerOrderOuGroup then
  begin
    I := Pos('group',LowerCase(Result));
    if I > 0 then
      Result := Copy(Result,1,I-1);
    I := Pos('order',LowerCase(Result));
    if I > 0 then
      Result := Copy(Result,1,I-1);
  end;

  I := Pos('group',LowerCase(pSQL));
  if I > 0 then
  begin
    Insert(' '+pSQLInserir,Result,I-1);
    Exit;
  end;

  I := Pos('order',LowerCase(pSQL));
  if I > 0 then
  begin
    Insert(' '+pSQLInserir,Result,I-1);
    Exit;
  end;

  //Se não passar por nenhum item acima
  Result := Result + ' ' + pSQLInserir;
end;

function Explode(pStr, pSeparador: string): TStringList;
var
  p: integer;
begin
  Result := TStringList.Create;
  Result.Text := StringReplace(pStr, pSeparador, sLineBreak, [rfReplaceAll] );
end;

function ExplodeToArray(pStr, pSeparador: string): TArrayString;
var
  S: TStrings;
  I: Integer;
begin
  S := Explode(pStr,pSeparador);
  SetLength(Result,S.Count);
  for I := 0 to S.Count - 1 do
    Result[I] := S.Strings[I];
end;

procedure ChaveQuery(pDataset: TDataSet; pChave: string);
var
  X: Integer;
  CampoChave: String;
begin
  pChave := Trim(pChave);

  if pChave = '' then
    Exit;

  while pChave <> '' do
  begin
    X := Pos(',',pChave);
    if X = 0 then
      CampoChave := pChave
    else
      CampoChave := Copy(pChave,1,X-1);

    pDataset.FieldByName(CampoChave).ProviderFlags := [pfInKey,pfInUpdate,pfInWhere];

    if X > 0 then
      Delete(pChave,1,X)
    else
      pChave := '';

    pChave := Trim(pChave);
  end;
end;

function GetSQLDataSet(pOwner: TComponent; pProviderName: string): string;
var
  P: TComponent;
begin
  try
    Result := '';

    P := POwner.FindComponent(pProviderName);
    if P <> nil then
    begin
      if (P is TDataSetProvider) then
      begin
        if ((P as TDataSetProvider).DataSet) is TSQLQuery then
        begin
          Result := TSQLQuery((P as TDataSetProvider).DataSet).SQL.Text;
        end;
        if ((P as TDataSetProvider).DataSet) is TSQLDataSet then
        begin
          Result := TSQLDataSet((P as TDataSetProvider).DataSet).CommandText;
        end;
      end;
    end;
  except
    Result := '';
  end;
end;

function ValidarDataSet(CDS: TClientDataSet): Boolean;
var
  I: Integer;
  Msg: string;
begin
  Result := True;

  if CDS.State = dsInactive then
    Exit;

  if CDS.State = dsBrowse then
  begin
    if CDS.RecordCount = 0 then
      Exit;
  end;

  for I := 0 to CDS.FieldCount - 1 do
  begin
    if ((CDS.Fields[I].IsNull) or (CDS.Fields[I].AsString = EmptyStr)) and
       (CDS.Fields[I].Required) then
    begin
      Result := False;
      Msg := 'O Campo "'+CDS.Fields[I].DisplayLabel+'" é de Preenchimento Obrigatório!';
      Application.MessageBox(PCHAR(Msg),'Atenção',MB_OK+MB_ICONINFORMATION);
      CDS.Fields[I].FocusControl;
      Exit;
    end;
  end;
end;

function GetCamposDataset(CDS: TClientDataSet): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to CDS.FieldCount - 1 do
  begin
    if CDS.Fields[I].FieldKind = fkData then
    begin
      if Result = '' then
        Result := Result + CDS.Fields[I].FieldName
      else
        Result := Result +', '+ CDS.Fields[I].FieldName;
    end;
  end;
end;

function TempoToTempoFormatado(Tempo: TDateTime):string;
var
  Hora,Minuto,Segundo,Milisegundo: Word;

  function Formata(Unidade: Word; Descricao: string): String;
  begin
    Result := '';
    if Unidade > 0 then
    begin
      Result := IntToStr(Unidade) +' '+ Descricao;
      if Unidade > 1 then
        Result := Result + chr(39)+'s';
      Result := Result + ' ';
    end;
  end;
begin
  DecodeTime(Tempo,Hora,Minuto,Segundo,Milisegundo);
  Result := Formata(Hora,'H')+Formata(Minuto,'Min')+Formata(Segundo,'Seg')+
            Formata(Milisegundo,'Miliseg');
end;

function TempoToStr(Tempo: TDateTime):string;
var
  Hora,Minuto,Segundo,Milisegundo: Word;
begin
  DecodeTime(Tempo,Hora,Minuto,Segundo,Milisegundo);
  Result := FormatFloat('00',Hora)       +':'+
            FormatFloat('00',Minuto)     +':'+
            FormatFloat('00',Segundo)    +':'+
            FormatFloat('00',Milisegundo);
end;

{ TUteis }

class function TUteis.GeraCaracteres(pDigitos: Integer): string;
const
  Str = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
var
  I: Integer;
begin
  for I := 1 to pDigitos do
  begin
    Randomize;
    Result := Result + Str[Random(Length(Str))+1];
  end;
end;

class procedure TUteis.AddLIstInOther(ListSource, ListDestino: TStrings);
var
  F: Integer;
begin
  for F := 0 to ListSource.Count - 1 do
  begin
    ListDestino.Add(ListSource.Strings[F]);
  end;
end;

class function TUteis.ArrayString(const AValues: array of string): string;
var
  I: Integer;
begin
  Result := '';

  for I := 0 to Length(AValues) -1 do
    Result := Result + IfThen(Result = '', '[' + AValues[I], ', ' + AValues[I]);

  Result := Result + ']';
end;

class function TUteis.Between(AValor, AValorInicial, AValorFinal: Double): Boolean;
begin
  Result := (AValor >= AVAlorInicial) and (AValor <= AValorFinal);
end;

class function TUteis.BoolToChar(Value: Boolean): Char;
begin
  if Value then
    Result := 'T'
  else
    Result := 'F';
end;

class function TUteis.CaminhoAplicacao: string;
begin
  Result := gsAppPath;
end;

class function TUteis.CaminhoPastaWindows(pTipoPasta: TPastaSistema): string;
var
  //MyObject : IUnknown;
  MyReg : TRegIniFile;
  Pasta: string;
begin
  case pTipoPasta of
    psDesktop: Pasta := 'Desktop';
    psIniciar: Pasta := 'Start Menu';
    psProgramasIniciar: Pasta := 'Programs';
  end;

  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  try
    Result := MyReg.ReadString ('Shell Folders',Pasta,'');
  finally
    MyReg.Free;
  end;
end;

class function TUteis.CaminhoTempDir: string;
begin
  Result := gsTempPath;
end;

class procedure TUteis.CaptureConsoleOutput(const ACommand, AParameters: string;
  ACallBack: TArg<PAnsiChar>);
const
  CReadBuffer = 2400;
var
  saSecurity: TSecurityAttributes;
  hRead: THandle;
  hWrite: THandle;
  suiStartup: TStartupInfo;
  piProcess: TProcessInformation;
  pBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dBuffer: array [0 .. CReadBuffer] of AnsiChar;
  dRead: DWord;
  dRunning: DWord;
begin
  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := True;
  saSecurity.lpSecurityDescriptor := nil;

  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
  begin
    FillChar(suiStartup, SizeOf(TStartupInfo), #0);
    suiStartup.cb := SizeOf(TStartupInfo);
    suiStartup.hStdInput := hRead;
    suiStartup.hStdOutput := hWrite;
    suiStartup.hStdError := hWrite;
    suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    suiStartup.wShowWindow := SW_HIDE;

    if CreateProcess(nil, pChar(ACommand + ' ' + AParameters), @saSecurity,
      @saSecurity, True, NORMAL_PRIORITY_CLASS, nil, nil, suiStartup,
      piProcess) then
    begin
      repeat
        dRunning := WaitForSingleObject(piProcess.hProcess, 100);
        Application.ProcessMessages();
        repeat
          dRead := 0;
          ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
          pBuffer[dRead] := #0;

          //OemToAnsi(pBuffer, pBuffer);
          //Unicode support by Lars Fosdal
          OemToCharA(pBuffer, dBuffer);
          ACallBack(dBuffer);
        until (dRead < CReadBuffer);
      until (dRunning <> WAIT_TIMEOUT);
      CloseHandle(piProcess.hProcess);
      CloseHandle(piProcess.hThread);
    end;
    CloseHandle(hRead);
    CloseHandle(hWrite);
  end;
end;

class function TUteis.CollateBr(pStr: string; AUpper: Boolean): string;
var
  I, Tamanho: Integer;
  Caracter, Resultado: string;
begin
  Result := '';
  Tamanho := Length(pStr);

  I := 1;
  while (I <= Tamanho) do
  begin
    Caracter := pStr[I];

    case pStr[I] of
      'á', 'â', 'ã', 'à', 'ä', 'å', 'Á', 'Â', 'Ã',
      'À', 'Ä', 'Å'                                   : Resultado := 'A';
      'é', 'ê', 'è', 'ë', 'É', 'Ê', 'È', 'Ë'          : Resultado := 'E';
      'í', 'î', 'ì', 'ï', 'Í', 'Î', 'Ì', 'Ï'          : Resultado := 'I';
      'ó', 'ô', 'õ', 'ò', 'ö', 'Ó', 'Ô', 'Õ', 'Ò', 'Ö': Resultado := 'O';
      'ú', 'û', 'ù', 'ü', 'Ú', 'Û', 'Ù', 'Ü'          : Resultado := 'U';
      'ç', 'Ç'                                        : Resultado := 'C';
      'ñ', 'Ñ'                                        : Resultado := 'N';
      'ý', 'ÿ', 'Ý', 'Y'                              : Resultado := 'Y';
      '"', '''', '-'                                  : Resultado := '';
    else
      Resultado := pStr[I];
    end;

    I := I + 1;

    Result := Result + Resultado;
  end;
  if AUpper then
    Result := UpperCase(Result);
end;

class function TUteis.CollateBrCaracter(AStr: string; AUpper: Boolean): string;
var
  I, Tamanho: Integer;
  Caracter, Resultado: string;
begin
  Result := '';
  Tamanho := Length(AStr);

  I := 1;
  while (I <= Tamanho) do
  begin
    Caracter := AStr[I];

    case AStr[I] of
      'á', 'â', 'ã', 'à', 'ä', 'å': Resultado := 'a';
      'Á', 'Â', 'Ã', 'À', 'Ä', 'Å': Resultado := 'A';

      'é', 'ê', 'è', 'ë'          : Resultado := 'e';
      'É', 'Ê', 'È', 'Ë'          : Resultado := 'E';

      'í', 'î', 'ì', 'ï'          : Resultado := 'i';
      'Í', 'Î', 'Ì', 'Ï'          : Resultado := 'I';

      'ó', 'ô', 'õ', 'ò', 'ö'     : Resultado := '0';
      'Ó', 'Ô', 'Õ', 'Ò', 'Ö'     : Resultado := 'O';

      'ú', 'û', 'ù', 'ü'          : Resultado := 'u';
      'Ú', 'Û', 'Ù', 'Ü'          : Resultado := 'U';

      'ç'                         : Resultado := 'c';
      'Ç'                         : Resultado := 'C';

      'ñ'                         : Resultado := 'n';
      'Ñ'                         : Resultado := 'N';

      'ý', 'ÿ'                    : Resultado := 'y';
      'Ý', 'Y'                    : Resultado := 'Y';
    else
      Resultado := AStr[I];
    end;

    I := I + 1;
    Result := Result + Resultado;
  end;

  if AUpper then
    Result := UpperCase(Result);
end;

class function TUteis.ContemLetra(const AValor: string): Boolean;
const
  Nume = '0123456789';
var
  I: Integer;
begin
  Result := False;

  for I := 1 to Length(AValor) do
  begin
    if Pos(AValor[I], Nume) = 0 then
      Exit(True);
  end;
end;

class function TUteis.CorInvertida(Color: TColor): TColor;
begin
  Result := RGB(255 - GetRValue(Color), 255 - GetGValue(Color), 255 - GetBValue(Color));
end;

class procedure TUteis.DebugSQL(const ASQL: string; AFilename: string);
var
  Stream: TStringStream;
  FilePath: string;
  Letter: string;
  vFilename: string;
begin
  if DebugHook = 0 then
    Exit;

  if ExisteUnidade('D:') then
    Letter := 'D:\'
  else
    Letter := 'C:\';

  vFilename := TUteis.MethodName(ProcByLevel(1, False)) + '.sql';

  FilePath := Letter + 'SQLDebug\';
  if not DirectoryExists(FilePath) then
    ForceDirectories(FilePath);

  Stream := TStringStream.Create(ASQL);
  try
    Stream.SaveToFile(FilePath + vFilename);
  finally
    Stream.Free;
  end;
end;

class function TUteis.CriaAtalho(pArquivo, pParametros, pNomeAtalho,
  pPastaDestino: string): Boolean;
var
  MyObject : IUnknown;
  MySLink : IShellLink;
  MyPFile : IPersistFile;
  WFileName : WideString;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
    SetArguments(PWideChar(pParametros));
    SetPath(PWideChar(pArquivo));
    SetWorkingDirectory(PWideChar(ExtractFileDir(pArquivo)));
  end;

  WFileName := pPastaDestino + '\' + pNomeAtalho + '.lnk';
  MyPFile.Save(PWideChar (WFileName), False);
end;

class function TUteis.GetDosOutput(const CommandLine: string): string;
var
  SA: TSecurityAttributes;
  SI: TStartupInfo;
  PI: TProcessInformation;
  StdOutPipeRead, StdOutPipeWrite: THandle;
  WasOK: Boolean;
  Buffer: array[0..255] of Char;
  BytesRead: Cardinal;
  WorkDir, Line: String;
begin
  Application.ProcessMessages;
  with SA do
  begin
    nLength := SizeOf(SA);
    bInheritHandle := True;
    lpSecurityDescriptor := nil;
  end;
  // create pipe for standard output redirection
  CreatePipe(StdOutPipeRead, // read handle
    StdOutPipeWrite, // write handle
    @SA, // security attributes
    0 // number of bytes reserved for pipe - 0
    );
  try
    // Make child process use StdOutPipeWrite as standard out,
    // and make sure it does not show on screen.
    with SI do
    begin
      FillChar(SI, SizeOf(SI), 0);
      cb := SizeOf(SI);
      dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
      wShowWindow := SW_HIDE;
      hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect std Input
      hStdOutput := StdOutPipeWrite;
      hStdError := StdOutPipeWrite;
    end;

    // launch the command line compiler
    WorkDir := ExtractFilePath(CommandLine);
    WasOK := CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil,
    PChar(WorkDir), SI, PI);

    // Now that the handle has been inherited, close write to be safe.
    // We don't want to read or write to it accidentally.
    CloseHandle(StdOutPipeWrite);
    // if process could be created then handle its output
    if not WasOK then
      raise Exception.Create('Could not execute command line!')
    else
    try
      // get all output until dos app finishes
      Line := '';
      repeat
        // read block of characters (might contain carriage returns and line feeds)
        WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);

        // has anything been read?
        if BytesRead > 0 then
        begin
          // finish buffer to PChar
          Buffer[BytesRead] := #0;
          // combine the buffer with the rest of the last run
          Line := Line + Buffer;
        end;
      until not WasOK or (BytesRead = 0);
      // wait for console app to finish (should be already at this point)
      WaitForSingleObject(PI.hProcess, INFINITE);
    finally
      // Close all remaining handles
      CloseHandle(PI.hThread);
      CloseHandle(PI.hProcess);
    end;
  finally
    Result := Line;
    CloseHandle(StdOutPipeRead);
  end;
end;

class function TUteis.DataSQL(AData: TDateTime; AHora: Boolean): string;
begin
  if AData = 0 then
    Result := ' NULL ';

  if AHora then
    Result := QuotedStr(FormatDateTime('dd.mm.yyyy hh:mm:ss', AData))
  else
    Result := QuotedStr(FormatDateTime('dd.mm.yyyy', AData))
end;

class function TUteis.DataSQL(AData: string; AHora: Boolean): string;
begin
  Result := DataSQL(StrToDateTimeDef(AData, 0), AHora);
end;

class function TUteis.DataTracoToDataBarra(pData: string): string;
begin
  //1975-01-15
  Result := Copy(pData,9,2)+'/'+Copy(pData,6,2)+'/'+Copy(pData,1,4);
end;

class function TUteis.DescontoRateado(ValorTotal, Valor,
  ValorDescontado: Real): Real;
begin
  try
    Result := (ValorDescontado*((Valor*100)/ValorTotal))/100;
  except
    Application.MessageBox('Erro ao Calcular Desconto! Verifique se os dados estão corretos.',
      'Erro',MB_OK+MB_ICONERROR);
  end;
end;

class function TUteis.DiasToHoras(AFormato: string; ADias, AMinutos: Double): string;
var
  T: Double;
  I: Integer;
  Horas, Min, A,B: Word;
begin
  T := (ADias * AMinutos) / 60 / 24;

  I := 0;
  while T >= 1 do
  begin
    Inc(I);
    T := IncDay(T,-1);
  end;

  I := I * 24;

  DecodeTime(T,Horas,Min,A,B);

  Horas := I + Horas;

  if (Horas = 0) and (Min = 0) then
  begin
    Result := '-';
    Exit;
  end;

  Result := FormatFloat(AFormato,Horas) + ':' + FormatFloat(AFormato,Min);
end;

class function TUteis.DuasDatasToStr(pDataIni, pDataFin: TDate; ASimples: Boolean): string;
begin
  if pDataIni > 0 then
  begin
    Result := DateToStr(pDataIni);

    if pDataFin <= 0 then
      Result := ' Após '+IfThen(not ASimples, 'o dia ')+Result;
  end;

  if pDataFin > 0 then
  begin
    if Result <> '' then
      Result := Result + ' a '
    else
      Result := ' Até '+IfThen(not ASimples, 'o dia ');

    Result := Result + DateToStr(pDataFin);
  end;
end;

class function TUteis.EncriptaMD5(const pValor: string): string;
var
  IdMD5: TIdHashMessageDigest5;
begin
  IdMD5 := TIdHashMessageDigest5.Create;
  try
    Result := idmd5.HashStringAsHex(pValor);
  finally
    IdMD5.Free;
  end;

  //Result := TMD5.MD5DigestToStr(TMD5.MD5String(pValor));
end;

class function TUteis.AddEspacoDireita(const AValue: string; const AQtde: Integer): string;
var
  strAux: string;
  I: Integer;
begin
  Result := AValue;

  for I := 1 to AQtde do
    Result := Result + ' ';
end;

class function TUteis.EstadoToStr(aEstado: TEstadosBrasileiros): string;
begin
  case aEstado of
    ebAcre            : Result := 'Acre';
    ebAlagoas         : Result := 'Alagoas';
    ebAmazonas        : Result := 'Amazonas';
    ebAmapa           : Result := 'Amapá';
    ebBahia           : Result := 'Bahia';
    ebCeara           : Result := 'Ceará';
    ebDistritoFederal : Result := 'Distrito Federal';
    ebEspiritoSanto   : Result := 'Espírito Santo';
    ebGoias           : Result := 'Goiás';
    ebMaranhao        : Result := 'Maranhão';
    ebMinasGerais     : Result := 'Minas Gerais';
    ebMatoGrosso      : Result := 'Mato Grosso';
    ebMatoGrossoSul   : Result := 'Mato Grosso do Sul';
    ebPara            : Result := 'Pará';
    ebParaiba         : Result := 'Paraíba';
    ebParana          : Result := 'Paraná';
    ebPiaui           : Result := 'Piauí';
    ebPernambuco      : Result := 'Pernambuco';
    ebRioJaneiro      : Result := 'Rio de Janeiro';
    ebRioGrandeNorte  : Result := 'Rio Grande do Norte';
    ebRioGrandeSul    : Result := 'Rio Grande do Sul';
    ebRondonia        : Result := 'Rondônia';
    ebRoraima         : Result := 'Roraima';
    ebSantaCatarina   : Result := 'Santa Catarina';
    ebSergipe         : Result := 'Sergipe';
    ebSaoPaulo        : Result := 'São Paulo';
    ebTocantins       : Result := 'Tocantins';
    ebExterior        : Result := 'Exterior';
  end;
end;

class function TUteis.EstadoToUF(aEstado: TEstadosBrasileiros): string;
begin
  case aEstado of
    ebAcre            : Result := 'AC';
    ebAlagoas         : Result := 'AL';
    ebAmazonas        : Result := 'AM';
    ebAmapa           : Result := 'AP';
    ebBahia           : Result := 'BA';
    ebCeara           : Result := 'CE';
    ebDistritoFederal : Result := 'DF';
    ebEspiritoSanto   : Result := 'ES';
    ebGoias           : Result := 'GO';
    ebMaranhao        : Result := 'MA';
    ebMinasGerais     : Result := 'MG';
    ebMatoGrosso      : Result := 'MT';
    ebMatoGrossoSul   : Result := 'MS';
    ebPara            : Result := 'PA';
    ebParaiba         : Result := 'PB';
    ebParana          : Result := 'PR';
    ebPiaui           : Result := 'PI';
    ebPernambuco      : Result := 'PE';
    ebRioJaneiro      : Result := 'RJ';
    ebRioGrandeNorte  : Result := 'RN';
    ebRioGrandeSul    : Result := 'RS';
    ebRondonia        : Result := 'RO';
    ebRoraima         : Result := 'RR';
    ebSantaCatarina   : Result := 'SC';
    ebSergipe         : Result := 'SE';
    ebSaoPaulo        : Result := 'SP';
    ebTocantins       : Result := 'TO';
    ebExterior        : Result := 'EX';
  end;
end;

class function TUteis.ExisteAplicativo(AApp: string): Boolean;
var
  Lista: TStrings;
  I: Integer;
begin
  Result := False;

  Lista := ListarAplicativos;

  for I := 0 to Lista.Count -1 do
  begin
    if Lista[I] = AApp then
      Exit(True);
  end;
end;

class function TUteis.ExisteUnidade(ALetra: string): Boolean;
var
  Lista: TStrings;
  I: Integer;
begin
  Result := False;

  Lista := ListaUnidades;

  for I := 0 to Lista.Count -1 do
  begin
    if Pos(ALetra, Lista.Strings[I]) > 0 then
      Exit(True);
  end;
end;

class function TUteis.FieldExist(DataSet: TDataSet; FieldName: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to DataSet.FieldCount - 1 do
  begin
    if DataSet.Fields[I].FieldName = FieldName then
    begin
      Result := True;
      Break;
    end;
  end;
end;

class function TUteis.FindProcess(ProcessName: string): DWORD;
var
  ContinueLoop                : BOOL;
  FSnapshotHandle             : THandle;
  FProcessEntry32             : TProcessEntry32;
begin
  Result := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

  while ContinueLoop and (not Boolean(Result)) do
  begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ProcessName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ProcessName))) then
    begin
      Result := FProcessEntry32.th32ProcessID;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
end;

class function TUteis.FNV1aHash(const s: AnsiString): LongWord;
var
  I: Integer;
const
  FNV_offset_basis = 2166136261;
  FNV_prime = 16777619;
begin
  Result := FNV_offset_basis;

  for I := 1 to Length(s) do
    Result := (Result xor Byte(s[I])) * FNV_prime;
end;

class procedure TUteis.FormataGrid(pComponent: TIWDBGrid);
begin
  with pComponent do
  begin
    BorderSize := 0;
    CellPadding := 2;
    CellSpacing := 2;
    Font.FontName := 'Arial';
    BGColor := clWebWHITE;
    HighlightColor := clNone;
    RollOver := True;
    RollOverColor := clWebWHITESMOKE;
    RowAlternateColor := clInfoBk;
    RowClick := True;
    RowCurrentColor := clWebDARKSEAGREEN; // clWebWHITESMOKE;
    RowHeaderColor := clWebSILVER;
  end;
end;

class procedure TUteis.FormataGrid(var AJvDBGrid: TJvDBGrid);
var
  I, Tamanho: Integer;
  cds: TClientDataSet;
begin
  if not Assigned(AJvDBGrid) then
    Exit;
  if not Assigned(AJvDBGrid.DataSource) then
    Exit;
  if not Assigned(AJvDBGrid.DataSource.DataSet) then
    Exit;

  cds := TClientDataSet(AJvDBGrid.DataSource.DataSet);

  for I := 0 to AJvDBGrid.Columns.Count - 1 do
  begin
    Tamanho := CDS.FieldByName(AJvDBGrid.Columns[I].FieldName).Size * 10;

    case CDS.FieldByName(AJvDBGrid.Columns[I].FieldName).DataType of
       ftString:
         begin
           if Tamanho > 500 then
             AJvDBGrid.Columns[I].Width := 500
           else
             AJvDBGrid.Columns[I].Width := Tamanho;
         end;
       ftFMTBcd:
         begin
           TFMTBCDField(AJvDBGrid.Columns[I].Field).DisplayFormat := '#,#0.00';
           AJvDBGrid.Columns[I].Width  := 80;
         end;
       ftFloat:
         begin
           TFloatField(AJvDBGrid.Columns[I].Field).DisplayFormat := '#,#0.00';
           AJvDBGrid.Columns[I].Width  := 80;
         end;

       ftInteger:
         begin
           TIntegerField(AJvDBGrid.Columns[I].Field).DisplayFormat := '000000';
           AJvDBGrid.Columns[I].Width  := 70;
         end;
       ftMemo, ftBlob: AJvDBGrid.Columns[I].Width  := 550;
    end;
  end;
end;

class function TUteis.FormataTelefone(pTelefone: string): string;
var
  Telefone, DDD: string;
  Tam: Integer;
begin
  Result := ApenasNumeros(pTelefone);
  Tam    := Length(Result);

  case Tam of
    8: //37271542
      begin
        Result := Copy(Result, 1, 4) + '-' + Copy(Result, 5, 4);
      end;
    10: //2737271542
      begin
        Result := '(' + Copy(Result, 1, 2) + ') ' + Copy(Result, 3, 4) + '-' + Copy(Result, 7, 4);
      end;
    11: //27996060038
      begin
        Result := '(' + Copy(Result, 1, 2) + ') ' + Copy(Result, 3, 5) + '-' + Copy(Result, 8, 4);
      end;
    12: //552737271542
      begin
        Result := '+' + Copy(Result, 1, 2) + ' (' + Copy(Result, 3, 2) + ') ' + Copy(Result, 5, 4) + '-' + Copy(Result, 9, 4);
      end;
    13: //5527996060038
      begin
        Result := '+' + Copy(Result, 1, 2) + ' (' + Copy(Result, 3, 2) + ') ' + Copy(Result, 5, 5) + '-' + Copy(Result, 10, 4);
      end;
  end;
end;

class procedure TUteis.FreeAndNil(var Obj);
begin
  try
    if Assigned(TObject(Obj)) then
      SysUtils.FreeAndNil(Obj);
  except

  end;
end;

class function TUteis.GeraCaracteres(pDigitos: Integer;
  pCaracteres: string): string;
var
  I: Integer;
begin
  if pCaracteres = '' then
    Exit;

  for I := 1 to pDigitos do
  begin
    Randomize;
    Result := Result + pCaracteres[Random(Length(pCaracteres))+1];
  end;
end;

class function TUteis.GeraChave(pItem, pValor1, pValor2: Integer): string;
const
  Caracteres = '1234567890ABEFHJKLMNPRTVWXZ';
var
  Chave: string;
begin
  //****** Resultado = 13 dígitos ******

  //Item - 2 dígitos
  Chave := IntToHex(pItem,2);
  if Length(Chave)  > 2 then
    Chave := Copy(Chave,1,2);
  Result := Chave;

  //Valor 1 - 5 dígitos
  Chave := IntToHex(pValor1,5);
  if Length(Chave) > 5 then
    Chave := Copy(Chave,1,5);
  Result := Result + Chave;

  //Caracter aleatório - 1 dígito
  Result := Result + GeraCaracteres(1,Caracteres);

  //Valor 2 - 5 dígitos
  Chave := IntToHex(pValor2,5);
  if Length(Chave) > 5 then
    Chave := Copy(Chave,1,5);
  Result := Result + Chave;
end;

class function TUteis.GeraCodigoBarras(const pMunicipio, pCodLib: string): string;
var
  Valor: string;
  Sum: Integer;
  DV1, DV2: Integer;
  I, V: Integer;
begin
  Valor := pMunicipio + ZeroEsq(pCodLib,6);
  Sum := 0;
  V   := 9;

  for I := 1 to Length(Valor) do
  begin
    Sum := StrToInt(Valor[I])*V;

    Dec(V);

    if V < 1 then
      V := 9;
  end;

  DV1 := Sum mod 11;

  Valor := pMunicipio + ZeroEsq(pCodLib,6) + IntToStr(DV1);
  V     := 9;

  for I := 1 to Length(Valor) do
  begin
    Sum := StrToInt(Valor[I])*V;

    Dec(V);

    if V < 1 then
      V := 9;
  end;

  DV2 := Sum mod 11;

  Result := pMunicipio + ZeroEsq(pCodLib,6) + ZeroEsq(IntToStr(DV1) + IntToStr(DV2), 3);
end;

class function TUteis.ValidarDigitoVerificador(
  const pChaveAcesso: string): Boolean;
var
  Valor: string;
  Sum: Integer;
  DV1, DV2: Integer;
  ValorDV1: string;
  I, V: Integer;
begin
  Result := False;
  try
    Valor := Copy(pChaveAcesso,1,13);
    ValorDV1 := Copy(pChaveAcesso,14, 3);

    Sum := 0;
    V := 9;

    for I := 1 to Length(Valor) do
    begin
      Sum := StrToInt(Valor[I])*V;

      Dec(V);

      if V < 1 then
        V := 9;
    end;

    DV1 := Sum mod 11;
    V := 9;

    Valor := Copy(pChaveAcesso,1,13) + IntToStr(DV1);
    for I := 1 to Length(Valor) do
    begin
      Sum := StrToInt(Valor[I])*V;

      Dec(V);

      if V < 1 then
        V := 9;
    end;

    DV2 := Sum mod 11;

    Result := ValorDV1 = ZeroEsq(IntToStr(DV1) + IntToStr(DV2), 3);
  except
    Result := False;
  end;
end;

class function TUteis.ValidarHora(Ahora: String): Boolean;
var
  Hora, Minuto, Segundo: Integer;
begin
  Result := False;

  try
    Hora := StrToInt(Copy(Ahora,1,Pos(':',Ahora)-1));
    Delete(Ahora,1,Pos(':',Ahora));

    Minuto := StrToInt(Copy(Ahora,1,Pos(':',Ahora)-1));
    Delete(Ahora,1,Pos(':',Ahora));

    Segundo := StrToInt(Ahora);

    if (Hora in [0..23]) and (Minuto in [0..59]) and (Segundo in [0..59]) then
      Result := True;
  except
    Result := False;
  end;
end;

class function TUteis.GetHDNumber: string;
var
  LabName: array[0..199] of Char;
  FileSys: array[0..19] of Char;
  SerNumber, CompLen, SysFlags: DWORD;
begin
  if GetVolumeInformation('C:\', @LabName, 200, @SerNumber, CompLen,
    SysFlags, @FileSys, 20) then
  begin
    Result := Format('%.8x', [SerNumber]);
  end;
end;

class function TUteis.GetJSONValue(pJSONObj: TJSONObject;
  pFieldName: string): TJSONValue;
var
  I: Integer;
begin
  Result := TJSONNull.Create;
  for I := 0 to pJSONObj.Size - 1 do
  begin
    with pJSONObj.Get(I) do
    begin
      if JsonString.Value = pFieldName then
      begin
        Result := JsonValue;
        Break;
      end;
    end;
  end;
end;

class function TUteis.GetPrimeiraLetra(AValue: string; AComEspeciais: Boolean): string;
var
  I: Integer;
  Anterior: String;
begin
  Result := '';

  Anterior := '';

  for I := 1 to Length(AValue) do
  begin
    if I > 1 then
      Anterior := Copy(AValue,I-1,1);

    if MatchStr(Anterior, [' ']) OR (I = 1) then
      Result := Result+AnsiUpperCase(Copy(AValue,I,1))
    else
    if AComEspeciais then
    begin
      if MatchStr(Anterior, ['ª', 'º', '°', '-', '*', '/', '+', '&', '@', '#', '$', '\', '|', '€', '§', '¢', '¬']) then
        Result := Result + Anterior;
    end;
  end;
end;

class function TUteis.IsNumber(pValue: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(pValue) do
  begin
    case pValue[I] of
      '0'..'9': ;
    else Exit;
    end;
  end;
  Result := True;
end;

class function TUteis.JSONToObj<T>(pUnMarshal: TJSONUnMarshal;
  pJSON: TJSONValue): T;
begin
  if pJSON is TJSONNull then
    Exit(nil);

  Exit(T(pUnMarshal.Unmarshal(pJSON)));
end;

class function TUteis.JSONToObj<T>(pJSON: TJSONValue): T;
var
  unm: TJSONUnMarshal;
begin
  unm := TJSONUnMarshal.Create;
  try
    Exit(JSONToObj<T>(unm,pJSON));
  finally
    unm.Free;
  end;
end;

class function TUteis.ListaMeses(AQtde: Integer; AShort: Boolean; AAno: string): TStrings;
var
  I: Integer;
begin
  if AQtde < 1 then
    AQtde := 1
  else
  if AQtde > 12 then
    AQtde := 12;

  Result := TStringList.Create;

  for I := 1 to AQtde do
    Result.Add(Mes(I, AShort) + IfThen(AAno <> '', '/' + AAno));
end;

class function TUteis.ListarAplicativos: TStrings;
var
  Registry: TRegistry;
  I: Integer;
  Icon: TIcon;
  DisplayName, DisplayIcon: string;
begin
  Result := TStringList.Create;

  Registry := TRegistry.Create;
  Icon     := TIcon.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;

    if Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Uninstall',False) Then
    begin
      Registry.GetKeyNames(Result);
      Registry.CloseKey;
    end;
  Finally
    FreeAndNil(Registry);
    FreeAndNil(Icon);
  end;
end;

class function TUteis.ListarArquivos(pDiretorio, pMascara: string): TStrings;
var
  Rec: TSearchRec;
begin
  Result := TStringList.Create;

  if SysUtils.FindFirst(pDiretorio + pMascara, faArchive, Rec) = 0 then
  try
    repeat
      Result.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
end;

class function TUteis.ListarAtahos(pDiretorio, pMascara: string): Tstrings;
var
  Rec: TSearchRec;
begin
  Result := TStringList.Create;
  if SysUtils.FindFirst(pDiretorio + pMascara, faAnyFile, Rec) = 0 then
  try
    repeat
      Result.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    SysUtils.FindClose(Rec);
  end;
end;

class function TUteis.ListarDiretorios(pDiretorio: string): TStrings;
var
  Rec: TSearchRec;
begin
  Result := TStringList.Create;

  if SysUtils.FindFirst(pDiretorio + '*', faDirectory, Rec) = 0 then
  try
    repeat
      if DirectoryExists(pDiretorio+'\'+Rec.Name) then
        Result.Add(Rec.Name);
    until SysUtils.FindNext(Rec) <> 0;
  finally
    if Result.count <> 0 then
    begin
      // deleta o diretorio ..
      Result.Delete(1);
      // deleta o diretorio .
      Result.Delete(0);
    end;
  end;
end;

class function TUteis.ListaUnidades: TStrings;
var
  Drives: TStringDynArray;
  I: Integer;
begin
  Result := TStringList.Create;

  Drives := TDirectory.GetLogicalDrives;
  for I := 0 to Length(Drives) -1 do
    Result.Add(Drives[I]);
end;

class function TUteis.LoadDataFromFile(pPath: string): OleVariant;
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    cds.LoadFromFile(pPath);
    Result := cds.Data;
  finally
    cds.Free;
  end;
end;

class function TUteis.LoadDataFromStream(pStream: TMemoryStream): OleVariant;
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    cds.LoadFromStream(pStream);
    Result := cds.Data;
  finally
    cds.Free;
  end;
end;

class function TUteis.GetFirebirdBinPach: string;
var
  Reg: TRegistry;
  Dir: string;
begin
  Result := '';

  Reg := TRegistry.Create(KEY_READ OR $0100);
  try
    Reg.Lazywrite := false;
    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKeyReadOnly('SOFTWARE\Firebird Project\Firebird Server\Instances') then
    begin
      Dir := Reg.ReadString('DefaultInstance');
      if Dir[Length(Dir)] <> '\' then
        Dir := Dir + '\';
      Dir := Dir + 'Bin\';

      if DirectoryExists(Dir) then
      begin
        Result := Dir;
      end;
    end;

    Reg.CloseKey;
  finally
    Reg.Free;
  end;
end;

class function TUteis.LowCase(pVAlue: Char): Char;
begin
  Result := Self.LowerCase(pVAlue)[1];
end;

class function TUteis.LowerCase(pValue: string): string;
const
  Minusculo = 'àâêôûãõáéíóúçü';
  Maiusculo = 'ÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
var
  x : Integer;
Begin
  pValue := SysUtils.LowerCase(pValue);

  for x := 1 to Length(pValue) do
  begin
    if Pos(pValue[x],Maiusculo) <> 0 Then
    begin
      pValue[x] := Minusculo[Pos(pValue[x],Maiusculo)];
    end;
  end;

  Result := pValue;
end;

class function TUteis.MD5File(const AFilePath: string): string;
begin
//  Result := TMD5.MD5DigestToStr(TMD5.MD5File(AFilePath));
end;

class function TUteis.Mes(AMes: Integer; AShort: Boolean): string;
begin
  if AShort then
  begin
    case AMes of
      1 : Result := 'Jan';
      2 : Result := 'Fev';
      3 : Result := 'Mar';
      4 : Result := 'Abr';
      5 : Result := 'Mai';
      6 : Result := 'Jun';
      7 : Result := 'Jul';
      8 : Result := 'Ago';
      9 : Result := 'Set';
      10: Result := 'Out';
      11: Result := 'Nov';
      12: Result := 'Dez';
    end;
  end
  else
  begin
    case AMes of
      1 : Result := 'Janeiro';
      2 : Result := 'Fevereiro';
      3 : Result := 'Março';
      4 : Result := 'Abril';
      5 : Result := 'Maio';
      6 : Result := 'Junho';
      7 : Result := 'Julho';
      8 : Result := 'Agosto';
      9 : Result := 'Setembro';
      10: Result := 'Outubro';
      11: Result := 'Novembro';
      12: Result := 'Dezembro';
    end;
  end;
end;

class function TUteis.MethodName(const AMethod: string): string;
begin
  Result := Copy(AMethod, 1, Pos('$', AMethod) -1);
end;

class function TUteis.MSecToTime(AMSec: Int64): TDateTime;
begin
  Result := AMSec / MSecsPerSec / SecsPerDay;
end;

class function TUteis.NomeExecutavel: string;
var
  Ext: string;
begin
  //Captura a extenção
  Ext := ExtractFileExt(Application.ExeName);
  Result := ExtractFileName(Application.ExeName);
  Result := AnsiReplaceStr(Result,Ext,'');
end;

class function TUteis.ObjetoString(const AField, AValue: string): string;
var
  strAux: string;
begin
  strAux := StringReplace(AValue, '\', '\\', [rfReplaceAll]);
  strAux := StringReplace(strAux, '"', '\"', [rfReplaceAll]);

  Result := '{"' + AField + '":"' + strAux + '"}';
end;

class function TUteis.ObjetoString(const AField: string; const AValue: Integer): string;
begin
  Result := TUteis.ObjetoString(AField, IntToStr(AValue));
end;

class function TUteis.ObjToJSON<T>(pMarshal: TJSONMarshal; pObj: T): TJSONValue;
begin
  if Assigned(pObj) then
  begin
    Exit(pMarshal.Marshal(pObj));
  end
  else
    exit(TJSONNull.Create);
end;

class function TUteis.ObjToJSON<T>(pObj: T): TJSONValue;
var
  m: TJSONMarshal;
begin
  m := TJSONMarshal.Create(TJSONConverter.Create);
  try
    FormatSettings.DecimalSeparator := '.';

    Result := ObjToJSON<T>(m,pObj);
  finally
    m.Free;

    FormatSettings.DecimalSeparator := ',';
  end;
end;

class function TUteis.PMaiuscula(Value: string): string;
var
  I: Integer;
  Ant: String;
begin
  Ant := '';
  Result := '';
  for I := 1 to Length(Value) do
  begin
    if I > 1 then
      Ant := Copy(Value,I-1,1);

    if (Ant = ' ') or (Ant = '.') or (Ant = '!') or (Ant = '?') or (Ant = '-') or (Ant = '/') or (Ant = '\') or (Ant = ';') or (Ant = '|') or (I = 1) then
      Result := Result+AnsiUpperCase(Copy(Value,I,1))
    else
      Result := Result+AnsiLowerCase(Copy(Value,I,1));
  end;
end;

class function TUteis.PMaiuscula(AValue: string; AExcludeList: TStrings): string;
var
  Palavras: TStrings;
  I: Integer;
  J: Integer;
  PalavraMin: string;
  Encontrada: Boolean;
begin
  Result := '';

  Palavras := SeparaPalavras(AValue);
  try
    for I := 0 to Palavras.Count -1 do
    begin
      Encontrada := False;

      PalavraMin := TUteis.LowerCase(Palavras.Strings[I]);

      for J := 0 to AExcludeList.Count -1 do
      begin
        if PalavraMin = AExcludeList.Strings[J] then
        begin
          Encontrada := True;
          Break;
        end
      end;

      if Encontrada then
        Result := Result + IfThen(Result = '', PalavraMin, ' ' + PalavraMin)
      else
        Result := Result + IfThen(Result = '', PMaiuscula(Palavras.Strings[I]), ' ' + PMaiuscula(Palavras.Strings[I]));
    end;
  finally
    FreeAndNil(Palavras);
  end;
end;

class function TUteis.Porcentagem(const ATotal, AParte: Double): Double;
begin
  Result := (AParte*100)/ATotal;
end;

class function TUteis.PrimeiraPalavra(const AValor: string): string;
var
  I: integer;
begin
  Result := '';

  for I := 1 to Length(AValor) do
  begin
    if AValor[I] = ' ' then
      Break;

    Result := Result + AValor[I];
  end;
end;

class function TUteis.PrimeiroDiaMes(aData: TDateTime): TDateTime;
var
  Dia, Mes, Ano: Word;
begin
  DecodeDate(aData,Ano,Mes,Dia);

  Result := EncodeDate(Ano,Mes,01);
end;

class function TUteis.SafeFloat(AValue: string): Double;
var
  dReturn : double;
begin
  AValue := stringReplace(AValue, '%', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, '$', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, ' ', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, '.', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'R', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'S', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'U', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, '£', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, '€', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'H', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'D', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, 'M', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, '/', '', [rfIgnoreCase, rfReplaceAll]);
  AValue := stringReplace(AValue, ':', '', [rfIgnoreCase, rfReplaceAll]);

  try
    dReturn := StrToFloatDef(AValue, 0);
  except
    AValue := stringReplace(AValue, ',', '.', [rfIgnoreCase, rfReplaceAll]);

    try
      dReturn := StrToFloatDef(AValue, 0);
    except
      dReturn := 0;
    end;
  end;

  Result := dReturn;
end;

class procedure TUteis.SaveDataToFile(pData: OleVariant; pPath: string);
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    cds.Data := pData;
    cds.SaveToFile(pPath);
  finally
    cds.Free;
  end;
end;

class procedure TUteis.SaveDataToStream(pData: OleVariant;
  var pStream: TMemoryStream);
var
  cds: TClientDataSet;
begin
  cds := TClientDataSet.Create(nil);
  try
    cds.Data := pData;
    cds.SaveToStream(pStream);
  finally
    cds.Free;
  end;
end;

class procedure TUteis.SaveToFile(const ASQL: string; AFilename: string);
var
  Stream: TStringStream;
  Path: string;
  Ext: string;
begin
  Ext := '';

  Path := ExtractFilePath(AFilename);

  if not DirectoryExists(Path) then
  begin
    try
      ForceDirectories(Path);
    except
      Exit;
    end;
  end;

  Ext := ExtractFileExt(AFilename);

  if Ext = '' then
    Ext := '.txt'
  else
    Ext := '';

  Stream := TStringStream.Create(ASQL);
  try
    Stream.SaveToFile(AFilename + Ext);
  finally
    FreeAndNil(Stream);
  end;
end;

class procedure TUteis.Select(pDataSet: TClientDataSet; pSQL: string);
var
  StrAux: string;
begin
  try
    if Trim( pSQL ) = '' then
      Exit;

    if pDataSet.State in [dsEdit, dsInsert] then
      pDataSet.Cancel;

    pDataSet.Close;
    pDataSet.IndexName := '';
    pDataSet.IndexFieldNames := '';
    pDataSet.CommandText := pSQL;
    pDataSet.Execute;
    pDataSet.Open;
  except
    on E: Exception do
    begin
      StrAux := E.Message + sLineBreak;
      StrAux := StrAux + 'DataSet: ' + pDataSet.Name;
      if pDataSet.Owner <> nil then
      begin
        StrAux := StrAux + ' Tela: '+pDataSet.Owner.Name;
      end;
      StrAux := StrAux + ' SQL: ' + pSQL;
      raise Exception.Create(StrAux);
    end;
  end;
end;

class function TUteis.SeparaPalavras(pTexto: string): TStringList;
begin
  Result := SeparaPalavras(pTexto, ' ');
end;

class function TUteis.SeparaPalavras(ATexto, ASeparador: string): TStringList;
var
  strAux: String;
  I: Integer;
begin
  strAux := '';

  Result := TStringList.Create;

  for I := 1 to Length(ATexto) do
  begin
    if Copy(ATexto,I,1) <> ASeparador then
    begin
      strAux := strAux+Copy(ATexto,I,1);
    end
    else
    begin
      Result.Add(strAux);
      strAux := '';
    end
  end;

  Result.Add(strAux);
end;

class function TUteis.SepararPalavras(const AValue: string): string;
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(AValue) do
  begin
    if MatchStr(AValue[I], ['_', '-', '/', '+', '.', ',', '&', '\', '=']) then
      Result := Result + ' '
    else
    if (TCharacter.IsLower(AValue, I)) or (I = 1) then
      Result := Result + AValue[I]
    else
    if TCharacter.IsUpper(AValue, I) then
      Result := Result + ' ' + AValue[I];
  end;
end;

class function TUteis.SetDataSystem(pDataHora: TDateTime): Boolean;
var
  DataHora: TSystemTime;
  Ano, Mes, Dia, H, M, S, Mil: word;
begin
  try
    DecodeDateTime(pDataHora, Ano, Mes, Dia, H, M, S, Mil);
    with DataHora do
    begin
      wYear := Ano;
      wMonth := Mes;
      wDay := Dia;
      wHour := H;
      wMinute := M;
      wSecond := S;
      wMilliseconds := Mil;
    end;
    if SetLocalTime(DataHora) then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

class function TUteis.SomenteLetras(aStr: string): string;
const
  Alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ';
var
  I: Integer;
begin
  for I := 1 to Length(aStr) do
  begin
    if Pos(aStr[I],Alfabeto) > 0 then
      Result := Result + aStr[I];
  end;
end;

class function TUteis.SomenteLetrasComAcentos(aStr: string): string;
const
  Alfabeto = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzÁÀÂÃÄÉÊÍÓÔÕÚÜÇáàâãäéêíóôõúüç ';
var
  I: Integer;
begin
  for I := 1 to Length(aStr) do
  begin
    if Pos(aStr[I],Alfabeto) > 0 then
      Result := Result + aStr[I];
  end;
end;

class function TUteis.SomenteNumeros(aStr: string): string;
const
  Numeros = '0123456789';
var
  I: Integer;
begin
  Result := '';

  for I := 1 to Length(aStr) do
  begin
    if Pos(aStr[I],Numeros) > 0 then
      Result := Result + aStr[I];
  end;
end;

class function TUteis.SomenteLetrasNumeros(AValue: string): string;
const
  Caracteres = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 ';
var
  I: Integer;
begin
  Result := '';
  AValue := CollateBr(AValue);
  for I := 1 to Length(AValue) do
  begin
    if Pos(AValue[I],Caracteres) > 0 then
      Result := Result + AValue[I];
  end;
end;

class function TUteis.StrToEstado(ANome: string): TEstadosBrasileiros;
var
  strAux: string;
begin
  strAux := TUteis.LowerCase(ANome);

  if MatchStr(strAux, ['acre', 'ac']) then
    Exit(ebAcre)
  else
  if MatchStr(strAux, ['alagoas', 'al']) then
    Exit(ebAlagoas)
  else
  if MatchStr(strAux, ['amazonas', 'am']) then
    Exit(ebAmazonas)
  else
  if MatchStr(strAux, ['amapá', 'ap']) then
    Exit(ebAmapa)
  else
  if MatchStr(strAux, ['bahia', 'ba']) then
    Exit(ebBahia)
  else
  if MatchStr(strAux, ['ceará', 'ce']) then
    Exit(ebCeara)
  else
  if MatchStr(strAux, ['distrito federal', 'df']) then
    Exit(ebDistritoFederal)
  else
  if MatchStr(strAux, ['espírito santo', 'es']) then
    Exit(ebEspiritoSanto)
  else
  if MatchStr(strAux, ['goiás', 'go']) then
    Exit(ebGoias)
  else
  if MatchStr(strAux, ['maranhão', 'ma']) then
    Exit(ebMaranhao)
  else
  if MatchStr(strAux, ['minas gerais', 'mg']) then
    Exit(ebMinasGerais)
  else
  if MatchStr(strAux, ['mato grosso', 'mt']) then
    Exit(ebMatoGrosso)
  else
  if MatchStr(strAux, ['mato grosso do sul', 'ms']) then
    Exit(ebMatoGrossoSul)
  else
  if MatchStr(strAux, ['pará', 'pa']) then
    Exit(ebPara)
  else
  if MatchStr(strAux, ['paraíba', 'pb']) then
    Exit(ebParaiba)
  else
  if MatchStr(strAux, ['paraná', 'pr']) then
    Exit(ebParana)
  else
  if MatchStr(strAux, ['piauí', 'pi']) then
    Exit(ebPiaui)
  else
  if MatchStr(strAux, ['pernambuco', 'pe']) then
    Exit(ebPernambuco)
  else
  if MatchStr(strAux, ['rio de janeiro', 'rj']) then
    Exit(ebRioJaneiro)
  else
  if MatchStr(strAux, ['rio grande do norte', 'rn']) then
    Exit(ebRioGrandeNorte)
  else
  if MatchStr(strAux, ['rio grande do sul', 'rs']) then
    Exit(ebRioGrandeSul)
  else
  if MatchStr(strAux, ['rondônia', 'ro']) then
    Exit(ebRondonia)
  else
  if MatchStr(strAux, ['roraima', 'rr']) then
    Exit(ebRoraima)
  else
  if MatchStr(strAux, ['santa catarina', 'sc']) then
    Exit(ebSantaCatarina)
  else
  if MatchStr(strAux, ['sergipe', 'se']) then
    Exit(ebSergipe)
  else
  if MatchStr(strAux, ['são paulo', 'sp']) then
    Exit(ebSaoPaulo)
  else
  if MatchStr(strAux, ['tocantins', 'to']) then
    Exit(ebTocantins)
  else
    Exit(ebExterior);
end;

class function TUteis.TempoEntre(pDias: Integer): string;
var
  Ano, Mes, Dia: Integer;
  exAno, exMes, ExDia: string;
begin
  Ano := 0;
  Mes := 0;
  Dia := 0;

  //Anos
  while pDias >= 365 do
  begin
    Inc(Ano);
    pDias := pDias - 365;
  end;

  //Mes
  while pDias >= 30 do
  begin
    Inc(Mes);
    pDias := pDias - 30;
  end;

  //Dias
  while pDias >= 1 do
  begin
    Inc(Dia);
    pDias := pDias - 1;
  end;


  if Ano = 1 then
    exAno := '1 ano '
  else
    exAno := IntToStr(ano) + ' Anos ';

  if Mes = 1 then
    exMes := '1 Mês '
  else
    exMes := IntToStr(Mes) + ' Meses ';

  if Dia = 1 then
    ExDia := '1 Dia'
  else
    ExDia := IntToStr(Dia) + ' Dias ';

  if Ano > 0 then
    Result := exAno;
  if Mes > 0  then
    Result := Result + exMes;
  if Dia > 0 then
    Result := Result + ExDia;
end;

class function TUteis.ToRomanos(const AValue: string): string;
var
  strAux, strTmp: string;
  I, Idx: Integer;
  n1, n2, n3: Char;
begin
  Result := '';
  strTmp := '';

  if (Length(AValue) = 0) or (StrToIntDef(AValue, 0) = 0) then
    Exit;

  I := StrToInt(AValue);

  if (I < 0) or (I > 3999) then
  begin
    Result := AValue;
    Exit;
  end;

  strAux := AValue;
  for I := 1 to Length(strAux) do
  begin
    Idx := 2 * (Length(strAux) - I) + 1;

    n1 := Romans[Idx];
    n2 := Romans[Idx + 1];
    n3 := Romans[Idx + 2];

    case strAux[I] of
      '1': strTmp := strTmp + n1;
      '2': strTmp := strTmp + n1 + n1;
      '3': strTmp := strTmp + n1 + n1 + n1;
      '4': strTmp := strTmp + n1 + n2;
      '5': strTmp := strTmp + n2;
      '6': strTmp := strTmp + n2 + n1;
      '7': strTmp := strTmp + n2 + n1 + n1;
      '8': strTmp := strTmp + n2 + n1 + n1 + n1;
      '9': strTmp := strTmp + n1 + n3;
    end;
  end;

  Result := strTmp;
end;

class function TUteis.UltimoDiaMes(aData: TDateTime): TDateTime;
var
  UltDia: Integer;
begin
  case MonthOf(aData) of
    1,3,5,7,8,10,12: UltDia := 31;
    4,6,9,11       : UltDia := 30;
  else
    if Bissexto(YearOf(aData)) then
      UltDia := 29
    else
      UltDia := 28;
  end;

  Result := EncodeDate(YearOf(aData),MonthOf(aData),UltDia);
end;

class function TUteis.UltimoDiaMes(AMes, AAno: Integer): Integer;
begin
  case AMes of
    1,3,5,7,8,10,12: Result := 31;
    4,6,9,11       : Result := 30;
  else
    if Bissexto(AAno) then
      Result := 29
    else
      Result := 28;
  end;
end;

class function TUteis.UpCase(pVAlue: Char): Char;
begin
  Result := Self.UpperCase(pVAlue)[1];
end;

class function TUteis.UpperCase(pVAlue: string): string;
const
  Minusculo = 'àâêôûãõáéíóúçü';
  Maiusculo = 'ÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
var
  x : Integer;
Begin
  pValue := SysUtils.UpperCase(pValue);
  for x := 1 to Length(pValue) do
  begin
    if Pos(pValue[x],Minusculo) <> 0 Then
    begin
      pValue[x] := Maiusculo[Pos(pValue[x],Minusculo)];
    end;
  end;
  Result := pValue;
end;

class function TUteis.UpperNome(const Nome: String): String;
var
  x : Integer;
  lista : Array[0..18] of String[03];

  function NaoAchaPreposicao(Palavra : String): Boolean;
  var
      x : Integer;
  begin
    Result := True;
    for x := 0 to 18 do
      if (Trim(Palavra) = lista[x]) then
        Result := False;
  end;
begin

  if (Trim(Nome) = '') Then
    Exit;

  Result := Self.LowerCase(Nome);

  lista[0] := 'das';
  lista[1] := 'dos';
  lista[2] := 'de';
  lista[3] := 'do';
  lista[4] := 'da';
  lista[5] := 'o';
  lista[6] := 'a';
  lista[7] := 'os';
  lista[8] := 'as';
  lista[9] := 'em';
  lista[10] := 'na';
  lista[11] := 'no';
  lista[12] := 'até';
  lista[13] := 'ao';
  lista[14] := 'aos';
  lista[15] := 'com';
  lista[16] := 'dum';
  lista[17] := 'por';
  lista[18] := 'sob';

  Result := TUteis.UpCase(Result[1]) + Copy(Result, 2, Length(Result));

  for x := 2 to Length(Nome) do
  begin
    if (Nome[x] = #32) then
      if (Copy(LowerCase(Nome),x+1,1) <> 'e') then
        if (NaoAchaPreposicao(Copy(LowerCase(Nome),x+1,3))) then
          Result := Copy(Result, 1, x) + TUteis.UpCase(Result[x+1]) +
                    Copy(Result, x+2, Length(Result));
  end;
end;

class function TUteis.ValidaCNS(ACNS: string; var AErro: string): Boolean;
const
  Invalido           = 'Atenção! Número de CNS inválido!';
  ErroQuantidade     = 'O número do CNS deve conter 15 caracteres!';
  ProvisorioInvalido = 'Atenção! Número Provisório inválido!';
  NaoInformado       = 'Atenção! CNS Não informado!';
var
  Soma: int64;
  I: Integer;
  pis: string;
  resto: integer;
  dv: integer;
  resultado: string;
  CNS: string;
begin
  Result := False;

  CNS := ApenasNumeros(ACNS);

  if (Trim(CNS) = '') then
  begin
    AErro := NaoInformado;
    Exit(False);
  end;

  if (Trim(CNS) = '000000000000000') then
  begin
    AErro := Invalido;
    Exit(False);
  end;

  if (Length(CNS) <> 15) then
  begin
    AErro := ErroQuantidade;
    Exit(False);
  end;

  if (StrToInt(Copy(CNS,0,1)) in [7, 8, 9]) then
  begin
    soma:=  ((strtoint64(copy(CNS,  1, 1)))*15)+
            ((strtoint64(copy(CNS,  2, 1)))*14)+
            ((strtoint64(copy(CNS,  3, 1)))*13)+
            ((strtoint64(copy(CNS,  4, 1)))*12)+
            ((strtoint64(copy(CNS,  5, 1)))*11)+
            ((strtoint64(copy(CNS,  6, 1)))*10)+
            ((strtoint64(copy(CNS,  7, 1)))* 9)+
            ((strtoint64(copy(CNS,  8, 1)))* 8)+
            ((strtoint64(copy(CNS,  9, 1)))* 7)+
            ((strtoint64(copy(CNS, 10, 1)))* 6)+
            ((strtoint64(copy(CNS, 11, 1)))* 5)+
            ((strtoint64(copy(CNS, 12, 1)))* 4)+
            ((strtoint64(copy(CNS, 13, 1)))* 3)+
            ((strtoint64(copy(CNS, 14, 1)))* 2)+
            ((strtoint64(copy(CNS, 15, 1)))* 1);

    Result := ((Soma mod 11) = 0);
    if not Result then
      AErro := ProvisorioInvalido;
  end
  else
  if (StrToInt(Copy(CNS,0,1)) in [1, 2]) then
  begin
    pis := copy(CNS,1,11);

    soma:=  ((strtoint64(copy(pis,  1, 1)))*15)+
            ((strtoint64(copy(pis,  2, 1)))*14)+
            ((strtoint64(copy(pis,  3, 1)))*13)+
            ((strtoint64(copy(pis,  4, 1)))*12)+
            ((strtoint64(copy(pis,  5, 1)))*11)+
            ((strtoint64(copy(pis,  6, 1)))*10)+
            ((strtoint64(copy(pis,  7, 1)))* 9)+
            ((strtoint64(copy(pis,  8, 1)))* 8)+
            ((strtoint64(copy(pis,  9, 1)))* 7)+
            ((strtoint64(copy(pis, 10, 1)))* 6)+
            ((strtoint64(copy(pis, 11, 1)))* 5);

    resto:= soma mod 11;
    dv     := 11 - resto;

    if dv = 11 then
       dv:= 0;

    if dv = 10 then
    begin
      soma:=  ((strtoint64(copy(pis, 1, 1)))*15)+
              ((strtoint64(copy(pis, 2, 1)))*14)+
              ((strtoint64(copy(pis, 3, 1)))*13)+
              ((strtoint64(copy(pis, 4, 1)))*12)+
              ((strtoint64(copy(pis, 5, 1)))*11)+
              ((strtoint64(copy(pis, 6, 1)))*10)+
              ((strtoint64(copy(pis, 7, 1)))* 9)+
              ((strtoint64(copy(pis, 8, 1)))* 8)+
              ((strtoint64(copy(pis, 9, 1)))* 7)+
              ((strtoint64(copy(pis,10, 1)))* 6)+
              ((strtoint64(copy(pis,11, 1)))* 5)+ 2;
      resto:= soma mod 11;
      dv     := 11 - resto;
      resultado:= pis + '001' + inttostr( dv );
    end
    else
    begin
      resultado:= pis + '000' + inttostr( dv );
    end;
    Result := CNS = resultado;
    if not Result then
      AErro := Invalido;
  end
  else begin
    Result := CNS = resultado;
    if not Result then
      AErro := Invalido;
  end;
end;

class function TUteis.ValidaCNS_PROV(pNumero: string): Boolean;
var
  pis       : string;
  resto     : integer;
  dv        : integer;
  soma      : int64;
  resultado : string;
begin
  soma:=  ( ( strtoint64( copy( pNumero, 1, 1 ) ) ) * 15 ) +
          ( ( strtoint64( copy( pNumero, 2, 1 ) ) ) * 14 ) +
          ( ( strtoint64( copy( pNumero, 3, 1 ) ) ) * 13 ) +
          ( ( strtoint64( copy( pNumero, 4, 1 ) ) ) * 12 ) +
          ( ( strtoint64( copy( pNumero, 5, 1 ) ) ) * 11 ) +
          ( ( strtoint64( copy( pNumero, 6, 1 ) ) ) * 10 ) +
          ( ( strtoint64( copy( pNumero, 7, 1 ) ) ) * 9 ) +
          ( ( strtoint64( copy( pNumero, 8, 1 ) ) ) * 8 ) +
          ( ( strtoint64( copy( pNumero, 9, 1 ) ) ) * 7 ) +
          ( ( strtoint64( copy( pNumero, 10, 1 ) ) ) * 6 ) +
          ( ( strtoint64( copy( pNumero, 11, 1 ) ) ) * 5 ) +
          ( ( strtoint64( copy( pNumero, 12, 1 ) ) ) * 4 ) +
          ( ( strtoint64( copy( pNumero, 13, 1 ) ) ) * 3 ) +
          ( ( strtoint64( copy( pNumero, 14, 1 ) ) ) * 2 ) +
          ( ( strtoint64( copy( pNumero, 15, 1 ) ) ) * 1 );

  resto:= soma mod 11;

  if resto <> 0 then
   Result := False
  else
   Result := True;

  {
   Observações:

    1) O Número Provisório sempre começa com “8” ou “9”
    2) Não existe máscara para o CNS nem para o Número Provisório. O número que aparece no cartão de forma separada (898  0000  0004  3208) deverá ser digitado sem as separações.
    3) O 16º número que aparece no Cartão é o número da via do cartão, não é deverá ser digitado.
  }
end;

class function TUteis.ValidarNIS(pNIS: string): Boolean;
const
  Factor : array[1..10] of byte = (29,23,19,17,13,11,7,5,3,2);
var
  Soma, I : Integer;
begin
  Result := False;
  Soma := 0;
  if (Length(pNIS) = 11) and (IsNumber(pNIS)) then
  begin
    if (pNIS[1] in ['1','2'] ) then
    begin
      for I := 1 to 10 do
        Soma  := Soma + ((StrToInt(pNIS[I])  * Factor[I]));

      if (StrToInt(pNIS[11]) = (9 - (Soma mod 10))) then
        Result := True;
    end;
  end
  else
  begin
    Result := False;
  end;
end;

class procedure TUteis.VersaoApp(var pMajor, pMinor, pRelease, pBuild: Integer);
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
  Prog : string;
begin
  pMajor   := 0;
  pMinor   := 0;
  pRelease := 0;
  pBuild   := 0;

  try
    Prog := Application.Exename;
    VerInfoSize := GetFileVersionInfoSize(PChar(prog), Dummy);
    GetMem(VerInfo, VerInfoSize);

    if not Assigned(VerInfo) then
      Exit;

    GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);

    with VerValue^ do
    begin
      V1 := dwFileVersionMS shr 16;
      V2 := dwFileVersionMS and $FFFF;
      V3 := dwFileVersionLS shr 16;
      V4 := dwFileVersionLS and $FFFF;
    end;

    FreeMem(VerInfo, VerInfoSize);

    pMajor   := V1;
    pMinor   := V2;
    pRelease := V3;
    pBuild   := V4;
  except

  end;
end;

class function TUteis.ValidaEmail(const AMailIn: string):Boolean;
const
  CaraEsp: array[1..40] of string[1] =
  ( '!','#','$','%','¨','&','*',
  '(',')','+','=','§','¬','¢','¹','²',
  '³','£','´','`','ç','Ç',',',';',':',
  '<','>','~','^','?','/','','|','[',']','{','}',
  'º','ª','°');
var
  i,cont   : Integer;
  EMail    : ShortString;
begin
  EMail := AMailIn;
  Result := True;
  cont := 0;

  if EMail = '' then
    Exit(False);

  if (Pos('@', EMail)<>0) and (Pos('.', EMail)<>0) then    // existe @ .
  begin
    if (Pos('@', EMail)=1) or (Pos('@', EMail)= Length(EMail)) or (Pos('.', EMail)=1) or (Pos('.', EMail)= Length(EMail)) or (Pos(' ', EMail)<>0) then
      Result := False
    else                                   // @ seguido de . e vice-versa
    if (abs(Pos('@', EMail) - Pos('.', EMail)) = 1) then
      Result := False
    else
    begin
      for i := 1 to 40 do            // se existe Caracter Especial
      begin
        if Pos(CaraEsp[i], EMail)<>0 then
          Result := False;
      end;

      for i := 1 to length(EMail) do
      begin                                 // se existe apenas 1 @
        if EMail[i] = '@' then
          cont := cont +1;                    // . seguidos de .
        if (EMail[i] = '.') and (EMail[i+1] = '.') then
          Result := false;
      end;

      // . no f, 2ou+ @, . no i, - no i, _ no i
      if (cont >=2) or ( EMail[length(EMail)]= '.' )
      or ( EMail[1]= '.' ) or ( EMail[1]= '_' )
      or ( EMail[1]= '-' )  then
        Result := false;

      {
      // @ seguido de COM e vice-versa
      if (abs(Pos('@', EMail) - Pos('com', EMail)) = 1) then
        Result := False;

      // @ seguido de - e vice-versa
      if (abs(Pos('@', EMail) - Pos('-', EMail)) = 1) then
        Result := False;

      // @ seguido de _ e vice-versa
      if (abs(Pos('@', EMail) - Pos('_', EMail)) = 1) then
        Result := False; }
    end;
  end
  else
    Result := False;
end;

class function TUteis.PISValido(pPIS: string): Boolean;
var
  vSoma :Integer;
  vResto:Integer;
begin
  Result:=False;
  vSoma :=0;
  pPIS:=SomenteNumeros(pPIS);
  if Length(pPIS) = 11 then
  begin
    vSoma:=(StrToInt(pPIS[1]) * 3) +
           (StrToInt(pPIS[2]) * 2) +
           (StrToInt(pPIS[3]) * 9) +
           (StrToInt(pPIS[4]) * 8) +
           (StrToInt(pPIS[5]) * 7) +
           (StrToInt(pPIS[6]) * 6) +
           (StrToInt(pPIS[7]) * 5) +
           (StrToInt(pPIS[8]) * 4) +
           (StrToInt(pPIS[9]) * 3) +
           (StrToInt(pPIS[10]) * 2);

    vResto:=vSoma mod 11;

    vResto:=11-vResto;

    if vResto = StrToInt(pPIS[11]) then
      Result:=True
    else if (vResto in [10,11]) and (StrToInt(pPIS[11]) = 0) then
      Result:=True;
  end;
end;

function MontarFiltroBetween(pValorInicial,pValorFinal: string; pCondicao: string): string;
var aux1,aux2: Integer;
begin
  try
    if pValorInicial <> '' then
      aux1 := StrToInt(pValorInicial)
    else
      aux1 := 0;

    if pValorFinal <> '' then
      aux2 := StrToInt(pValorFinal)
    else
      aux2 := 0;

    if (aux1 > 0) and (aux2 > 0) then
      Result := pCondicao+' BETWEEN '+ QuotedStr(IntToStr(aux1))+
                ' AND '+QuotedStr(IntToStr(aux2))
    else
    if (aux1 > 0) and (aux2 <= 0) then
      Result := pCondicao + ' >= ' + QuotedStr(IntToStr(aux1))
    else
    if (aux1 <= 0) and (aux2 > 0) then
      Result := pCondicao+' <= '+ QuotedStr(IntToStr(aux2))
    else
      Result := '';
  except
    Result := pCondicao+' <= 0';
  end;
end;

procedure MarcarTodos(aCheckList: TCheckListBox);
var
  I: Integer;
begin
  with aCheckList do
  begin
    for I := 0 to aCheckList.Count -1 do
    begin
      Checked[I] := True;
    end;
  end;
end;

procedure DesmarcarTodos(aCheckList: TCheckListBox);
var
  I: Integer;
begin
  with aCheckList do
  begin
    for I := 0 to aCheckList.Count -1 do
    begin
      Checked[I] := False;
    end;
  end;
end;

procedure InverterSelecao(aCheckList: TCheckListBox);
var
  I: Integer;
begin
  with aCheckList do
  begin
    for I := 0 to aCheckList.Count -1 do
    begin
      Checked[I] := not Checked[I];
    end;
  end;
end;

function ItensSelecionados(aCheckList: TCheckListBox): string;
var
  I: Integer;
begin
  Result := '';

  with aCheckList do
  begin
    for I := 0 to Count - 1 do
    begin
      if Checked[I] then
      begin
        if Result = '' then
          Result := QuotedStr(TItemCheckList(Items.Objects[I]).Codigo)
        else
          Result := Result + ',' + QuotedStr(TItemCheckList(Items.Objects[I]).Codigo);
      end;
    end;
  end;

  if Result = '' then
    Result := ' IS NOT NULL '
  else
    Result := ' IN ('+Result+') ';
end;

function EntreDatas(DataInicial, DataFinal: TDateTime): string;
var
  iAnos, iMeses, iDias, iHoras, iMinutos, iSegundos : Integer;
  dTempoAtendimento, dDataInicial, dDataFinal : TDateTime;
  sTexto : string;
begin

  Result := '';

  dDataInicial := DataInicial;
  dDataFinal   := DataFinal;
  dTempoAtendimento := (dDataFinal - dDataInicial);

  iAnos     := YearsBetween(dDataInicial, dDataFinal);
  iMeses    := MonthsBetween(dDataInicial, dDataFinal);
  iDias     := DaysBetween(dDataInicial, dDataFinal);
  iHoras    := HoursBetween(dDataInicial, dDataFinal);
  iMinutos  := MinutesBetween(dDataInicial, dDataFinal);
  iSegundos := SecondsBetween(dDataInicial, dDataFinal);

  sTexto := sTexto + IntToStr(idias)    + ' Dia(s) ';

  Result := sTexto;
end;

end.
