program ufProjeto;

uses
  Vcl.Forms,
  ufPrincipal in 'ufPrincipal.pas' {Livraria},
  uDataModule in 'uDataModule.pas' {DataModule1: TDataModule},
  ClasseAutor in 'ClasseAutor.pas',
  ClasseLivro in 'ClasseLivro.pas',
  uAutorDAO in 'uAutorDAO.pas',
  uLivroDAO in 'uLivroDAO.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := Debughook<>0;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLivraria, Livraria);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;

end.
