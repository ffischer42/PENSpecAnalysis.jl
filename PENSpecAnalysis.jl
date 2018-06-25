# Part of PENSpecAnalysis.jl

__precompile__(true)

module PENSpecAnalysis

using FileIO
using StatsBase
using Polynomials
using Distributions
using DataFrames
using DataStructures

include("read_spec_data.jl")
include("fit_spec.jl")
include("util.jl")

end # module
