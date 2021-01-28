module AWSLambdaRuntimeInterfaceClients

import HTTP
import JSON

function init()
    global AWS_LAMBDA_RUNTIME_API = ENV["AWS_LAMBDA_RUNTIME_API"]
    global BASE_URL = "http://$(AWS_LAMBDA_RUNTIME_API)/2018-06-01/runtime"
end

function next_invocation()
    res = HTTP.get("$(BASE_URL)/invocation/next")
    body = String(res.body)
    headers = Dict(res.headers)
    return headers, body
end

function invocation_response(request_id, response)
    url = "$(BASE_URL)/invocation/$(request_id)/response"
    headers = ["Content-type" => "application/json"]
    HTTP.post(url, headers, response)
end

function invocation_error(request_id)
    url = "$(BASE_URL)/invocation/$(request_id)/error"
    body = Dict("errorType" => "InvalidEventDataException",
                "errorMessage" => "Error parsing event data.")
    headers = Dict("Content-type" => "application/json",
                   "Lambda-Runtime-Function-Error-Type" => "Unhandled")
    HTTP.post(url, headers, JSON.json(body))
end

function initialization_error()
    body = Dict("errorMessage" => "Failed to load function.",
                "errorType" => "InvalidFunctionException")
    headers = Dict("Content-type" => "application/json",
                   "Lambda-Runtime-Function-Error-Type" => "Unhandled")
    url = "$(BASE_URL)/init/error"
    HTTP.post(url, headers, JSON.json(body))
end

function execute(handler)
    while true
        local state, request_id
        try
            state = :start
            headers, body = next_invocation()
            request_id = headers["Lambda-Runtime-Aws-Request-Id"]
            # @info "Received event" request_id
            state = :received

            response  = handler(body, headers)
            # @info "Got response from handler" response
            state = :handled

            invocation_response(request_id, response)
            # @info "notified lambda runtime"
            state = :finished
        catch ex
            if state == :start
                @error "Unable to receive request" ex
            elseif state == :received
                @error "Unable to handle event" ex request_id
                invocation_error(request_id)
            elseif state == :handled
                @error "Unable to notify lambda runtime (invocation response)" ex request_id
            else
                @error "Unknown state" ex state
            end
        end
    end
end

end # module
