# function to find the index next to the bin of interest

"""
find_index(A,value)

Find first index where value appears in list A
"""
function find_index(A, value)
    #b = findnext(A, value)
    c = minimum(find(a -> a >= value,A))
    d = maximum(find(a -> a <= value,A))
    index = 0
    if abs(value-A[c]) <= abs(value-A[d])
        index = Int(c)
    else
        index = Int(d)
    end
    return index
end

"""
find_index(h::Histogram,value)

Find first bin index where value appears in histogram h
"""
function find_index(h::Histogram,value)
    x = range(minimum(h.edges)[1],(maximum(h.edges)[1]/length(h.edges[1])),1024)
    index = find_index(x,value)
    return index
end
export find_index
# Include Measurements support

"""
find_value(h::Histogram, value)

Find y value for the bin containing value in histogram h.
"""
function find_value(h::Histogram, value)
    h.weights[find_index(h,value)] ± 1 / sqrt(h.weights[find_index(h,value)])
end
export find_value

"""
prepare_dir(filepath::String, pattern="")

Create OrderedDict of files matching option pattern in provided filepath.
"""
function prepare_dir(filepath::String, pattern="")
    data_dir = "/remote/ceph/group/gedet/data/pen/2018/$filepath"
    data_list = glob("*$pattern*",data_dir)
    data_dict = OrderedDict()
    start_cha = length(data_dir)+1
    for iter in eachindex(data_list)
        if contains(data_list[iter],".")
            data_dict[data_list[iter][start_cha:findlast(data_list[iter],'.')-1]]=data_list[iter]
        else
            data_dict[data_list[iter][start_cha:end]]=data_list[iter]
        end
    end
    return data_dict
end
export prepare_dir


"""
subtract_bkg(data, bkg)

Subtracting the background data from the raw data.
There are several input formats implemented:
 - data::Array{Any,2}
 - data::Array{Any,1}
 - data::StatsBase.Weights{Float64,Float64,Array{Float64,1}}
 which are the common formats resulting from the read_spec_data.jl
 The Background is demanded in the format of a Tuple including the x data to check whether the 
 background corresponds to the data (in case the x data is given). 
"""

function subtract_bkg(data, bkg)
    if length(bkg) == 2 # Check the format of the background data
        background = bkg[2]
    else 
        background = bkg
    end
    
    if typeof(data) == Array{Any,2}
        if data[1][1] == bkg[1]
            data_bkg_sub = Matrix{Any}(Int(length(data)/2), 2)
            i = 1
            while i <= Int(length(data)/2)
                data_bkg_sub[i,1] = data[i][1]
                data_bkg_sub[i,2] = data[i][2].- background
                i += 1
            end
            return data_bkg_sub
        else 
            println("Wavelength calibration does not fit!")
            return
        end
        
        
    elseif typeof(data) == Array{Any,1}
            data_bkg_sub = Array{Any}(Int(length(data)))
            i = 1
            while i <= Int(length(data))
                data_bkg_sub[i] = data[i].- background
                i += 1
            end  
        return data_bkg_sub

        
    elseif typeof(data) == StatsBase.Weights{Float64,Float64,Array{Float64,1}}
        data_bkg_sub = data.- background
        return data_bkg_sub

        
    else
        println("Wrong format. Are you sure that you put it in the 'Counts'?")
        return
    end
    
end
export subtract_bkg
