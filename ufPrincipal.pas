unit ufPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Phys.Intf, FireDAC.Phys,
  FireDAC.Comp.DataSet,
  FireDAC.Stan.Param, FireDAC.Phys.MySQLDef,
  uDataModule,
  FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Phys.MySQL, FireDAC.Stan.Intf,
  FireDAC.Comp.UI, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.Client,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, ClasseAutor, ClasseLivro, uAutorDAO;

type
  TModo = (modoInclusao, modoAlteracao, modoLeitura);
  TDataModule = class(TDataModule1);

  TLivraria = class(TForm)
    pnlFundo: TPanel;
    pnlAutores: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    pnlA_Operacoes: TPanel;
    btnA_Alterar: TButton;
    btnA_Incluir: TButton;
    btnA_Excluir: TButton;
    edtId_Autores: TEdit;
    edtNome_Autores: TEdit;
    btnA_Anterior: TButton;
    btnA_Proximo: TButton;
    btnVerLivros: TButton;
    pnlA_Confirmar: TPanel;
    btnA_Cancelar: TButton;
    btnA_Salvar: TButton;
    btnAbrirConsulta: TButton;
    dbGridAutores: TDBGrid;
    lblModoAutor: TLabel;
    pnlLivros: TPanel;
    btnFecharConsulta: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtId_Livro: TEdit;
    edtAutor_Livro: TEdit;
    pnlL_Operacoes: TPanel;
    btnL_Excluir: TButton;
    btnL_Alterar: TButton;
    btnL_Incluir: TButton;
    lblModoLivro: TLabel;
    btnL_Proximo: TButton;
    btnL_Anterior: TButton;
    dbGridLivros: TDBGrid;
    pnlL_Confirmar: TPanel;
    btnL_Salvar: TButton;
    btnL_Cancelar: TButton;
    edtNome_Livro: TEdit;

    procedure btnAbrirConsultaClick(Sender: TObject);
    procedure btnA_ProximoClick(Sender: TObject);
    procedure btnA_AnteriorClick(Sender: TObject);
    procedure btnA_AlterarClick(Sender: TObject);
    procedure btnA_IncluirClick(Sender: TObject);
    procedure btnA_ExcluirClick(Sender: TObject);
    procedure btnA_SalvarClick(Sender: TObject);
    procedure btnA_CancelarClick(Sender: TObject);
    procedure btnVerLivrosClick(Sender: TObject);
    procedure btnL_AnteriorClick(Sender: TObject);
    procedure btnL_ProximoClick(Sender: TObject);
    procedure btnFecharConsultaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbGridAutoresCellClick(Column: TColumn);
    procedure dbGridAutoresColumnMoved(Sender: TObject;
      FromIndex, ToIndex: Integer);
    procedure dbGridAutoresKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbGridLivrosCellClick(Column: TColumn);
    procedure dbGridLivrosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbGridLivrosColumnMoved(Sender: TObject;
      FromIndex, ToIndex: Integer);
    procedure btnL_SalvarClick(Sender: TObject);
    procedure btnL_CancelarClick(Sender: TObject);
    procedure btnL_ExcluirClick(Sender: TObject);
    procedure btnL_AlterarClick(Sender: TObject);
    procedure btnL_IncluirClick(Sender: TObject);
  private
    FAutor: TAutor;
    FModo: TModo;
    FLivro: TLivro;
    procedure ConsultarLinhas_Autor;
    procedure ConsultarLinhas_Livro;
    procedure ConexaoBD;
    procedure AfterScrollDS(ADataSet: TDataSet);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Livraria: TLivraria;

implementation

{$R *.dfm}

procedure TLivraria.ConexaoBD;
begin
  if DataModule1.conexao.Connected = False then
  begin
    DataModule1.conexao.Connected := True;
    ShowMessage('Banco de Dados Conectado.');
  end
  else
  begin
    DataModule1.conexao.Connected := False;
    ShowMessage('Banco de Dados Desconectado.');
  end;
end;

procedure TLivraria.btnL_AlterarClick(Sender: TObject);
begin
  btnVerLivros.Enabled := False;
  btnL_Alterar.Enabled := False;
  btnL_Incluir.Enabled := False;
  btnL_Excluir.Enabled := True;
  btnL_Cancelar.Enabled := True;
  btnL_Salvar.Enabled := True;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := False;
  edtAutor_Livro.ReadOnly := True;
  edtNome_Livro.SetFocus;
  lblModoLivro.Caption := 'Modo: Alteração';
  FModo := modoAlteracao;
end;

procedure TLivraria.btnL_AnteriorClick(Sender: TObject);
begin
  DataModule1.qryLivros.Prior;
  ConsultarLinhas_Livro;
end;

