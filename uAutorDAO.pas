unit uAutorDAO;

interface
uses
SysUtils, ClasseAutor, uDataModule, Dialogs;
type
  TModo = (modoLeitura, modoAlteracao, modoEdicao);
  TAutorDAO = class

  private

  public
    class function CarregarValores(AID : Integer): TAutor ;
    class procedure ExcluirValor(AID : Integer);
    class procedure SalvarValor(AAutor : TAutor);

end;

implementation

uses
  FireDAC.Comp.Client;

{ TDAutor }

class function TAutorDAO.CarregarValores(AID : Integer): TAutor;
var
  _autor : TAutor;
  _qryLoad : TFDQuery;
begin
  try
    _qryLoad := TFDQuery.Create(nil);
    _qryLoad.Connection := DataModule1.conexao;
    _qryLoad.SQL.Text :=
      'SELECT * FROM autores WHERE id_autor = ' + AID.ToString;
    try
      _qryLoad.Open;
    except
      on E: Exception do
      raise Exception.Create('Falha ao abrir a consulta de Autores AQUI!' +
        E.Message);
    end;
    if _qryLoad.IsEmpty then
    begin
      ShowMessage('ID não encontrado na base de Dados.');
      Exit
    end;
    _autor := TAutor.Create;

    _autor.idAutor := _qryLoad.FieldByName('id_autor').AsInteger;
    _autor.Nome := _qryLoad.FieldByName('nome_autor').AsString;
    _autor.Hora := _qryLoad.FieldByName('hora_log').AsDateTime;
    _autor.Data := _qryLoad.FieldByName('data_log').AsDateTime;
  finally

    FreeAndNil(_qryLoad);
  end;
  Result := _Autor;
end;

class procedure TAutorDAO.ExcluirValor(AID : Integer);
var
  _qryAutores : TFDQuery;
begin
  _qryAutores :=  TFDQuery.Create(nil);
  _qryAutores.Connection := DataModule1.conexao;
  try
    if _qryAutores.ExecSQL('DELETE FROM autores WHERE id_autor=' +
     AID.ToString) > 0 then
      begin
        ShowMessage('Registro EXCLUIDO com sucesso!');
      end else
        
  finally
    FreeAndNil(_qryAutores);
  end;

end;


class procedure TAutorDAO.SalvarValor(AAutor : TAutor);
var
_qryAutores : TFDQuery;
begin
  _qryAutores := TFDQuery.Create(nil);
  _qryAutores.Connection := DataModule1.conexao;
  _qryAutores.SQL.Text :=
    'SELECT * FROM autores WHERE id_autor = ' + AAutor.idAutor.ToString;
  try
    try
      _qryAutores.Open;
    except
      on E: Exception do
        raise Exception.Create('Erro ao carregar a Query.' + E.Message);
    end;

    if _qryAutores.IsEmpty then
      _qryAutores.Append
    else
      _qryAutores.Edit;

    _qryAutores.FieldByName('nome_autor').Value := AAutor.Nome;
    _qryAutores.FieldByName('hora_log').Value :=   AAutor.Hora;
    _qryAutores.FieldByName('data_log').Value :=   AAutor.Data;
    
    try
      _qryAutores.Post;
    except
      on E: Exception do
        raise Exception.Create('Erro ao SALVAR os valores.' + E.Message);
    end;
  finally
    FreeAndNil(_qryAutores);
  end;
end;

end.
