{ config, pkgs, ... }:

{
	fonts = {
		enableCoreFonts = true;
		enableFontDir = true;
		enableGhostscriptFonts = false;

		fonts = with pkgs; [
			symbola
			font-awesome-ttf
			libertine
			# code2000
			# code2001
			# code2002
			terminus_font
			ubuntu_font_family
			liberation_ttf
			freefont_ttf
			source-code-pro
			(let inconsolata-lgc  = let version = "1.2.0";
			in with pkgs; stdenv.mkDerivation rec {
				name = "inconsolata-lgc-${version}";
				src = fetchurl {
				url = "https://github.com/MihailJP/Inconsolata-LGC/releases/download/LGC-1.2.0/InconsolataLGC-OT-1.2.0.tar.xz";
				sha256 = "0rw8i481sdqi0pspbvyd2f86k0vlrb6mbi94jmsl1kms18c18p66";
				};
				dontBuild = true;
				installPhase = let
				fonts_dir = "$out/share/fonts/opentype";
				doc_dir = "$out/share/doc/${name}";
				in ''
				mkdir -pv "${fonts_dir}"
				mkdir -pv "${doc_dir}"
								 cp -v *.otf "${fonts_dir}"
								 cp -v {README,LICENSE,ChangeLog} "${doc_dir}"
				'';
				meta = with stdenv.lib; {
					homepage = http://www.levien.com/type/myfonts/inconsolata.html;
					description = "A monospace font for both screen and print, LGC extension";
					license = licenses.ofl;
					platforms = platforms.all;
				};
			}; in inconsolata-lgc)
			inconsolata
			vistafonts
			dejavu_fonts
			freefont_ttf
			unifont
			cm_unicode
			ipafont
			baekmuk-ttf
			source-han-sans-japanese
			source-han-sans-korean
			source-han-sans-simplified-chinese
			source-han-sans-traditional-chinese
			source-sans-pro
			source-serif-pro
			fira
			fira-code
			fira-mono
			hasklig
		];

		fontconfig = {
			enable = true;
			dpi = 100;
			antialias = true;
			hinting = {
				autohint = false;
				enable = true;
			};
			subpixel.lcdfilter = "default";
			ultimate = {
				enable = true; # see also: rendering, substitutions
			};
			defaultFonts = {
				serif = [ "Source Sans Pro" "DejaVu Serif" "IPAMincho" "Beakmuk Batang" ];
				sansSerif = [ "Source Serif Pro" "DejaVu Sans" "IPAGothic" "Beakmuk Dotum" ];
				monospace = [ "Inconsolata LGC" "DejaVu Sans Mono" "IPAGothic" "Beakmuk Dotum" ];
			};
		};
	};
}
