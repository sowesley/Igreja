program WSIgreja;

uses
  Vcl.Forms,
  ULogin in 'Forms\ULogin.pas' {FLogin},
  UDefault in 'Forms\UDefault.pas' {FDefault},
  UPrincipal in 'Forms\UPrincipal.pas' {FPrincipal},
  UConexao in 'Acesso\UConexao.pas',
  UConfigIni in 'Acesso\UConfigIni.pas',
  UMensagem in 'Forms\UMensagem.pas' {FMensagem},
  Utils.Helper in 'Classes\Utils.Helper.pas',
  Utils.MD5 in 'Classes\Utils.MD5.pas',
  Utils.Message in 'Classes\Utils.Message.pas',
  Utils.Types in 'Classes\Utils.Types.pas',
  Utils.Util in 'Classes\Utils.Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.CreateForm(TFMensagem, FMensagem);
  Application.Run;
end.
