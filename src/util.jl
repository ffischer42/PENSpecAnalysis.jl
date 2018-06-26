# function to find the index next to the bin of interest
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

function find_index(h::Histogram,value)
    x = range(minimum(h.edges)[1],(maximum(h.edges)[1]/length(h.edges[1])),1024)
    index = find_index(x,value)
    return index
end

# Include Measurements support
function find_value(h::Histogram, value)
    h.weights[find_index(h,value)] ± 1 / sqrt(h.weights[find_index(h,value)])
end
export find_value

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
