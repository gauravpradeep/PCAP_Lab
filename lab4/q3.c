#include <mpi.h>
#include <stdio.h>

int main(int argc, char *argv[]){
	int rank, N,arr[4][4],cols[4],colsums[4];

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		if(rank == 0) {
        arr[0][0] = 1; arr[0][1] = 2; arr[0][2] = 3; arr[0][3] = 4;
        arr[1][0] = 1; arr[1][1] = 2; arr[1][2] = 3; arr[1][3] = 1;
        arr[2][0] = 1; arr[2][1] = 1; arr[2][2] = 1; arr[2][3] = 1;
        arr[3][0] = 2; arr[3][1] = 1; arr[3][2] = 2; arr[3][3] = 1;
    }
	}
	MPI_Scatter(arr,4,MPI_INT,cols,4,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scan(cols,colsums,4,MPI_INT,MPI_SUM,MPI_COMM_WORLD);
	MPI_Gather(colsums,4,MPI_INT,arr,4,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		for(int i=0;i<4;i++)
		{
			for(int j=0;j<4;j++)
				printf("%d ",arr[i][j]);
			printf("\n");
		}
	}
	MPI_Finalize();
}
