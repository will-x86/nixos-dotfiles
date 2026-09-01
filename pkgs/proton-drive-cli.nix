{
  lib,
  buildFHSEnv,
  fetchurl,
  runCommand,
  writeShellScript,
  libsecret,
  glib,
  dbus,
}:

let
  version = "0.8.0";

  proton-drive-binary = fetchurl {
    url = "https://proton.me/download/drive/cli/${version}/linux-x64/proton-drive";
    sha256 = "0dbpaz77srvpgjkg6a9kb59prbcrrlpg1rhpvf82g2cwf5qxfhwl";
  };

  bin = runCommand "proton-drive-bin" { } ''
    install -Dm755 ${proton-drive-binary} $out/bin/proton-drive
  '';

  runScript = writeShellScript "proton-drive-run" ''
    exec ${bin}/bin/proton-drive "$@"
  '';
in
buildFHSEnv {
  inherit version;
  name = "proton-drive-cli";
  targetPkgs =
    pkgs: with pkgs; [
      libsecret
      glib
      dbus
    ];
  inherit runScript;

  meta = with lib; {
    description = "Proton Drive CLI — manage your Proton Drive from the terminal";
    homepage = "https://proton.me/blog/proton-drive-cli";
    license = licenses.unfree;
    mainProgram = "proton-drive";
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
