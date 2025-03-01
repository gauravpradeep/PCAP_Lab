#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
__global__ void CUDACountWord(char *text, int textLength, char *word, int wordLength, unsigned int *d_count, int *wordLengths) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    int start=0;
    bool match=true;
    for(int i=0;i<tid;i++)
    {
        start+=wordLengths[i];
        start+=1;
    }
    printf("%d %d",tid, wordLengths[tid]);
    if(wordLengths[tid]!=wordLength)
        match=false;
    else{
        for(int i=0;i<wordLength;i++)
        {
            if(text[start+i]!=word[i])
                match=false;
        }
    }
        if (match) {
            atomicAdd(d_count, 1);
        }
}

int main() {
    char text[100];
    char word[10];
    char *d_text, *d_word;
    int *d_wordLengths;
    unsigned int count = 0, result;
    unsigned int *d_count;
    
    printf("Enter a string: ");
    fgets(text,100,stdin);
    int textLength = strlen(text);
    if (text[textLength - 1] == '\n') text[textLength - 1] = '\0'; // Remove newline
    textLength = strlen(text);
    int wordLengths[textLength];
    int len=0,wc=0;
    for(int i=0;i<textLength;i++)
    {
        if(text[i]!=' ' && text[i]!='\0')
            len++;
        else
        {
            wordLengths[wc]=len;
            wc+=1;
            len=0;
        }
    }
    if (len > 0) {
        wordLengths[wc] = len;
        wc += 1;
    }
    printf("Enter word to search: ");
    scanf("%s",word);
    int wordLength = strlen(word);
    wordLength = strlen(word); 

    cudaMalloc((void**)&d_text, textLength * sizeof(char));
    cudaMalloc((void**)&d_word, wordLength * sizeof(char));
    cudaMalloc((void**)&d_count, sizeof(unsigned int));
    cudaMalloc((void**)&d_wordLengths, wc* sizeof(int));
    cudaMemcpy(d_text, text, textLength * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_word, word, wordLength * sizeof(char), cudaMemcpyHostToDevice);
    cudaMemcpy(d_count, &count, sizeof(unsigned int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_wordLengths, wordLengths, wc * sizeof(int), cudaMemcpyHostToDevice);

    CUDACountWord<<<1, wc>>>(d_text, textLength, d_word, wordLength, d_count, d_wordLengths);
    
    cudaMemcpy(&result, d_count, sizeof(unsigned int), cudaMemcpyDeviceToHost);
    
    printf("Total occurrences of '%s' = %u\n", word, result);
    
    cudaFree(d_text);
    cudaFree(d_word);
    cudaFree(d_count);
    
    return 0;
}