procedure TLivraria.btnL_CancelarClick(Sender: TObject);
begin
  ConsultarLinhas_Livro;
  btnVerLivros.Enabled := True;
  btnL_Alterar.Enabled := True;
  btnL_Incluir.Enabled := True;
  btnL_Excluir.Enabled := False;
  btnL_Cancelar.Enabled := False;
  btnL_Salvar.Enabled := False;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := True;
  FModo := modoLeitura;
  lblModoLivro.Caption := 'Modo: Leitura';
end;

procedure TLivraria.btnL_ExcluirClick(Sender: TObject);
begin
  if DataModule1.conexao.ExecSQL('DELETE FROM livros WHERE id_livro=' +
  QuotedStr(edtId_Livro.Text)) > 0 then
    begin
      ShowMessage('Excluido com sucesso!');
      DataModule1.qryLivros.Refresh;
      ConsultarLinhas_Livro;
      btnVerLivros.Enabled := True;
      btnL_Alterar.Enabled := True;
      btnL_Incluir.Enabled := True;
      btnL_Excluir.Enabled := False;
      btnL_Cancelar.Enabled := False;
      btnL_Salvar.Enabled := False;
      edtId_Livro.ReadOnly := True;
      edtNome_Livro.ReadOnly := True;
      FModo := modoLeitura;
      lblModoLivro.Caption := 'Modo: Leitura';
    end;
end;

procedure TLivraria.btnL_IncluirClick(Sender: TObject);
begin
  btnVerLivros.Enabled := False;
  btnL_Alterar.Enabled := False;
  btnL_Incluir.Enabled := False;
  btnL_Excluir.Enabled := False;
  btnL_Cancelar.Enabled := True;
  btnL_Salvar.Enabled := True;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := False;
  FModo := modoInclusao;
  lblModoLivro.Caption := 'Modo: Inclusão';
  edtNome_Livro.Clear;
  edtNome_Livro.SetFocus;
  if edtAutor_Livro.Text = '' then
    begin
      edtAutor_Livro.ReadOnly := False;
    end
  else
    begin
      edtAutor_Livro.ReadOnly := True;
    end;
end;

procedure TLivraria.btnL_SalvarClick(Sender: TObject);
var
edtNLivro : String;
begin
  edtNLivro := edtNome_Livro.Text;
  if FModo = modoLeitura then
        Exit;

      if FModo = modoInclusao then
      begin
        edtId_Livro.ReadOnly := False;
        DataModule1.qryLivros.Append;
      end
      else
        DataModule1.qryLivros.Edit;

        FLivro.Nome_Livro := edtNLivro;
        FLivro.AutorLivro := StrToInt(edtId_Autores.Text);

        DataModule1.qryLivros.FieldByName('nome_livro').Value :=
          FLivro.Nome_Livro;
        DataModule1.qryLivros.FieldByName('autor_livro').Value :=
          FLivro.AutorLivro;
        DataModule1.qryLivros.Post;

        if dbGridLivros.CanFocus then
          dbGridLivros.SetFocus;

        btnL_Salvar.Enabled := False;
        ConsultarLinhas_Livro;
        btnVerLivros.Enabled := True;
        btnL_Alterar.Enabled := True;
        btnL_Incluir.Enabled := True;
        btnL_Excluir.Enabled := False;
        btnL_Cancelar.Enabled := False;
        btnL_Salvar.Enabled := False;
        edtId_Livro.ReadOnly := True;
        edtNome_Livro.ReadOnly := True;
        FModo := modoLeitura;
        lblModoLivro.Caption := 'Modo: Leitura';
end;

procedure TLivraria.btnA_AlterarClick(Sender: TObject);
begin
  if TButton(Sender).Name = 'btnA_Alterar' then
  begin
    btnA_Cancelar.Enabled := True;
    btnA_Salvar.Enabled := True;
    btnVerLivros.Enabled := False;
    btnA_Alterar.Enabled := False;
    btnA_Incluir.Enabled := False;
    btnA_Excluir.Enabled := True;
    edtId_Autores.ReadOnly := True;
    edtNome_Autores.ReadOnly := False;
    edtNome_Autores.SetFocus;
    lblModoAutor.Caption := 'Modo: Alteração';
    FModo := modoAlteracao;
  end;
end;

procedure TLivraria.btnA_AnteriorClick(Sender: TObject);
begin
  DataModule1.qryAutores.Prior;
  ConsultarLinhas_Autor;
end;

procedure TLivraria.btnA_CancelarClick(Sender: TObject);
begin
  btnA_Cancelar.Enabled := False;
  btnA_Salvar.Enabled := False;
  ConsultarLinhas_Autor;
  btnVerLivros.Enabled := True;
  btnA_Alterar.Enabled := True;
  btnA_Incluir.Enabled := True;
  btnA_Excluir.Enabled := False;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := True;
  FModo := modoLeitura;
  lblModoAutor.Caption := 'Modo: Leitura';
