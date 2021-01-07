#= in the name of Almighty
Assalamu Alaikum
ONEinitialsetup:
- Julia version: 1.3.1
- Author: nagoor
- Date: 2020-07-06
=#
println("in the name of Almighty ")
import Pkg;
ENV["PYTHON"]= "/usr/bin/python2.7"   # check your python path for rospy version
Pkg.add("PyCall")
Pkg.build("PyCall")
Pkg.add("PyPlot")
Pkg.build("PyPlot")
Pkg.add("RobotOS")
Pkg.build("RobotOS")
Pkg.add("DataFrames")
Pkg.add("LightGraphs")
Pkg.add("SimpleWeightedGraphs")
Pkg.add("OrderedCollections")
Pkg.add("HDF5")
Pkg.add("JLD")
