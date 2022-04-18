//
// Created by xale3k on 18.04.2022.
//

#ifndef CUDASORT_FUNCTIONSCPP_H
#define CUDASORT_FUNCTIONSCPP_H

void selectionSort(int *arr, int n)
{
    for (int i = 0; i < n - 1; i++)
    {
        int min_id = i;

        for (int j = i + 1; j < n; j++)
            if (arr[j] < arr[min_id])
                min_id = j;

        int temp = arr[min_id];
        arr[min_id] = arr[i];
        arr[i] = temp;
    }
}

#endif //CUDASORT_FUNCTIONSCPP_H
