#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
	int rank,size,n;
	MPI_Status status;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	if(rank==0){
		printf("Enter number \n");
		scanf("%d",&n);
		n=n+1;
		MPI_Send(&n,1,MPI_INT,rank+1,rank+1,MPI_COMM_WORLD);
		MPI_Recv(&n,1,MPI_INT,size-1,rank,MPI_COMM_WORLD,&status);
		printf("Rank : %d received : %d \n",rank,n);
	}
	// else if(rank==size-1){
	// 	MPI_Recv(&n,1,MPI_INT,rank-1,rank,MPI_COMM_WORLD,&status);
	// 	printf("Rank : %d received : %d \n",rank,n);
	// 	n=n+1;
	// 	MPI_Send(&n,1,MPI_INT,0,0,MPI_COMM_WORLD);
	// }

	else{
		MPI_Recv(&n,1,MPI_INT,rank-1,rank,MPI_COMM_WORLD,&status);
		printf("Rank : %d received : %d \n",rank,n);
		n=n+1;
		if(rank==size-1)
			MPI_Send(&n,1,MPI_INT,0,0,MPI_COMM_WORLD);
		else
			MPI_Send(&n,1,MPI_INT,rank+1,rank+1,MPI_COMM_WORLD);	
	}

}