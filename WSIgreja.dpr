program WSIgreja;

uses
  Vcl.Forms,
  ULogin in 'Forms\ULogin.pas' {FLogin},
  UDefault in 'Forms\UDefault.pas' {FDefault},
  UPrincipal in 'Forms\UPrincipal.pas' {FPrincipal},
  UConexao in 'Acesso\UConexao.pas',
  UConfigIni in 'Acesso\UConfigIni.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
