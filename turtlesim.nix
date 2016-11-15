{ catkin, cmake, gtest, pkgconfig, pyEnv
, stdenv, fetchurl, geometry_msgs, message_generation, message_runtime
, rosconsole, roscpp, roscpp_serialization, roslib, rostime, std_msgs, std_srvs
, mkRosCmakePackage
, qt5
# , qtbase5-dev, qt5-qmake, libqt5-core, libqt5-gui
}:
mkRosCmakePackage rec {
  name = "turtlesim";
  version = "0.7.1";
  src = fetchurl {
    url = "https://github.com/ros/ros_tutorials/archive/${version}.tar.gz";
    sha256 = "18iifdsjwbs5csg60rinkdlmbmhpbxsk9d7f7zp5v29bwcmdrxjm";
  };
  unpackPhase = ''
    tar --strip-components=1 -xf ${src} ros_tutorials-0.7.1/turtlesim
    export sourceRoot="$PWD"/turtlesim
  '';
  configurePhase = ''
    cmakeConfigurePhase
  '';
  preConfigure = ''
    export dontUseQmakeConfigure="true"
  '';
  cmakeFlags = ["-DCMAKE_OSX_DEPLOYMENT_TARGET=" "-DCMAKE_OSX_SYSROOT="];
  propagatedBuildInputs = with qt5; [
    cmake
    pkgconfig
    gtest
    pyEnv
    catkin
    message_generation
    message_runtime
    std_msgs
    geometry_msgs
    rosconsole
    roscpp
    std_srvs
    qtbase
    makeQtWrapper
    qmakeHook
  ];
  postInstall = ''
    mkdir -p $out/bin
    makeQtWrapper $out/lib/turtlesim/turtlesim_node $out/bin/turtlesim_node
  '';
}
