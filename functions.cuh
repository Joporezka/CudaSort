#ifndef __CUDA_FUNCTIONS_H__
#define __CUDA_FUNCTIONS_H__
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
using namespace std;
__global__ void selectionSortCUDA(int *arr, int n)
{
    int min_idx;
    int i=ThreadIdx.x;
    int j=i;

    for (int i = 0; i < n-1; i++)
    {
        min_idx = i;
        for (int j = i+1; j < n; j++)
            if (arr[j] < arr[min_idx])
                min_idx = j;

        swap(arr[min_idx], arr[i]);
    }
}
#endif