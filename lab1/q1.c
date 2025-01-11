#include <mpi.h>
#include <math.h>
#include <stdio.h>
int main(int argc, char *argv[]){
	int x,rank;
	x=2;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	printf(" Process rank : %d   Answer : %f \n",rank,pow(x,rank));
	MPI_Finalize();
	return 0;
}