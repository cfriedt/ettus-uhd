#!/bin/sh

export PATH=/usr/lib/ccache:"${PATH}"
PREFIX=/usr/local

echo "gcc: $(which gcc)"
echo "g++: $(which g++)"

mkdir -p host/build
cd host/build
cmake \
        -Wno-dev \
        -DCMAKE_BUILD_TYPE:STRING=Debug \
        -DENABLE_C_API=OFF \
        -DENABLE_MANUAL=OFF \
        -DENABLE_MAN_PAGES=OFF \
        -DENABLE_DOXYGEN=OFF \
        -DCMAKE_INSTALL_PREFIX=${PREFIX} \
        -DENABLE_EXAMPLES=ON \
        -DENABLE_UTILS=ON \
        -DENABLE_TESTS=ON \
        -DENABLE_N320=OFF \
        -DENABLE_N300=OFF \
        -DENABLE_E320=OFF \
        -DENABLE_USRP1=OFF \
        -DENABLE_USRP2=ON \
        -DENABLE_B100=OFF \
        -DENABLE_B200=OFF \
        -DENABLE_X300=OFF \
        -DENABLE_USB=OFF \
        -DENABLE_OCTOCLOCK=OFF \
        -DENABLE_MPMD=OFF \
        -DENABLE_DPDK=OFF \
        ..

CMAKE_RET=$?
if [ $CMAKE_RET -ne 0 ]; then
        echo "cmake failed: $CMAKE_RET"
        exit $CMAKE_RET
fi

make -j$(nproc --all)

MAKE_RET=$?
if [ $MAKE_RET -ne 0 ]; then
        echo "make failed: $MAKE_RET"
        exit $MAKE_RET
fi

make -j$(nproc --all) test

MAKE_TEST_RET=$?
if [ $MAKE_TEST_RET -ne 0 ]; then
        echo "make test failed: $MAKE_TEST_RET"
        exit $MAKE_TEST_RET
fi

exit 0
