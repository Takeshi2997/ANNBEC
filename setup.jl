module Const
using Base.Iterators

# System Size
const LS   = 4
const LB   = 8
const dimS = LS^3
const dimB = LB^3

# Lattice
function lattice(L)
    a = [i for i in 1:L]
    lattice = reshape(collect(product(a, a, a)), L^3)
    return lattice
end
const latticeS = lattice(LS)
const latticeB = lattice(LB)

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
