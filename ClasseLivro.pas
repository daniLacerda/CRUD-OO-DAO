unit ClasseLivro;

interface

uses
  SysUtils;

type
  TLivro = class
  private
    FidLivro: Integer;
    FAutorLivro: Integer;
    FNome_Livro : String;

    procedure SetAutorLivro(const Value: Integer);
    procedure SetidLivro(const Value: Integer);
    procedure SetNome_Livro(const Value : String);

  public
    property idLivro: Integer read FidLivro write SetidLivro;
    property AutorLivro: Integer read FAutorLivro write SetAutorLivro;
    property Nome_Livro: String read FNome_Livro write SetNome_Livro;
  end;

implementation

{ TLivro }

procedure TLivro.SetAutorLivro(const Value: Integer);
begin
  Self.FAutorLivro := Value;
end;

procedure TLivro.SetidLivro(const Value: Integer);
begin
  Self.FidLivro := Value;
end;

procedure TLivro.SetNome_Livro(const Value: String);
begin
  Self.FNome_Livro := Value;
end;

end.
