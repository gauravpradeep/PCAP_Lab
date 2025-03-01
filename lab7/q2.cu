#include <stdio.h>
#include <string.h>
#include <cuda_runtime.h>

__global__ void copyStringProgressively(char* d_result, const char* d_input, int str_len, int n) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < n) {
        int length_to_copy = str_len - idx;
        int offset = idx * str_len;

        for (int i = 0; i < length_to_copy; ++i) {
            d_result[offset + i] = d_input[i]; 
        }
        
        if (length_to_copy < str_len) {
            d_result[offset + length_to_copy] = '\0';
        }
    }
}

int main() {
    const char* input_string = "PCAP";
    int n = 4;

    int str_len = strlen(input_string);
    int result_len = str_len * n;

    char* d_input;
    char* d_result;
    cudaMalloc((void**)&d_input, str_len * sizeof(char));
    cudaMalloc((void**)&d_result, result_len * sizeof(char));

    cudaMemcpy(d_input, input_string, str_len * sizeof(char), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;

    copyStringProgressively<<<blocksPerGrid, threadsPerBlock>>>(d_result, d_input, str_len, n);

    char* h_result = (char*)malloc((result_len + 1) * sizeof(char));

    cudaMemcpy(h_result, d_result, result_len * sizeof(char), cudaMemcpyDeviceToHost);

    h_result[result_len] = '\0';

    printf("Result after progressively shortening the string: \n");
    for (int i = 0; i < n; ++i) {
        int length_to_print = str_len - i;
        for (int j = 0; j < length_to_print; ++j) {
            printf("%c", h_result[i * str_len + j]);
        }
        //printf("\n");
    }

    cudaFree(d_input);
    cudaFree(d_result);

    free(h_result);

    return 0;
}