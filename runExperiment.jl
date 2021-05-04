# This code simulates a time measurement and time reproduction experiment
# using a model of a robust neural integrator based on the theoretical
# framework of dynamic neural fields.
#
# The experiment consists of two stages: the measuring epoch (ME) and
# the production epoch (PE).
#
# During measurement, the temporal accumulation of input
# leads to the evolution of a self-stabilized bump whose amplitude reflects
# elapsed time.
#
# During production, the stored information is used to reproduce
# on a trial-by-trial basis the time interval either by input
# strength.
#
# If you use this code, please cite:
# Wojtak, W., Ferreira, F., Bicho, E., & Erlhagen, W. (2019, September).
# Neural field model for measuring and reproducing time intervals.
# In International Conference on Artificial Neural Networks (pp. 327-338).
# Springer, Cham.



# Load packages and scripts
using Plots, FFTW
include("scripts/functions.jl")
include("scripts/ME.jl")
include("scripts/PE.jl")

# Spatial coordinates
L = 60; dx = 0.05; x = collect(-L/2:dx:L/2)
# Temporal coordinates
tmax = 3; dt = 0.001; steps = collect(0:dt:tmax)

# FFT of the kernel (for convolution)
wHat = fft(wmex(x,3,1.5,1,3,0.5))

# Parameters
theta = 0.25 # firing threshold
epsi = 0.01 # noise strength
mu = 1000 # sigmoid steepness

# Time intervals to measure and reproduce
sample_intervals = collect(500:50:1000)

# Run ME
@time x, t, u, v, u_final, max_vals = runME_input(sample_intervals,x,dx,steps,dt,wHat,theta,mu,epsi)

# Plot the results
h1 = plot(x,u_final, xlims = (-15,15), dpi = 300,
            xtickfont = font(12, "Arial"), ytickfont = font(12),
            xlabel = "x", ylabel = "u(x)", legend=:false)
display(h1)

# Get bump amplitudes at the end of ME
const max_amp = log.(max_vals)

# Run PE
@time x, t, u, v, max_u_prod, saved_u_prod = runPE_input(x,dx,steps,dt,wHat,theta,mu)

# Plot the results
h2 = plot((t.*1000).-500, [max_u_prod],
            legend=:false,
            xlabel = "t [ms]",
            ylabel = "max(u,t)",
            xticks = 0:500:3000)
display(h2)

prod_max, max_ind_prod = findmax(max_u_prod,dims=1)
produced_intervals = zeros(1,length(max_ind_prod))

for i in 1:length(max_ind_prod)
    j = max_ind_prod[i]
    produced_intervals[i] = j[1] - 500
end

# Print measured and produced values
println("\nLearned intervals are ",sample_intervals)
println("\nProduced intervals are ",produced_intervals)
