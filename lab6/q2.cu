#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>

__global__ void selsort(int *A, int *O, int n)
{
	int tid=blockIdx.x*blockDim.x + threadIdx.x;
	int pos=0;
	int ele=A[tid];
	for(int i=0;i<n;i++)
	{
		if(A[i]<ele || (A[i]==ele && i<tid))
			pos++;
	}
	O[pos]=ele;
}

int main(){
 	int N;
 	
 	printf("Enter size of array");
 	scanf("%d",&N);
 	int *h_A = (int*)malloc(N*sizeof(int));
 	int *h_O = (int*)malloc(N*sizeof(int));

 	int *d_A, *d_O;

 	cudaMalloc((void**)&d_A,N*sizeof(int));
 	cudaMalloc((void**)&d_O,N*sizeof(int));

 	printf("Enter elements of A");
 	for(int i=0;i<N;i++)
 		scanf("%d",h_A+i);

 	cudaMemcpy(d_A,h_A,N*sizeof(int),cudaMemcpyHostToDevice);
 	selsort<<<1,N>>>(d_A,d_O,N);
 	cudaMemcpy(h_O,d_O,N*sizeof(int),cudaMemcpyDeviceToHost);
 	printf("Sorted array \n");
 	for(int i=0;i<N;i++)
 		printf("%d ",*(h_O+i));
 	printf("\n");

 	cudaFree(d_A);
}