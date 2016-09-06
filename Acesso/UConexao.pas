unit UConexao;

interface

uses Uni, UniProvider, InterBaseUniProvider, UConfigIni, System.SysUtils, Vcl.Forms, UMensagem, Utils.Message;

type
  TUsuarios = record
  private
    FCodigo: Integer;
    FSenha: string;
    FLogin: string;
    FNome: string;
    FSenhaHash: string;
    procedure SetCodigo(const Value: Integer);
    procedure SetLogin(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetSenha(const Value: string);
    procedure SetSenhaHash(const Value: string);
  public
    property Codigo: Integer read FCodigo write SetCodigo;
    property Login: string read FLogin write SetLogin;
    property Nome: string read FNome write SetNome;
    property Senha: string read FSenha write SetSenha;
    property SenhaHash: string read FSenhaHash write SetSenhaHash;
  end;

  TConnector = class(TUniConnection)
  private
    FProvider: TInterBaseUniProvider;
  public
    constructor Create;
    destructor Destroy; override;
    class function Initiate: TConnector;
  end;

  TConexao = class
  strict private
    class var FInstance: TConexao;
  private
    FConn: TConnector;
    FAutenticado: Boolean;
    FUser: TUsuarios;
  public
    class function Instance: TConexao;
    function Consulta(ASql: string): TUniQuery;

    property User: TUsuarios read FUser;
    property Autenticado: Boolean read FAutenticado write FAutenticado;
  end;

implementation

{ TConexao }

function TConexao.Consulta(ASql: string): TUniQuery;
begin
  if ASql = '' then
    raise Exception.Create('SQL Inválido!');

  Result := TUniQuery.Create(nil);
  Result.Connection := TConnector.Create;
  Result.SQL.Text   := ASql;

  try
    Result.Open;
  except
    on E: Exception do
      TMensagens.ShowMessage('Erro ao realizar a consulta SQL! Erro: ' + sLineBreak + E.Message, tmErro);
  end;
end;

class function TConexao.Instance: TConexao;
begin
  if not Assigned(FInstance) then
    FInstance := TConexao.Create;

  Result := FInstance;
end;

{ TConnector }

constructor TConnector.Create;
begin
  inherited Create(nil);
  FProvider := TInterBaseUniProvider.Create(Self);

  Self.AutoCommit   := True;
  Self.Connected    := False;
  Self.LoginPrompt  := False;
  Self.ProviderName := 'InterBase';
  Self.Database     := TConfigIni.Database;
  Self.Server       := TConfigIni.Servidor;
  Self.Username     := TConfigIni.Usuario;
  Self.Password     := TConfigIni.Senha;

  Self.SpecificOptions.Add('InterBase.ClientLibrary=fbclient.dll');
  Self.SpecificOptions.Add('InterBase.CharSet='+TConfigIni.CharSet);

  try
    Self.Connect;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao conectar: ' + E.Message), 'Erro');
    end;
  end;
end;

destructor TConnector.Destroy;
begin
  Self.Disconnect;

  FreeAndNil(FProvider);
  inherited;
end;

class function TConnector.Initiate: TConnector;
begin
  Result := TConnector.Create;
end;

{ TUsuarios }

procedure TUsuarios.SetCodigo(const Value: Integer);
begin
  FCodigo := Value;
end;

procedure TUsuarios.SetLogin(const Value: string);
begin
  FLogin := Value;
end;

procedure TUsuarios.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TUsuarios.SetSenha(const Value: string);
begin
  FSenha := Value;
end;

procedure TUsuarios.SetSenhaHash(const Value: string);
begin
  FSenhaHash := Value;
end;

end.
