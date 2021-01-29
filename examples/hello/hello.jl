import AWSLambdaRuntimeInterfaceClient
const ric = AWSLambdaRuntimeInterfaceClient

import JSON

# Make handler
function handler(event, context)
    return "Hello World! $(JSON.json(event))"
end

# Pass handler to RIC and start
ric.start(handler)
