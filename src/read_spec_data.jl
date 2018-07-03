# Compute StatsBase Histogram from raw spectrometer output.

"""
read_spec_data(filename::String)

Reads input csv datafile from ANDOR Spectrometer into StatsBase histogram for analysis.

# Arguements
- 'filename::String': Spectrometer data file to be opened.

# Returns
- 'h::Histogram': Histogram of data.
"""
function read_spec_data(filename::String)
    f = open(filename)
    data = readdlm(IOBuffer(readstring(f)),',')
    data = data[1:end,1:2]

    edge_vec = [0.5 * (data[:,1][i] + data[:,1][i + 1]) for i = 1:length(data[:,1]) - 1]
    unshift!(edge_vec, data[:,1][1]-(data[:,1][2]-data[:,1][1])/2)
    append!(edge_vec, data[:,1][end]+(data[:,1][end]-data[:,1][end-1])/2)

    h = fit(Histogram, float.(data[1:end,1]),weights(float.(data[1:end,2])),edge_vec,closed=:left)
    return h
end

# Returns raw data for data_format == true and the histogram for data_format == false
# Arguements
#- 'filename::String': Spectrometer data file to be opened.
#- 'data_format::Bool': 'true' for raw data and 'false' for the histogram

# Returns
#- 'h::Histogram': Histogram of data.
# or if 'data_format = true'
#- 'x::Array{Float64,1}', 'y::StatsBase.Weights{Float64,Float64,Array{Float64,1}}': wavelength and counts in arrays

function read_spec_data(filename::String, data_format::Bool)
    f = open(filename)
    data = readdlm(IOBuffer(readstring(f)),',')
    data = data[1:end,1:2]

    edge_vec = [0.5 * (data[:,1][i] + data[:,1][i + 1]) for i = 1:length(data[:,1]) - 1]
    unshift!(edge_vec, data[:,1][1]-(data[:,1][2]-data[:,1][1])/2)
    append!(edge_vec, data[:,1][end]+(data[:,1][end]-data[:,1][end-1])/2)
    if data_format
        return float.(data[1:end,1]), weights(float.(data[1:end,2]))
    else
        h = fit(Histogram, float.(data[1:end,1]),weights(float.(data[1:end,2])),edge_vec,closed=:left)
        return h
    end
end

export read_spec_data
