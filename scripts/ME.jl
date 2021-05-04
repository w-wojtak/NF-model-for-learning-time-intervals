# Measuring epoch (ME)

function runME_input(sample_intervals,x,dx,steps,dt,wHat,theta,mu,epsi)

    # Input parameters
    A_input = 1.75; sigma_input = 2

    # Initialize fiedls
    u0 = 0.225 .* ones(length(x)); v0 = 0.5 .- copy(u0)
    u = copy(u0); v = copy(v0)
    max_u = zeros(length(steps),length(sample_intervals))
    u_save = zeros(length(x),length(sample_intervals))

    for sample in 1:length(sample_intervals)
        u = copy(u0); v = copy(v0)
        for i in 1:length(steps)
            # Apply inputs ranging from 500 to 1000 ms
            if 0.5/dt < i < (0.5/dt + sample_intervals[sample])
                input = gauss(x,A_input,sigma_input)
            else
                input = zeros(length(x))
            end
            # Update fields
            f = 1.0 ./ (1.0 .+ exp.(-mu .* (u .- theta)))
            conv = dx .* conv!(f,wHat)
            u .= u .+ dt .* (-u .+ v .+ conv .+ input .+ sqrt.(epsi) .*  randn(length(x)))
            v .= v .+ dt .* (-v .+ u .- conv)
            max_u[i,sample] = maximum(u); u_save[:,sample] = u
        end # end current sample
    end  # end sampling
    return x, steps, u, v, u_save, max_u[end,:]
end
