#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	int rank, N, A[10], f[10],x,fact=1;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		fprintf(stdout,"Enter %d elements",N);
		fflush(stdout);
		for(int i=0;i<N;i++)
			scanf("%d",&A[i]);
	}
	MPI_Scatter(A,1,MPI_INT,&x,1,MPI_INT,0,MPI_COMM_WORLD);
	fprintf(stdout,"Received %d in process %d \n",x,rank);
	fflush(stdout);
	for(int i=1;i<=x;i++)
		fact*=i;
	MPI_Gather(&fact,1,MPI_INT,f,1,MPI_INT,0,MPI_COMM_WORLD);
	fprintf(stdout,"\n");
	if(rank==0)
	{
		for(int i=0;i<N;i++)
		{
			fprintf(stdout,"%d ",f[i]);
			fflush(stdout);
		}
	}
	MPI_Finalize();
}