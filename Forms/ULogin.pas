unit ULogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans,
  dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMetropolis,
  dxSkinMetropolisDark, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White, dxSkinPumpkin,
  dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue, cxTextEdit,
  AdvGlassButton, Vcl.StdCtrls, dxGDIPlusClasses, Vcl.ExtCtrls, RzPanel,
  Data.DB, DBAccess, UConexao, Uni, Utils.Message, Utils.MD5;

type
  TFLogin = class(TForm)
    pnl1: TRzPanel;
    grp1: TRzGroupBox;
    img1: TImage;
    pnl2: TRzPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    btnLogin: TAdvGlassButton;
    btnFechar: TAdvGlassButton;
    edtUsuario: TcxTextEdit;
    edtSenha: TcxTextEdit;
    procedure btnFecharClick(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtUsuarioKeyPress(Sender: TObject; var Key: Char);
    procedure edtSenhaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FLogin: TFLogin;

implementation

{$R *.dfm}

procedure TFLogin.btnFecharClick(Sender: TObject);
begin
  if Application.MessageBox('Deseja encerrar a aplicação?', 'Atenção', MB_YESNO + MB_ICONQUESTION) = IDYES then
    Application.Terminate;
end;

procedure TFLogin.btnLoginClick(Sender: TObject);
var
  qry: TUniQuery;
  vSql: string;
  Senha: string;
  Login: string;
begin
  if edtUsuario.Text = '' then
  begin
    TMensagens.ShowMessage('Informe o Login!', 'Atenção', tmAtencao, tbOk);
    edtUsuario.SetFocus;
    Exit;
  end;

  if edtSenha.Text = '' then
  begin
    if TMensagens.ShowMessage('Senha em branco! Continuar assim mesmo?', 'Atenção', tmQuestao, tbSimNao) = mrNo then
    begin
      edtSenha.SetFocus;
      Exit;
    end;
  end;

  Senha := TMD5.Hash(edtSenha.Text);
  Login := AnsiLowerCase(edtUsuario.Text);

  vSql := 'SELECT COUNT(*), ID, NOME ' + sLineBreak +
    'FROM SEG_USUARIO ' + sLineBreak +
    'WHERE LOWER(LOGIN) = ' + QuotedStr(Login) + sLineBreak +
    '  AND UPPER(SENHA) = ' + QuotedStr(Senha) + sLineBreak +
    'GROUP BY ID, NOME';

  qry := TConexao.Instance.Consulta(vSql);
  try
    try
      if qry.IsEmpty then
        raise Exception.Create('Usuário e/ou Senha Inválido!');

      if qry.Fields[0].AsInteger = 1 then
      begin
        TConexao.Instance.Autenticado    := True;
        TConexao.Instance.User.Codigo    := qry.FieldByName('ID').AsInteger;
        TConexao.Instance.User.Login     := Login;
        TConexao.Instance.User.Senha     := edtSenha.Text;
        TConexao.Instance.User.SenhaHash := Senha;
        TConexao.Instance.User.Nome      := qry.FieldByName('NOME').AsString;

        Close;
      end
      else
        raise Exception.Create('Não foi possível identificar o usuário informado!');
    except
      on E: Exception do
      begin
        TMensagens.ShowMessage(E.Message, 'Erro', tmErro);
        Abort;
      end;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TFLogin.edtSenhaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if btnLogin.CanFocus then
      btnLogin.SetFocus;
  end;
end;

procedure TFLogin.edtUsuarioKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if edtSenha.CanFocus then
      edtSenha.SetFocus;
  end;
end;

procedure TFLogin.FormCreate(Sender: TObject);
begin
  TConexao.Instance.Autenticado := False;
end;

procedure TFLogin.FormShow(Sender: TObject);
begin
  if DebugHook <> 0 then
  begin
//    edtUsuario.Text := 'sowesley';
//    edtSenha.Text   := 'cw260814';
//    btnLogin.SetFocus;
  end;
end;

end.
