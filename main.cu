
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

using namespace std;
#include <stdio.h>
#include<chrono>
#include <ctime>
#include <cmath>
#include <iostream>
#include <fstream>
#include "functionsCpp.h"


__global__ void selectionSortCUDA(int* arr,int n)
{
    int ti = threadIdx.x;
    int tj = threadIdx.y;

    if (ti < n - 1) {
        int min_idx = ti;
        if ((tj>=ti+1) && (tj < n)) {
            if (arr[tj] < arr[min_idx]) {
                min_idx = tj;
            }

        }
        int temp = arr[min_idx];
        arr[min_idx] = arr[ti];
        arr[ti] = temp;
    }



}

//#include "device_functions.h"
//#include <cuda.h>
/*
    nvcc main.cu -o out  -ccbin "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64"
    start .\out.exe
 */


int main()
{
    system("chcp 65001"); //переключаем кодировку в кириллицу
    int choose = 0;
    cin>>choose;
    switch (choose)
    {
        case 1: {
            cout << "Введите размер массива: ";
            int n;
            cin >> n;
            int *mas = new int[n];
            for (int i = 0; i < n; i++) {
                cin >> mas[i];
            }
            selectionSort(mas, n);
            for(int i=0;i<n;i++)
            {
                cout<<mas[i]<<" ";
            }
            cout<<endl;
            break;
        }
        case 2: {
            cout<<"Сортировка простым выбором: "<<endl;
            for(int n1=pow(10,2);n1<=pow(10,6);n1*=10)
            {
                int *mas1 = new int[n1];
                for (int i = 0; i < n1; i++) {
                    mas1[i] = rand() % 100;
                }
                cout<<"Размер массива: "<<n1<<endl;
                //selectionSort(mas1, n1);
                //проверяем время работы
                auto start = chrono::high_resolution_clock::now();
                //запускаем функцию
                int *cudaA = 0;
                cudaMalloc(&cudaA, sizeof(mas1));
                cudaMemcpy(cudaA, mas1, sizeof(mas1), cudaMemcpyHostToDevice);
                selectionSortCUDA << < 1, n1 >> > (cudaA, n1);
                cudaMemcpy(mas1, cudaA, n1, cudaMemcpyDeviceToHost);
                cudaFree(cudaA);

                auto finish = chrono::high_resolution_clock::now();
                auto time = chrono::duration_cast<chrono::microseconds>(finish - start).count();
                cout<< "Время выполнения "<<n1<<" CUDA: "<<time<<"mks"<< endl;
                if(n1<=pow(10,6)){
                    int* masCPU = new int[n1];
                    for (int i = 0; i < n1; i++) {
                        masCPU[i] = rand() % 100;
                    }
                    auto startCPU = chrono::high_resolution_clock::now();

                    selectionSort(mas1, n1);

                    auto finishCPU = chrono::high_resolution_clock::now();
                    if(n1>=pow(10,4))
                    {
                        auto timeCPU = chrono::duration_cast<chrono::milliseconds>(finishCPU - startCPU).count();
                        cout << "Время выполнения " << n1 << " CPU: " << timeCPU << "ms" << endl;
                    }else{
                        auto timeCPU = chrono::duration_cast<chrono::microseconds>(finishCPU - startCPU).count();
                        cout<<"Время выполнения "<<n1<<" на CPU: "<<timeCPU<<"mks"<<endl;
                    }
                }
                delete[] mas1;
            }

            break;

        }
        default:
            cout<<"Неверный выбор";
            break;
    }

    system("pause");
    return 0;

}