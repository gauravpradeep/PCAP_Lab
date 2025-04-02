#include <iostream>
#include <cuda.h>
#include <stdio.h>
// CUDA kernel for matrix multiplication
__global__ void matrixMulKernel(float *d_A, float *d_B, float *d_C, int width) {
    int Row = blockIdx.y * blockDim.y + threadIdx.y;
    int Col = blockIdx.x * blockDim.x + threadIdx.x;

    if (Row < width && Col < width) {
        float Cvalue = 0.0;
        for (int k = 0; k < width; ++k) {
            Cvalue += d_A[Row * width + k] * d_B[k * width + Col];
        }
        d_C[Row * width + Col] = Cvalue;
    }
}

void matrixMultiplication(float *h_A, float *h_B, float *h_C, int width) {
    int size = width * width * sizeof(float);
    
    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, size);
    cudaMalloc(&d_B, size);
    cudaMalloc(&d_C, size);

    cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, size, cudaMemcpyHostToDevice);

    dim3 dimBlock(16, 16); // 16x16 threads per block
    dim3 dimGrid((width + dimBlock.x - 1) / dimBlock.x, (width + dimBlock.y - 1) / dimBlock.y); // Grid size

    matrixMulKernel<<<dimGrid, dimBlock>>>(d_A, d_B, d_C, width);

    cudaMemcpy(h_C, d_C, size, cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);
}

int main() {
    int width = 3; // Example width of the matrices
    int size = width * width;
    float *h_A = new float[size];
    float *h_B = new float[size];
    float *h_C = new float[size];

    // Initialize matrices with some values
    for (int i = 0; i < size; i++) {
        h_A[i] = static_cast<float>(i);
        h_B[i] = static_cast<float>(i);
    }

    matrixMultiplication(h_A, h_B, h_C, width);

    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            std::cout << h_C[i * width + j] << " ";
        }
        std::cout << std::endl;
    }
    delete[] h_A;
    delete[] h_B;
    delete[] h_C;

    return 0;
}