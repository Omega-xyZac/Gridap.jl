module UtilsTests

using Test

@testset "Helpers" begin include("HelpersTests.jl") end

@testset "CachedArrays" begin include("CachedArraysTests.jl") end

@testset "CachedSubVectors" begin include("CachedSubVectorsTests.jl") end

end # module

