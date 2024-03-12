# Neural Field Model for Measuring and Reproducing Time Intervals

This repository hosts the Julia code used in the paper "Neural field model for measuring and reproducing time intervals" by W. Wojtak et al. 

The code utilizes a neural field model for learning temporal intervals demarcated by two time markers during the measurement epoch and reproducing them in the production epoch.
For details, please refer to the aforementioned article.


## The model

The model consists of two neural fields of Amari type:

$$\dfrac{\partial u(x,t)}{\partial t} = -u(x,t) + v(x,t) + \int_{\Omega} w (|x-y|)f(u(y,t)-\theta){\rm d} y + I(x,t) + \epsilon^{1/2}{\rm d}W(x,t)$$  

$$\dfrac{\partial v(x,t)}{\partial t} = -v(x,t) + u(x,t) - \int_{\Omega} w (|x-y|)f(u(y,t)-\theta){\rm d} y,$$

where $w$ is the Mexican hat function given by the difference of two Gaussians:

$$w(x) = A_{ex}e^{\left(-x^{2}/2\sigma^{2}_ {ex} \right)} - A_{in}e^{\left(-x^{2}/2\sigma^{2}_ {in}\right)} - g_{in}$$

with $A_{ex}  > A_{in} > 0$ and $\sigma_{in} > \sigma_{ex} > 0$  and $g_{in} > 0$.

The firing rate function $f$ is the Heaviside funciton with threshold $\theta$.


## Numerics

Numerical simulations of the model were done in Julia using a forward Euler method with time step `Δt = 0.001` and spatial step `Δx = 0.005`, on a finite domain `Ω` with length `L = 60`. To compute the spatial convolution of `w` and `f` we employ a fast Fourier transform (FFT), using Julia’s package FFTW with functions `fft` and `ifft` to perform the Fourier transform and the inverse Fourier transform, respectively.
 


## Simulation results


### Measuring time intervals

The shape of the self-stabilized bumps reflects the fact that a longer accumulation time results in a higher bump amplitude:  
![image](https://github.com/w-wojtak/NF-model-for-learning-time-intervals/assets/19287772/8418bf05-172a-43a5-a562-d4b06e996d47)


### Reproducing time intervals

Reproducing time intervals can be done by varying either the inputs or the initial conditions:  
![image](https://github.com/w-wojtak/NF-model-for-learning-time-intervals/assets/19287772/0fa73bc6-2714-4584-8841-151a89796ecb)



Values (in milliseconds) of sample and produced intervals:  

| Sample interval                     | 500 | 550 | 600 | 650 | 700 | 750 | 800 | 850 | 900 | 950 | 1000 |
|-------------------------------------|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|
| Produced interval (external inputs) | 516 | 579 | 626 | 679 | 732 | 777 | 820 | 858 | 907 | 953 | 986  |
| Produced interval (initial conditions) | 518 | 604 | 676 | 741 | 793 | 820 | 862 | 893 | 923 | 950 | 972  |



---

If you use the code, please cite:  

@inproceedings{wojtak2019neural,  
  title={Neural field model for measuring and reproducing time intervals},  
  author={Wojtak, Weronika and Ferreira, Flora and Bicho, Estela and Erlhagen, Wolfram},  
  booktitle={Artificial Neural Networks and Machine Learning--ICANN 2019: Theoretical Neural Computation: 28th International Conference on Artificial Neural Networks, Munich, Germany, September 17--19, 2019, Proceedings, Part I 28},  
  pages={327--338},  
  year={2019},  
  organization={Springer}  
}  
