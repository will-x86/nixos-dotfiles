{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "proton-drive-cli";
  version = "0.8.0";

  src = fetchurl {
    url = "https://proton.me/download/drive/cli/${version}/linux-x64/proton-drive";
    sha256 = "0dbpaz77srvpgjkg6a9kb59prbcrrlpg1rhpvf82g2cwf5qxfhwl";
  };

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/proton-drive
    chmod +x $out/bin/proton-drive
    runHook postInstall
  '';

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