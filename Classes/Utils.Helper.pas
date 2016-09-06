unit Utils.Helper;

interface

uses Winapi.Windows, Data.DBXJSON, System.SysUtils, Datasnap.DSHTTP, Datasnap.DBClient, System.Classes, System.Variants, Vcl.ExtCtrls, RzCmboBx,
  CurvyControls, Vcl.Menus, Data.DB, System.StrUtils, Vcl.StdCtrls, JvCombobox, Data.DBXJSONReflect, Vcl.DBCtrls, JvToolEdit, Data.DBXDBReaders,
  Vcl.Controls, AdvSmoothSlider, System.DateUtils, frxClass, IWSystem, Vcl.CheckLst, Utils.Util, JvCheckListBox, Data.DBXCommon, Vcl.Forms, Json,
  System.Rtti, AdvGrid, Vcl.Graphics, Vcl.DBGrids, System.Generics.Defaults, Vcl.ComCtrls, JvListBox, Vcl.Clipbrd, JvDBGrid, JclDebug, Datasnap.DSHTTPClient;

type
  TEncodingType = (eASCII, eUTF8);

  TItem = class;
  TEtapa = class;

  // Helper para JSONArray
  TJSONArrayHelper = class Helper for TJsonArray
  private
    function GetFieldIndex(AIndex: Integer): TJSONValue;
  public
    procedure AddValue(AValue: string); overload;
    procedure AddValue(AValue: Integer); overload;
    procedure AddValue(AValue: TDate); overload;
    procedure AddValue(AValue: TDateTime); overload;
    procedure AddValue(AValue: Double); overload;
    procedure AddValue(AValue: Boolean); overload;
    procedure AddValue(AValue: TJsonArray); overload;
    procedure AddValue(AValue: TJSONObject); overload;
    procedure AddValue(AValue: TJSONValue); overload;
    procedure SaveToFile(AFilename: string);
    procedure DebugFile(AFilename: string = '');

    function SizeFor: Integer;
    function SizeGrid: Integer;
    function IsEmpty: Boolean;
    function HasRecords: Boolean;
    class function Inverse(AArray: TJsonArray): TJsonArray;

    Property Field[AIndex: Integer]: TJSONValue read GetFieldIndex;
  end;

  // Helper para JSONObject
  TJSONObjectHelper = class Helper for TJSONObject
  private
    function GetFieldIndex(AIndex: Integer): TJSONValue;
    function GetFieldByName(AName: String): TJSONValue;
    function GetFieldName(AIndex: Integer): string;
  public
    procedure AddValue(ADescription: string; AValue: string); overload;
    procedure AddValue(ADescription: string; AValue: Integer); overload;
    procedure AddValue(ADescription: string; AValue: TDate); overload;
    procedure AddValue(ADescription: string; AValue: TDateTime); overload;
    procedure AddValue(ADescription: string; AValue: Double); overload;
    procedure AddValue(ADescription: string; AValue: Boolean); overload;
    procedure AddValue(ADescription: string; AValue: TJsonArray); overload;
    procedure AddValue(ADescription: string; AValue: TJSONObject); overload;
    procedure AddValue(ADescription: string; AValue: TJSONValue); overload;

    procedure Replace(ADescription: string; AValue: string); overload;
    procedure Replace(ADescription: string; AValue: Integer); overload;
    procedure Replace(ADescription: string; AValue: TDate); overload;
    procedure Replace(ADescription: string; AValue: TDateTime); overload;
    procedure Replace(ADescription: string; AValue: Double); overload;
    procedure Replace(ADescription: string; AValue: Boolean); overload;
    procedure Replace(ADescription: string; AValue: TJsonArray); overload;
    procedure Replace(ADescription: string; AValue: TJSONObject); overload;
    procedure Replace(ADescription: string; AValue: TJSONValue); overload;

    procedure SaveToFile(AFilename: string);
    procedure DebugFile(AFilename: string = '');

    function HasField(AName: string): Boolean;

    property FieldName[AIndex: Integer]: string read GetFieldName;
    Property Field[AIndex: Integer]: TJSONValue read GetFieldIndex; default;
    Property Field[AName: String]: TJSONValue read GetFieldByName; default;
  end;

  // Helper para JSONPair
  TJSONPairHelper = class Helper for TJSONPair
  public
    function FieldName: string;
  end;

  // Helper para JSONValue
  TJSONValueHelper = class Helper for TJSONValue
  private
    function GetFieldIndex(AIndex: Integer): TJSONValue;
    function GetFieldName(AName: String): TJSONValue;
  public
    function AsString: string;
    function AsUpper: string;
    function AsLower: string;
    function AsStrNull: string;
    function AsInteger: Integer;
    function AsDouble: Double;
    function AsDoubleSql: string;
    function AsDoubleNull: string;
    function AsBoolean: Boolean;
    function AsJsonArray: TJsonArray;
    function AsDateTime: TDateTime;
    function AsQuotedStr: string;
    function AsQuotedDate: string;
    function AsQuotedDateTime: string;
    function AsJsonObject: TJSONObject;
    function Substring(AStart, ACount: Integer): string;

    procedure Salvar(const AFilename: string);

    class function ParseArray(AValue: string; AValueIsArray: Boolean = False): TJsonArray; overload;
    class function ParseArray(AValue: string; AEncoding: TEncodingType; AValueIsArray: Boolean = False): TJsonArray; overload;
    class function ParseObject(AValue: string): TJSONObject;

    Property Field[AIndex: Integer]: TJSONValue read GetFieldIndex; default;
    Property Field[AName: String]: TJSONValue read GetFieldName; default;
  end;

  // Helper para DSHTTP
  TDSHTTPHelper = class Helper for TDSHTTP
  public
    function Rest(AURL: string): TJsonArray;
  end;

  // Helper para ClientDataSet
  TClientDataSetHelper = class Helper for TClientDataSet
  private
    function GetFieldIndex(AIndex: Integer): TField;
    function GetFieldName(AName: string): TField;
    function GetBrowsing: Boolean;
    function GetEditing: Boolean;
    function GetInserting: Boolean;
    function GetIsInactive: Boolean;
  public
    property Field[AIndex: Integer]: TField read GetFieldIndex; default;
    property Field[AName: string]: TField read GetFieldName; default;
    property IsInactive: Boolean read GetIsInactive;
    property Browsing: Boolean read GetBrowsing;
    property Editing: Boolean read GetEditing;
    property Inserting: Boolean read GetInserting;

    procedure AddFilter(AFilter: string);
    procedure CleanFilter;

    function IsFilled: Boolean;
    function HasField(AFieldName: string): Boolean;

    function isValid: Boolean; overload;
    function isValid(const AShowError: Boolean): Boolean; overload;
  end;

  // Helper para TField
  TFieldHelper = class Helper for TField
  private
    function GetAsSql: string;
    function GetIsEmpty: Boolean;
    function GetIsFilled: Boolean;
    function GetLength: Integer;
    function GetAsDQuoted: string;
    function GetAsUpper: string;
    procedure SetAsUpper(const Value: string);
    function GetAsFormat(AFormat: string): string;
    function GetAsSubString(ASize: Integer): string;
    function GetAsFloatSQL: string;
    function GetAsLower: string;
    procedure SetAsLower(const Value: string);
  public
    property AsSql: string read GetAsSql;
    property AsDQuoted: string read GetAsDQuoted;
    property AsFloatSQL: string read GetAsFloatSQL;
    property IsEmpty: Boolean read GetIsEmpty;
    property IsFilled: Boolean read GetIsFilled;
    property Length: Integer read GetLength;
    property AsUpper: string read GetAsUpper write SetAsUpper;
    property AsLower: string read GetAsLower write SetAsLower;
    property AsFormat[AFormat: string]: string read GetAsFormat;
    property AsSubString[ASize: Integer]: string read GetAsSubString;
    procedure DefaultOrder;
    function Substring(AStart, ACount: Integer): string;
    function AsDef(ADef: Integer): Integer; overload;
    function AsDef(ADef: Double): Double; overload;
    function AsDef(ADef: Boolean): Boolean; overload;
    function AsDef(ADef: TDate): TDate; overload;
    function AsDef(ADef: TDateTime): TDateTime; overload;
  end;

  // Helper para Readers
  TDBXReaderHelper = class Helper for TDBXReader
  private
    function GetFieldIndex(AIndex: Integer): TDBXValue;
    function GetFieldName(AName: string): TDBXValue;
    function GetRecNo: Integer;
  public
    constructor Create(AConn: TDBXConnection);
    property Field[AIndex: Integer]: TDBXValue read GetFieldIndex; default;
    property Field[AName: string]: TDBXValue read GetFieldName; default;
    property RecNo: Integer read GetRecNo;

  end;

  TDBXValueHelper = class Helper for TDBXValue
  private
    function GetAsInteger: Integer;
    function GetAsSql: string;
    function GetAsFloatSQL: string;
    function GetAsDateSql: string;
    function GetAsLower: string;
    function GetAsUpper: string;
  public
    property AsInteger: Integer read GetAsInteger;
    property AsSql: string read GetAsSql;
    property AsFloatSQL: string read GetAsFloatSQL;
    property AsDateSql: string read GetAsDateSql;
    property AsUpper: string read GetAsUpper;
    property AsLower: string read GetAsLower;
  end;

  TDBXRowHelper = class Helper for TDBXRow
  public
    function RecNo: Integer;
  end;

  TDBXValueListHelper = class Helper for TDBXValueList
  private
    procedure First;
  public
    procedure GoToFirst;
  end;

  // Helper para Command
  TDBXCommandHelper = class Helper for TDBXCommand
  public
    procedure Release;
  end;

  // Helper para TObject
  TObjectHelper = class Helper for TObject
  public
    function AsJsonObject: TJSONObject;
    function AsJsonArray: TJsonArray;
    procedure Bloquear;
    procedure Desbloquear;
    function getProperty(const AProperty: string): TValue;
    function Invoke(const AMethod: string;
      const AParametros: array of TValue): TValue;
    procedure setProperty(const AProperty: string; const AValor: TValue);
  end;

  // Helper para TStrings
  TStringsHelper = class Helper for TStrings
  public
    function SubString(Line, Index, Count: Integer): string;
  end;

  // Helper para TStringBuilder
  TStringBuilderHelper = class Helper for TStringBuilder
  public
    function Append(const Value: Boolean; Quoted: Boolean = False)
      : TStringBuilder; overload;
    function Replace(const OldValue: string; const NewValue: Integer)
      : TStringBuilder; overload;
    function Replace(const OldValue: string; const NewValue: Double)
      : TStringBuilder; overload;
    function Replace(const OldValue: string; const NewValue: TDateTime)
      : TStringBuilder; overload;
  end;

  // Helper para ListBox
  TListBoxHelper = class Helper for TListBox
  public
    function getObject(AIndex: Integer): TObject;
  end;

  TJvListBoxHelper = class Helper for TJvListBox
  private
    function GetField(AName: string): TJSONValue;
    function GetFieldAt(AIndex: Integer; AName: string): TJSONValue;
    function GetJSONObjects(AIndex: Integer): TJSONObject;
    function GetObjects(AIndex: Integer): TObject;
  public
    function getObject: TObject; overload;
    function getObject<T: class>: T; overload;
    function JSONObject: TJSONObject;
    function IsNull: Boolean;
    property Field[AName: string]: TJSONValue read GetField;
    property FieldAt[AIndex: Integer; AName: string]: TJSONValue read GetFieldAt;
    property Objects[AIndex: Integer]: TObject read GetObjects;
    property JSONObjects[AIndex: Integer]: TJSONObject read GetJSONObjects;
  end;

  // Helper para CheckListBox
  TCheckListBoxHelper = class Helper for TCheckListBox
  public
    function getObject(AIndex: Integer): TObject; overload;
    function getObject<T: class>(AIndex: Integer): T; overload;
    procedure NovoItem(const ACodigo: Integer; const ADescricao: string);
    function getIn: string;
  end;

  // Helper para JvCheckListBox
  TJvCheckListBoxHelper = class Helper for TJvCheckListBox
  private
    function getCheckedObject(AIndex: Integer): TItemCheckList;
    function GetObjectAt(AIndex: Integer): TItemCheckList;
    function getUncheckedObject(AIndex: Integer): TItemCheckList;
    function getCheckedString(AIndex: Integer): string;
    function GetStringAt(AIndex: Integer): string;
    function getUncheckedString(AIndex: Integer): string;
    function GetIntegerAt(AIndex: Integer): Integer;
    function getCheckedInteger(AIndex: Integer): Integer;
    function getUncheckedInteger(AIndex: Integer): Integer;
  public
    property ObjectAt[AIndex: Integer]: TItemCheckList read GetObjectAt;
    property StringAt[AIndex: Integer]: string read GetStringAt;
    property IntegerAt[AIndex: Integer]: Integer read GetIntegerAt;

    property CheckedObject[AIndex: Integer]: TItemCheckList
      read getCheckedObject;
    property CheckedString[AIndex: Integer]: string read getCheckedString;
    property CheckedInteger[AIndex: Integer]: Integer read getCheckedInteger;

    property UncheckedObject[AIndex: Integer]: TItemCheckList
      read getUncheckedObject;
    property UncheckedString[AIndex: Integer]: string read getUncheckedString;
    property UncheckedInteger[AIndex: Integer]: Integer
      read getUncheckedInteger;
  end;

  //Helper para ListView
  TListViewHelper = class Helper for TListView
  private
    function GetChecked(AIndex: Integer): Boolean;
    procedure SetChecked(AIndex: Integer; const Value: Boolean);
    function GetGroupID(AIndex: Integer): Integer;
  public
    function ItemsFor: Integer;
    function GetObject(AIndex: Integer): TListItem;
    function CheckCount(AFast: Boolean = False): Integer;
    function NoChecks: Boolean;
    property Checked[AIndex: Integer]: Boolean read GetChecked write SetChecked;
    property GroupID[AIndex: Integer]: Integer read GetGroupID;
  end;

  // Helper para AdvSmoothSlider
  TAdvSmoothSliderHelper = class Helper for TAdvSmoothSlider
  private
    function GetValue: Boolean;
    procedure SetValue(const Value: Boolean);
  public
    property Value: Boolean read GetValue write SetValue;
  end;

  TAdvStringGridHelper = class Helper for TAdvStringGrid
  private
    function GetJSONObject(c, r: Integer): TJSONObject;
    procedure OrdenaGrid(Sender: TObject; ACol, ARow: Integer);
  public
    property JSONObjects[c, r: Integer]: TJSONObject read GetJSONObject;
    procedure FormatGrid(const ATitulos: array of string; const ASizes: array of Integer; AFilterDropDownAuto: Boolean = False);
    procedure ClearDataRows;
    procedure ClearDataCols(AColStart, AColCount: Integer; RemoveObjects: Boolean);
    function IncRowCount(ACount: Integer = 1): Integer;
    function DecRowCount(ACount: Integer = 1): Integer;
    function IsEmpty: Boolean;
    function RowsFor: Integer;
    function ColsFor: Integer;
    function GetObject<T: class>(c, r: Integer): T;
    procedure RestandardGrid; overload;
    procedure RestandardGrid(AStylesToKeep: array of TFontStyle); overload;
    procedure StyleRow(ARow: Integer; AStyle: TFontStyles); overload;
    procedure StyleRow(AStyle: TFontStyles); overload;
    procedure StrikeRow(ARow: Integer); overload;
    procedure StrikeRow; overload;
    procedure BoldRow(ARow: Integer); overload;
    procedure BoldRow; overload;
  end;

  // Helper para ComboBox
  TCustomComboBoxHelper = class Helper for TCustomComboBox
  private
    procedure SetItemString(const Value: string);
    function GetIsEmpty: Boolean;
    function GetIsNull: Boolean;
  public
    procedure IndexOf(const AValue: String);
    procedure SetNull;
    property ItemString: string write SetItemString;
    property IsEmpty: Boolean read GetIsEmpty;
    property IsNull: Boolean read GetIsNull;
  end;

  TComboBoxHelper = class Helper for TJvComboBox
  private
    procedure SetItemString(const Value: string);
    function GetFieldByName(AName: String): TJSONValue;
    function GetFieldAtByName(AIndex: Integer; AName: String): TJSONValue;
  public
    procedure Add(AValue: string); overload;
    procedure Add(AValue: string; AObject: TObject); overload;
    procedure SetKeyIndex<T>(const Value: T);
    procedure SetNull;
    function GetKeyIndex<T>: T;
    function GetItem: TItem;
    function GetItemAt(const AIndex: Integer): TItem;
    function getObject: TObject; overload;
    function getObject<T: class>: T; overload;
    function GetObjectAt(const AIndex: Integer): TObject; overload;
    function GetObjectAt<T: class>(const AIndex: Integer): T; overload;
    function GetJSONObject: TJSONObject;
    function GetJSONObjectAt(const AIndex: Integer): TJSONObject;
    function Substring(const AFrom: Integer; const ACount: Integer): string;
    property ItemString: string write SetItemString;
    property Field[AName: String]: TJSONValue read GetFieldByName;
    property FieldAt[AIndex: Integer; AName: String]: TJSONValue read GetFieldAtByName;
  end;

  TRZComboBoxHelper = class Helper for TRzComboBox
  public
    function getObject: TObject; overload;
    function getObject<T: class>: T; overload;
    function GetObjectAt(const AIndex: Integer): TObject; overload;
    function GetObjectAt<T: class>(const AIndex: Integer): T; overload;
  end;

  TJvCheckedComboBoxHelper = class Helper for TJvCheckedComboBox
  private
    function GetFieldByName(AIndex: Integer; AName: String): TJSONValue;
  public
    function GetObject(const AIndex: Integer): TObject; overload;
    function GetObject<T: class>(const AIndex: Integer): T; overload;
    function GetJSONObject(const AIndex: Integer): TJSONObject;
    function ItemsFor: Integer;
    function CheckCount(AFast: Boolean = False): Integer;
    function NoChecks: Boolean;
    property Field[AIndex: Integer; AName: String]: TJSONValue read GetFieldByName;
  end;

  TLookupComboBoxHelper = class Helper for TCustomDBLookupComboBox
  private
    function GetAsString: string;
    procedure SetAsString(const Value: string);
    function GetAsInteger: Integer;
    procedure SetAsInteger(const Value: Integer);
    function GetAsDouble: Double;
    procedure SetAsDouble(const Value: Double);
    function GetIsEmpty: Boolean;
  public
    procedure Clear;

    property AsString: string read GetAsString write SetAsString;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TDBLookupComboBoxHelper = class Helper for TDBLookupComboBox
  public
    procedure SetFields(AKey, AList: string); overload;
    procedure SetFields(AIndexKey, AIndexList: Integer); overload;
    procedure Grow;
  end;

  TCurvyComboHelper = class Helper for TCurvyCombo
  private
    function GetIsEmpty: Boolean;
    function GetIsNull: Boolean;
  public
    property IsEmpty: Boolean read GetIsEmpty;
    property IsNull: Boolean read GetIsNull;

    function getObject: TObject; overload;
    function getObject(AIndex: Integer): TObject; overload;
  end;

  // Helper para TRadioGroup
  TRadioGroupHelper = class Helper for TRadioGroup
  public
    function GetSelectionName: string;
  end;

  TPopupMenuHelper = class Helper for TPopupMenu
  public
    procedure Popup(P: TPoint); overload;
    procedure PopupAtCursor;
  end;

  // Helper para JvDateEdit
  TJvDateEditHelper = class Helper for TJvCustomDateEdit
  private
    function GetSqlDate: string;
    procedure SetSqlDate(const Value: string);
  public
    property SqlDate: string read GetSqlDate write SetSqlDate;
    function Day: Integer;
    function StrDay: string;
    function Month: Integer;
    function StrMonth: string;
    function Year: Integer;
    function StrYear: string;
  end;

  //Helper para JvDBGrid
  TJvDBGridHelper = class Helper for TJvDBGrid
  private
    function GetColumnByName(AFieldName: string): TColumn;
    function GetColIndex(AFieldName: string): Integer;
  public
    property Field[AFieldName: string]: TColumn read GetColumnByName;
    property ColIndex[AFieldName: string]: Integer read GetColIndex;

    procedure HideColumns;
    procedure SetColumn(AColumn, ANewIndex, AWidth: Integer; AReadOnly: Boolean; ATitle: string = ''); overload;
    procedure SetColumn(AColumnName: string; ANewIndex, AWidth: Integer; AReadOnly: Boolean; ATitle: string = ''); overload;
  end;

  // Helper para Edit
  TCustomEditHelper = class Helper for TCustomEdit
  private
    function GetAsDate: TDateTime;
    function GetAsDouble: Double;
    function GetAsInteger: Integer;
    function GetAsString: string;
    procedure SetAsDate(const Value: TDateTime);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsString(const Value: string);
    function GetIsEmpty: Boolean;
    procedure SetMasked(AFormat: string; const Value: string);
    function GetLength: Integer;
  public
    property Masked[AFormat: string]: string write SetMasked;
    property AsString: string read GetAsString write SetAsString;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsDate: TDateTime read GetAsDate write SetAsDate;
    property IsEmpty: Boolean read GetIsEmpty;
    property Length: Integer read GetLength;
  end;

  // Helper para TCheckBox
  TCheckBoxHelper = class Helper for TCheckBox
  private
    function GetUnchecked: Boolean;
    function GetAsString: string;
  public
    property Unchecked: Boolean read GetUnchecked;
    property AsString: string read GetAsString;
    procedure InvertState;
    procedure Check;
    procedure Uncheck;
  end;

  TDBCheckBoxHelper = class Helper for TDBCheckBox
  private
    function GetUnchecked: Boolean;
    function GetAsString(ATrue: string): string;
  public
    property Unchecked: Boolean read GetUnchecked;
    property AsString[ATrue: string]: string read GetAsString;
    procedure InvertState;
    procedure Check;
    procedure Uncheck;
  end;

  // Helper para FastReport
  TfrxReportHelper = class Helper for TfrxReport
  public
    procedure LoadFromFile(AFilename: string); overload;
    procedure ExecuteReport(AFilename: string; AParams: array of string; AReportIndex: Integer); overload;
    procedure ExecuteReport(AFilename: string; AParams: array of string; AReportIndex: array of Integer); overload;
    procedure ExecuteReport(AFilename: string; AParams: array of string; AReportName: string = ''); overload;
    procedure ExecuteReport(AFilename: string; AParams: array of string; AReportName: array of string); overload;
    procedure DebugReport(AFilename: string; AReportname: string = '');
    // procedure ShowReport; override;
    function HasVariables: Boolean;
    procedure SetParam(const AParam: string); overload;
    procedure SetParam(const AParam, AValue: string); overload;
    procedure SetParam(const AParam: string; const AValue: Integer;
      const AFormat: string = '00'); overload;
    procedure SetParam(const AParam: string; const AValue: Double;
      const AFormat: string = '#,##0.00'); overload;
    procedure SetParam(const AParam: string; const AValue: TDateTime;
      const AFormat: string = 'dd/mm/yyyy'); overload;
    procedure SetParam(const AParam: string; const AValue: Boolean); overload;
  end;

  TFormHelper = class Helper for TForm
  private
  public
    function Invoke(const AMethod: string; const AParametros: array of TValue): TValue;
  end;

  TControlHelper = class Helper for TControl
  public
    procedure AlignCenterCenter;
    procedure Enable;
    procedure Disable;
    procedure ToClipboard(AValue: string);
  end;

  TWinControlHelper = class Helper for TWinControl
  public
    procedure DYE(AColor: TColor);
  end;

  TLabelHelper = class Helper for TLabel
  public
    procedure DYE(AColor: TColor);
    procedure ToClipboard; overload;
    procedure ToClipboard(ASize: Integer); overload;
    procedure ToClipboard(AStart, ASize: Integer); overload;
  end;

  //Objetos Auxiliares
  TItem = class
  private
    FCodigo: Integer;
    FDescricao: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Descricao: string read FDescricao write FDescricao;
  end;

  TEtapa = class
  private
    FDescricao: string;
    FId: Integer;
    FFim: TDateTime;
    FInicio: TDateTime;
    FNotaMax: Double;
    function GetPeriodo: string;
  public
    property Id: Integer read FId write FId;
    property Descricao: string read FDescricao write FDescricao;
    property Inicio: TDateTime read FInicio write FInicio;
    property Fim: TDateTime read FFim write FFim;
    property Periodo: string read GetPeriodo;
    property NotaMax: Double read FNotaMax write FNotaMax;
  end;

  TJsonUtils = class
  public
    class function Marshal<T: class>(AObjetoj: T): TJSONValue;

    class function UnMarshal<T: class>(AJSON: TJSONValue): T; overload;
    class function UnMarshal<T: class>(AJSON: string): T; overload;
  end;

