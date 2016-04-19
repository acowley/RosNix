{
  bloom = super.buildPythonPackage {
    name = "bloom-0.5.21";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [catkin-pkg setuptools empy dateutil pyyaml rosdep rosdistro vcstools];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/b/bloom/bloom-0.5.21.tar.gz";
      md5 = "60d2c00dc6ae09a6451a76a498ea6bb7";
    };
  };
  catkin-pkg = super.buildPythonPackage {
    name = "catkin-pkg-0.2.10";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [argparse docutils dateutil];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/catkin_pkg/catkin_pkg-0.2.10.tar.gz";
      md5 = "da93566c65dddfa9f821e18944c5ee5e";
    };
  };
  catkin-tools = super.buildPythonPackage {
    name = "catkin-tools-0.3.1";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [catkin-pkg setuptools pyyaml];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/c/catkin_tools/catkin_tools-0.3.1.tar.gz";
      md5 = "ccdfdd6b2390c0bee1bf3da62af64c64";
    };
  };
  distribute = super.buildPythonPackage {
    name = "distribute-0.7.3";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [setuptools];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/d/distribute/distribute-0.7.3.zip";
      md5 = "c6c59594a7b180af57af8a0cc0cf5b4a";
    };
  };
  empy = super.buildPythonPackage {
    name = "empy-3.3.2";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/E/EmPy/empy-3.3.2.tar.gz";
      md5 = "fbb34761cdf9acc4c65e298c9eced395";
    };
  };
  rosdep = super.buildPythonPackage {
    name = "rosdep-0.11.4";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [catkin-pkg rospkg rosdistro pyyaml nose];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rosdep/rosdep-0.11.4.tar.gz";
      md5 = "c8969f199b0590338bf20dab63bc4d50";
    };
  };
  rosdistro = super.buildPythonPackage {
    name = "rosdistro-0.4.7";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [catkin-pkg rospkg pyyaml setuptools];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rosdistro/rosdistro-0.4.7.tar.gz";
      md5 = "a699690fab755fd1b92b2ac04933e227";
    };
  };
  rosinstall = super.buildPythonPackage {
    name = "rosinstall-0.7.7";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [vcstools pyyaml rosdistro catkin-pkg wstool];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rosinstall/rosinstall-0.7.7.tar.gz";
      md5 = "50a9aa165b1f1689b70a973ff731926c";
    };
  };
  rosinstall-generator = super.buildPythonPackage {
    name = "rosinstall-generator-0.1.11";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [argparse catkin-pkg distribute rosdistro rospkg pyyaml];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rosinstall_generator/rosinstall_generator-0.1.11.tar.gz";
      md5 = "7196f4670d546b803158562276d4f0e5";
    };
  };
  rospkg = super.buildPythonPackage {
    name = "rospkg-1.0.38";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [pyyaml];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/r/rospkg/rospkg-1.0.38.tar.gz";
      md5 = "9953ac8a1e6c393ff27dcec8cb88feb5";
    };
  };
  vcstools = super.buildPythonPackage {
    name = "vcstools-0.1.38";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [pyyaml dateutil];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/v/vcstools/vcstools-0.1.38.tar.gz";
      md5 = "575ba1fc4437ec4848a20cee84269f38";
    };
  };
  wstool = super.buildPythonPackage {
    name = "wstool-0.1.12";
    buildInputs = with self; [];
    doCheck = false;
    propagatedBuildInputs = with self; [vcstools pyyaml];
    src = fetchurl {
      url = "https://pypi.python.org/packages/source/w/wstool/wstool-0.1.12.tar.gz";
      md5 = "d6f075feaa65b88544ec6c02c2763e37";
    };
  };
}
