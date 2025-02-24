# Installing SST-autocompiler

Download [llvm-project-18.1.8.src.tar.xz](https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/llvm-project-18.1.8.src.tar.xz)

```bash
curl -LO https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/llvm-project-18.1.8.src.tar.xz
tar -xf llvm-project-18.1.8.src.tar.xz
cd llvm-project-18.1.8.src
mkdir build && cd build

ccmake -S ../llvm \
-DLLVM_ENABLE_PROJECTS="clang;compiler-rt;lld" \
-DLLVM_ENABLE_RUNTIMES=all \
-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
-DCMAKE_BUILD_TYPE=RelWithDebInfo \
-DCMAKE_INSTALL_PREFIX=$HOME/llvm-project-18.1.8.src/install \
-DLLVM_INCLUDE_TESTS=OFF \
-DLLVM_ENABLE_ZSTD=OFF \
-DLLVM_USE_LINKER=lld \
-DLLVM_TARGETS_TO_BUILD=host \
-G Ninja

ninja -j 6 && ninja install

export PATH=$HOME/llvm-project-18.1.8.src/install/bin:$PATH
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# ensure clang/clang++ work and point to the location installed above
# which clang[++]
# clang++ foo.cc

cd

git clone https://github.com/nab880/sst-autocompiler.git
cd sst-autocompiler
mkdir build && cd build

../configure CXX=clang++ CC=clang \
--with-std=17 \
--prefix=$HOME/sst-autocompiler/install \
--with-sst-macro=$HOME/sst-macro/install \
--with-clang=$HOME/llvm-project-18.1.8.src/install

make V=1 && make install

export PATH=$HOME/sst-autocompiler/install/bin:$PATH
```