implementation

uses
  Vcl.Grids;

{ TJsonValueHelper }

function TJSONValueHelper.AsBoolean: Boolean;
begin
  Result := False;

  if Self is TJSONTrue then
    Result := True
  else
  begin
    if Self is TJSONString then
    begin
      if UpperCase(Self.AsString[1]) = 'T' then
        Result := True
      else if UpperCase(Self.AsString[1]) = 'S' then
        Result := True
      else
        Result := False;
    end
    else if Self is TJSONNumber then
    begin
      if Self.AsInteger > 0 then
        Result := True
      else
        Result := False;
    end
    else
      Result := False;
  end;
end;

function TJSONValueHelper.AsDateTime: TDateTime;
var
  vData: Double;
begin
  if TryStrToFloat(Value, vData) then
    Result := FloatToDateTime(vData)
  else
    Result := StrToDateTimeDef(Value, 0)
end;

function TJSONValueHelper.AsDouble: Double;
begin
  Result := StrToFloatDef(AnsiReplaceStr(Value, '.', ''), 0);
end;

function TJSONValueHelper.AsDoubleNull: string;
var
  strAux: string;
begin
  if Self.AsString = '' then
    strAux := 'NULL'
  else
  begin
    strAux := FloatToStr(AsDouble);

    strAux := AnsiReplaceStr(strAux, '.', '');
    strAux := AnsiReplaceStr(strAux, ',', '.');
  end;

  Result := strAux;
