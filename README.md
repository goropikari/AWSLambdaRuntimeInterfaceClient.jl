# AWSLambdaRuntimeInterfaceClient

This is an AWS Lambda Runtime Interface Client for Julia.

Examples are located at [emaples](./examples).

# Usage

First you define a handler function and then pass it to RIC.
Generate `Project.toml` and `Manifest.toml` accordingly.

Because my package is not registered with [JuliaRegistries/General](https://github.com/JuliaRegistries/General), you have to include `Manifest.toml` in order to build container image.
Otherwise, clone this repository, copy to a container image and change `JULIA_DEPOT_PATH` properly.

`hello.jl`
```julia
import AWSLambdaRuntimeInterfaceClient
const ric = AWSLambdaRuntimeInterfaceClient

import JSON

# Make handler
function handler(event, context)
    return "Hello World! $(JSON.json(event))"
end

# Pass handler to RIC and start
ric.start(handler)
```


`Dockerfile`
```dockerfile
FROM julia:1.5.3

WORKDIR /var/task
ENV JULIA_DEPOT_PATH /var/task/.julia

COPY Project.toml .
COPY Manifest.toml .
COPY hello.jl .

RUN julia --project=. -e "using Pkg; Pkg.instantiate(); Pkg.precompile()"

ENTRYPOINT ["/usr/local/julia/bin/julia", "--project=.", "hello.jl"]
```

# Test locally

```bash
$ docker build -t lambda_julia .
$ curl -Lo aws-lambda-rie https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie
$ chmod +x aws-lambda-rie
$ docker run -v $(pwd)/aws-lambda-rie:/aws-lambda-rie \
    -p 9000:8080 \
    --entrypoint=/aws-lambda-rie \
    lambda_julia \
    /usr/local/julia/bin/julia --project=. hello.jl

$ curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"name":"John"}'
Hello World! {"name":"John"}
```

This package is inspired by [tk3369/aws-lambda-container-julia](https://github.com/tk3369/aws-lambda-container-julia).
