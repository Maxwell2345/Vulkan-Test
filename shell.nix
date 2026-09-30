{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    # Wayland Dependencies
    kdePackages.wayland
    kdePackages.wayland-protocols
    libxkbcommon
    libdecor
    libdrm


    # X11 dependencies
    libx11
    libxext
    libxcursor
    libxrandr
    libxi
    libxfixes
    libxcb
    libxscrnsaver
    libxtst

    # Other SDL3 Dependencies
    sdl3
    alsa-lib
    ibus
    ibus-with-plugins
    dbus
    jack2
    pipewire
    libpulseaudio
    sndio
    fribidi
    libthai
    libdatrie
    libdrm
    libunwind
    libusb1
    libgbm

    # SDL3_image Dependencies
    libavif
    libpng
    libtiff
    libwebp
    
    # Required for compilation
    pkg-config
    cmake

    # Other Libraries
    fmt
    
    # Optional but recommended
    libGL
  ];

  shellHook = ''
    echo "Welcome to MAGE Dev Enviroment!"
    chmod +x setup.sh
    ./setup.sh
  '';
}
