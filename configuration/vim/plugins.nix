{ pkgs, fetchgit }:

let
  buildVimPlugin = pkgs.vimUtils.buildVimPluginFrom2Nix;
in {
  "fzf" = buildVimPlugin {
    name = "fzf";
    src = fetchgit {
      url = "https://github.com/junegunn/fzf";
      rev = "248320fa55c75a69a8f479125de68f10ee2311d0";
      sha256 = "1ddph34dbj4fw3x48n3ywfw48b2frpnly3hmd3835vb9nwfzf1i8";
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
      sha256 = "1469bd744lf8vk1nnw7kyq4ahpw84crp614mkpq88cs6rhvjhcyw";
    };
    dependencies = [];
  };
}
