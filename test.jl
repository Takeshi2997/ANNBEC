include("./setup.jl")
using .Const, LinearAlgebra, InteractiveUtils, Distributed


B = [1  0  0  0
     0 -1  2  0
     0  2 -1  0
     0  0  0  1]
for i in 1:Const.dimS
    ix = Const.latticeS[i]
    iy1 = (Const.LB+(ix[1]-Const.LB)%Const.LS+1, ix[2], ix[3])
    iy2 = (ix[1], ix[2]%Const.LS+1, ix[3])
    iy3 = (ix[1], ix[2], ix[3]%Const.LS+1)
    j1 = Const.indices[iy1]
    j2 = Const.indices[iy2]
    j3 = Const.indices[iy3]
    println(ix, "\t", iy1, "\t", iy2, "\t", iy3)
end 