end;

function TJSONValueHelper.AsDoubleSql: string;
var
  strAux: string;
begin
  strAux := FloatToStr(AsDouble);

  strAux := AnsiReplaceStr(strAux, '.', '');
  strAux := AnsiReplaceStr(strAux, ',', '.');

  Result := strAux;
end;

function TJSONValueHelper.AsInteger: Integer;
begin
  Result := StrToIntDef(Value, 0);
end;

function TJSONValueHelper.AsJsonArray: TJsonArray;
begin
  if Self is TJsonArray then
    Result := TJsonArray(Self)
  else
    Result := nil;
end;

function TJSONValueHelper.AsJsonObject: TJSONObject;
begin
  if Self is TJSONObject then
    Result := TJSONObject(Self)
  else
    Result := nil;
end;

function TJSONValueHelper.AsLower: string;
begin
  Result := LowerCase(Value);
end;

function TJSONValueHelper.AsQuotedDate: string;
begin
  Result := QuotedStr(FormatDateTime('DD.MM.YYYY', AsDateTime));
end;

function TJSONValueHelper.AsQuotedDateTime: string;
begin
  Result := QuotedStr(FormatDateTime('DD.MM.YYYY HH:MM:SS', AsDateTime));
end;

function TJSONValueHelper.AsQuotedStr: string;
begin
  Result := QuotedStr(Value);
end;

function TJSONValueHelper.AsString: string;
begin
  Result := Value;
end;

function TJSONValueHelper.AsStrNull: string;
begin
  if Value = '' then
    Result := 'NULL'
  else
    Result := QuotedStr(Value);
end;

function TJSONValueHelper.AsUpper: string;
begin
  Result := AnsiUpperCase(Value);
end;

function TJSONValueHelper.GetFieldIndex(AIndex: Integer): TJSONValue;
begin
  Result := Self.AsJsonObject.Field[AIndex];
end;

function TJSONValueHelper.GetFieldName(AName: String): TJSONValue;
begin
  Result := Self.AsJsonObject.Field[AName];
end;

class function TJSONValueHelper.ParseArray(AValue: string;
  AValueIsArray: Boolean): TJsonArray;
var
  ObjTemp: TJSONObject;
begin
  if AValueIsArray then
    Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AValue), 0)
      .AsJsonArray
  else
  begin
    ObjTemp := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AValue), 0)
      .AsJsonObject;
    Result := ObjTemp.Field[0].AsJsonArray;
  end;
end;

class function TJSONValueHelper.ParseArray(AValue: string; AEncoding: TEncodingType; AValueIsArray: Boolean): TJsonArray;
var
  ObjTemp: TJSONObject;
begin
  case AEncoding of
    eASCII: Result := ParseArray(AValue, AValueIsArray);
    eUTF8:
      begin
        if AValueIsArray then
          Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AValue), 0)
            .AsJsonArray
        else
        begin
          ObjTemp := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AValue), 0)
            .AsJsonObject;

          Result := ObjTemp.Field[0].AsJsonArray;
        end;
      end;
  end;
end;

class function TJSONValueHelper.ParseObject(AValue: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AValue), 0)
    .AsJsonObject;
end;

procedure TJSONValueHelper.Salvar(const AFilename: string);
var
  strAux: TStringBuilder;
  StringStream: TStringStream;
begin
  if FileExists(AFilename) then
    DeleteFile(PWideChar(AFilename));

  strAux := TStringBuilder.Create;
  try
    strAux.Append(UTF8Encode(Self.ToString));
    StringStream := TStringStream.Create(strAux.ToString);
    try
      StringStream.SaveToFile(AFilename);
    finally
      StringStream.Free;
    end;
  finally
    strAux.Free;
  end;
end;

function TJSONValueHelper.Substring(AStart, ACount: Integer): string;
begin
  Result := Copy(AsString, AStart, ACount);
end;

{ TJsonArrayHelper }

procedure TJSONArrayHelper.AddValue(AValue: TDate);
begin
  Self.AddElement(TJSONNumber.Create(AValue));
end;

procedure TJSONArrayHelper.AddValue(AValue: TDateTime);
begin
  Self.AddElement(TJSONNumber.Create(AValue));
end;

procedure TJSONArrayHelper.AddValue(AValue: string);
begin
  Self.AddElement(TJSONString.Create(AValue));
end;

procedure TJSONArrayHelper.AddValue(AValue: Integer);
begin
  Self.AddElement(TJSONNumber.Create(AValue));
end;

procedure TJSONArrayHelper.AddValue(AValue: Double);
begin
  Self.AddElement(TJSONNumber.Create(AValue));
end;

procedure TJSONArrayHelper.AddValue(AValue: TJSONObject);
begin
  Self.AddElement(AValue);
end;

procedure TJSONArrayHelper.AddValue(AValue: TJSONValue);
begin
  Self.AddElement(AValue);
end;

procedure TJSONArrayHelper.DebugFile(AFilename: string);
var
  Stream: TStringStream;
  FilePath: string;
  Letter: string;
  vFilename: string;
begin
  if DebugHook = 0 then
    Exit;

  if TUteis.ExisteUnidade('D:') then
    Letter := 'D:\'
  else
    Letter := 'C:\';

  vFilename := TUteis.MethodName(ProcByLevel(1, False)) + '.json';

  FilePath := Letter + 'JSONDebug\';
  if not DirectoryExists(FilePath) then
    ForceDirectories(FilePath);

  Stream := TStringStream.Create(Self.ToString);
  try
    Stream.SaveToFile(FilePath + vFilename);
  finally
    Stream.Free;
  end;
end;

function TJSONArrayHelper.GetFieldIndex(AIndex: Integer): TJSONValue;
begin
  Result := Self.Get(AIndex);
end;

function TJSONArrayHelper.HasRecords: Boolean;
begin
  Result := Self.Size > 0;
end;

class function TJSONArrayHelper.Inverse(AArray: TJsonArray): TJsonArray;
var
  I: Integer;
