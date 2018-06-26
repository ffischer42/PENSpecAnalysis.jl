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

export read_spec_data
