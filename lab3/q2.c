#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	int rank, N, A[100], avg[10], M, p_avg=0,final_avg[10];
	float ans=0;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		fprintf(stdout,"Enter value of M");
		fflush(stdout);
		scanf("%d",&M);
		fprintf(stdout,"Enter %d elements",M*N);
		fflush(stdout);
		for(int i=0;i<M*N;i++)
			scanf("%d",&A[i]);
	}
	MPI_Bcast(&M,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(A,M,MPI_INT,avg,M,MPI_INT,0,MPI_COMM_WORLD);
	for(int i=0;i<M;i++)
		p_avg+=avg[i];
	p_avg/=M;
	MPI_Gather(&p_avg,1,MPI_INT,final_avg,1,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		for(int i=0;i<N;i++)
		{
			ans+=final_avg[i];
		}
		ans/=N;
		fprintf(stdout,"Average = %f",ans);
		fflush(stdout);
	}
	
	MPI_Finalize();
}