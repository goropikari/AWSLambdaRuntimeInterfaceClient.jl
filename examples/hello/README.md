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
