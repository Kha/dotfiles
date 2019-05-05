{ pkgs }:

{
  packageOverrides = pkgs: {
    iosevka-ss09 = pkgs.iosevka.override {
      set = "type";
      design = ["ss09"];
    };
  };
  allowUnfree = true;
}
