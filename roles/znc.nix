{ config, pkgs, ... }:

{
  networking.firewall.allowedTCPPorts = [ 5000 ];

	services.znc = {
    enable = true;
    confOptions = {
      networks = {
        freenode = {
          channels = [ "haskell" "haskell.au" "haskell-beginners" "haskell-offtopic" "idris" "nixos" "purescript" "qfpl" ];
          modules = [ "log" "simple_away" ];
          server = "chat.freenode.net";
          port = 6697;
          useSSL = true;
        };
      };
      nick = "vaibhavsagar";
      # passBlock with `nix-shell -p znc --command "znc --makepass"`.
      # and place it inside secrets.nix
			passBlock = (import ../secrets.nix).zncPassBlock;
    };
  };
}
