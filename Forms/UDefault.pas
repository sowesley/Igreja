unit UDefault;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, UConexao;

type
  TFDefault = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    function getConn: TConexao;

  public
    property Conn: TConexao read getConn;
  end;

var
  FDefault: TFDefault;

implementation

{$R *.dfm}

procedure TFDefault.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFDefault.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    Perform(WM_NEXTDLGCTL, 0, 0);
  end;
end;

function TFDefault.getConn: TConexao;
begin
  Result := TConexao.Instance;
end;

end.
