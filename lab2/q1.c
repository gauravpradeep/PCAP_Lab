#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
	char s[100];
	int len,rank;
	MPI_Status status;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(rank==0){
		printf("Enter word \n");
		scanf("%s",s);
		len=strlen(s);
		MPI_Ssend(&len,1,MPI_INT,1,1,MPI_COMM_WORLD);
		MPI_Ssend(s,len,MPI_CHAR,1,2,MPI_COMM_WORLD);
		MPI_Recv(s,len,MPI_CHAR,1,3,MPI_COMM_WORLD,&status);
		printf("Process %d received toggled string : %s \n",rank,s);
	}
	else{
		MPI_Recv(&len,1,MPI_INT,0,1,MPI_COMM_WORLD,&status);
		MPI_Recv(s,len,MPI_CHAR,0,2,MPI_COMM_WORLD,&status);
		for(int i=0;i<len;i++){
			if(s[i]>=97)
				s[i]=s[i]-32;
			else
				s[i]=s[i]+32;	
		}
		MPI_Ssend(s,len,MPI_CHAR,0,3,MPI_COMM_WORLD);
	}
}