#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	int rank, N, x,arr[3][3],sub_arr[3],ans;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		fprintf(stdout,"Enter element to be searched");
		scanf("%d",&x);
		fflush(stdout);
		fprintf(stdout,"Enter 9 elements");
		fflush(stdout);
		for(int i=0;i<3;i++)
		{
			for(int j=0;j<3;j++)
				scanf("%d",&arr[i][j]);
		}
	}
	MPI_Bcast(&x,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(arr,3,MPI_INT,sub_arr,3,MPI_INT,0,MPI_COMM_WORLD);
	// printf("r:%d F:%d\n",rank,sub_arr[0]);
	int count = 0;
	for(int i=0;i<3;i++)
	{
		if(sub_arr[i]==x)
			count++;
	}
	MPI_Reduce(&count,&ans,1,MPI_INT,MPI_SUM,0,MPI_COMM_WORLD);
	if(rank==0)
		fprintf(stdout,"SUM : %d",ans);
	MPI_Finalize();
}

