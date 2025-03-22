#include <stdio.h>
#include <cuda.h>

__global__ void SpMV(int r, float* data, int* row_ptr, int* col_index, float* x, float* y) {
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    if (row < r) {
        float dot = 0.0f;
        int row_start = row_ptr[row];
        int row_end = row_ptr[row + 1];

        for (int ele = row_start; ele < row_end; ele++) {
            dot += data[ele] * x[col_index[ele]];
        }

        y[row] += dot;
    }
}

int main() {
    int r, c;

    printf("Enter r: ");
    scanf("%d", &r);

    printf("Enter c: ");
    scanf("%d", &c);

    float mat[r][c];  

    printf("Enter elements:\n");
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            scanf("%f", &mat[i][j]);
        }
    }

    int row_ptr[r + 1];
    float data[r * c];           
    int col_index[r * c];

    int n = 0;
    row_ptr[0] = 0;  

    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            if (mat[i][j] != 0) {
                data[n] = mat[i][j];
                col_index[n] = j;
                n++;
            }
        }
        row_ptr[i + 1] = n;
    }

    printf("Data Array:\n");
    for (int i = 0; i < n; i++) {
        printf("%.2f ", data[i]);
    }
    printf("\n");

    printf("Row Pointer Array:\n");
    for (int i = 0; i <= r; i++) {
        printf("%d ", row_ptr[i]);
    }
    printf("\n");

    printf("Column Index Array:\n");
    for (int i = 0; i < n; i++) {
        printf("%d ", col_index[i]);
    }
    printf("\n");

    float x[c];
    printf("Enter x:\n");
    for (int i = 0; i < c; i++) {
        scanf("%f", &x[i]);
    }

    float y[r]; 
    printf("Enter y:\n");
    for (int i = 0; i < r; i++) {
        scanf("%f", &y[i]);
    }

    float *d_data, *d_x, *d_y;
    int *d_row_ptr, *d_col_index;

    cudaMalloc((void**)&d_data, n * sizeof(float));
    cudaMalloc((void**)&d_row_ptr, (r + 1) * sizeof(int));
    cudaMalloc((void**)&d_col_index, n * sizeof(int));
    cudaMalloc((void**)&d_x, c * sizeof(float));
    cudaMalloc((void**)&d_y, r * sizeof(float)); 

    cudaMemcpy(d_data, data, n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_row_ptr, row_ptr, (r + 1) * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_col_index, col_index, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_x, x, c * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, y, r * sizeof(float), cudaMemcpyHostToDevice); 

    SpMV<<<1,r>>>(r, d_data, d_row_ptr, d_col_index, d_x, d_y);

    cudaMemcpy(y, d_y, r * sizeof(float), cudaMemcpyDeviceToHost);

    printf("Result:\n");
    for (int i = 0; i < r; i++) {
        printf("%.2f\n", y[i]);
    }

    cudaFree(d_data);
    cudaFree(d_row_ptr);
    cudaFree(d_col_index);
    cudaFree(d_x);
    cudaFree(d_y);

    return 0;
}