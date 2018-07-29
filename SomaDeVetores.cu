#include <iostream>

using namespace std;

__global__ void SomaVetores(int* vetorA, int* vetorB, int* vetorC, int tamanho)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < tamanho)
        vetorC[i] = vetorA[i] + vetorB[i];
}

int main()
{
    int tamanho = 100000000;
    size_t totalBytes = tamanho * sizeof(int);
    
    int* vetorA = (int*) malloc(totalBytes);
    int* vetorB = (int*) malloc(totalBytes);
    int* vetorC = (int*) malloc(totalBytes);

    
    if(vetorA == NULL || vetorB == NULL || vetorC == NULL)
    {
        cout << "Memoria insuficiente!" << endl;
        return 0;
    }

    for(int index = 0; index < tamanho; index++)
    {
        vetorA[index] = vetorB[index] = index; 
        vetorC[index] = 0; 
    }

    int* cudaVetorA;
    int* cudaVetorB;
    int* cudaVetorC;
    
    cudaMalloc(&cudaVetorA, totalBytes);
    cudaMalloc(&cudaVetorB, totalBytes);
    cudaMalloc(&cudaVetorC, totalBytes);

    cudaMemcpy(cudaVetorA, vetorA, totalBytes, cudaMemcpyHostToDevice);
    cudaMemcpy(cudaVetorB, vetorB, totalBytes, cudaMemcpyHostToDevice);

    SomaVetores<<<1, tamanho>>>(cudaVetorA, cudaVetorB, cudaVetorC, tamanho);

    cudaMemcpy(vetorC, cudaVetorC, totalBytes, cudaMemcpyDeviceToHost);
   
    cudaFree(cudaVetorA);
    cudaFree(cudaVetorB);
    cudaFree(cudaVetorC);

    /*
    for(int index = 0; index < tamanho; index++)
    {
        cout << "C = " << vetorC[index] << endl;
    }
    */

    free(vetorA);
    free(vetorB);
    free(vetorC);

    cout << "200 OK" << endl;

    return 0;
}