end;

procedure TLivraria.btnA_ExcluirClick(Sender: TObject);
var
  _id : Integer;
begin
  _id := StrToInt(edtId_Autores.Text);
  try
  TAutorDAO.ExcluirValor(_id);
  except
  on E: Exception do
  begin
    ShowMessage('Erro ao Excluir o Registro, DESGRAÇA.');
    Exit;
  end;

  end;

  DataModule1.qryAutores.Refresh;
  btnA_Cancelar.Enabled := False;
  btnA_Salvar.Enabled := False;
  ConsultarLinhas_Autor;
  btnVerLivros.Enabled := True;
  btnA_Alterar.Enabled := True;
  btnA_Incluir.Enabled := True;
  btnA_Excluir.Enabled := False;
  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := True;
  FModo := modoLeitura;
  lblModoAutor.Caption := 'Modo: Leitura';

end;

procedure TLivraria.btnA_IncluirClick(Sender: TObject);
begin
  if TButton(Sender).Name = 'btnA_Incluir' then
  begin
    btnVerLivros.Enabled := False;
    btnA_Alterar.Enabled := False;
    btnA_Incluir.Enabled := False;
    btnA_Excluir.Enabled := False;
    btnA_Cancelar.Enabled := True;
    btnA_Salvar.Enabled := True;
    edtId_Autores.ReadOnly := True;
    edtId_Autores.Clear;
    edtNome_Autores.ReadOnly := False;
    edtNome_Autores.Clear;
    edtNome_Autores.SetFocus;
    FModo := modoInclusao;
    lblModoAutor.Caption := 'Modo: Inclusão';
  end
end;

procedure TLivraria.btnA_ProximoClick(Sender: TObject);
begin
  DataModule1.qryAutores.Next;
  ConsultarLinhas_Autor;
end;

procedure TLivraria.btnA_SalvarClick(Sender: TObject);
var
  _autores : TAutor;

begin
  _autores := TAutor.Create;
  try
    if FModo = modoAlteracao then
      _autores.idAutor := StrToInt(edtId_Autores.Text);

    _autores.Nome    :=   edtNome_Autores.Text;
    _autores.Hora    :=   Time();
    _autores.Data    :=   Date();

    TAutorDAO.SalvarValor(_autores);
  finally
    FreeAndNil(_autores);
  end;
  DataModule1.qryAutores.Refresh;
  FModo := modoLeitura;
  lblModoAutor.Caption := 'Modo: Leitura';
  ShowMessage('Registro Salvo com Sucesso!');
  btnA_Salvar.Enabled := False;
  btnA_Cancelar.Enabled := False;
  btnA_Alterar.Enabled := True;
  btnA_Incluir.Enabled := True;
  btnA_Excluir.Enabled := False;
    if dbGridAutores.CanFocus then
    dbGridAutores.SetFocus;

{  if FModo = modoLeitura then
    Exit;

  if FModo = modoInclusao then
  begin

    DataModule1.qryAutores.Append;
  end
  else
    DataModule1.qryAutores.Edit;

  FAutor.Nome := edtNome_Autores.Text;
  FAutor.Hora := Time();
  FAutor.Data := Date();

  DataModule1.qryAutores.FieldByName('nome_autor').Value := FAutor.Nome;
  DataModule1.qryAutores.FieldByName('hora_log').Value := FAutor.Hora;
  DataModule1.qryAutores.FieldByName('data_log').Value := FAutor.Data;
  DataModule1.qryAutores.Post;
  FModo := modoLeitura;
  lblModoAutor.Caption := 'Modo: Leitura';

  if dbGridAutores.CanFocus then
    dbGridAutores.SetFocus;  }
end;

procedure TLivraria.btnFecharConsultaClick(Sender: TObject);
begin
  DataModule1.conexao.Connected := False;
  DataModule1.qryAutores.Active := False;
  pnlAutores.Enabled := False;
  pnlAutores.Visible := False;

  DataModule1.qryLivros.Active := False;
  pnlLivros.Enabled := False;
  pnlLivros.Visible := False;
  btnFecharConsulta.Enabled := False;
  btnAbrirConsulta.Enabled := True;

end;

procedure TLivraria.btnL_ProximoClick(Sender: TObject);
begin
  DataModule1.qryLivros.Next;
  ConsultarLinhas_Livro;
end;

