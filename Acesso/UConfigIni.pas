unit UConfigIni;

interface

uses System.IniFiles, IWSystem, System.SysUtils, System.Classes;

type
  TConfigIni = class
  public
    class function Servidor: string;
    class function Usuario: string;
    class function Senha: string;
    class function Database: string;
    class function CharSet: string;
  end;

implementation

{ TConfigIni }

class function TConfigIni.CharSet: string;
begin
  Result := 'ISO8859_1';
end;

class function TConfigIni.Database: string;
begin
  Result := 'C:\Wesley\Igreja\BD\Matriz.FDB';
end;

class function TConfigIni.Senha: string;
begin
  Result := 'masterkey';
end;

class function TConfigIni.Servidor: string;
begin
  Result := '127.0.0.1';
end;

class function TConfigIni.Usuario: string;
begin
  Result := 'sysdba';
end;

end.
