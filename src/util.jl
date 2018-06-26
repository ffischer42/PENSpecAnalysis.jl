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
export find_index

function find_value(h::Histogram, value)
    h.weights(find_index(h,value)) ± 1 / sqrt(h.weights(find_index(h,value)))
end
export find_value
