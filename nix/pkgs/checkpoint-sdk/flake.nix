{
  description = "Check Point Management API Python SDK";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in
      {
        packages.default = python.pkgs.buildPythonPackage rec {
          pname = "cp-mgmt-api-sdk";
          version = "1.9.0";
          format = "setuptools";

          src = pkgs.fetchFromGitHub {
            owner = "CheckPointSW";
            repo = "cp_mgmt_api_python_sdk";
            rev = "master";  # You might want to pin to a specific commit
            sha256 = "sha256-k4gMlO3T0r5mrW/uFb03rVVwUzoHIJF2uJnCuR+dObY="; 
          };

          propagatedBuildInputs = with python.pkgs; [
            requests
          ];

          doCheck = false;  # Disable tests as they require connection to Check Point management server

          meta = with pkgs.lib; {
            description = "Check Point Management API Python SDK";
            homepage = "https://github.com/CheckPointSW/cp_mgmt_api_python_sdk";
            license = licenses.mit;  # Verify the actual license
          };
        };
      }
    );
}
