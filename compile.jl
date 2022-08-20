#!/usr/bin/env julia

using PackageCompiler, Pkg

function main(; generator_file = nothing, trace = false)
  Pkg.add("JuliaFormatter")
  trace_file = abspath("$(@__DIR__)/build/trace.jl")
  (!isdir(dirname(trace_file))) && (mkdir(dirname(trace_file)))

  # trace the simple julia compilation #########################################
  if trace
    program_body = """
    using JuliaFormatter
    format_file("$(@__FILE__)")
    format_text(replace(read("$(@__FILE__)", String), r"\\s+" => ""))
    """
    run(Cmd(["julia", "--trace-compile", trace_file, "-e", program_body]))
  end

  # find modules used in the trace #############################################
  modules = Set{String}()
  open(trace_file, "r") do f # regex find all modules in the trace file
    lines = [line for line in readlines(f) if length(line) > 0]
    for line in lines
      m = match(r"[^.]([A-Za-z]+)\.[a-zA-z]", line)
      captures = m == nothing ? String[] : m.captures
      union!(modules, captures)
    end
  end
  delete!(modules, "Main")
  delete!(modules, "Base")
  println("using $(join(modules, ", "))")
  for mod in modules # install modules found in the trace
    try
      Pkg.add(mod)
    catch e
    end
  end

  # write module using directives into the trace file ##########################
  filecontents = read(trace_file, String)
  open(trace_file, "w") do f
    if match(r"^using", filecontents) == nothing
      write(f, "using $(join(modules, ", "))\n")
      if generator_file != nothing
        write(f, "include(\"$(generator_file)\")\n")
      end
    end
    write(f, filecontents)
  end

  # create the actual sysimage.so file #########################################
  create_sysimage(
    ["JuliaFormatter"],
    sysimage_path = abspath("$(@__DIR__)/build/juliaformatall_sysimage.so"),
    precompile_execution_file = trace_file,
  )
  return
end

main(; generator_file = abspath("$(@__DIR__)/main.jl"), trace = true)
