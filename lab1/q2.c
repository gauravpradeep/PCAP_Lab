#include "mpi.h"
#include <stdio.h>
int main(int argc, char *argv[])
{
	int rank;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(rank%2==0)
		printf("Rank : %d Hello \n",rank);
	else
		printf("Rank : %d World \n",rank);
	MPI_Finalize();
	return 0;
}