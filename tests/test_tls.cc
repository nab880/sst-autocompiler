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
