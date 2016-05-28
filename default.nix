with (import <nixpkgs> {}).pkgs;
let 
  basePythonPackages = python27Packages;
  sip = callPackage ./sip.nix {
      inherit (basePythonPackages) buildPythonPackage;
  };
  pythonPackagesWithLocals = basePythonPackages.override (oldAttrs: {
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
      numpy setuptools sphinx six dateutil docutils argparse pyyaml nose
      rosdep rosinstall-generator wstool rosinstall catkin-tools catkin-pkg
      bloom empy
      matplotlib pillow pydot paramiko 
      coverage netifaces mock psutil
      pyqt4 pyside
      # pyopengl 
      # cairocffi
      sip
      (pygraphviz.override { doCheck = false; })
      # (callPackage ./sip.nix {inherit (basePythonPackages) buildPythonPackage;})
      # (pygraphviz.override { doCheck = false; })
    ];
  };
  localPackages = rec {
    console-bridge = callPackage ./console-bridge.nix {};
    poco = callPackage ./poco.nix {};
    collada-dom = callPackage ./collada-dom.nix {};
    urdfdom-headers = callPackage ./urdfdom-headers.nix {};
    urdfdom = callPackage ./urdfdom.nix { inherit urdfdom-headers console-bridge; };
  };
  rosDistributions = {
    indigo = "2014-07-22-indigo";
    jade = "2015-05-23-jade";
  };
  srcPyEnv = python27.buildEnv.override {
    extraLibs = with pythonPackagesWithLocals; [
      setuptools rosdep rosinstall-generator wstool rosinstall
      catkin-tools catkin-pkg
    ];
  };

  # Builds a rosinstall file for a particular variant of a given
  # distro and initializes a workspace for that variant.
  mkRosSrcDerivation = distro: variant:
    stdenv.mkDerivation {
      name = "ros-"+distro+"-"+variant+"-src";
      version = lib.getAttr distro rosDistributions;
      srcs = [];
      buildInputs = [ srcPyEnv cacert ];
      buildCommand = ''
        source $stdenv/setup
        mkdir -p $out
        #cd $out
        export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
        rosinstall_generator ${variant} --rosdistro ${distro} --deps --tar > $out/${distro}_${variant}.rosinstall
        # export TMPDIR=/tmp
        # wstool init $out/src $out/${distro}_${variant}.rosinstall
        # if [ -f $out/src/robot_model/collada_parser/CMakeLists.txt ]; then
        #   sed -i 's/find_package(COLLADA_DOM 2.3 COMPONENTS 1.5)/find_package(COLLADA_DOM 2.4 COMPONENTS 1.5)/' $out/src/robot_model/collada_parser/CMakeLists.txt
        # fi
      '';
    };

  mkRosVariant = distro: variant: srcDeriv:
    stdenv.mkDerivation {
      name = "ros-"+distro+"-"+variant;
      version = lib.getAttr distro rosDistributions;
      src = srcDeriv;
      shellHook = "source $out/setup.bash";
      propagatedBuildInputs = [
        pkgconfig cmake libyaml lz4 assimp boost tinyxml graphviz
        opencv3 eigen tbb pyEnv sbcl bzip2 ncurses
        pcl libogg gtk2 glib libtheora pango gdk_pixbuf atk
        # tango-icon-theme
        qt4 qhull gtest cppunit libyamlcpp log4cxx curl ]
        ++ lib.attrValues localPackages;
      NIX_CFLAGS_COMPILE="-I${gtk2}/include/gtk-2.0 -I${glib}/include/glib-2.0 -I${glib}/lib/glib-2.0/include -I${pango}/include/pango-1.0 -I${gtk2}/lib/gtk-2.0/include -I${gdk_pixbuf}/include/gdk-pixbuf-2.0 -I${atk}/include/atk-1.0";

      # These are just for linking image_view
      NIX_LDFLAGS="-lgobject-2.0 -lgtk-x11-2.0";
      buildCommand = ''
        source $stdenv/setup
        mkdir -p $out
        cp -R $srcDeriv/* .
        # Fix syntax highlighting */
        HOME=$out
        export TERM=xterm-256color
        export PYTHONHOME=${python}
        catkin config --install --install-space $out

        catkin build -DCMAKE_BUILD_TYPE=Release \
        -DPYTHON_LIBRARY=${python}/lib/libpython2.7.dylib \
        -DPYTHON_INCLUDE_DIR=${python}/include/python2.7 \
        -DPYTHON_EXECUTABLE=${python.passthru.interpreter} \
        -DEIGEN_ROOT_DIR=${eigen} \
        -DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3

        echo "Installation successful, please source the ROS workspace:"
        echo
        echo "  source $out/setup.bash"
        echo
      '';
    };

  # See http://www.ros.org/reps/rep-0131.html#variants for a list of
  # ROS variants.
  mkDistro = distro:
    let mkVariant = name: rosinstall: {
          inherit name;
          value = mkRosVariant distro name rosinstall;
        };
        mkSrcVariant = vname: {
          name = vname + "-src";
          value = mkRosSrcDerivation distro vname;
        };
        variants = [ "ros-core" "ros-base" "ros-full" "robot" "perception"
                     "simulators" "viz" "desktop" "desktop-full" ];
        rosinstalls = map mkSrcVariant variants;
        distros = lib.zipListsWith mkVariant variants rosinstalls;
    in builtins.listToAttrs (rosinstalls ++ distros);
in
{
  indigo = mkDistro "indigo";
  jade = mkDistro "jade";
}

# stdenv.mkDerivation {
#   name = "ros";
#   version = "";
#   envPhase = ''
#     export EIGEN_ROOT_DIR=${eigen}
#     export EIGEN3_INCLUDE_DIR=${eigen}/include/eigen3
#     sed -i 's/find_package(COLLADA_DOM 2.3 COMPONENTS 1.5)/find_package(COLLADA_DOM 2.4 COMPONENTS 1.5)/' ./src/robot_model/collada_parser/CMakeLists.txt
#   '';
#   NIX_CFLAGS_COMPILE = "-isystem ${python}/include/python"+python.majorVersion;
#   buildInputs = [ pkgconfig cmake libyaml lz4 assimp boost tinyxml graphviz
#                   opencv3 eigen tbb pyEnv sbcl bzip2
#                   # tango-icon-theme
#                   # qt4
#                   qhull gtest cppunit libyamlcpp log4cxx curl
#                 ] ++ lib.attrValues localPackages;
# }
