# Part of PENSpecAnalysis.jl module.



"""
peakfit(x,y)

Fits second order polynomial to mapping x -> y around maximal y-value.

# Arguements
- 'xaxis': x values for fit
- 'yaxis': y values to be fitted to.
# Returns
- 'peak::Measurement': Peak extracted from fit, with resolution.
- 'fit_function::function': function mapping x -> y
- 'chisquare::Float64' chi squared of fit to input data.
- 'p::Polynomial' polynomial computed, alternate form of fit_function.
"""
# function peakfit(xaxis,yaxis; range=10)
#     range = range / 2
#     max =  findmax(yaxis)
#      p = polyfit(float.(xaxis[max[2]]-range):float.(xaxis[max[2]]+range),float.(yaxis[max[2]]-range):float.(yaxis[max[2]]+range),2)
#     c = coeffs(p)
#     fit_function(x) = c[1]+c[2]x+c[3]x^2  # [f(x) = f(x) + c[iter]*x^(iter-1) for iter in eachindex(c)]
#     peak = roots(polyder(p,1))[1] ± (xaxis[end]-xaxis[1])/length(xaxis)
#     return peak, fit_function, chisquare(xaxis[max[2]]-range):float.(xaxis[max[2]]+range, yaxis[max[2]]-range):float.(yaxis[max[2]]+range, p),p
# end

function peakfit(xaxis,yaxis; range=10)
    max =  findmax(yaxis)
    p = polyfit(float.(xaxis[max[2]-range:max[2]+range]),float.(yaxis[max[2]-range:max[2]+range]),2)
    c = coeffs(p)
    fit_function(x) = c[1]+c[2]x+c[3]x^2  # [f(x) = f(x) + c[iter]*x^(iter-1) for iter in eachindex(c)]
    peak = roots(polyder(p,1))[1] ± (xaxis[end]-xaxis[1])/length(xaxis)
    return peak, fit_function, chisquare(xaxis[max[2]-range:max[2]+range], yaxis[max[2]-range:max[2]+range], p),p
end

function peakfit(xaxis,yaxis,range,string::String)
    max =  findmax(yaxis)
    p = polyfit(float.(xaxis[max[2]-15:max[2]+7]),float.(yaxis[max[2]-15:max[2]+7]),2)
    c = coeffs(p)
    fit_function(x) = c[1]+c[2]x+c[3]x^2
    peak = roots(polyder(p,1))[1] ± (xaxis[end]-xaxis[1])/length(xaxis)
    diffstring = @sprintf("%0.2f",peak[1]-xaxis[indmax(yaxis)])
    println("Difference [fit - data] = $diffstring nm")
    return peak, fit_function, chisquare(xaxis[max[2]-15:max[2]+7], yaxis[max[2]-15:max[2]+7], p),p
end


"""
peakfit(h::Histogram)

Fits second order polynomial to mapping x -> y around maximal y-value.
Alias for peakfit(h.edges,h.weight)

# Arguements
- 'xaxis': x values for fit
- 'yaxis': y values to be fitted to.
# Returns
- 'p': Array of returned value from peakfit(x,y)
"""
function peakfit(h::Histogram; range=10)
    p = peakfit(float.(h.edges[1]), float.(h.weights),range=range)
    return p
end

export peakfit

"""
chisquare(xaxis, yaxis, model)

Calculates the chi squared of a set of data (x,y) and a model

"""
function chisquare(xaxis, yaxis, model)
    chi2 = 0
    for i in eachindex(xaxis)
       chi2= chi2+ (yaxis[i] - polyval(model, xaxis[i]))^2 / polyval(model, xaxis[i])
    end
    return chi2
end
