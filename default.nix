with (import <nixpkgs> {}).pkgs;
let 
  basePythonPackages = python27Packages;
  pythonPackagesWithLocals = basePythonPackages.override (a: {
    self = pythonPackagesWithLocals;
    python = pyEnv.python;
  }) // (scopedImport {
    self = pythonPackagesWithLocals;
    super = basePythonPackages;
    inherit pkgs;
    inherit (pkgs) fetchurl fetchgit;
  } ./python-packages.nix);
  pyEnv = python27.buildEnv.override {
    extraLibs = with pythonPackagesWithLocals; [
    # extraLibs = with python27Packages; [
      numpy setuptools sphinx six dateutil docutils argparse pyyaml nose
      rosdep rosinstall-generator wstool rosinstall catkin-tools catkin-pkg
      bloom empy
      matplotlib pillow pydot paramiko 
      coverage netifaces mock psutil
      # pyqt4 pyside
      # pyopengl 
      # cairocffi
      (callPackage ./sip.nix {inherit (basePythonPackages) buildPythonPackage;})
      (pygraphviz.override { doCheck = false; })
    ];
  };
in
stdenv.mkDerivation {
  name = "ros";
  version = "";
  envPhase = ''
    export EIGEN_ROOT_DIR=${eigen}
    export EIGEN3_INCLUDE_DIR=${eigen}/include/eigen3
  '';
  NIX_CFLAGS_COMPILE = "-isystem ${python}/include/python"+python.majorVersion;
  buildInputs = [ cmake libyaml lz4 assimp boost tinyxml graphviz
                  opencv3 eigen tbb pyEnv sbcl
                  # tango-icon-theme
                  # qt4
                  (callPackage ./console-bridge.nix {})
                  (callPackage ./urdfdom-headers.nix {})
                  (callPackage ./poco.nix {})
                  (callPackage ./collada-dom.nix {})
                  qhull gtest cppunit libyamlcpp log4cxx curl ];
}
