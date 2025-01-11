#include "mpi.h"
#include <stdio.h>
int main(int argc, char *argv[])
{
	int rank;
	int a=3,b=2;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(rank==0)
		printf("Rank %d Sum : %d \n",rank,a+b);
	else if(rank==1)
		printf("Rank %d Difference : %d \n",rank,a-b);
	else if(rank==2)
		printf("Rank %d Product : %d \n",rank,a*b);
	else
		printf("Rank %d Quotient : %d \n",rank,a/b);
	MPI_Finalize();
	return 0;
}