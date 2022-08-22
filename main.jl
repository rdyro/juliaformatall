using JuliaFormatter, JSON

####################################################################################################

function files_by_filetype(ft, dirname)
  files = reduce(vcat, map(triplet -> joinpath.(triplet[1], triplet[3]), walkdir(dirname)))
  return filter(file -> splitext(file)[2] == ft, files)
end

####################################################################################################

function main(dirname::Union{String,Nothing}=nothing)::Nothing
  options =
    Dict([:indent => 2, :margin => 100, :always_for_in => true, :whitespace_in_kwargs => false])
  if haskey(ENV, "JULIAFORMATALL_CONFIG")
    user_config = JSON.parse(ENV["JULIAFORMATALL_CONFIG"])
    merge!(options, Dict{Symbol,Any}(Symbol(pair.first) => pair.second for pair in user_config))
  end

  (dirname == nothing) && (dirname = pwd())
  all_files = files_by_filetype(".jl", dirname)
  for file in all_files
    try
      println("Formatting file: $(file)")
      format_file(file; options...)
    catch e
      println("Error ocurred in $(file)")
      println(e)
    end
  end

  all_notebooks = files_by_filetype(".ipynb", dirname)
  for notebook_file in all_notebooks
    anything_changed, notebook = false, nothing
    try
      notebook = JSON.parse(read(notebook_file, String))
      if get(get(get(notebook, "metadata", Dict()), "kernelspec", Dict()), "language", "") ==
         "julia"
        println("Formatting notebook: $(notebook_file)")
        for cell in get(notebook, "cells", Dict())
          formatted = format_text(join(cell["source"], ""); options...)
          formatted = [line for line in split(formatted, "\n") if length(line) > 0]
          formatted = map(line -> "$line\n", formatted)
          cell["source"] = formatted
          anything_changed = true
        end
      end
    catch e
      println("Error ocurred in $(notebook_file)")
      println(e)
      println()
    end
    if anything_changed
      open(notebook_file, "w") do f
        write(f, JSON.json(notebook))
      end
    end
  end
end

####################################################################################################
