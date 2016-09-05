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
  Data.DB, DBAccess, UConexao, Uni;

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
begin
  qry := TConexao.Consulta('SELECT ID FROM SEG_USUARIO WHERE LOWER(LOGIN) = ' + Trim(edtUsuario.Text));
  try
    if not qry.IsEmpty then
      ShowMessage(qry.Fields[0].AsString);
  finally
    FreeAndNil(qry);
  end;
end;

end.
