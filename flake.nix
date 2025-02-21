# flake.nix
{
  description = "ansible development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # Custom flakes
    checkpoint-sdk.url = "path:nix/pkgs/checkpoint-sdk";
  };

  outputs = { self, nixpkgs, flake-utils, checkpoint-sdk }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
        pythonEnv = pkgs.python3.withPackages (pythonPackages: 
				  with pythonPackages; [
            # Specify python packages to include in development shell
            pip
				    ansible 
            checkpoint-sdk.packages.${system}.default
			    ]
	      );
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pythonEnv # Defined above
            # Specify packages to include in devshell
            pkgs.ansible
          ];
         
          # Specify shell commands you want to run upon entering new dev shell (running "nix develop" command)
          shellHook = ''
            echo
            ansible-galaxy collection install check_point.mgmt check_point.gaia
            echo
            echo "> Ansible Checkpoint development environment loaded!"
            python -c 'import cpapi' && echo "> Checkpoint API python SDK successfully imported!"

            # Verify Checkpoint collection installation
            # echo "Installed Check Point collections:"
            # ansible-galaxy collection list | grep check_point 
            echo
            echo "> Remember to set checkpoint management password environment variable for this demo:"
            echo "  Found in: Keeper->CheckPoint Mgmt SSH/WebGUI ReadWriteAccess"
            echo "export CHECKPOINT_PASSWORD='<your_password_here>'"
            echo
          '';
        };
      }
    );
}