begin
  Result := TJsonArray.Create;

  for I := AArray.SizeFor downto 0 do
    Result.AddValue(AArray.Field[I]);
end;

function TJSONArrayHelper.IsEmpty: Boolean;
begin
  Result := Self.Size = 0;
end;

procedure TJSONArrayHelper.AddValue(AValue: Boolean);
begin
  if AValue then
    Self.AddElement(TJSONTrue.Create)
  else
    Self.AddElement(TJSONFalse.Create);
end;

procedure TJSONArrayHelper.AddValue(AValue: TJsonArray);
begin
  Self.AddElement(AValue);
end;

procedure TJSONArrayHelper.SaveToFile(AFilename: string);
var
  Stream: TStringStream;
  FilePath: string;
begin
  FilePath := ExtractFileDir(AFilename);
  if not DirectoryExists(FilePath) then
    ForceDirectories(FilePath);

  Stream := TStringStream.Create(Self.ToString);
  try
    Stream.SaveToFile(AFilename);
  finally
    Stream.Free;
  end;
end;

function TJSONArrayHelper.SizeFor: Integer;
begin
  Result := Size - 1;
end;

function TJSONArrayHelper.SizeGrid: Integer;
begin
  Result := Self.Size + 1;
end;

{ TJsonObjectHelper }

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: TDate);
begin
  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(DateToStr(AValue))));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: TDateTime);
begin
  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(DateTimeToStr(AValue))));
end;

procedure TJSONObjectHelper.AddValue(ADescription, AValue: string);
begin
  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: Integer);
begin
  Self.AddPair(TJSONPair.Create(ADescription, TJSONNumber.Create(AValue)));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: Double);
begin
  Self.AddPair(TJSONPair.Create(ADescription, TJSONNumber.Create(AValue)));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: TJSONObject);
begin
  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: TJSONValue);
begin
  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.DebugFile(AFilename: string);
var
  Stream: TStringStream;
  FilePath: string;
  Letter: string;
  vFilename: string;
begin
  if DebugHook = 0 then
    Exit;

  if TUteis.ExisteUnidade('D:') then
    Letter := 'D:\'
  else
    Letter := 'C:\';

  vFilename := TUteis.MethodName(ProcByLevel(1, False)) + '.json';

  FilePath := Letter + 'JSONDebug\';
  if not DirectoryExists(FilePath) then
    ForceDirectories(FilePath);

  Stream := TStringStream.Create(Self.ToString);
  try
    Stream.SaveToFile(FilePath + vFilename);
  finally
    Stream.Free;
  end;
end;

function TJSONObjectHelper.GetFieldIndex(AIndex: Integer): TJSONValue;
begin
  Result := Self.Get(AIndex).JsonValue;
end;

function TJSONObjectHelper.GetFieldName(AIndex: Integer): string;
begin
  Result := Self.Get(AIndex).FieldName;
end;

function TJSONObjectHelper.HasField(AName: string): Boolean;
var
  I: Integer;
begin
  Result := False;

  for I := 0 to Self.Size -1 do
  begin
    if (AName = Self.FieldName[I]) then
      Exit(True);
  end;
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: TDate);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(DateToStr(AValue))));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: TDateTime);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(DateTimeToStr(AValue))));
end;

procedure TJSONObjectHelper.Replace(ADescription, AValue: string);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: Integer);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, TJSONNumber.Create(AValue)));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: Double);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, TJSONNumber.Create(AValue)));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: TJSONObject);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: TJSONValue);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: Boolean);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(BoolToStr(AValue, True))));
end;

procedure TJSONObjectHelper.Replace(ADescription: string; AValue: TJsonArray);
begin
  if Self.HasField(ADescription) then
    Self.RemovePair(ADescription);

  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

function TJSONObjectHelper.GetFieldByName(AName: String): TJSONValue;
begin
  Result := Self.Get(AName).JsonValue;
end;

procedure TJSONObjectHelper.SaveToFile(AFilename: string);
var
  Stream: TStringStream;
  FilePath: string;
begin
  FilePath := ExtractFileDir(AFilename);
  if not DirectoryExists(FilePath) then
    ForceDirectories(FilePath);

  Stream := TStringStream.Create(Self.ToString);
  try
    Stream.SaveToFile(AFilename);
  finally
    Stream.Free;
  end;
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: Boolean);
begin
  Self.AddPair(TJSONPair.Create(ADescription,
    TJSONString.Create(BoolToStr(AValue, True))));
end;

procedure TJSONObjectHelper.AddValue(ADescription: string; AValue: TJsonArray);
begin
  Self.AddPair(TJSONPair.Create(ADescription, AValue));
end;

{ TDSHTTPHelper }

function TDSHTTPHelper.Rest(AURL: string): TJsonArray;
begin
  Result := TJSONValue.ParseArray(Get(AURL));
end;

{ TClientDataSetHelper }

procedure TClientDataSetHelper.AddFilter(AFilter: string);
begin
  if AFilter = '' then
    Exit;

  Self.Filter := Self.Filter + AFilter;
  Self.Filtered := True;
end;

procedure TClientDataSetHelper.CleanFilter;
begin
  Self.Filter := '';
  Self.Filtered := False;
end;

function TClientDataSetHelper.GetBrowsing: Boolean;
begin
  Result := (Self.State = dsBrowse);
end;

function TClientDataSetHelper.GetEditing: Boolean;
begin
  Result := (Self.State = dsEdit);
end;

function TClientDataSetHelper.GetFieldIndex(AIndex: Integer): TField;
begin
  Result := Self.Fields[AIndex];
end;

function TClientDataSetHelper.GetFieldName(AName: string): TField;
begin
  Result := Self.FieldByName(AName);
end;

function TClientDataSetHelper.GetInserting: Boolean;
begin
  Result := (Self.State = dsInsert);
end;

function TClientDataSetHelper.GetIsInactive: Boolean;
begin
  Result := (Self.State = dsInactive);
end;

function TClientDataSetHelper.HasField(AFieldName: string): Boolean;
begin
  Result := (Self.FindField(AFieldName) <> nil);
end;

function TClientDataSetHelper.IsFilled: Boolean;
begin
  Result := not Self.IsEmpty;
end;

function TClientDataSetHelper.isValid: Boolean;
begin
  Result := Self.isValid(True);
end;

function TClientDataSetHelper.isValid(const AShowError: Boolean): Boolean;
var
  I: Integer;
  Msg: string;
begin
  Result := True;

  if Self.State = dsInactive then
    Exit;

  if Self.State = dsBrowse then
  begin
    if Self.RecordCount = 0 then
      Exit;
  end;

  for I := 0 to Self.FieldCount - 1 do
  begin
    if ((Self.Fields[I].IsNull) or (Self.Fields[I].AsString = EmptyStr)) and
      (Self.Fields[I].Required) then
    begin
      Result := False;
      Self.Fields[I].FocusControl;

      if AShowError then
      begin
        Msg := 'O Campo "' + Self.Fields[I].DisplayLabel +
          '" é de Preenchimento Obrigatório!';
        Application.MessageBox(PCHAR(Msg), 'Atenção',
          MB_OK + MB_ICONINFORMATION);
      end;
      Exit;
    end;
  end;
end;

{ TStringsHelper }

function TStringsHelper.SubString(Line, Index, Count: Integer): string;
begin
  Result := Copy(Self.Strings[Line], Index, Count);
end;

{ TListBoxHelper }

