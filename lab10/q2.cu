#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>

#define MAX_KERNEL_SIZE 1024

__constant__ float d_M[MAX_KERNEL_SIZE];

__global__ void conv1d(float *N, float *P, int mwidth, int width) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;

    float res = 0;
    int start = tid - (mwidth / 2);
    for (int i = 0; i < mwidth; i++) {
        if (start + i >= 0 && start + i < width)
            res += N[start + i] * d_M[i];
    }
    P[tid] = res;
}

int main() {
    int N, M;

    printf("Enter size of array: ");
    scanf("%d", &N);
    float *h_N = (float*)malloc(N * sizeof(float));
    printf("Enter size of kernel: ");
    scanf("%d", &M);
    if (M > MAX_KERNEL_SIZE) {
        printf("Kernel size exceeds maximum allowed size of %d\n", MAX_KERNEL_SIZE);
        return 1;
    }
    float *h_M = (float*)malloc(M * sizeof(float));
    float *h_P = (float*)malloc(N * sizeof(float));

    float *d_N, *d_P;

    cudaMalloc((void**)&d_N, N * sizeof(float));
    cudaMalloc((void**)&d_P, N * sizeof(float));
    printf("Enter elements of N: ");
    for (int i = 0; i < N; i++)
        scanf("%f", h_N + i);
    printf("Enter elements of mask: ");
    for (int i = 0; i < M; i++)
        scanf("%f", h_M + i);

    cudaMemcpy(d_N, h_N, N * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpyToSymbol(d_M, h_M, M * sizeof(float));
    conv1d<<<(N + 255) / 256, 256>>>(d_N, d_P, M, N);
    cudaMemcpy(h_P, d_P, N * sizeof(float), cudaMemcpyDeviceToHost);
    printf("Convolution result: \n");
    for (int i = 0; i < N; i++)
        printf("%f ", *(h_P + i));
    printf("\n");

    cudaFree(d_N);
    cudaFree(d_P);
    free(h_N);
    free(h_M);
    free(h_P);

    return 0;
}