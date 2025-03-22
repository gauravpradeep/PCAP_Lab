#include <stdio.h>
#include <cuda.h>
#include <math.h>

__global__ void onesComplementKernel(int* a, int* b, int m, int n) {
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < m && col < n) {
        int idx = row * n + col;

        if (row == 0 || col == 0 || row == m - 1 || col == n - 1) {
            b[idx] = a[idx];
        } else {
            int num = a[idx];
            int temp = num;
            int bits[32];
            int count = 0;

            while (temp > 0) {
                bits[count++] = temp % 2;
                temp /= 2;
            }

            int bin = 0, place = 1;
            for (int i = 0; i < count; i++) {
                int flipped = bits[i] ^ 1;
                bin += flipped * place;
                place *= 10;
            }

            b[idx] = bin;
        }
    }
}

int main() {
    int m, n;
    printf("Enter m: ");
    scanf("%d", &m);
    printf("Enter n: ");
    scanf("%d", &n);

    int a[m][n], b[m][n];

    printf("Enter elements:\n");
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            scanf("%d", &a[i][j]);

    int* d_a, *d_b;
    size_t size = m * n * sizeof(int);

    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    dim3 blockSize(16, 16);
    dim3 gridSize(1,1,1);

    onesComplementKernel<<<gridSize, blockSize>>>(d_a, d_b, m, n);
    cudaMemcpy(b, d_b, size, cudaMemcpyDeviceToHost);

    printf("Ans:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", b[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_a);
    cudaFree(d_b);
    return 0;
}