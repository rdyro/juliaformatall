# Intro to `juliaformatall`
A julia wrapper utility exposing
[JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) as a shell tool
for multi-file project formatting from the shell.

# Quick install

The install does nothing malicious, but quite aggressively sets all defaults.

```bash
source install
juliaformatall .
```

# Usage

From the shell, give the tool a directory root and it will recursively find all
Julia files and reformat them using [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl).

```bash
juliaformatall
juliaformatall .
juliaformatall path/to/project
```

At first usage, it compiles a static binary using
[PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl), making it
fast and by extensions usable in realtime from the shell.

# Formatting options configuration

[JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl) provides many
syntax formatting configuration options. 

These can be set for this tool by setting an environment variable
`JULIAFORMATALL_CONFIG` to represent a JSON configuration string. 

For example
```
export 
```

# Installation

- copy the `juliaformatall` executable into a directory covered by `$PATH`.
- set the environment variable `JULIAFORMATALL_HOME` to this directory.

    e.g. `export JULIAFORMATALL_HOME="$(pwd)"`

- run `juliaformatall`

The first use will compile a static image and place it into `JULIAFORMATALL_HOME` directory.

# Dependencies

The package depends on
- the [Julia](https://julialang.org) programming language
- the package [JuliaFormatter.jl](https://github.com/domluna/JuliaFormatter.jl)
- the package [PackageCompiler.jl](https://github.com/JuliaLang/PackageCompiler.jl)