procedure TLivraria.ConsultarLinhas_Livro;
begin
  Self.FLivro.idLivro := DataModule1.qryLivros.FieldByName('id_livro')
    .AsInteger;
  Self.FLivro.Nome_Livro := DataModule1.qryLivros.FieldByName
    ('nome_livro').AsString;
  Self.FLivro.AutorLivro := DataModule1.qryLivros.FieldByName('autor_livro')
    .AsInteger;

  edtId_Livro.Text := DataModule1.qryLivros.FieldByName('id_livro').AsString;
  edtNome_Livro.Text := Self.FLivro.Nome_Livro;
  edtAutor_Livro.Text := DataModule1.qryLivros.FieldByName
    ('autor_livro').AsString;
end;

procedure TLivraria.dbGridLivrosCellClick(Column: TColumn);
begin
  ConsultarLinhas_Livro();
end;

procedure TLivraria.dbGridLivrosColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ConsultarLinhas_Livro();
end;

procedure TLivraria.dbGridLivrosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_down then
  begin
    if btnL_Proximo.Enabled then
      btnL_Proximo.Click;

    Abort;
  end;

  if Key = vk_up then
  begin
    if btnL_Anterior.Enabled then
      btnL_Anterior.Click;

    Abort;
  end;
end;

procedure TLivraria.dbGridAutoresCellClick(Column: TColumn);
begin
  ConsultarLinhas_Autor();
end;

procedure TLivraria.dbGridAutoresColumnMoved(Sender: TObject;
  FromIndex, ToIndex: Integer);
begin
  ConsultarLinhas_Autor();
end;

procedure TLivraria.dbGridAutoresKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vk_down then
  begin
    if btnA_Proximo.Enabled then
      btnA_Proximo.Click;

    Abort;
  end;

  if Key = vk_up then
  begin
    if btnA_Anterior.Enabled then
      btnA_Anterior.Click;

    Abort;
  end;
end;

procedure TLivraria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(Self.FAutor);
  FreeAndNil(Self.FLivro);
end;

procedure TLivraria.FormCreate(Sender: TObject);
begin
  //Self.FAutor := TAutor;
  Self.FLivro := TLivro.Create;
end;

procedure TLivraria.btnVerLivrosClick(Sender: TObject);
begin
  pnlLivros.Enabled := True;
  DataModule1.qryLivros.Active := Active;
  DataModule1.qryLivros.SQL.Text :=
    ('SELECT id_livro, nome_livro, autor_livro FROM livros WHERE autor_livro ='
    + IntToStr(FAutor.idAutor) + '');

  try
    DataModule1.qryLivros.AfterScroll := AfterScrollDS;
    DataModule1.qryLivros.Open;
  except
    on E: Exception do
      raise Exception.Create('Falha ao abrir a consulta de Livros!' +
        E.Message);
  end;
  pnlLivros.Enabled := True;
  pnlLivros.Visible := True;
  DataModule1.qryLivros.FetchAll;
  DataModule1.qryLivros.First;

  ConsultarLinhas_Livro();
  btnL_Excluir.Enabled := False;
  btnL_Salvar.Enabled := False;
  btnL_Cancelar.Enabled := False;
  edtId_Livro.ReadOnly := True;
  edtNome_Livro.ReadOnly := True;
  edtAutor_Livro.ReadOnly := True;

  if dbGridLivros.CanFocus then
    dbGridLivros.SetFocus;
end;

procedure TLivraria.ConsultarLinhas_Autor;
var
  _autor : TAutor;
begin
  _autor := TAutorDAO.CarregarValores(DataModule1.qryAutores.FieldByName('id_autor').AsInteger);
  try
    edtId_Autores.Text := _autor.idAutor.ToString;
    edtNome_Autores.Text := _autor.Nome;
    finally
    FreeAndNil(_autor);
  end;
end;

procedure TLivraria.AfterScrollDS(ADataSet: TDataSet);
begin
  ConsultarLinhas_Autor();
  ConsultarLinhas_Livro();
end;

procedure TLivraria.btnAbrirConsultaClick(Sender: TObject);
begin
  ConexaoBD;
  DataModule1.qryAutores.Active := Active;

  if btnFecharConsulta.Enabled = False then
    btnFecharConsulta.Enabled := True;

  btnA_Cancelar.Enabled := False;
  btnA_Salvar.Enabled := False;
  pnlAutores.Enabled := True;
  pnlAutores.Visible := True;
  btnVerLivros.Enabled := True;
  btnA_Excluir.Enabled := False;
  DataModule1.qryAutores.FetchAll;
  DataModule1.qryAutores.First;
  ConsultarLinhas_Autor();

  edtId_Autores.ReadOnly := True;
  edtNome_Autores.ReadOnly := True;
  btnAbrirConsulta.Enabled := False;

  if dbGridAutores.CanFocus then
    dbGridAutores.SetFocus;
end;

end.
