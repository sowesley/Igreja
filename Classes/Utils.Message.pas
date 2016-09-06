unit Utils.Message;

interface

uses
  Windows, Forms, Utils.Types, SysUtils, UMensagem, Vcl.Graphics, UConfigIni;

type
  TTipoMsg = (tmInformacao, tmAtencao, tmQuestao, tmErro, tmSucesso);
  TTipoBotoes = (tbOk, tbOkCancelar, tbSimNao, tbSimNaoCancelar);

  TMensagens = class
    class function ShowMessage(const aMsg: string; aCaption: string; aIcone: TTipoMsg; aBotoes: TTipoBotoes): Integer; overload;
    class function ShowMessage(const aMsg: string): Integer; overload; class function ShowMessage(const aMsg: string; aCaption: string): Integer; overload;
    class function ShowMessage(const aMsg: string; aCaption: string; aIcone: TTipoMsg): Integer; overload;
    class function ShowMessage(const aMsg: string; aCaption: string; aBotoes: TTipoBotoes): Integer; overload;
    class function ShowMessage(const aMsg: string; aIcone: TTipoMsg): Integer; overload;
    class function ShowMessage(const aMsg: string; aBotoes: TTipoBotoes): Integer; overload;
    class function ShowMessage(const aMsg: string; aIcone: TTipoMsg; aBotoes: TTipoBotoes): Integer; overload;
  end;

implementation

{ TMensagens }

class function TMensagens.ShowMessage(const aMsg: string; aCaption: string; aIcone: TTipoMsg; aBotoes: TTipoBotoes): Integer;
var
  loForm: TFMensagem;
  Imagem: string;
  vCor: TColor;
begin
  loForm := TFMensagem.Create(nil);
  try
    loForm.btnSim.Hide;
    loForm.btnNao.Hide;
    loForm.btnCancelar.Hide;
    loForm.btnOK.Hide;

    case aBotoes of
      tbOk:
        begin
          loForm.btnOK.Show;
        end;
      tbOkCancelar:
        begin
          loForm.btnOK.Show;
          loForm.btnCancelar.Show;
        end;
      tbSimNao:
        begin
          loForm.btnSim.Show;
          loForm.btnNao.Show;
        end;
      tbSimNaoCancelar:
        begin
          loForm.btnSim.Show;
          loForm.btnNao.Show;
          loForm.btnCancelar.Show;
        end;
    end;

    case aIcone of
      tmInformacao:
        begin
          Imagem := 'ImgInformacao.png';
          vCor   := $00FFF31C;
        end;
      tmAtencao:
        begin
          Imagem := 'ImgAtencao.png';
          vCor   := $000FCDFD;
        end;
      tmQuestao:
        begin
          Imagem := 'ImgPergunta.png';
          vCor   := $00FF8080;
        end;
      tmErro:
        begin
          Imagem := 'ImgErro.png';
          vCor   := $000000E1;
        end;
      tmSucesso:
       begin
         Imagem := 'ImgSucesso.png';
         vCor   := $0000EA00;
       end;
    end;

    loForm.Image1.Picture.LoadFromFile(TConfigIni.CaminhoImagens + Imagem);
    loForm.lblTitulo.Color  := vCor;
    loForm.pnlLateral.Color := vCor;

    loForm.lblTitulo.Caption := aCaption;
    loForm.lblMensagem.HTMLText.Text := '<P align="center">' + aMsg + '</P>';

    loForm.ShowModal;

    Result := loForm.Resultado;
  finally
    FreeAndNil(loForm);
  end;
end;

class function TMensagens.ShowMessage(const aMsg: string): Integer;
begin
  Result := ShowMessage(aMsg,'Atenção!',tmInformacao,tbOk);
end;

class function TMensagens.ShowMessage(const aMsg: string;
  aCaption: string): Integer;
begin
  Result := ShowMessage(aMsg,aCaption,tmInformacao,tbOk);
end;

class function TMensagens.ShowMessage(const aMsg: string; aCaption: string;
  aIcone: TTipoMsg): Integer;
begin
  Result := ShowMessage(aMsg,aCaption,aIcone,tbOk);
end;

class function TMensagens.ShowMessage(const aMsg: string; aCaption: string;
  aBotoes: TTipoBotoes): Integer;
begin
  Result := ShowMessage(aMsg,aCaption,tmInformacao,aBotoes);
end;

class function TMensagens.ShowMessage(const aMsg: string;
  aIcone: TTipoMsg): Integer;
begin
  Result := ShowMessage(aMsg,'Atenção!',aIcone,tbOk);
end;

class function TMensagens.ShowMessage(const aMsg: string;
  aBotoes: TTipoBotoes): Integer;
begin
  Result := ShowMessage(aMsg,'Atenção!',tmInformacao,aBotoes);
end;

class function TMensagens.ShowMessage(const aMsg: string; aIcone: TTipoMsg;
  aBotoes: TTipoBotoes): Integer;
begin
  Result := ShowMessage(aMsg,'Atenção!',aIcone,aBotoes);
end;

end.
