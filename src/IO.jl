struct ParallelExodusDatabase{M, I, B, F}
  exo::Cint
end

function ParallelExodusDatabase(file_name::String, mode::String, comm::MPI.Comm, info::MPI.Info)
  @show comm
  if lowercase(mode) == "r"
    exo = @ccall libexodus.ex_open_par_int(
      file_name::Cstring, 
      Exodus.EX_READ::Cint, 
      Exodus.cpu_word_size::Ref{Cint}, 
      Exodus.IO_word_size::Ref{Cint}, 
      Exodus.version_number::Ref{Cfloat}, 
      comm::MPI.Comm, info::MPI.Info,
      Exodus.EX_API_VERS_NODOT::Cint
    )::Cint
    Exodus.exodus_error_check(exo, "ParallelExodus.ParallelExodusDatabase -> libexodus.ex_open_par_int")
    M, I, B = Exodus.exo_int_types(exo)
    F       = Exodus.exo_float_type(exo)
    return ParallelExodusDatabase{M, I, B, F}(exo)
  elseif lowercase(mode) == "w"
    # TODO currently sets defaults of Int32, Int32, Int32, Float64
    exo = @ccall libexodus.ex_create_int(
      file_name::Cstring,
      Exodus.EX_WRITE::Cint,
      Exodus.cpu_word_size::Ref{Cint}, 
      Exodus.IO_word_size::Ref{Cint}, 
      # comm::MPI.Comm, info::MPI.Info,
      Exodus.EX_API_VERS_NODOT::Cint
    )::Cint
    Exodus.exodus_error_check(exo, "ParallelExodus.ParallelExodusDatabase -> libexodus.ex_create_par_int")
    M, I, B = Int32, Int32, Int32
    F       = Float64
    return ParallelExodusDatabase{M, I, B, F}(exo)
  else
    error("Unsupported mode")
  end
end

function Base.close(exo::ParallelExodusDatabase)
  error_code = @ccall libexodus.ex_close(exo.exo::Cint)::Cint
  Exodus.exodus_error_check(error_code, "close -> ex_close")
end