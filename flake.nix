{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
    in rec {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          python3
          stdenv.cc.cc.lib

          # for CUDA
          cudatoolkit
          freeglut
          linuxPackages.nvidia_x11
          libGLU
          libGL
          xorg.libXi
          xorg.libXmu
          xorg.libXext
          xorg.libX11
          xorg.libXv
          xorg.libXrandr          
        ];
        shellHook = ''
          echo "Hello from Python Dev Shell"
          [ ! -d "env" ] && python -m venv env
          source env/bin/activate \
          pip install -r requirements.txt
          export LD_LIBRARY_PATH=${pkgs.stdenv.cc.cc.lib}/lib/:$LD_LIBRARY_PATH
          export CUDA_PATH=${pkgs.cudatoolkit}
          export LD_LIBRARY_PATH=${pkgs.linuxPackages.nvidia_x11}/lib:${pkgs.ncurses5}/lib:$LD_LIBRARY_PATH
          export EXTRA_LDFLAGS="-L/lib -L${pkgs.linuxPackages.nvidia_x11}/lib"
          export EXTRA_CCFLAGS="-I/usr/include"
        '';        
      };
    }
  );
}
