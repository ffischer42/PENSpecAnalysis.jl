# Part of PENSpecAnalysis.jl

__precompile__(true)

module PENSpecAnalysis

using FileIO
using StatsBase
using Polynomials
using Distributions
using DataFrames
using DataStructures
using Measurements
using Glob
using Plots
using SIUnits, SIUnits.ShortUnits

include("read_spec_data.jl")
include("fit_spec.jl")
include("util.jl")
include("plot.jl")

end # module
