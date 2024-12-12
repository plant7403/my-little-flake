{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "SPL token-cli";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "solana-labs";
    repo = pname;
    rev = version;
    hash = "sha256-+s5RBC3XSgb8omTbUNLywZnP6jSxZBKSS1BmXOjRF8M=";
  };

  cargoHash = "sha256-jtBw4ahSl88L0iuCXxQgZVm1EcboWRJMNtjxLVTtzts=";

  meta = {
    description = "Test";
    homepage = "https://github.com/solana-labs/solana-program-library";
    license = lib.licenses.unlicense;
    maintainers = [];
  };
}
