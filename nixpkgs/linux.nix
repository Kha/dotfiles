{ config, lib, pkgs, unstable, inputs, ... }:

{
  home.packages = with pkgs; [
    # dev
    rr perf
  ];
}
