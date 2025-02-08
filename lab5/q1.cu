#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>
__global__ void vectorAdd(int *a, int *b, int *c){
	int tid = blockIdx.x*blockDim.x + threadIdx.x;
	*(c+tid)=*(a+tid)+*(b+tid);	
 }

 int main(){
 	int N;
 	
 	printf("Enter size of array");
 	scanf("%d",&N);
 	int *a = (int*)malloc(N*sizeof(int));
 	int *b = (int*)malloc(N*sizeof(int));
 	int *c = (int*)malloc(N*sizeof(int));

 	int *d_a, *d_b, *d_c;
 	int size=N*sizeof(int);
 	cudaMalloc((void**)&d_a,size);
 	cudaMalloc((void**)&d_b,size);
 	cudaMalloc((void**)&d_c,size);
 	printf("Enter elements of A");
 	for(int i=0;i<N;i++)
 		scanf("%d",a+i);
 	printf("Enter elements of B");
 	for(int i=0;i<N;i++)
 		scanf("%d",b+i);

 	cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
 	cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);
 	vectorAdd<<<1,N>>>(d_a,d_b,d_c);
 	cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
 	printf("N threads result \n");
 	for(int i=0;i<N;i++)
 		printf("%d ",*(c+i));
 	printf("\n");
 	vectorAdd<<<N,1>>>(d_a,d_b,d_c);
 	cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
 	printf("N blocks result \n");
 	for(int i=0;i<N;i++)
 		printf("%d ",*(c+i));
 	printf("\n");

 	dim3 dimGrid(ceil(N/256),1,1);
 	dim3 dimBlock(256,1,1);

	vectorAdd<<<dimGrid, dimBlock>>>(d_a,d_b,d_c);
 	cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);
 	printf("256 threads result \n");
 	for(int i=0;i<N;i++)
 		printf("%d ",*(c+i));	
 	printf("\n");

 	cudaFree(d_a);
 	cudaFree(d_b);
 	cudaFree(d_c);

}