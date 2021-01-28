import AWSLambdaRuntimeInterfaceClients
const ric = AWSLambdaRuntimeInterfaceClients

function handler(event, context)
    return "Hello World!"
end

ric.init()
ric.execute(handler)
