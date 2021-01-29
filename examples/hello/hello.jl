import AWSLambdaRuntimeInterfaceClient
const ric = AWSLambdaRuntimeInterfaceClient

import JSON

# Make handler
function handler(event, context)
    return "Hello World! $(JSON.json(event))"
end

# Initialize RIC
ric.init()

# Pass handler to RIC and execute
ric.execute(handler)
