module Func
include("./setup.jl")
include("./ann.jl")
using .Const, .ANN, LinearAlgebra, Distributed

function flip(x::Vector{Float32}, iy::Integer)

    xflip = copy(x)
    xflip[iy] *= -1f0
    return xflip
end

function flip2(x::Vector{Float32}, iy::Integer, ix::Integer)

    xflip = copy(x)
    xflip[iy] *= -1f0
    xflip[ix] *= -1f0
    return xflip
end

function update(x::Vector{Float32})
    
    for ix in 1:length(x)
        x₁ = x[ix]
        z = ANN.forward(x)
        xflip = flip(x, ix)
        zflip = ANN.forward(xflip)
        prob = exp(2.0f0 * real(zflip - z))
        @inbounds x[ix] = ifelse(rand(Float32) < prob, -x₁, x₁)
    end
end

function hamiltonianS(x::Vector{Float32}, z::Complex{Float32}, 
                      i::Integer, j::Integer)

    out = 0.0f0im
    if x[i] != x[j]
        xflip = flip2(x, i, j)
        zflip = ANN.forward(xflip)
        out  += exp(zflip - z)
    end

    return Const.t * out
end

function energyS(x::Vector{Float32})

    z = ANN.forward(x)
    sum = 0.0f0im
    @simd for i in 1:Const.dimS
        ix = Const.latticeS[i]
        iy1 = (Const.LB+(ix[1]-Const.LB)%Const.LS+1, ix[2], ix[3])
        iy2 = (ix[1], ix[2]%Const.LS+1, ix[3])
        iy3 = (ix[1], ix[2], ix[3]%Const.LS+1)
        j1 = Const.indices[iy1]
        j2 = Const.indices[iy2]
        j3 = Const.indices[iy3]
        sum += hamiltonianS(x, z, i, j1)
        sum += hamiltonianS(x, z, i, j2)
        sum += hamiltonianS(x, z, i, j3)
    end

    return sum
end

function hamiltonianB(x::Vector{Float32}, z::Complex{Float32}, 
                      i::Integer, j::Integer)

    out = 0.0f0im
    if x[i] != x[j]
        xflip = flip2(x, i, j)
        zflip = ANN.forward(xflip)
        out  += exp(zflip - z)
    end

    return Const.t * out
end

function energyB(x::Vector{Float32})

    z = ANN.forward(x)
    sum = 0.0f0im
    @simd for i in length(x)
        ix = Const.latticeS[i]
        iy1 = (ix[1]%Const.LB+1, ix[2], ix[3])
        iy2 = (ix[1], ix[2]%Const.LB+1, ix[3])
        iy3 = (ix[1], ix[2], ix[3]%Const.LB+1)
        j1 = Const.indices[iy1]
        j2 = Const.indices[iy2]
        j3 = Const.indices[iy3]
        sum += hamiltonianB(x, z, i, j1)
        sum += hamiltonianB(x, z, i, j2)
        sum += hamiltonianB(x, z, i, j3)
    end

    return sum
end

end
