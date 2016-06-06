{ pkgs, fetchgit }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {
  "fzf" = buildVimPlugin {
    name = "fzf";
    src = fetchgit {
      url = "https://github.com/junegunn/fzf";
      rev = "248320fa55c75a69a8f479125de68f10ee2311d0";
      sha256 = "1hs4jnvic9jhg4r300c0qdhxwg2pyc19n0q1khwyndngrqkfzdsz";
    };
    buildPhase = ''
    ls | grep -v plugin | xargs rm -rf
    '';
    dependencies = [];
  };
  "fzf.vim" = buildVimPlugin {
    name = "fzf.vim";
    src = fetchgit {
      url = "https://github.com/junegunn/fzf.vim";
      rev = "2eebbf654051cb115b3434ce59bc12ac731650a2";
      sha256 = "1r7cxk04spdbl8rhs1lb0ijjzr0ga4jngqm2ydgw4qrrvgkdilar";
    };
    dependencies = [];
  };

  "trailing-whitespace" = buildVimPlugin {
    name = "trailing-whitespace";
    src = fetchgit {
      url = "https://github.com/bronson/vim-trailing-whitespace";
      rev = "733fb64337b6da4a51c85a43450cd620d8b617b5";
      sha256 = "1l8rgnxbny8rikgajn5qd3c7ip3rf32phfklxxnvfyxrr6x259m0";
    };
    dependencies = [];
  };
}
