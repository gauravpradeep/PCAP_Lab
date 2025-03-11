#include <cuda_runtime.h>
#include <stdio.h>
#include <device_launch_parameters.h>

__global__ void multiplyKernel_rowwise(int *a, int *b, int *c, int wa, int wb) {
    int ridA = threadIdx.x;  // Each thread computes one row
    if (ridA < wa) {
        for (int cidB = 0; cidB < wb; cidB++) {
            int sum = 0;
            for (int k = 0; k < wa; k++) {
                sum += a[ridA * wa + k] * b[k * wb + cidB];
            }
            c[ridA * wb + cidB] = sum;
        }
    }
}

__global__ void multiplyKernel_colwise(int *a, int *b, int *c, int ha, int wa, int wb) {
    int cidB = threadIdx.x;  // Each thread computes one column
    if (cidB < wb) {
        for (int ridA = 0; ridA < ha; ridA++) {
            int sum = 0;
            for (int k = 0; k < wa; k++) {
                sum += a[ridA * wa + k] * b[k * wb + cidB];
            }
            c[ridA * wb + cidB] = sum;
        }
    }
}

__global__ void multiplyKernel_elementwise(int *a, int *b, int *c, int wa, int wb) {
    int ridA = threadIdx.y;
    int cidB = threadIdx.x;
    
    if (ridA < wa && cidB < wb) {
        int sum = 0;
        for (int k = 0; k < wa; k++) {
            sum += a[ridA * wa + k] * b[k * wb + cidB];
        }
        c[ridA * wb + cidB] = sum;
    }
}

int main() {
    int n, m, a, b;

    printf("Enter n and m for A(nxm): ");
    scanf("%d %d", &n, &m);

    int A[n][m];
    printf("Enter A:\n");
    for (int i = 0; i < n; i++)
        for (int j = 0; j < m; j++)
            scanf("%d", &A[i][j]);

    printf("Enter a and b for B(axb): ");
    scanf("%d %d", &a, &b);

    if (m != a) {
        printf("Matrix multiplication not possible. m must equal a.\n");
        return -1;
    }

    int B[a][b], C[n][b], D[n][b], E[n][b];

    printf("Enter B:\n");
    for (int i = 0; i < a; i++)
        for (int j = 0; j < b; j++)
            scanf("%d", &B[i][j]);

    int *d_A, *d_B, *d_C;
    cudaMalloc((void**)&d_A, sizeof(int) * n * m);
    cudaMalloc((void**)&d_B, sizeof(int) * a * b);
    cudaMalloc((void**)&d_C, sizeof(int) * n * b);

    cudaMemcpy(d_A, A, sizeof(int) * n * m, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B, sizeof(int) * a * b, cudaMemcpyHostToDevice);

    // Set grid and block dimensions dynamically
    dim3 blockDim1(n, 1);
    multiplyKernel_rowwise<<<1, blockDim1>>>(d_A, d_B, d_C, m, b);
    cudaDeviceSynchronize();  // Ensure kernel finishes
    cudaMemcpy(C, d_C, sizeof(int) * n * b, cudaMemcpyDeviceToHost);

    dim3 blockDim2(1, b);
    multiplyKernel_colwise<<<1, blockDim2>>>(d_A, d_B, d_C, n, m, b);
    cudaDeviceSynchronize();
    cudaMemcpy(D, d_C, sizeof(int) * n * b, cudaMemcpyDeviceToHost);

    dim3 blockDim3(b, n);
    multiplyKernel_elementwise<<<1, blockDim3>>>(d_A, d_B, d_C, m, b);
    cudaDeviceSynchronize();
    cudaMemcpy(E, d_C, sizeof(int) * n * b, cudaMemcpyDeviceToHost);

    printf("Row-wise multiplication (each thread handles a row):\n");
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < b; j++)
            printf("%d ", C[i][j]);
        printf("\n");
    }

    printf("Column-wise multiplication (each thread handles a column):\n");
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < b; j++)
            printf("%d ", D[i][j]);
        printf("\n");
    }

    printf("Element-wise multiplication (each thread handles an element):\n");
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < b; j++)
            printf("%d ", E[i][j]);
        printf("\n");
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}