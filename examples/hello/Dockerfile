FROM julia:1.5.3

RUN julia -e 'using Pkg; Pkg.add(url="https://github.com/goropikari/AWSLambdaRuntimeInterfaceClients.jl"); Pkg.precompile()'


WORKDIR /var/task
COPY hello.jl .

ENTRYPOINT ["/usr/local/julia/bin/julia", "hello.jl"]
