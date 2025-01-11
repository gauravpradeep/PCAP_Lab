#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
	int rank,size,n;
	MPI_Status status;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	MPI_Comm_size(MPI_COMM_WORLD,&size);
	int arr[size];
	if(rank==0){
		printf("Enter % d elements into the array",size);
		for(int i=0;i<size;i++){
			scanf("%d",&arr[i]);
		}
		for(int i=1;i<size;i++)
		{
			MPI_Send(&arr[i],1,MPI_INT,i,i,MPI_COMM_WORLD);
		}
	}
	else{
		MPI_Recv(&n,1,MPI_INT,0,rank,MPI_COMM_WORLD,&status);
		if(rank%2==0)
			printf("Rank : %d received : %d square : %d \n",rank,n,n*n);
		else
			printf("Rank : %d received : %d cube : %d \n",rank,n,n*n*n);			
	}

}