using Makie,WGLMakie
using DataFrames
using GeoStats
using CoordRefSystems
using Unitful
using GeometryBasics
using GeoMakie
coords= [rand(35.,22.5,100),(36.,22.5,100),(38.,22.5,100.)]

table = (; Temp=[100.,0.,300.].*u"K")
gg=georef(table,coords; crs=LatLonAlt)
grid=CartesianGrid(100,100)

model = Kriging(GaussianVariogram(range=1.))
interpolated = gg |> Interpolate(grid)

sphere=Sphere((0.0,0.0,0.0),1.0)
viz(gg.geometry,color=gg.Temp)


# attribute table
table = (; Temp=[1.,0.,1.])

# coordinates for each row
coord = [(25.,25.), (50.,75.), (75.,50.)]

# georeference data
geotable = georef(table, coord; crs=LatLon)

# interpolation domain
grid = CartesianGrid((100, 100,100),(-50,-50,-50),(1,1,1))

# choose an interpolation model
model = Kriging(GaussianVariogram(range=35.))

# perform interpolation over grid
interp = geotable |> Interpolate(grid, model)

viz(interp.geometry, color=interp.Temp,colorbar=true)

cc=rand(Point3, 10, crs=LatLonAlt);


rand(Point, 10)
rand(Triangle, 10)
rand(Point, 10, crs=Cartesian2D)
cc=rand(LatLon, 100)

table=(; Temp=rand(100), Pressure=rand(100), RH=rand(100))
geot=georef(table,cv;crs=LatLon)

viz(geot.geometry, color=geot.Temp)

cv= [(ustrip(x.lat), ustrip(x.lon)) for x in cc]

fig = Figure()
ga = GeoAxis(
    fig[1, 1],
    dest="+proj=ortho",
    title = "Orthographic projection",
    xticklabelcolor=:red, xgridcolor=:red,
)

field=rand(length(unique(cv[:,1])),length(unique(cv[:,2])));
linear_interpolation(sort(unique(cv)),rand(length(unique(cv))))

sp = surface!(ga,unique(cv[:,1]),unique(cv[:,2]), zeros(length(unique(cv[:,1])),length(unique(cv[:,2]))); color=rand(length(unique(cv[:,1])),length(unique(cv[:,2]))), shading = NoShading, colormap=:rainbow_bgyrm_35_85_c69_n256)
cb = Colorbar(fig[1, 2], sp)
fig


lons = -180:180
lats = -90:90
field = [exp(cosd(l)) + 3(y/90) for l in lons, y in lats]