function TListBoxHelper.getObject(AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

{ TComboBoxHelper }

procedure TComboBoxHelper.Add(AValue: string);
var
  Tam: Integer;
begin
  Self.Items.Add(AValue);

  Tam := Self.Width + Trunc(Length(AValue) * 5.3);
  if (Self.DropDownWidth < Tam) or (Self.Items.Count = 1) then
    Self.DropDownWidth := Tam;
end;

procedure TComboBoxHelper.Add(AValue: string; AObject: TObject);
var
  Tam: Integer;
begin
  Self.AddItem(AValue, AObject);

  Tam := Self.Width + Trunc(Length(AValue) * 5.3);
  if (Self.DropDownWidth < Tam) or (Self.Items.Count = 1) then
    Self.DropDownWidth := Tam;
end;


function TComboBoxHelper.GetFieldAtByName(AIndex: Integer; AName: String): TJSONValue;
begin
  Result := Self.GetJSONObjectAt(AIndex).Field[AName];
end;

function TComboBoxHelper.GetFieldByName(AName: String): TJSONValue;
begin
  Result := Self.GetJSONObject.Field[AName];
end;

function TComboBoxHelper.GetItem: TItem;
begin
  Result := TItem(Self.Items.Objects[Self.ItemIndex]);
end;

function TComboBoxHelper.GetItemAt(const AIndex: Integer): TItem;
begin
  Result := TItem(Self.Items.Objects[AIndex]);
end;

function TComboBoxHelper.GetJSONObject: TJSONObject;
begin
  Result := TJSONObject(Self.Items.Objects[Self.ItemIndex]);
end;

function TComboBoxHelper.GetJSONObjectAt(const AIndex: Integer): TJSONObject;
begin
  Result := TJSONObject(Self.Items.Objects[AIndex]);
end;

function TComboBoxHelper.GetKeyIndex<T>: T;
begin
  Result := getObject.getProperty('id').AsType<T>;
end;

function TComboBoxHelper.getObject: TObject;
begin
  if Self.ItemIndex = -1 then
    Result := nil
  else
    Result := Self.Items.Objects[Self.ItemIndex];
end;

function TComboBoxHelper.getObject<T>: T;
begin
  Result := T(Self.getObject);
end;

function TComboBoxHelper.GetObjectAt(const AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

function TComboBoxHelper.GetObjectAt<T>(const AIndex: Integer): T;
begin
  Result := T(Self.GetObjectAt(AIndex));
end;

procedure TComboBoxHelper.SetItemString(const Value: string);
begin
  Self.ItemIndex := Self.Items.IndexOf(Value);
end;

procedure TComboBoxHelper.SetKeyIndex<T>(const Value: T);
var
  I: Integer;
  obj: TObject;
  js: TJSONObject;
  Val: TValue;
  lComparer: IEqualityComparer<T>;
begin
  lComparer := TEqualityComparer<T>.Default;

  for I := 0 to Self.Items.Count - 1 do
  begin
    obj := Self.GetObjectAt(I);

    if not Assigned(obj) then
      Continue;

    if obj is TJSONObject then
    begin
      js := TJSONObject(obj);

      Val := js.Field['id'].Value;

      if Val.IsEmpty then
        Continue;

      if lComparer.Equals(Value, Val.AsType<T>) then
      begin
        Self.ItemIndex := I;
        Exit;
      end;
    end
    else
    begin
      Val := obj.getProperty('id');

      if Val.IsEmpty then
        Continue;

      if lComparer.Equals(Value, Val.AsType<T>) then
      begin
        Self.ItemIndex := I;
        Exit;
      end;
    end;
  end;
end;

procedure TComboBoxHelper.SetNull;
begin
  Self.ItemIndex := -1;
end;

function TComboBoxHelper.Substring(const AFrom, ACount: Integer): string;
begin
  Result := Copy(Self.Text, AFrom, ACount);
end;

{ TCustomComboBoxHelper }

function TCustomComboBoxHelper.GetIsEmpty: Boolean;
begin
  Result := Self.Items.Count = 0;
end;

function TCustomComboBoxHelper.GetIsNull: Boolean;
begin
  Result := Self.ItemIndex = -1;
end;

procedure TCustomComboBoxHelper.IndexOf(const AValue: String);
begin
  Self.ItemIndex := Self.Items.IndexOf(AValue);
end;

procedure TCustomComboBoxHelper.SetItemString(const Value: string);
begin
  Self.ItemIndex := Self.Items.IndexOf(Value);
end;

procedure TCustomComboBoxHelper.SetNull;
begin
  Self.ItemIndex := -1;
end;

{ TJsonUtils }

class function TJsonUtils.Marshal<T>(AObjetoj: T): TJSONValue;
var
  Marshal: TJSONMarshal;
begin
  Marshal := TJSONMarshal.Create(TJSONConverter.Create);
  try
    Result := Marshal.Marshal(AObjetoj);
  finally
    Marshal.Free;
  end;
end;

class function TJsonUtils.UnMarshal<T>(AJSON: TJSONValue): T;
var
  UnMarshal: TJSONUnMarshal;
begin
  UnMarshal := TJSONUnMarshal.Create;
  try
    Result := T(UnMarshal.UnMarshal(AJSON));
  finally
    UnMarshal.Free;
  end;
end;

class function TJsonUtils.UnMarshal<T>(AJSON: string): T;
var
  UnMarshal: TJSONUnMarshal;
  jObject: TJSONValue;
begin
  UnMarshal := TJSONUnMarshal.Create;
  try
    jObject := TJSONValue.ParseObject(AJSON);
    Result := T(UnMarshal.UnMarshal(jObject));
  finally
    UnMarshal.Free;
  end;
end;

{ TLookupComboBoxHelper }

function TLookupComboBoxHelper.GetAsDouble: Double;
begin
  if Self.KeyValue <> Null then
    Result := Self.KeyValue
  else
    Result := 0;
end;

function TLookupComboBoxHelper.GetAsInteger: Integer;
begin
  if Self.KeyValue <> Null then
    Result := Self.KeyValue
  else
    Result := 0;
end;

function TLookupComboBoxHelper.GetAsString: string;
begin
  if Self.KeyValue <> Null then
    Result := VarToStr(Self.KeyValue)
  else
    Result := '';
end;

function TLookupComboBoxHelper.GetIsEmpty: Boolean;
begin
  Result := (Self.KeyValue = Null);
end;

procedure TLookupComboBoxHelper.Clear;
begin
  Self.KeyValue := Null;
end;

procedure TLookupComboBoxHelper.SetAsDouble(const Value: Double);
begin
  if Value < 0 then
    Clear
  else
    KeyValue := Value;
end;

procedure TLookupComboBoxHelper.SetAsInteger(const Value: Integer);
begin
  if Value < 0 then
    Clear
  else
    KeyValue := Value;
end;

procedure TLookupComboBoxHelper.SetAsString(const Value: string);
begin
  if StrToIntDef(Value, -1) < 0 then
    Clear
  else
    KeyValue := Value;
end;

{ TJvDateEditHelper }

function TJvDateEditHelper.StrDay: string;
begin
  Result := IntToStr(Day);
end;

function TJvDateEditHelper.Day: Integer;
begin
  Result := DayOf(Self.Date);
end;

function TJvDateEditHelper.GetSqlDate: string;
begin
  Result := QuotedStr(FormatDateTime('dd.mm.yyyy', Self.Date));
end;

function TJvDateEditHelper.StrMonth: string;
begin
  Result := IntToStr(Month);
end;

function TJvDateEditHelper.Month: Integer;
begin
  Result := MonthOf(Self.Date);
end;

procedure TJvDateEditHelper.SetSqlDate(const Value: string);
var
  A: Variant;
begin
  Self.Date := StrToDateDef(Value, 0);
end;

function TJvDateEditHelper.Year: Integer;
begin
  Result := YearOf(Self.Date);
end;

function TJvDateEditHelper.StrYear: string;
begin
  Result := IntToStr(Year);
end;

{ TCustomEditHelper }

function TCustomEditHelper.GetAsDate: TDateTime;
begin
  Result := StrToDateDef(Self.Text, 0);
end;

function TCustomEditHelper.GetAsDouble: Double;
begin
  Result := TUteis.SafeFloat(Self.Text);
end;

function TCustomEditHelper.GetAsInteger: Integer;
begin
  Result := StrToIntDef(Self.Text, 0);
end;

function TCustomEditHelper.GetAsString: string;
begin
  Result := Self.Text;
end;

function TCustomEditHelper.GetIsEmpty: Boolean;
begin
  Result := (Trim(Self.Text) = '');
end;

function TCustomEditHelper.GetLength: Integer;
begin
  Result := System.Length(Self.AsString);
end;

procedure TCustomEditHelper.SetAsDate(const Value: TDateTime);
begin
  Self.Text := FormatDateTime('dd/mm/yyyy', Value);
end;

procedure TCustomEditHelper.SetAsDouble(const Value: Double);
begin
  Self.Text := FormatFloat('#,##0.00', Value);
end;

procedure TCustomEditHelper.SetAsInteger(const Value: Integer);
begin
  Self.Text := IntToStr(Value);
end;

procedure TCustomEditHelper.SetAsString(const Value: string);
begin
  Self.Text := Value;
end;

procedure TCustomEditHelper.SetMasked(AFormat: string; const Value: string);
var
  I: Integer;
  strAux: string;
begin
  strAux := Value;

  for I := 1 to System.Length(strAux) do
  begin
    if (AFormat[I] = '9') and not(strAux[I] in ['0' .. '9']) and
      (System.Length(strAux) = System.Length(AFormat) + 1) then
      delete(strAux, I, 1);

    if (AFormat[I] <> '9') and (strAux[I] in ['0' .. '9']) then
      insert(AFormat[I], strAux, I);
  end;

  Self.AsString := strAux;
  Self.SelStart := Self.Length;
end;

{ TfrxReportHelper }

procedure TfrxReportHelper.SetParam(const AParam: string; const AValue: Integer;
  const AFormat: string);
begin
  Self.Variables[AParam] := QuotedStr(FormatFloat(AFormat, AValue));
end;

procedure TfrxReportHelper.SetParam(const AParam: string; const AValue: Double;
  const AFormat: string);
begin
  Self.Variables[AParam] := QuotedStr(FormatFloat(AFormat, AValue));
end;

procedure TfrxReportHelper.SetParam(const AParam: string);
begin
  Self.Variables[AParam] := QuotedStr('');
end;

procedure TfrxReportHelper.SetParam(const AParam, AValue: string);
begin
  Self.Variables[AParam] := QuotedStr(AValue);
end;

procedure TfrxReportHelper.ExecuteReport(AFilename: string; AParams: array of string; AReportIndex: array of Integer);
var
  objParam: TJSONObject;
  jParam: TJsonArray;
  I: Integer;
  vParam, vValue: string;
begin
  objParam := nil;
  jParam := nil;

  if Length(AParams) > 0 then
    jParam := TJSONObject.ParseArray(TUteis.ArrayString(AParams), eUTF8, True);

  Self.LoadFromFile(AFilename);

  if Length(AReportIndex) = 1 then
    Self.Pages[AReportIndex[0]].Visible := True
  else
  begin
    for I := 0 to Length(AReportIndex) -1 do
      Self.Pages[AReportIndex[I]].Visible := True
  end;

  if Assigned(jParam) then
  begin
    for I := 0 to jParam.SizeFor do
    begin
      objParam := jParam.Field[I].AsJsonObject;

      if Assigned(objParam) then
      begin
        vParam := objParam.FieldName[0];
        vValue := objParam.Field[0].AsString;

        Self.SetParam(vParam, vValue);
      end;
    end;
  end;

  if HasVariables then
  begin
    for I := 0 to Variables.Count - 1 do
    begin
      if Variables.Items[I].Value = Null then
        Self.SetParam(Trim(Variables.Items[I].Name), '');
    end;
  end;

  Self.ShowReport;
end;

procedure TfrxReportHelper.ExecuteReport(AFilename: string; AParams: array of string; AReportName: string);
var
  I: Integer;
begin
  Self.LoadFromFile(AFilename);

  I := -1;

  if AReportName <> '' then
  begin
    for I := 0 to Self.PagesCount -1 do
    begin
      if Self.Pages[I].Name = AReportName then
        Break;
    end;

    ExecuteReport(AFilename, AParams, I);
  end
  else
    ExecuteReport(AFilename, AParams, [0]);
end;

procedure TfrxReportHelper.DebugReport(AFilename, AReportname: string);
var
  I: Integer;
begin
  Self.LoadFromFile(AFilename);

  I := -1;

  if AReportName <> '' then
  begin
    for I := 0 to Self.PagesCount -1 do
    begin
      if Self.Pages[I].Name = AReportName then
      begin
        Self.Pages[I].Visible := True;
        Break;
      end;
    end;

    DesignReport;
  end
  else
    DesignReport;
end;

procedure TfrxReportHelper.ExecuteReport(AFilename: string; AParams, AReportName: array of string);
var
  I, J: Integer;
  Arr: array of Integer;
begin
  Self.LoadFromFile(AFilename);

  if Length(AReportName) = 1 then
    ExecuteReport(AFilename, AParams, [0])
  else
  begin
    SetLength(Arr, 0);

    for I := 0 to Length(AReportName) -1 do
    begin
      for J := 0 to Self.PagesCount -1 do
      begin
        if Self.Pages[J].Name = AReportName[I] then
        begin
          SetLength(Arr, Length(Arr) + 1);
          Arr[Length(Arr) - 1] := J;
          Break;
        end;
      end;
    end;

    ExecuteReport(AFilename, AParams, Arr);
  end;
end;

procedure TfrxReportHelper.ExecuteReport(AFilename: string; AParams: array of string; AReportIndex: Integer);
begin
  Self.LoadFromFile(AFilename);

  if AReportIndex = -1 then
    ExecuteReport(AFilename, AParams)
  else
    ExecuteReport(AFilename, AParams, [AReportIndex]);
end;

function TfrxReportHelper.HasVariables: Boolean;
begin
  Result := Self.Variables.Count > 0;
end;

procedure TfrxReportHelper.LoadFromFile(AFilename: string);
var
  strAux: string;

  function GetPath: string;
  var
    Caminho: string;
  begin
    Result := '';

    Caminho := gsAppPath + 'Relatórios\Fast\';
    if DirectoryExists(Caminho) then
      Exit(Caminho);

    Caminho := gsAppPath + 'Relatorios\Fast\';
    if DirectoryExists(Caminho) then
      Exit(Caminho);

    Caminho := gsAppPath + 'Relatórios\';
    if DirectoryExists(Caminho) then
      Exit(Caminho);

    Caminho := gsAppPath + 'Relatorios\';
    if DirectoryExists(Caminho) then
      Exit(Caminho);
  end;
begin
  if ExtractFileExt(AFilename) = '' then
    AFilename := AFilename + '.fr3';

  strAux := GetPath + AFilename;

  Self.LoadFromFile(strAux, False);
end;

procedure TfrxReportHelper.SetParam(const AParam: string;
  const AValue: Boolean);
begin
  Self.Variables[AParam] := QuotedStr(IfThen(AValue, 'Sim', 'Não'));
end;

// procedure TfrxReportHelper.ShowReport;
// var
// I: Integer;
// begin
// if HasVariables then
// begin
// for I := 0 to Variables.Count -1 do
// begin
// if Variables.Items[I].Value = Null then
// Self.SetParam(Trim(Variables.Items[I].Name), '');
// end;
// end;
//
// inherited;
// end;

procedure TfrxReportHelper.SetParam(const AParam: string;
  const AValue: TDateTime; const AFormat: string);
begin
  Self.Variables[AParam] := QuotedStr(FormatDateTime(AFormat, AValue));
end;

{ TCheckListBoxHelper }

procedure TCheckListBoxHelper.NovoItem(const ACodigo: Integer;
  const ADescricao: string);
var
  Item: TItem;
begin
  Item := TItem.Create;
  Item.Codigo := ACodigo;
  Item.Descricao := ADescricao;
  Self.Items.AddObject(Item.Descricao, Item);
end;

function TCheckListBoxHelper.getIn: string;
var
  I: Integer;
  Item: TObject;
begin
  Result := '';
  for I := 0 to Self.Items.Count - 1 do
  begin
    if Self.Checked[I] then
    begin
      Item := Self.Items.Objects[I];
      if Item <> nil then
      begin
        Result := Result + IfThen(Result = '', '', ', ') +
          IntToStr(TItem(Item).Codigo);
      end;
    end;
  end;

  if Trim(Result) = '' then
    Result := ' NOT IS NULL '
end;

function TCheckListBoxHelper.getObject(AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

function TCheckListBoxHelper.getObject<T>(AIndex: Integer): T;
begin
  Result := T(getObject(AIndex));
end;

{ TJvCheckListBoxHelper }

function TJvCheckListBoxHelper.getCheckedInteger(AIndex: Integer): Integer;
begin
  Result := StrToIntDef(Self.GetChecked.Strings[AIndex], -1);
end;

function TJvCheckListBoxHelper.getCheckedObject(AIndex: Integer)
  : TItemCheckList;
begin
  Result := TItemCheckList(Self.GetChecked.Objects[AIndex]);
end;

function TJvCheckListBoxHelper.getCheckedString(AIndex: Integer): string;
begin
  Result := Self.GetChecked.Strings[AIndex];
end;

function TJvCheckListBoxHelper.GetIntegerAt(AIndex: Integer): Integer;
begin
  Result := StrToIntDef(Self.Items.Strings[AIndex], -1);
end;

function TJvCheckListBoxHelper.GetObjectAt(AIndex: Integer): TItemCheckList;
begin
  Result := TItemCheckList(Self.Items.Objects[AIndex]);
end;

function TJvCheckListBoxHelper.GetStringAt(AIndex: Integer): string;
begin
  Result := Self.Items.Strings[AIndex];
end;

function TJvCheckListBoxHelper.getUncheckedInteger(AIndex: Integer): Integer;
begin
  Result := StrToIntDef(Self.GetUnchecked.Strings[AIndex], -1);
end;

function TJvCheckListBoxHelper.getUncheckedObject(AIndex: Integer)
  : TItemCheckList;
begin
  Result := TItemCheckList(Self.GetUnchecked.Objects[AIndex]);
end;

function TJvCheckListBoxHelper.getUncheckedString(AIndex: Integer): string;
begin
  Result := Self.GetUnchecked.Strings[AIndex];
end;

{ TDBXReaderHelper }

constructor TDBXReaderHelper.Create(AConn: TDBXConnection);
begin
  Self.FCommand := AConn.CreateCommand;
end;

function TDBXReaderHelper.GetFieldIndex(AIndex: Integer): TDBXValue;
begin
  Result := Self.Value[AIndex];
end;

function TDBXReaderHelper.GetFieldName(AName: string): TDBXValue;
begin
  Result := Self.Value[AName];
end;

function TDBXReaderHelper.GetRecNo: Integer;
var
  vRow: TDBXRow;
begin
  vRow := Self.GetRow;
  Result := vRow.RecNo;
end;

{ TDBXValueHelper }

function TDBXValueHelper.GetAsDateSql: string;
begin
  Result := SQLData(Self.AsDate, True, False);
end;

function TDBXValueHelper.GetAsFloatSQL: string;
var
  strAux: string;
begin
  if Self.IsNull then
    Result := 'NULL'
  else
    Result := QuotedStr(FloatToSQL(StrFloat(Self.AsString)));
end;

function TDBXValueHelper.GetAsInteger: Integer;
begin
  Result := Self.AsInt32;
end;

function TDBXValueHelper.GetAsLower: string;
begin
  Result := AnsiLowerCase(Self.AsString);
end;

function TDBXValueHelper.GetAsSql: string;
begin
  Result := QuotedStr(Self.AsString);
end;

function TDBXValueHelper.GetAsUpper: string;
begin
  Result := AnsiUpperCase(Self.AsString);
end;

{ TDBXRowHelper }

function TDBXRowHelper.RecNo: Integer;
begin
  Result := Self.Generation;
end;

{ TCheckBoxHelper }

procedure TCheckBoxHelper.Check;
begin
  Self.Checked := True;
end;

function TCheckBoxHelper.GetAsString: string;
begin
  Result := IfThen(Self.Checked, 'True', 'False');
end;

function TCheckBoxHelper.GetUnchecked: Boolean;
begin
  Result := (Self.Checked = False);
end;

procedure TCheckBoxHelper.InvertState;
begin
  Self.Checked := not Self.Checked;
end;

procedure TCheckBoxHelper.Uncheck;
begin
  Self.Checked := False;
end;

{ TFieldHelper }

function TFieldHelper.GetAsDQuoted: string;
begin
  Result := '"' + Self.AsString + '"';
end;

function TFieldHelper.GetAsFloatSQL: string;
var
  strAux: string;
begin
  strAux := FloatToStr(Self.AsFloat);

  strAux := AnsiReplaceStr(strAux, '.', '');
  strAux := AnsiReplaceStr(strAux, ',', '.');

  Result := strAux;
end;

function TFieldHelper.GetAsFormat(AFormat: string): string;
begin
  case Self.DataType of
    ftSmallint, ftInteger, ftWord, ftLargeint, ftLongWord, ftShortint:
      begin
        Result := FormatFloat(AFormat, Self.AsInteger);
      end;
    ftFloat, ftCurrency, ftBCD, ftFMTBcd, ftExtended:
      begin
        Result := FormatFloat(AFormat, Self.AsFloat);
      end;
    ftDate, ftDateTime, ftTime, ftTimeStamp:
      begin
        Result := FormatDateTime(AFormat, Self.AsDateTime);
      end;
  else
    Result := Self.AsString;
  end;
end;

function TFieldHelper.GetAsLower: string;
begin
  Result := AnsiLowerCase(Self.AsString);
end;

function TFieldHelper.GetAsSql: string;
begin
  Result := QuotedStr(Self.AsString);
end;

function TFieldHelper.GetAsSubString(ASize: Integer): string;
begin
  Result := Substring(1, ASize);
end;

function TFieldHelper.GetAsUpper: string;
begin
  Result := AnsiUpperCase(Self.AsString);
end;

function TFieldHelper.AsDef(ADef: Double): Double;
begin
  Result := StrToFloatDef(Self.AsString, ADef);
end;

function TFieldHelper.AsDef(ADef: Integer): Integer;
begin
  Result := StrToIntDef(Self.AsString, ADef);
end;

function TFieldHelper.AsDef(ADef: Boolean): Boolean;
begin
  Result := StrToBoolDef(Self.AsString, ADef);
end;

function TFieldHelper.AsDef(ADef: TDateTime): TDateTime;
begin
  Result := StrToDateTimeDef(Self.AsString, ADef);
end;

procedure TFieldHelper.DefaultOrder;
begin
  TClientDataSet(Self.DataSet).IndexName := Self.FieldName;
end;

function TFieldHelper.AsDef(ADef: TDate): TDate;
begin
  Result := StrToDateDef(Self.AsString, ADef);
end;

function TFieldHelper.GetIsEmpty: Boolean;
begin
  Result := (Self.IsNull or (VarToStr(Self.Value) = ''));
end;

function TFieldHelper.GetIsFilled: Boolean;
begin
  Result := (VarToStr(Self.Value) <> '');
end;

function TFieldHelper.GetLength: Integer;
begin
  Result := System.Length(Self.AsString);
end;

procedure TFieldHelper.SetAsLower(const Value: string);
begin
  Self.AsString := AnsiLowerCase(Self.AsString);
end;

procedure TFieldHelper.SetAsUpper(const Value: string);
begin
  Self.AsString := AnsiUpperCase(Self.AsString);
end;

function TFieldHelper.Substring(AStart, ACount: Integer): string;
begin
  Result := Copy(Self.AsString, AStart, ACount);
end;

{ TDBLookupComboBoxHelper }

procedure TDBLookupComboBoxHelper.SetFields(AKey, AList: string);
begin
  Self.KeyField := AKey;
  Self.ListField := AList;
end;

procedure TDBLookupComboBoxHelper.Grow;
var
  Tam: Integer;
  LookField: string;
begin
  if Assigned(ListSource) then
  begin
    ListSource.DataSet.DisableControls;
    try
      ListSource.DataSet.First;
      while not ListSource.DataSet.Eof do
      begin
        Tam := Width + Trunc(Length(ListSource.DataSet.FieldByName(ListField)
          .AsString) * 4.5);
        if (DropDownWidth < Tam) or (ListSource.DataSet.RecordCount = 1) then
          DropDownWidth := Tam;

        ListSource.DataSet.Next;
      end;
    finally
      ListSource.DataSet.EnableControls;
    end;
  end
  else if Assigned(Self.DataSource) then
  begin
    if DataSource.DataSet.FieldByName(DataField).FieldKind = fkLookup then
      LookField := DataSource.DataSet.FieldByName(DataField).LookupResultField;

    with DataSource.DataSet.FieldByName(DataField).LookupDataSet do
    begin
      DisableControls;
      try
        First;
        while not Eof do
        begin
          Tam := Width + Trunc(Length(FieldByName(LookField).AsString) * 4.5);
          if (DropDownWidth < Tam) or (RecordCount = 1) then
            DropDownWidth := Tam;

          Next;
        end;
      finally
        EnableControls;
      end;
    end;
  end
end;

procedure TDBLookupComboBoxHelper.SetFields(AIndexKey, AIndexList: Integer);
begin
  if Assigned(Self.ListSource) then
  begin
    if Self.ListSource.DataSet <> nil then
    begin
      Self.KeyField := Self.ListSource.DataSet.Fields[AIndexKey].FieldName;
      Self.ListField := Self.ListSource.DataSet.Fields[AIndexList].FieldName;
    end;
  end
  else
    raise Exception.Create('"ListSource" não informado!');
end;

{ TDBXValueListHelper }

procedure TDBXValueListHelper.First;
begin

end;

procedure TDBXValueListHelper.GoToFirst;
begin

end;

{ TJSONPairHelper }

function TJSONPairHelper.FieldName: string;
begin
  Result := Self.JsonString.Value;
end;

{ TFormHelper }

function TFormHelper.Invoke(const AMethod: string;
  const AParametros: array of TValue): TValue;
var
  RttiCont: TRttiContext;
  RttiType: TRttiType;
  RttiMethod: TRttiMethod;
begin
  RttiCont := TRttiContext.Create;
  try
    RttiType := RttiCont.GetType(Self.ClassInfo);
    RttiMethod := RttiType.GetMethod(AMethod);

    if RttiMethod <> nil then
      Result := RttiMethod.Invoke(Self, AParametros);
  finally
    RttiCont.Free;
  end;
end;

{ TObjectHelper }

function TObjectHelper.AsJsonArray: TJsonArray;
begin
  Result := TJsonArray(Self);
end;

function TObjectHelper.AsJsonObject: TJSONObject;
begin
  Result := TJSONObject(Self);
end;

procedure TObjectHelper.Bloquear;
var
  RttiCont: TRttiContext;
  RttiTipo: TRttiType;
  RttiProp: TRttiProperty;
begin
  if not Assigned(Self) then
    Exit;

  RttiCont := RttiCont.Create;
  try
    RttiTipo := RttiCont.GetType(Self.ClassInfo);
    RttiProp := RttiTipo.getProperty('Enabled');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, False);
      Exit;
    end;

    RttiProp := RttiTipo.getProperty('Active');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, False);
      Exit;
    end;

    RttiProp := RttiTipo.getProperty('Visible');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, False);
      Exit;
    end;
  finally
    RttiCont.Free;
  end;
