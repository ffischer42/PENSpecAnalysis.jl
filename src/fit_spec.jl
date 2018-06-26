# Part of PENSpecAnalysis.jl module.h =

function peakfit(xaxis,yaxis)
    max =  findmax(yaxis)
    p = polyfit(float.(xaxis[max[2]-5:max[2]+5]),float.(yaxis[max[2]-5:max[2]+5]),2)
    c = coeffs(p)
    fit_function(x) = c[1]+c[2]x+c[3]x^2  # [f(x) = f(x) + c[iter]*x^(iter-1) for iter in eachindex(c)]
    peak = roots(polyder(p,1))[1] \pm   (xaxis[end]-xaxis[1])/length(xaxis)
    return peak, fit_function, chisquare(xaxis[max[2]-5:max[2]+5], yaxis[max[2]-5:max[2]+5], p),p
end

function peakfit(xaxis,yaxis,range)
    max =  findmax(yaxis)
    p = polyfit(float.(xaxis[max[2]-range:max[2]+range]),float.(yaxis[max[2]-range:max[2]+range]),2)
    c = coeffs(p)
    fit_function(x) = c[1]+c[2]x+c[3]x^2  # [f(x) = f(x) + c[iter]*x^(iter-1) for iter in eachindex(c)]
    peak = roots(polyder(p,1))[1] \pm   (xaxis[end]-xaxis[1])/length(xaxis)
    diffstring = @sprintf("%0.2f",r[1]-xaxis[indmax(yaxis)])
    if range == 15
        println("Difference [fit - data] = $diffstring nm")
    end
    return peak, fit_function, chisquare(xaxis[max[2]-range:max[2]+range], yaxis[max[2]-range:max[2]+range], p),p
end

function peakfit(xaxis,yaxis,range,string::String)
    max =  findmax(yaxis)
    p = polyfit(float.(xaxis[max[2]-15:max[2]+7]),float.(yaxis[max[2]-15:max[2]+7]),2)
    c = coeffs(p)
    fit_function(x) = c[1]+c[2]x+c[3]x^2
    peak = roots(polyder(p,1))[1] \pm   (xaxis[end]-xaxis[1])/length(xaxis)
    diffstring = @sprintf("%0.2f",r[1]-xaxis[indmax(yaxis)])
    println("Difference [fit - data] = $diffstring nm")
    return peak, fit_function, chisquare(xaxis[max[2]-15:max[2]+7], yaxis[max[2]-15:max[2]+7], p),p
end

function peakfit(h::Histogram)
    p = peakfit(float.(h.edges[1]), float.(h.weights))
    return p
end

export peakfit

function chisquare(xaxis, yaxis, model)
    chi2 = 0
    for i in eachindex(xaxis)
       chi2= chi2+ (yaxis[i] - polyval(model, xaxis[i]))^2 / polyval(model, xaxis[i])
    end
    return chi2
end
