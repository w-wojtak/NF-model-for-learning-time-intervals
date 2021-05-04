# Production epoch (PE)

function runPE_input(x,dx,steps,dt,wHat,theta,mu)
    u0 = 0.225 .* ones(length(x))
    v0 = 0.5 .- copy(u0)

    redout_threshold = 2
    max_u = zeros(length(steps),length(max_amp))
    u2save = zeros(length(x),length(max_amp))

    input_0 = zeros(length(x))

    for sample in 1:length(max_amp)
        u = copy(u0)
        v = copy(v0)
        input_i = (1/ 1max_amp[sample]) .* exp.(-0.5 .* (x).^2 ./ 2^2)
        reached_th = false

        for i in 1:length(steps)
            if 0.5/dt > i || reached_th == true
                input = input_0
            else
                input = input_i
            end
            # Update fields
            f = 1.0 ./ (1.0 .+ exp.(-mu .* (u .- theta)))
            conv = dx .* conv!(f,wHat)
            u .= u .+ dt .* (-u .+ v .+ conv .+ input)
            v .= v .+ dt .* (-v .+ u .- conv)
            max_u[i,sample] = maximum(u)
            u2save[:,sample] = u

            if maximum(u) >= redout_threshold
                u = copy(u0)
                v = copy(v0)
                reached_th = true
            end
        end # end current sample
    end # end sampling
    return x, steps, u, v, max_u, u2save
end