end;

procedure TObjectHelper.Desbloquear;
var
  RttiCont: TRttiContext;
  RttiTipo: TRttiType;
  RttiProp: TRttiProperty;
begin
  if not Assigned(Self) then
    Exit;

  RttiCont := RttiCont.Create;
  try
    RttiTipo := RttiCont.GetType(Self.ClassInfo);
    RttiProp := RttiTipo.getProperty('Enabled');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, True);
      Exit;
    end;

    RttiProp := RttiTipo.getProperty('Active');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, True);
      Exit;
    end;

    RttiProp := RttiTipo.getProperty('Visible');
    if Assigned(RttiProp) then
    begin
      RttiProp.SetValue(Self, True);
      Exit;
    end;
  finally
    RttiCont.Free;
  end;
end;

function TObjectHelper.getProperty(const AProperty: string): TValue;
var
  RttiCont: TRttiContext;
  RttiTipo: TRttiType;
  RttiProp: TRttiProperty;
begin
  Result := nil;
  if not Assigned(Self) then
    Exit;

  RttiCont := RttiCont.Create;
  try
    RttiTipo := RttiCont.GetType(Self.ClassInfo);
    RttiProp := RttiTipo.getProperty(AProperty);
    if Assigned(RttiProp) then
      Result := RttiProp.GetValue(Self);
  finally
    RttiCont.Free;
  end;
