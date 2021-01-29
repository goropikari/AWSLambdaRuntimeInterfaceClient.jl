FROM julia:1.5.3

WORKDIR /var/task
ENV JULIA_DEPOT_PATH /var/task/.julia

COPY Project.toml .
COPY Manifest.toml .
COPY hello.jl .

RUN julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"

ENTRYPOINT ["/usr/local/julia/bin/julia", "--project=.", "hello.jl"]
