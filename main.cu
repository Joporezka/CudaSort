
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

using namespace std;
#include <stdio.h>
#include<chrono>
#include <ctime>
#include <cmath>
#include <iostream>
#include <fstream>

/*
    nvcc main.cu -o out  -ccbin "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64"
    start .\out.exe
 */

__global__ void solve(int* mas,int n5)
{
    int i = threadIdx.x;

    long long int counter = 0, move = 0;

    for (int i1 = 0; i1 < n5; i1++)
    {
        counter++;
        int key = mas[i1];
        int j = i1 - 1;
        while (j >= 0 && key < mas[j]) {
            mas[j + 1] = mas[j];
            j--;
            move++;
        }
        mas[j + 1] = key;
    }



}

int main()
{
    system("chcp 65001"); //переключаем кодировку в кириллицу
    ofstream f("out.txt");

    const int n5 = 100000000;
    int* mas = new int[n5];


    if (n5 != 10)cout << "Проверка на случайно сгенерированном массиве размерности: " << n5;
    auto start_time = chrono::steady_clock::now();

    int* cudaA = 0;

    cudaMalloc(&cudaA, sizeof(mas));

    cudaMemcpy(cudaA, mas, sizeof(mas),cudaMemcpyHostToDevice);



    for (int i = 0; i < n5; i++) {
        mas[i] = 1 + rand() % 100000;
    }



    solve << <1, n5 >> > (cudaA,n5);

    cudaMemcpy(mas, cudaA, n5, cudaMemcpyDeviceToHost);
    auto end_time = chrono::steady_clock::now();
    auto all_in_all = chrono::duration_cast<chrono::nanoseconds>(end_time - start_time);
    //cout << "\nC = " << counter << " M = " << move << " C+M = " << counter + move;
    f << "\n Time of compilation: " << double(all_in_all.count() / 1000000.0) << " ms\n\n";
    cout << "\n Time of compilation: " << double(all_in_all.count() / 1000000.0) << " ms\n\n";

    system("pause");
    return 0;

}