end;

function TObjectHelper.Invoke(const AMethod: string;
  const AParametros: array of TValue): TValue;
var
  RttiCont: TRttiContext;
  RttiTipo: TRttiType;
  RttiMethod: TRttiMethod;
begin
  Result := nil;
  if not Assigned(Self) then
    Exit;

  RttiCont := RttiCont.Create;
  try
    RttiTipo := RttiCont.GetType(Self.ClassInfo);
    RttiMethod := RttiTipo.GetMethod(AMethod);
    if Assigned(RttiMethod) then
      Result := RttiMethod.Invoke(Self, AParametros);
  finally
    RttiCont.Free;
  end;
end;

procedure TObjectHelper.setProperty(const AProperty: string;
  const AValor: TValue);
var
  RttiCont: TRttiContext;
  RttiTipo: TRttiType;
  RttiProp: TRttiProperty;
begin
  if not Assigned(Self) then
    Exit;

  RttiCont := RttiCont.Create;
  try
    RttiTipo := RttiCont.GetType(Self.ClassInfo);
    RttiProp := RttiTipo.getProperty(AProperty);
    if Assigned(RttiProp) then
      RttiProp.SetValue(Self, AValor);
  finally
    RttiCont.Free;
  end;
end;

{ TRadioGroupHelper }

function TRadioGroupHelper.GetSelectionName: string;
begin
  Result := Self.Items.Strings[Self.ItemIndex];
end;

{ TCurvyComboHelper }

function TCurvyComboHelper.GetIsEmpty: Boolean;
begin
  Result := Self.Items.Count = 0;
end;

function TCurvyComboHelper.GetIsNull: Boolean;
begin
  Result := Self.ItemIndex < 0;
end;

function TCurvyComboHelper.getObject: TObject;
begin
  Result := Self.Items.Objects[Self.ItemIndex];
end;

