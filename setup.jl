module Const
using Base.Iterators

# System Size
const LS   = 4
const LB   = 6
const dimS = LS^3
const dimB = LB^3

# Lattice
function makelattice(L::Integer, system::String)
    v = zeros(Integer, L)
    if system == "System"
        v .+= Const.LB
    end
    a = [i for i in 1:L]
    lattice = reshape(collect(product(a.+v, a, a)), L^3)
    return lattice
end
function makeindices(lattice::Array{Tuple{Int64,Int64,Int64},1})
    dim = length(lattice)
    indices = Dict{Tuple, Int64}()
    for i in 1:dim
        coordinate = lattice[i]
        indices[coordinate] = i
    end
    return indices
end
const latticeS = makelattice(LS, "System")
const latticeB = makelattice(LB, "Bath")
const lattice  = vcat(latticeB, latticeS)
const indices  = makeindices(lattice)

# System Param
const t = 1.0f0
const U = 1.0f0

# Repeat Number
const burnintime = 100
const iters_num = 200
const it_num = 2000
const iϵmax = 10
const num = 10000

# Network Params
const layer = [dimB+dimS, 88, 88, 2]
const layers_num = length(layer) - 1

# Learning Rate
const lr = 0.001f0

end
