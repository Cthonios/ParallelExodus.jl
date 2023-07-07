using ParallelExodus
using Documenter

DocMeta.setdocmeta!(ParallelExodus, :DocTestSetup, :(using ParallelExodus); recursive=true)

makedocs(;
    modules=[ParallelExodus],
    authors="Craig M. Hamel <cmhamel32@gmail.com> and contributors",
    repo="https://github.com/cmhamel/ParallelExodus.jl/blob/{commit}{path}#{line}",
    sitename="ParallelExodus.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://cmhamel.github.io/ParallelExodus.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/cmhamel/ParallelExodus.jl",
    devbranch="main",
)
