#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>

__global__ void sinAngles(float *a, float *b){
	int tid = blockIdx.x*blockDim.x + threadIdx.x;
	*(b+tid)=sin(*(a+tid));	
 }

 int main(){
 	int N;
 	
 	printf("Enter size of array");
 	scanf("%d",&N);
 	int size=N*sizeof(float);
 	float *a = (float*)malloc(size);
 	float *b = (float*)malloc(size);
 	float *d_a, *d_b;
 	cudaMalloc((void**)&d_a,size);
 	cudaMalloc((void**)&d_b,size);
 	printf("Enter elements of array");
 	for(int i=0;i<N;i++)
 		scanf("%f",a+i);
 	
 	cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
 	sinAngles<<<1,N>>>(d_a,d_b);
 	cudaMemcpy(b,d_b,size,cudaMemcpyDeviceToHost);
 	printf("N threads result \n");
 	for(int i=0;i<N;i++)
 		printf("%f ",*(b+i));
  	cudaFree(d_a);
 	cudaFree(d_b);
 	
 }
