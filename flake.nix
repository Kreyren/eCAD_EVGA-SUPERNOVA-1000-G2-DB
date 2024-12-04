{
	description = "Open-Source Replacement Daughter Board for EVGA SUPERNOVA 1000 G2";

	inputs = {
		nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

		nixos-hardware.url = "github:NixOS/nixos-hardware";
		nixos-flake.url = "github:srid/nixos-flake";
		impermanence.url = "github:kreyren/impermanence"; # Use a fork to manage https://github.com/nix-community/impermanence/issues/167
		flake-parts.url = "github:hercules-ci/flake-parts";
		mission-control.url = "github:Platonic-Systems/mission-control";
		flake-root.url = "github:srid/flake-root";

		# Home-Manager
			hm = {
				url = "github:nix-community/home-manager/release-24.05";
				inputs.nixpkgs.follows = "nixpkgs";
			};

		nixos-generators = {
			url = "github:nix-community/nixos-generators";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs @ { self, ... }:
		inputs.flake-parts.lib.mkFlake { inherit inputs; } {
			imports = [
				./tasks # Include tasks

				inputs.flake-root.flakeModule
				inputs.mission-control.flakeModule
			];

			# Set Supported Systems
			systems = [
				"x86_64-linux"
				"aarch64-linux"
				"riscv64-linux"
				"armv7l-linux"
			];

			perSystem = { system, config, inputs', ... }: {
				devShells.default = inputs.nixpkgs.legacyPackages.${system}.mkShell {
					name = "NiXium-devshell";
					nativeBuildInputs = [
						inputs.nixpkgs.legacyPackages.${system}.bashInteractive # For terminal
						inputs.nixpkgs.legacyPackages.${system}.nil # Needed for linting
						inputs.nixpkgs.legacyPackages.${system}.nixpkgs-fmt # Nixpkgs formatter
						inputs.nixpkgs.legacyPackages.${system}.git # Working with the codebase

						inputs.nixpkgs.legacyPackages.${system}.fira-code # For liquratures in code editors

						inputs.nixpkgs.legacyPackages.${system}.kicad-small

						inputs.nixos-generators.packages.${system}.nixos-generate
					];
					inputsFrom = [
						config.mission-control.devShell
						config.flake-root.devShell
					];
					# Environmental Variables
					#VARIABLE = "value"; # Comment
				};
			};
		};
}
