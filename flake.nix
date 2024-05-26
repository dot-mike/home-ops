{
  description = "HomeOps";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, flake-utils, nixpkgs-unstable }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        pkgsUnstable = import nixpkgs-unstable {
          inherit system;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          packages = [
            ansible
            pkgsUnstable.ansible-lint
            pkgsUnstable.bws
            bmake
            diffutils
            docker
            docker-compose_1 # TODO upgrade to version 2
            dyff
            git
            direnv
            envsubst
            go
            gotestsum
            iproute2
            jq
            k9s
            kanidm
            kube3d
            kubectl
            kubernetes-helm
            kustomize
            libisoburn
            neovim
            openssh
            p7zip
            rage
            shellcheck
            sops
            opentofu
            yamllint
            yq
            xorriso

            (python3.withPackages (p: with p; [
              docker
              docker-compose
              jinja2
              kubernetes
              mkdocs-material
              netaddr
              pexpect
              rich
              dnspython
              proxmoxer
              jmespath
              pip
            ]))
          ];

          shellHook = ''
            export HISTFILE=($PWD)/.history
            export LANG=C.UTF-8
            eval "$(direnv hook bash)"
            find . -name .envrc -exec direnv allow {} \;
          '';
        };
      }
    );
}
