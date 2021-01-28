import AWSLambdaRuntimeInterfaceClient
const ric = AWSLambdaRuntimeInterfaceClient

# Make handler
function handler(event, context)
    return "Hello World!"
end

# Initialize RIC
ric.init()

# Pass handler to RIC and execute
ric.execute(handler)