function TCurvyComboHelper.getObject(AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

{ TPanelHelper }

procedure TControlHelper.AlignCenterCenter;
var
  L, T: Integer;
begin
  if Assigned(Self.Parent) then
  begin
    T := Trunc((Self.Parent.Height / 2) - (Self.Height / 2));
    L := Trunc((Self.Parent.Width / 2) - (Self.Width / 2));

    Self.Left := L;
    Self.Top := T;
  end;
end;

{ TAdvSmoothSliderHelper }

function TAdvSmoothSliderHelper.GetValue: Boolean;
begin
  case Self.State of
    ssOn:
      Result := True;
    ssOff:
      Result := False;
  end;
end;

procedure TAdvSmoothSliderHelper.SetValue(const Value: Boolean);
begin
  if Value then
    Self.State := ssOn
  else
    Self.State := ssOff;
end;

{ TStringBuilderHelper }

function TStringBuilderHelper.Append(const Value: Boolean; Quoted: Boolean)
  : TStringBuilder;
begin
  if Quoted then
    Append(QuotedStr(BoolToStr(Value, True)))
  else
    Append(Value);
end;

function TStringBuilderHelper.Replace(const OldValue: string;
  const NewValue: Integer): TStringBuilder;
begin
  Replace(OldValue, IntToStr(NewValue));
end;

function TStringBuilderHelper.Replace(const OldValue: string;
  const NewValue: Double): TStringBuilder;
begin
  Replace(OldValue, FloatToSQL(NewValue));
end;

function TStringBuilderHelper.Replace(const OldValue: string;
  const NewValue: TDateTime): TStringBuilder;
begin
  Replace(OldValue, SQLData(NewValue, True, False));
end;

{ TAdvStringGridHelper }

function TAdvStringGridHelper.GetJSONObject(c, r: Integer): TJSONObject;
begin
  Result := TJSONObject(Self.Objects[c, r]);
end;

function TAdvStringGridHelper.GetObject<T>(c, r: Integer): T;
begin
  Result := T(Objects[c, r]);
end;

function TAdvStringGridHelper.IncRowCount(ACount: Integer): Integer;
begin
  if IsEmpty then
  begin
    RowCount := 2;
    Exit(RowCount);
  end;

  Self.RowCount := Self.RowCount + ACount;
  Result := Self.RowCount;
end;

function TAdvStringGridHelper.IsEmpty: Boolean;
begin
  Result := ((Self.RowCount < 3) and ((not Assigned(Self.Objects[0, 1])) and
    (Self.Cells[0, 1] = '')));
end;

procedure TAdvStringGridHelper.OrdenaGrid(Sender: TObject; ACol, ARow: Integer);
begin
  if ARow <> 0 then
    Exit;

  SortIndexes.Clear;
  SortIndexes.Add(ACol);
  QSortIndexed;
end;

procedure TAdvStringGridHelper.RestandardGrid;
begin
  RestandardGrid([]);
end;

procedure TAdvStringGridHelper.RestandardGrid(AStylesToKeep: array of TFontStyle);
var
  I: Integer;
  J: Integer;
  New: TFontStyles;
begin
  for I := 0 to RowsFor do
  begin
    New   := [];

    for J := Low(AStylesToKeep) to High(AStylesToKeep) do
    begin
      if AStylesToKeep[J] in FontStyles[0, I] then
        New := New + [AStylesToKeep[J]];
    end;

    StyleRow(I, New);
  end;
end;

function TAdvStringGridHelper.RowsFor: Integer;
begin
  Result := Self.RowCount - 1;
end;

procedure TAdvStringGridHelper.StrikeRow(ARow: Integer);
var
  I: Integer;
begin
  for I := 0 to ColsFor do
  begin
    FontStyles[I, ARow] := FontStyles[I, ARow] + [fsStrikeOut];
    FontColors[I, ARow] := clRed;
  end;
end;

procedure TAdvStringGridHelper.StrikeRow;
begin
  StrikeRow(Row);
end;

procedure TAdvStringGridHelper.StyleRow(AStyle: TFontStyles);
begin
  StyleRow(Row, AStyle);
end;

procedure TAdvStringGridHelper.StyleRow(ARow: Integer; AStyle: TFontStyles);
var
  I: Integer;
begin
  for I := 0 to ColsFor do
    FontStyles[I, ARow] := AStyle;
end;

procedure TAdvStringGridHelper.BoldRow;
begin
  BoldRow(Row);
end;

procedure TAdvStringGridHelper.BoldRow(ARow: Integer);
var
  I: Integer;
begin
  for I := 0 to ColsFor do
    FontStyles[I, ARow] := FontStyles[I, ARow] + [fsBold];
end;

procedure TAdvStringGridHelper.ClearDataCols(AColStart, AColCount: Integer; RemoveObjects: Boolean);
var
  I: Integer;
  J: Integer;
begin
  for I := 1 to RowsFor do
  begin
    if RemoveObjects then
      Objects[0, I] := nil;

    for J := AColStart to (AColStart + AColCount -1) do
      Cells[J, I] := '';
  end;
end;

procedure TAdvStringGridHelper.ClearDataRows;
var
  I: Integer;
begin
//  for I := 0 to Self.RowsFor do
//  begin
//    Self.Objects[0, I].Free;
//    Self.Objects[0, I] := nil;
//  end;

  Self.ClearRows(1, Self.RowCount);
  Self.RowCount := 2;
  Self.Row := 1;
end;

function TAdvStringGridHelper.ColsFor: Integer;
begin
  Result := ColCount -1;
end;

function TAdvStringGridHelper.DecRowCount(ACount: Integer): Integer;
begin
  Self.RowCount := Self.RowCount - ACount;
  Result := Self.RowCount;
end;

procedure TAdvStringGridHelper.FormatGrid(const ATitulos: array of string;
  const ASizes: array of Integer; AFilterDropDownAuto: Boolean);
var
  I: Integer;
begin
  if Self is TAdvStringGrid then
  begin
    with TAdvStringGrid(Self) do
    begin
      Clear;
      FixedCols := 0;
      FixedRows := 1;
      RowCount := 2;
      ColCount := Length(ATitulos);

      DefaultRowHeight := 20;
      Options := Options + [goRowSelect, goRowSizing, goColSizing];

      Navigation.AllowClipboardShortCuts := True;
      Navigation.AllowClipboardAlways    := True;

      FilterDropDownAuto := AFilterDropDownAuto;

      for I := Low(ASizes) to High(ASizes) do
        ColWidths[I] := ASizes[I];

      with ColumnHeaders do
      begin
        Clear;

        for I := Low(ATitulos) to High(ATitulos) do
        begin
          Add(ATitulos[I]);
          Alignments[I, 0] := taCenter;
        end;
      end;

      if not Assigned(OnFixedCellClick) then
        OnFixedCellClick := OrdenaGrid;
    end;
  end;
end;

procedure TControlHelper.Disable;
begin
  Self.Enabled := False;
end;

procedure TControlHelper.Enable;
begin
  Self.Enabled := True;
end;

procedure TControlHelper.ToClipboard(AValue: string);
begin
  Clipboard.AsText := AValue;
end;

{ TWinControlHelper }

procedure TWinControlHelper.DYE(AColor: TColor);
begin
  if not Assigned(Self.Brush) then
    Exit;

  Self.Brush.Color := AColor;
  Self.Repaint;
end;

{ TDBXCommandHelper }

procedure TDBXCommandHelper.Release;
begin
  if Self.IsPrepared then
    Self.Close;

  FreeAndNil(Self);
end;

{ TPopupMenuHelper }

procedure TPopupMenuHelper.Popup(P: TPoint);
begin
  Self.Popup(P.X, P.Y);
end;

procedure TPopupMenuHelper.PopupAtCursor;
begin
  Self.Popup(Mouse.CursorPos);
end;

{ TDBCheckBoxHelper }

procedure TDBCheckBoxHelper.Check;
begin
  Self.Checked := True;
end;

function TDBCheckBoxHelper.GetAsString(ATrue: string): string;
begin
  if LowerCase(ATrue) = 't' then
    Result := IfThen(Self.Checked, 'T', 'F')
  else
  if LowerCase(ATrue) = 'true' then
    Result := IfThen(Self.Checked, 'True', 'False')
  else
  if LowerCase(ATrue) = '1' then
    Result := IfThen(Self.Checked, '1', '0')
  else
    Result := IfThen(Self.Checked, 'True', 'False')
end;

function TDBCheckBoxHelper.GetUnchecked: Boolean;
begin
  Result := (Self.Checked = False);
end;

procedure TDBCheckBoxHelper.InvertState;
begin
  Self.Checked := not Self.Checked;
end;

procedure TDBCheckBoxHelper.Uncheck;
begin
  Self.Checked := False;
end;

{ TLabelHelper }

procedure TLabelHelper.DYE(AColor: TColor);
begin
  if not Assigned(Self.Font) then
    Exit;

  Self.Font.Color := AColor;
end;

procedure TLabelHelper.ToClipboard(ASize: Integer);
begin
  Clipboard.AsText := LeftStr(Caption, ASize);
end;

procedure TLabelHelper.ToClipboard;
begin
  Clipboard.AsText := Caption;
end;

procedure TLabelHelper.ToClipboard(AStart, ASize: Integer);
begin
  Clipboard.AsText := Copy(Caption, AStart, ASize);
end;

{ TListViewHelper }

function TListViewHelper.CheckCount(AFast: Boolean): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to ItemsFor do
  begin
    if Checked[I] then
    begin
      Inc(Result);

      if AFast then
        Exit;
    end;
  end;
end;

function TListViewHelper.GetChecked(AIndex: Integer): Boolean;
begin
  Result := Self.Items.Item[AIndex].Checked;
end;

function TListViewHelper.GetGroupID(AIndex: Integer): Integer;
begin
  Result := Self.Items.Item[AIndex].GroupID;
end;

function TListViewHelper.GetObject(AIndex: Integer): TListItem;
begin
  Result := Self.Items.Item[AIndex];
end;

function TListViewHelper.ItemsFor: Integer;
begin
  Result := Self.Items.Count -1;
end;

function TListViewHelper.NoChecks: Boolean;
begin
  Result := CheckCount = 0;
end;

procedure TListViewHelper.SetChecked(AIndex: Integer; const Value: Boolean);
begin
  Self.Items.Item[AIndex].Checked := Value;
end;

{ TJvCheckedComboBoxHelper }

function TJvCheckedComboBoxHelper.CheckCount(AFast: Boolean): Integer;
var
  I: Integer;
begin
  Result := 0;

  for I := 0 to Self.Items.Count -1 do
  begin
    if Self.Checked[I] then
    begin
      Inc(Result);

      if AFast then
        Exit;
    end;
  end;
end;

function TJvCheckedComboBoxHelper.GetFieldByName(AIndex: Integer; AName: String): TJSONValue;
begin
  Result := Self.GetJSONObject(AIndex).Field[AName];
end;

function TJvCheckedComboBoxHelper.GetJSONObject(const AIndex: Integer): TJSONObject;
begin
  Result := TJSONObject(Self.GetObject(AIndex));
end;

function TJvCheckedComboBoxHelper.GetObject(const AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

function TJvCheckedComboBoxHelper.GetObject<T>(const AIndex: Integer): T;
begin
  Result := T(Self.GetObject(AIndex));
end;

function TJvCheckedComboBoxHelper.ItemsFor: Integer;
begin
  Result := Self.Items.Count -1;
end;

function TJvCheckedComboBoxHelper.NoChecks: Boolean;
begin
  Result := Self.CheckCount(True) = 0;
end;

{ TJvListBoxHelper }

function TJvListBoxHelper.GetField(AName: string): TJSONValue;
begin
  Result := JSONObject.Field[AName];
end;

function TJvListBoxHelper.GetFieldAt(AIndex: Integer; AName: string): TJSONValue;
begin
  Result := JSONObjects[AIndex].Field[AName];
end;

function TJvListBoxHelper.GetJSONObjects(AIndex: Integer): TJSONObject;
begin
  Result := TJSONObject(Objects[AIndex]);
end;

function TJvListBoxHelper.getObject: TObject;
begin
  Result := Items.Objects[ItemIndex];
end;

function TJvListBoxHelper.getObject<T>: T;
begin
  Result := T(getObject);
end;

function TJvListBoxHelper.GetObjects(AIndex: Integer): TObject;
begin
  Result := Items.Objects[AIndex];
end;

function TJvListBoxHelper.IsNull: Boolean;
begin
  Result := ItemIndex < 0;
end;

function TJvListBoxHelper.JSONObject: TJSONObject;
begin
  Result := TJSONObject(getObject);
end;

{ TEtapa }

function TEtapa.GetPeriodo: string;
begin
  Result := 'de ' + FormatDateTime('dd/mm/yyyy', Inicio) + ' a ' + FormatDateTime('dd/mm/yyyy', Fim);
end;

{ TJvDBGridHelper }

function TJvDBGridHelper.GetColIndex(AFieldName: string): Integer;
var
  I: Integer;
begin
  Result := -1;

  for I := 0 to Columns.Count -1 do
  begin
    if Columns.Items[I].FieldName = AFieldName then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TJvDBGridHelper.GetColumnByName(AFieldName: string): TColumn;
var
  I: Integer;
begin
  Result := nil;

  for I := 0 to Columns.Count -1 do
  begin
    if Columns.Items[I].FieldName = AFieldName then
    begin
      Result := Columns.Items[I];
      Exit;
    end;
  end;
end;

procedure TJvDBGridHelper.HideColumns;
var
  I: Integer;
begin
  for I := 0 to Columns.Count -1 do
    Columns.Items[I].Visible := False;
end;

procedure TJvDBGridHelper.SetColumn(AColumnName: string; ANewIndex, AWidth: Integer; AReadOnly: Boolean; ATitle: string);
var
  IdxCol: Integer;
begin
  IdxCol := ColIndex[AColumnName];

  Columns.Items[IdxCol].Index       := ANewIndex;
  Columns.Items[ANewIndex].Visible  := True;
  Columns.Items[ANewIndex].Width    := AWidth;
  Columns.Items[ANewIndex].ReadOnly := AReadOnly;

  if ATitle <> '' then
    Columns.Items[ANewIndex].Title.Caption := ATitle;
end;

procedure TJvDBGridHelper.SetColumn(AColumn, ANewIndex, AWidth: Integer; AReadOnly: Boolean; ATitle: string);
begin
  Columns.Items[AColumn].Index      := ANewIndex;
  Columns.Items[ANewIndex].Visible  := True;
  Columns.Items[ANewIndex].Width    := AWidth;
  Columns.Items[ANewIndex].ReadOnly := AReadOnly;

  if ATitle <> '' then
    Columns.Items[ANewIndex].Title.Caption := ATitle;
end;

{ TRZComboBoxHelper }

function TRZComboBoxHelper.getObject: TObject;
begin
  if Self.ItemIndex = -1 then
    Result := nil
  else
    Result := Self.Items.Objects[Self.ItemIndex];
end;

function TRZComboBoxHelper.getObject<T>: T;
begin
  Result := T(Self.getObject);
end;

function TRZComboBoxHelper.GetObjectAt(const AIndex: Integer): TObject;
begin
  Result := Self.Items.Objects[AIndex];
end;

function TRZComboBoxHelper.GetObjectAt<T>(const AIndex: Integer): T;
begin
  Result := T(GetObjectAt(AIndex));
end;

end.
