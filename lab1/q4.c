#include "mpi.h"
#include <stdio.h>
int main(int argc, char *argv[])
{
	int rank;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	char s[]="HELLO";
	int toggled;
	if(s[rank]>=97)
		toggled=s[rank]-32;
	else
		toggled=s[rank]+32;
	printf("Rank : %d Letter : %c \n",rank,toggled);
	MPI_Finalize();
	return 0;
}