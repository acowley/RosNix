{ stdenv, fetchurl, boost }:
stdenv.mkDerivation {
  name = "metslib";
  version = "0.5.3";
  src = fetchurl {
    url = "http://www.coin-or.org/download/source/metslib/metslib-0.5.3.tgz";
    sha256 = "0gacl3npgslkb82pwp2z6vzri3j6s0wynl2cl5kbjybwpsijl51k";
  };

  # METSlib is written against a C++ <random> standard library API
  # that matches boost rather than libc++ (as of April 2016).
  preConfigure = ''
    sed -i 's,#  include <random>,#  include <boost/random.hpp>,' ./metslib/mets.hh
    sed -i -e 's/std::uniform_int</boost::uniform_int</g' \
           -e 's/std::minstd_rand0/boost::minstd_rand0/g' \
           -e 's/std::variate_generator</boost::variate_generator</g' \
           ./metslib/model.hh
    sed -i -e 's/std::variate_generator</boost::variate_generator</g' \
           -e 's/std::mt19937/boost::mt19937/g' \
           -e 's/std::uniform_real</boost::uniform_real</g' \
           ./metslib/simulated-annealing.hh
  '';
  buildInputs = [ boost ];

  meta = {
    description = "A metaheuristic modeling framework and optimization toolkit";
    homepage = https://projects.coin-or.org/metslib;
    license = stdenv.lib.licenses.gpl3;
    platforms = with stdenv.lib.platforms; darwin;
  };
}
