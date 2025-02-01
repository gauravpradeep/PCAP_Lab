#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	int rank, N,fact=1,factsum;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	// for(int i=1;i<=rank+1;i++)
	// 	fact*=i;
	int p=rank+1;
	MPI_Scan(&p,&fact,1,MPI_INT,MPI_PROD,MPI_COMM_WORLD);
	// MPI_Scan(&fact,&factsum,1,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
	MPI_Reduce(&fact,&factsum,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	fprintf(stdout,"rank :%d factorial : %d \n",p,fact);
	if(rank==0)
		fprintf(stdout,"Sum of factorials : %d",factsum);
	
	MPI_Finalize();
	}

