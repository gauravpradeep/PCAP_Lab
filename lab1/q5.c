#include "mpi.h"
#include <stdio.h>
int main(int argc, char *argv[])
{
	int rank;
	MPI_Init(&argc,&argv);
	MPI_Comm_rank(MPI_COMM_WORLD,&rank);
	if(rank%2==0)
		printf("Rank : %d Factorial : %d \n",rank,fact(rank));
	else
		printf("Rank : %d Fibonacci : %d \n",rank,fib(rank));
	MPI_Finalize();
	return 0;
}

int fib(int n){
	int first=0;
	int second=1;
	if(n==1)
		return first;
	if(n==2)
		return second;
	int curr=0;
	for(int i=2;i<n;i++)
	{
		curr=first+second;
		first=second;
		second=curr;
	}
	return curr;
}

int fact(int n){
	int f=1;
	for(int i=1;i<=n;i++)
		f*=i;
	return f;
}