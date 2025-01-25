#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
	int rank, N,chunk;
	char s1[10], s2[10], chunk_s1[10], chunk_s2[10], partial_res[100], ans[100];	

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		fprintf(stdout,"Enter 2 strings");
		fflush(stdout);
		scanf("%s",s1);
		fflush(stdout);
		scanf("%s",s2);
		chunk=strlen(s1)/N;
	}
	MPI_Bcast(&chunk,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(s1,chunk,MPI_CHAR,chunk_s1,chunk,MPI_CHAR,0,MPI_COMM_WORLD);
	MPI_Scatter(s2,chunk,MPI_CHAR,chunk_s2,chunk,MPI_CHAR,0,MPI_COMM_WORLD);		
	int x=0;
	for(int i=0;i<chunk;i++)
	{
		partial_res[x]=chunk_s1[i];
		partial_res[x+1]=chunk_s2[i];
		x=x+2;
	}
	MPI_Gather(partial_res,2*chunk,MPI_CHAR,ans,2*chunk,MPI_CHAR,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		ans[2*strlen(s1)]='\0';
		fprintf(stdout,"%s",ans);
	}
	MPI_Finalize();
}