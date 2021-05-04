# Set up functions
gauss(x,A,sigma) = A .* exp.(-0.5 .* (x).^2 ./ sigma^2)
wmex(x,A_e,A_i,s_e,s_i,g_inh) = gauss(x,A_e,s_e) .- gauss(x,A_i,s_i) .- g_inh

function conv!(x,wHat)
    copy = fft(x)
    @. copy .= wHat .* copy
    ifft!(copy); @. x .= real(copy)
    x .= ifftshift(x)
end
