#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void add1(int* a, int* b, int* c, int m, int n) {
    int rid = threadIdx.y;
    int cid = threadIdx.x;
    c[n*rid + cid] = a[n*rid + cid]+b[n*rid + cid];
}

__global__ void add2(int* a, int* b, int* c, int m, int n){
    int rid=threadIdx.x;
    for(int i=0;i<n;i++)
        c[rid*n + i] = a[rid*n + i] + b[rid*n + i];
}
__global__ void add3(int* a, int* b, int* c, int m, int n){
    int cid=threadIdx.x;
    for(int i=0;i<n;i++)
        c[i*n+cid] = a[i*n+cid] + b[i*n+cid];
}


int main() {
    int M,N;
    
    printf("Enter no of rows of matrix");
    scanf("%d",&M);
    printf("Enter no of columns of matrix");
    scanf("%d",&N);

    int h_A[M][N],h_B[M][N],h_C[M][N];
    int *d_A, *d_B, *d_C;

    cudaMalloc((void**)&d_A,M*N*sizeof(int));
    cudaMalloc((void**)&d_B,M*N*sizeof(int));
    cudaMalloc((void**)&d_C,M*N*sizeof(int));

    printf("Enter elements of A");
    
    for(int i=0;i<M;i++)
    {
        for(int j=0;j<N;j++)
            scanf("%d",&h_A[i][j]);
    }

    printf("Enter elements of B");
    for(int i=0;i<M;i++)
    {
        for(int j=0;j<N;j++)
            scanf("%d",&h_B[i][j]);
    }

    cudaMemcpy(d_A,h_A,M*N*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_B,h_B,M*N*sizeof(int),cudaMemcpyHostToDevice);
    // dim3 blockDim(N, M);
    // add1<<<1,blockDim>>>(d_A,d_B,d_C,M,N);
// --------------------------------

    // dim3 blockDim(M,1);
    // add2<<<1,blockDim>>>(d_A,d_B,d_C,M,N);
// --------------------------------

    dim3 blockDim(N,1);  
    add3<<<1,blockDim>>>(d_A,d_B,d_C,M,N);
// --------------------------------


    cudaMemcpy(h_C,d_C,M*N*sizeof(int),cudaMemcpyDeviceToHost);
    for(int i=0;i<M;i++)
    {
        for(int j=0;j<N;j++)
            printf("%d ",h_C[i][j]);
        printf("\n");
    }

    return 0;
}