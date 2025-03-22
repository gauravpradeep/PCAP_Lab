#include <stdio.h>
#include <cuda.h>
#include <math.h>

__global__ void transformMatrix(int* mat, int m, int n) {
    int row = threadIdx.x;

    if (row < m) {
        if (row == 0) return; 

        for (int k = 0; k < n; k++) {
            int idx = row * n + k;
            mat[idx] = powf(mat[idx], row+1); 
        }
    }
}

int main() {
    int m, n;
    printf("Enter m: ");
    scanf("%d", &m);
    printf("Enter n: ");
    scanf("%d", &n);

    int mat[m][n];

    printf("Enter elements:\n");
    for (int i = 0; i < m; i++)
        for (int j = 0; j < n; j++)
            scanf("%d", &mat[i][j]);

    int* d_mat;
    cudaMalloc((void**)&d_mat, m * n * sizeof(int));
    cudaMemcpy(d_mat, mat, m * n * sizeof(int), cudaMemcpyHostToDevice);

    transformMatrix<<<1, m>>>(d_mat, m, n);

    cudaMemcpy(mat, d_mat, m * n * sizeof(int), cudaMemcpyDeviceToHost);

    printf("Transformed Matrix:\n");
    for (int i = 0; i < m; i++) {
        for (int j = 0; j < n; j++) {
            printf("%d ", mat[i][j]);
        }
        printf("\n");
    }

    cudaFree(d_mat);
    return 0;
}