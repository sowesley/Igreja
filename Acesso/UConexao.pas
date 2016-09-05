unit UConexao;

interface

uses Uni, UniProvider, InterBaseUniProvider, UConfigIni, System.SysUtils, Vcl.Forms;

type
  TConnector = class(TUniConnection)
  private
    FProvider: TInterBaseUniProvider;
  public
    constructor Create;
    destructor Destroy; override;
    class function Initiate: TConnector;
  end;

  TConexao = class
  private
    FConn: TConnector;
  public
    class function Consulta(ASql: string): TUniQuery;
  end;

implementation

{ TConexao }

class function TConexao.Consulta(ASql: string): TUniQuery;
begin
  Result := TUniQuery.Create(nil);
  Result.Connection := TConnector.Create;

  Result.SQL.Text := ASql;
  Result.Open;
end;

{ TConnector }

constructor TConnector.Create;
begin
  FProvider := TInterBaseUniProvider.Create(nil);

  Self.AutoCommit   := True;
  Self.Connected    := False;
  Self.LoginPrompt  := False;
  Self.ProviderName := 'InterBase';
  Self.Database     := TConfigIni.Database;
  Self.Server       := TConfigIni.Servidor;
  Self.Username     := TConfigIni.Usuario;
  Self.Password     := TConfigIni.Senha;

  Self.SpecificOptions.Add('ClientLibrary');
  Self.SpecificOptions.Add('CharSet');

  Self.SpecificOptions.Values['ClientLibrary'] := 'fbclient.dll';
  Self.SpecificOptions.Values['CharSet']       := TConfigIni.CharSet;

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

end.
