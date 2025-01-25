#include <mpi.h>
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[]){
	int rank, N,chunk,temp_vcount=0,vcounts[10],ans=0;
	char s[10], chunk_s[10];	

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &N);

	if(rank==0){
		fprintf(stdout,"Enter string");
		fflush(stdout);
		scanf("%s",s);
		chunk=strlen(s)/N;
	}
	MPI_Bcast(&chunk,1,MPI_INT,0,MPI_COMM_WORLD);
	MPI_Scatter(s,chunk,MPI_CHAR,chunk_s,chunk,MPI_CHAR,0,MPI_COMM_WORLD);		
	for(int i=0;i<chunk;i++)
	{
		if(chunk_s[i]=='a'||chunk_s[i]=='e'||chunk_s[i]=='i'||chunk_s[i]=='o'||chunk_s[i]=='u')
			continue;
		else
			temp_vcount+=1;
	}
	MPI_Gather(&temp_vcount,1,MPI_INT,vcounts,1,MPI_INT,0,MPI_COMM_WORLD);
	if(rank==0)
	{
		for(int i=0;i<N;i++)
		ans+=vcounts[i];
		fprintf(stdout,"No of non-vowels: %d",ans);
		fflush(stdout);
	}


	MPI_Finalize();
}