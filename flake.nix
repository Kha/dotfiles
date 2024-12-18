{
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-24.11;
    unstable.url = github:NixOS/nixpkgs/nixos-unstable;
    home-manager.url = github:rycee/home-manager/release-24.11;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = github:NixOS/nixos-hardware;
    nix-doom-emacs-unstraightened.url = github:marienz/nix-doom-emacs-unstraightened;
    nix-doom-emacs-unstraightened.inputs.nixpkgs.follows = "";
    zsh-auto-notify.url = github:MichaelAquilina/zsh-auto-notify;
    zsh-auto-notify.flake = false;
    niri.url = "github:sodiboo/niri-flake";
    #niri.inputs.niri-src.follows = "niri-src";
    #niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  # based on https://github.com/davidtwco/veritas/blob/master/flake.nix
  outputs = { self, ... } @ inputs:
    with inputs.nixpkgs.lib;
    let
      forEachSystem = genAttrs [ "x86_64-linux" "aarch64-darwin" ];
      pkgsBySystem = forEachSystem (system:
        import inputs.nixpkgs {
          inherit system;
          config = import ./nixpkgs/config.nix;
        } // {
          unstable = import inputs.unstable { inherit system; config = import ./nixpkgs/config.nix; };
        });

      mkNixOsConfiguration = name: { system, config }:
        nameValuePair name (nixosSystem {
          inherit system;
          modules = [
            inputs.niri.nixosModules.niri
            ({ name, ... }: {
              # Set the hostname to the name of the configuration being applied (since the
              # configuration being applied is determined by the hostname).
              networking.hostName = name;
            })
            ({ inputs, ... }: {
              # Use the nixpkgs from the flake.
              nixpkgs = {
                pkgs = pkgsBySystem."${system}";
                overlays = [ inputs.niri.overlays.niri ];
              };

              # For compatibility with nix-shell, nix-build, etc.
              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            })
            #({ lib, ... }: {
            #  # Set the system configuration revision.
            #  system.configurationRevision = lib.mkIf (self ? rev) self.rev;
            #})
            ({ inputs, unstable, ... }: {
              # Re-expose self and nixpkgs as flakes.
              nix.registry = {
                # induces unnecessary drv changes
                #self.flake = inputs.self;
                nixpkgs = {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  flake = inputs.nixpkgs;
                };
              };
              nix.extraOptions = builtins.readFile ./nix/nix.conf;

              home-manager.extraSpecialArgs = { inherit inputs; inherit (pkgsBySystem."${system}") unstable; };
            })
            (import config)
          ];
          specialArgs = { inherit name inputs; inherit (pkgsBySystem."${system}") unstable; };
        });

      mkHomeManagerConfiguration = name: { system, config }:
        nameValuePair name ({ ... }: {
          imports = [
            (import config)
            inputs.nix-doom-emacs-unstraightened.hmModule
          ];

          # For compatibility with nix-shell, nix-build, etc.
          home.file.".nixpkgs".source = inputs.nixpkgs;
          home.file.".nixpkgs-unstable".source = inputs.unstable;
          systemd.user.sessionVariables."NIX_PATH" =
            mkForce "nixpkgs=$HOME/.nixpkgs\:unstable=$HOME/.nixpkgs-unstable:$NIX_PATH";

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
                # induces unnecessary drv changes
                #{
                #  from = { id = "self"; type = "indirect"; };
                #  to = toInput inputs.self;
                #}
                {
                  from = { id = "nixpkgs"; type = "indirect"; };
                  to = toInput inputs.nixpkgs;
                }
                {
                  from = { id = "unstable"; type = "indirect"; };
                  to = toInput inputs.unstable;
                }
              ];
          };
        });

      mkHomeManagerHomeConfiguration = name: { system }:
        nameValuePair name (inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsBySystem."${system}";
          modules = [
            self.homeManagerConfigurations."${name}"
            {
              home = {
                username = "sebastian";
                homeDirectory = if system == "aarch64-darwin" then "/Users/sebastian" else "/home/sebastian";
              };
            }
          ];
          extraSpecialArgs = { inherit name inputs; inherit (pkgsBySystem."${system}") unstable; };
        });
    in
    {
      # Attribute set of hostnames to home-manager modules with the entire configuration for
      # that host - consumed by the home-manager NixOS module for that host (if it exists)
      # or by `mkHomeManagerHomeConfiguration` for home-manager-only hosts.
      homeManagerConfigurations = mapAttrs' mkHomeManagerConfiguration {
        wandersail = { system = "x86_64-linux"; config = ./nixpkgs/wandersail.nix; };

        theseus = { system = "x86_64-linux"; config = ./nixpkgs/wandersail.nix; };

        soothebox = { system = "x86_64-linux"; config = ./nixpkgs/wandersail.nix; };

        "sebastian@chonk.lean-fro.org" = { system = "x86_64-linux"; config = ./nixpkgs/chonk.nix; };
      };

      homeConfigurations = mapAttrs' mkHomeManagerHomeConfiguration {
        "sebastian@chonk.lean-fro.org" = { system = "x86_64-linux"; };
      };

      # Attribute set of hostnames to evaluated NixOS configurations. Consumed by `nixos-rebuild`
      # on those hosts.
      nixosConfigurations = mapAttrs' mkNixOsConfiguration {
        wandersail = { system = "x86_64-linux"; config = ./nixos/wandersail.nix; };

        theseus = { system = "x86_64-linux"; config = ./nixos/theseus.nix; };

        soothebox = { system = "x86_64-linux"; config = ./nixos/soothebox.nix; };
      };
  };
}
