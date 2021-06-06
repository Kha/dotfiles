{
  inputs = {
    nix.url = github:NixOS/nix;
    nixpkgs.url = github:NixOS/nixpkgs/nixos-21.05;
    unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:rycee/home-manager/release-21.05;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = github:NixOS/nixos-hardware;
    nix-ld.url = "github:Mic92/nix-ld";
    nix-ld.inputs.nixpkgs.follows = "nixpkgs";
  };

  # based on https://github.com/davidtwco/veritas/blob/master/flake.nix
  outputs = { self, ... } @ inputs:
    with inputs.nixpkgs.lib;
    let
      forEachSystem = genAttrs [ "x86_64-linux" ];
      pkgsBySystem = forEachSystem (system:
        let unstable = import inputs.unstable { inherit system; config = import ./nixpkgs/config.nix; }; in
        import inputs.nixpkgs {
          inherit system;
          config = import ./nixpkgs/config.nix;
        }
      );

      mkNixOsConfiguration = name: { system, config }:
        nameValuePair name (nixosSystem {
          inherit system;
          modules = [
            ({ name, ... }: {
              # Set the hostname to the name of the configuration being applied (since the
              # configuration being applied is determined by the hostname).
              networking.hostName = name;
            })
            ({ inputs, ... }: {
              # Use the nixpkgs from the flake.
              nixpkgs = { pkgs = pkgsBySystem."${system}"; };

              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            })
            #({ lib, ... }: {
            #  # Set the system configuration revision.
            #  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            #})
            ({ inputs, ... }: {
              # Re-expose self and nixpkgs as flakes.
              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = inputs.nixpkgs;
                };
              };
              nix.extraOptions = builtins.readFile ./nix/nix.conf;
              nix.package = inputs.nix.defaultPackage.${system};
            })
            (import config)
          ];
          specialArgs = { inherit name inputs; };
        });

      mkHomeManagerConfiguration = name: { system, config }:
        nameValuePair name ({ ... }: {
          imports = [
            (import config)
          ];

          # For compatibility with nix-shell, nix-build, etc.
          home.file.".nixpkgs".source = inputs.nixpkgs;
          systemd.user.sessionVariables."NIX_PATH" =
            mkForce "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

          # Re-expose self and nixpkgs as flakes.
          xdg.configFile."nix/registry.json".text = builtins.toJSON {
            version = 2;
            flakes =
              let
                toInput = input:
                  {
                    type = "path";
                    path = input.outPath;
                  } // (
                    filterAttrs
                      (n: _: n == "lastModified" || n == "rev" || n == "revCount" || n == "narHash")
                      input
                  );
              in
              [
                {
                  from = { id = "self"; type = "indirect"; };
                  to = toInput inputs.self;
                }
                {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  to = toInput inputs.nixpkgs;
                }
              ];
          };
        });

      mkHomeManagerHostConfiguration = name: { system }:
        nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
          inherit system;
          configuration = { ... }: {
            imports = [ self.homeManagerConfigurations."${name}" ];
            nixpkgs = {
              config = import ./nixpkgs/config.nix;
            };
          };
          pkgs = pkgsBySystem."${system}";
        });
    in
    {
      # Attribute set of hostnames to home-manager modules with the entire configuration for
      # that host - consumed by the home-manager NixOS module for that host (if it exists)
      # or by `mkHomeManagerHostConfiguration` for home-manager-only hosts.
      homeManagerConfigurations = mapAttrs' mkHomeManagerConfiguration {
        wandersail = { system = "x86_64-linux"; config = ./nixpkgs/wandersail.nix; };

        i44pc65 = { system = "x86_64-linux"; config = ./nixpkgs/i44pc65.nix; };
      };

      # Attribute set of hostnames to evaluated NixOS configurations. Consumed by `nixos-rebuild`
      # on those hosts.
      nixosConfigurations = mapAttrs' mkNixOsConfiguration {
        wandersail = { system = "x86_64-linux"; config = ./nixos/wandersail.nix; };
      };
  };
}
