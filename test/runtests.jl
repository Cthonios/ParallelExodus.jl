using Exodus
using MPI
using ParallelExodus
using ParallelExodus_jll
using Test

# @testset "ParallelExodus.jl" begin
#   comm = MPI
# end

# first decomp a mesh
# @decomp "test/mesh_test.g" 2

coords = Vector{Matrix{Float64}}(undef, 2)

# now enter MPI land
info = MPI.Info()
MPI.Init()
comm = MPI.COMM_WORLD
# info = MPI.Info()
print("Hello world, I am rank $(MPI.Comm_rank(comm)) of $(MPI.Comm_size(comm))\n")

base_file_name = "test/mesh_test.g"
file_name = base_file_name * ".$(MPI.Comm_size(comm)).$(MPI.Comm_rank(comm))"
println("File name = $file_name")
println("Attepting to open file name = $file_name")

exo = ParallelExodusDatabase(file_name, "r", comm, info)
@show exo

MPI.Barrier(comm)

# trying to create files
print("Hello world, I am rank $(MPI.Comm_rank(comm)) of $(MPI.Comm_size(comm))\n")

base_file_name = "test_output.e"
file_name = base_file_name * ".$(MPI.Comm_size(comm)).$(MPI.Comm_rank(comm))"
println("File name = $file_name")
println("Attepting to create file name = $file_name")

exo = ParallelExodusDatabase(file_name, "w", comm, info)
@show exo

close(exo)

MPI.Barrier(comm)