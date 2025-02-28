#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>

__global__ void oddEven(int *A, int n)
{
	int tid=blockIdx.x*blockDim.x +threadIdx.x;
	if(tid%2==1 && tid+1<n)
	{
		if(A[tid]>A[tid+1])
		{
			int temp=A[tid];
			A[tid]=A[tid+1];
			A[tid+1]=temp;
		}
	}
}

__global__ void evenOdd(int *A, int n)
{
	int tid=blockIdx.x*blockDim.x +threadIdx.x;
	if(tid%2==0 && tid+1<n)
	{
		if(A[tid]>A[tid+1])
		{
			int temp=A[tid];
			A[tid]=A[tid+1];
			A[tid+1]=temp;
		}
	}
}

int main(){
 	int N;
 	
 	printf("Enter size of array");
 	scanf("%d",&N);
 	int *h_A = (int*)malloc(N*sizeof(int));

 	int *d_A;

 	cudaMalloc((void**)&d_A,N*sizeof(int));
 	printf("Enter elements of A");
 	for(int i=0;i<N;i++)
 		scanf("%d",h_A+i);

 	cudaMemcpy(d_A,h_A,N*sizeof(int),cudaMemcpyHostToDevice);
 	for(int i=0;i<N/2;i++)
 	{
 		oddEven<<<1,N>>>(d_A,N);
 		evenOdd<<<1,N>>>(d_A,N);
 	}
 	cudaMemcpy(h_A,d_A,N*sizeof(int),cudaMemcpyDeviceToHost);
 	printf("Sorted array \n");
 	for(int i=0;i<N;i++)
 		printf("%d ",*(h_A+i));
 	printf("\n");

 	cudaFree(d_A);
}