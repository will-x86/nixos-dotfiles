{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      SF-Pro = pkgs.callPackage ./SF-Pro {inherit (pkgs) stdenv;};
      SF-Pro-mono = pkgs.callPackage ./SF-Pro-mono {};
    };
  };
}
