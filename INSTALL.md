# Installing SST-autocompiler

Download [llvm-project-18.1.8.src.tar.xz](https://github.com/llvm/llvm-project/releases/download/llvmorg-18.1.8/llvm-project-18.1.8.src.tar.xz)

## Load modules (optional)
```bash
module load sems-clang
module load sems-ninja
```

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
# Required on Mac only!
export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

# ensure clang/clang++ work and point to the location installed above
# which clang[++]
# clang++ foo.cc

# use llvm lld; sometimes regular ld fails
export LDFLAGS="-fuse-ld=lld"

cd

# Install sst-macro
git clone https://github.com/jmlapre/sst-macro.git
cd sst-macro
git switch update_to_llvm18
./autogen.sh
mkdir build && cd build

../configure CXX=clang++ CC=clang \
--with-std=17 \
--prefix=$HOME/sst-macro/install \
--with-clang=$HOME/llvm-project-18.1.8.src/install

make V=1 && make install
export PATH=$HOME/sst-macro/install/bin:$PATH

cd

# Install sst-autocompiler
git clone https://github.com/jmlapre/sst-autocompiler.git
cd sst-autocompiler
git switch update_to_llvm_18
./autogen.sh
mkdir build && cd build

../configure CXX=clang++ CC=clang \
--with-std=17 \
--prefix=$HOME/sst-autocompiler/install \
--with-sst-macro=$HOME/sst-macro/install \
--with-clang=$HOME/llvm-project-18.1.8.src/install

make V=1 && make install

export PATH=$HOME/sst-autocompiler/install/bin:$PATH

# Test that sst-autocompiler works
cd ../tests
./build.sh
```

The above command should generate (roughly) the following output:
```bash
./build.sh 
+ cat test_tls.cc
#include <sstmac_mpi.h>
#include <iostream>

#define sstmac_app_name test_tls
#include <skeleton.h>

int my_global=0;

int main(int argc, char* argv[]) {

  MPI_Init(&argc,&argv);

  int my_rank;
  MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);

  ++my_global;

  MPI_Barrier(MPI_COMM_WORLD);

  std::cerr << "my_global: " << my_global << std::endl;

  MPI_Finalize();

  return 0;
}
+ hg++ -D_LIBCPP_REMOVE_TRANSITIVE_INCLUDES -I/home/jmlapre/sst-macro/install/include/sumi-mpi -c test_tls.cc
+ hg++ test_tls.o -o mylib.so
clang++: warning: argument unused during compilation: '-undefined dynamic_lookup' [-Wunused-command-line-argument]
+ cat params.ini
accuracy_parameter = 0

switch {
 name = pisces
 arbitrator = cut_through
 buffer_size = 64MB
 bandwidth = 12.46936341GB/s
 mtu = 4096
 link {
  latency = 100ns
  credit_latency = 10ns
  bandwidth = 12.46936341GB/s
 }
 xbar {
  bandwidth = 1000GB/s
  send_latency = 10ns
  credit_latency = 100ns
 }
 injection {
  credits = 16384
 }
 ejection {
  bandwidth =   12.46936341GB/s
  send_latency = 100ns
  credit_latency = 10ns
 }
 logp {
  bandwidth = 12.46936341GB/s
  hop_latency = 100ns
  out_in_latency = 100ns
 }
 router {
  name = star_minimal
 }
}

topology {
 name = star
 concentration = 32
}

node {
 app1 {
   launch_cmd = aprun -n 2 -N 1
   exe=./mylib.so
   mpi {
     max_vshort_msg_size = 4096 B
     max_eager_msg_size = 32768 B
     post_header_delay =     0.35906660 us
     post_rdma_delay =     0.88178612 us
     rdma_pin_latency =   5.42639881 us
     rdma_page_delay =  50.50000000 ns
     comm_sync_stats = true
   }
 }
 memory {
  name = pisces
  total_bandwidth = 15 GB/s
  latency = 15ns
  mtu = 512
  max_channel_bandwidth =    11.19735732 GB/s
 }
 model = simple
 frequency = 2.1 gHz
 ncores = 24
 nsockets = 4
 nic {
  name = pisces
  injection {
   redundant = 8
   bandwidth =   11.19735732 GB/s
   latency =   0.6us
   arbitrator = cut_through
   credits = 16384
   mtu = 4096
  }
 }
 proc {
   frequency = 2.1ghz
 }
}

congestion_model = pisces
+ sstmac -f params.ini
sstmac
  --debug="" \
  --configfile="params.ini" \

my_global: 1
my_global: 1
Estimated total runtime of           0.00000248 seconds
SSTMAC   repo:   4b2a69ac49794f39e22e5817d489410f391d881c
SST/macro ran for       0.0020 seconds
```
