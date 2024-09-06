using Makie
using DataFrames,CSV
using WGLMakie
using GeoMakie

projname="220"
filename_lat=projname*"/in_lat.dat"
filename_lon=projname*"/in_lon.dat"
filename_alt=projname*"/in_alt.dat"

struct GeoCoord
    lat::Float64
    lon::Float64
    alt::Float64
end

Makie.convevert_arguments(::Type{AbstractPlot}, x::GeoCoord)=(decompose(Point3f, x),)



function _parse_array(filename::String,header=1)
    io=open(filename,"r") ;
    elem  = readlines(io)[header:end];
    values  = join(elem," ") |> x-> split(x) |> x -> parse.(Float64,x)
    return values

end
function read_data(project_name;sink=Array,data::String="temp",header::Int=16)
    filename_lat=projname*"/in_lat.dat"
    filename_lon=projname*"/in_lon.dat"
    filename_alt=projname*"/in_alt.dat"
    filename_data=projname*"/in_"*data*".dat"

    latitudes=_parse_array(filename_lat,16);
    longitudes=_parse_array(filename_lon,16);
    altitudes=_parse_array(filename_alt,17);
    @info "unique latitudes: $(length(unique(latitudes)))"
    @info "unique longitudes: $(length(unique(longitudes)))"
    coord_angles = [(lat,lon) for (lat,lon) in zip(latitudes,longitudes)]
    points = [(lat_lon[1],lat_lon[2],alt) for lat_lon in coord_angles, alt in altitudes]


    return points[:]
end

data=read_data("220")
