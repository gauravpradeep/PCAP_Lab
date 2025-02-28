#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>

__global__ void conv1d(float *N, float *M, float *P, int mwidth, int width){
	int tid=blockIdx.x*blockDim.x + threadIdx.x;

	float res=0;
	int start=tid-(mwidth/2);
	for(int i=0;i<mwidth;i++)
	{
		if(start+i>=0 && start+i<width)
			res+=N[start+i]*M[i];
	}
	P[tid]=res;
}

int main(){
 	int N,M;
 	
 	printf("Enter size of array");
 	scanf("%d",&N);
 	float *h_N = (float*)malloc(N*sizeof(float));
 	printf("Enter size of kernel");
 	scanf("%d",&M);
 	float *h_M = (float*)malloc(N*sizeof(float));
 	float *h_P = (float*)malloc(N*sizeof(float));

 	float *d_N, *d_M, *d_P;

 	cudaMalloc((void**)&d_N,N*sizeof(float));
 	cudaMalloc((void**)&d_M,M*sizeof(float));
 	cudaMalloc((void**)&d_P,N*sizeof(float));
 	printf("Enter elements of N");
 	for(int i=0;i<N;i++)
 		scanf("%f",h_N+i);
 	printf("Enter elements of mask");
 	for(int i=0;i<M;i++)
 		scanf("%f",h_M+i);

 	cudaMemcpy(d_N,h_N,N*sizeof(int),cudaMemcpyHostToDevice);
 	cudaMemcpy(d_M,h_M,M*sizeof(int),cudaMemcpyHostToDevice);
 	conv1d<<<1,N>>>(d_N, d_M, d_P, M, N);
 	cudaMemcpy(h_P,d_P,N*sizeof(int),cudaMemcpyDeviceToHost);
 	printf("Convolution result \n");
 	for(int i=0;i<N;i++)
 		printf("%f ",*(h_P+i));
 	printf("\n");

 	cudaFree(d_N);
 	cudaFree(d_M);
 	cudaFree(d_P);

}