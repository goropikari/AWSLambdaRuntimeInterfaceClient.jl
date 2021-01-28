import AWSLambdaRuntimeInterfaceClients
const ric = AWSLambdaRuntimeInterfaceClients

# Make handler
function handler(event, context)
    return "Hello World!"
end

# Initialize RIC
ric.init()

# Pass handler to RIC and execute
ric.execute(handler)
