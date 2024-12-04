{ ... }:

{
	perSystem = { inputs', lib, pkgs, ... }: {
		mission-control.scripts = {
			kicad = {
				description = "Launch repository-standardized KiCAD";
				category = "Integrated Development Environments";
				exec = ''
					${inputs'.nixpkgs.legacyPackages.kicad-small}/bin/kicad "$FLAKE_ROOT/src/evga1000g2db.kicad_pro"
				'';
			};
		};
	};
}
