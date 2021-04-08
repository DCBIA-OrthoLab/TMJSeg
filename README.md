# tmjseg
Temporo mandibular joint segmentation algorithm in computed tomography images

## How to use a Matlab code as a standalone application 


1. Download and install Matlab Runtime on your machine with corresponding version:
	- Download the runtime from here : https://www.mathworks.com/products/compiler/matlab-runtime.html

2. Compile your code in Matlab using the command : mcc -m -R -nodisplay TMJSeg.m

3. Define the environment variable LD_LIBRARY_PATH as shown in the readme created during the compilation.

## How to run this program
	
	The input is an image in nifti format, the output is the image with _seg 

```
	TMJSeg input.nii
```