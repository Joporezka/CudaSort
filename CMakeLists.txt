cmake_minimum_required(VERSION 3.20)
project(CudaSort CUDA)

set(CMAKE_CUDA_STANDARD 23)

add_executable(CudaSort main.cu)

set_target_properties(CudaSort PROPERTIES
        CUDA_SEPARABLE_COMPILATION ON)
