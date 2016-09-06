unit UMensagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, RzPanel,
  dxGDIPlusClasses, Vcl.StdCtrls, HTMLabel, AdvGlowButton;

type
  TFMensagem = class(TForm)
    pnl1: TRzPanel;
    pnlLateral: TRzPanel;
    RzPanel1: TRzPanel;
    lblTitulo: TLabel;
    lblMensagem: THTMLabel;
    pnl3: TRzPanel;
    btnSim: TAdvGlowButton;
    btnCancelar: TAdvGlowButton;
    btnNao: TAdvGlowButton;
    btnOK: TAdvGlowButton;
    Image1: TImage;
    procedure btnSimClick(Sender: TObject);
    procedure btnNaoClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    FResultado: Integer;
  public
    property Resultado: Integer read FResultado write FResultado;
  end;

var
  FMensagem: TFMensagem;

implementation

{$R *.dfm}

procedure TFMensagem.btnCancelarClick(Sender: TObject);
begin
  Resultado := mrCancel;
  Close;
end;

procedure TFMensagem.btnNaoClick(Sender: TObject);
begin
  Resultado := mrNo;
  Close;
end;

procedure TFMensagem.btnOKClick(Sender: TObject);
begin
  Resultado := mrOk;
  Close;
end;

procedure TFMensagem.btnSimClick(Sender: TObject);
begin
  Resultado := mrYes;
  Close;
end;

end.
