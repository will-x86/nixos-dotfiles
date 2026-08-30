{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  autoPatchelfHook,
  gtk3,
  libxkbcommon,
  wayland,
  xorg,
  xdotool,
  libayatana-appindicator,
  libGL,
  vulkan-loader,
  libsecret,
  glib,
}:

let
  libX11 = xorg.libX11;
  libxcbPkg = xorg.libxcb;
in
rustPlatform.buildRustPackage {
  pname = "neutronsync";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "WilhelmZA";
    repo = "protondrive_linux_sync";
    rev = "refs/heads/rust";
    hash = "sha256-4ZzugJAj7kE6N/pXuELvnIJrtpVQuR6HqxX7bXi63gE=";
  };

  buildFeatures = [ "gui" ];

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    libxkbcommon
    wayland
    libX11
    libxcbPkg
    libGL
    xdotool
    vulkan-loader
    libayatana-appindicator
    libsecret
    glib
  ];
  cargoHash = "sha256-Ab+xzYWsaXHTGiWttggQ5D3qcG9xLZzLn1d8NJj11Ws=";
  # autoPatchelfHook covers DT_NEEDED libs (gtk3, glib, xdo, etc.).
  # libsecret and libvulkan are dlopen'd by Rust at runtime; add them to
  # LD_LIBRARY_PATH via the wrapper since they have no DT_NEEDED entries.
  postFixup = ''
    for bin in neutronsync neutronsync-gui; do
      wrapProgram "$out/bin/$bin" \
        --prefix PATH : ${lib.makeBinPath [glib xdotool]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [vulkan-loader libsecret]}
    done
  '';

  meta = with lib; {
    description = "Bidirectional Proton Drive folder sync built on the official proton-drive CLI";
    homepage = "https://github.com/WilhelmZA/protondrive_linux_sync";
    license = licenses.mit;
    mainProgram = "neutronsync";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}