= module WEBrick::HTTPStatus

== Singleton Methods

--- [](code)
#@todo

== Module Functions

--- reason_phrase(code)
#@todo

--- info?(code)
#@todo

--- success?(code)
#@todo

--- redirect?(code)
#@todo

--- error?(code)
#@todo

--- client_error?(code)
#@todo

--- server_error?(code)
#@todo

== Constants

--- StatusMessage
#@todo

--- CodeToError
#@todo

--- RC_CONTINUE
--- RC_SWITCHING_PROTOCOLS
--- RC_OK
--- RC_CREATED
--- RC_ACCEPTED
--- RC_NON_AUTHORITATIVE_INFORMATION
--- RC_NO_CONTENT
--- RC_RESET_CONTENT
--- RC_PARTIAL_CONTENT
--- RC_MULTIPLE_CHOICES
--- RC_MOVED_PERMANENTLY
--- RC_FOUND
--- RC_SEE_OTHER
--- RC_NOT_MODIFIED
--- RC_USE_PROXY
--- RC_TEMPORARY_REDIRECT
--- RC_BAD_REQUEST
--- RC_UNAUTHORIZED
--- RC_PAYMENT_REQUIRED
--- RC_FORBIDDEN
--- RC_NOT_FOUND
--- RC_METHOD_NOT_ALLOWED
--- RC_NOT_ACCEPTABLE
--- RC_PROXY_AUTHENTICATION_REQUIRED
--- RC_REQUEST_TIMEOUT
--- RC_CONFLICT
--- RC_GONE
--- RC_LENGTH_REQUIRED
--- RC_PRECONDITION_FAILED
--- RC_REQUEST_ENTITY_TOO_LARGE
--- RC_REQUEST_URI_TOO_LARGE
--- RC_UNSUPPORTED_MEDIA_TYPE
--- RC_REQUEST_RANGE_NOT_SATISFIABLE
--- RC_EXPECTATION_FAILED
--- RC_INTERNAL_SERVER_ERROR
--- RC_NOT_IMPLEMENTED
--- RC_BAD_GATEWAY
--- RC_SERVICE_UNAVAILABLE
--- RC_GATEWAY_TIMEOUT
--- RC_HTTP_VERSION_NOT_SUPPORTED
#@todo







= class WEBrick::HTTPStatus::Status < StandardError
= class WEBrick::HTTPStatus::Info < WEBrick::HTTPStatus::Status
= class WEBrick::HTTPStatus::Success < WEBrick::HTTPStatus::Status
= class WEBrick::HTTPStatus::Redirect < WEBrick::HTTPStatus::Status
= class WEBrick::HTTPStatus::Error < WEBrick::HTTPStatus::Status
= class WEBrick::HTTPStatus::ClientError < WEBrick::HTTPStatus::Error
= class WEBrick::HTTPStatus::ServerError < WEBrick::HTTPStatus::Error

= class WEBrick::HTTPStatus::EOFError < StanderdError

= class WEBrick::HTTPStatus::Continue < WEBrick::HTTPStatus::Info
= class WEBrick::HTTPStatus::SwitchingProtocols < WEBrick::HTTPStatus::Info

= class WEBrick::HTTPStatus::OK < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::Created < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::Accepted < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::NonAuthoritativeInformation < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::NoContent < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::ResetContent < WEBrick::HTTPStatus::Success
= class WEBrick::HTTPStatus::PartialContent < WEBrick::HTTPStatus::Success

= class WEBrick::HTTPStatus::MultipleChoices < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::MovedPermanently < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::Found < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::SeeOther < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::NotModified < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::UseProxy < WEBrick::HTTPStatus::Redirect
= class WEBrick::HTTPStatus::TemporaryRedirect < WEBrick::HTTPStatus::Redirect

= class WEBrick::HTTPStatus::BadRequest < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::Unauthorized < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::PaymentRequired < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::Forbidden < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::NotFound < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::MethodNotAllowed < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::NotAcceptable < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::ProxyAuthenticationRequired < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::RequestTimeout < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::Conflict < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::Gone < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::LengthRequired < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::PreconditionFailed < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::RequestEntityTooLarge < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::RequestURITooLarge < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::UnsupportedMediaType < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::RequestRangeNotSatisfiable < WEBrick::HTTPStatus::ClientError
= class WEBrick::HTTPStatus::ExpectationFailed < WEBrick::HTTPStatus::ClientError

= class WEBrick::HTTPStatus::InternalServerError < WEBrick::HTTPStatus::ServerError
= class WEBrick::HTTPStatus::NotImplemented < WEBrick::HTTPStatus::ServerError
= class WEBrick::HTTPStatus::BadGateway < WEBrick::HTTPStatus::ServerError
= class WEBrick::HTTPStatus::ServiceUnavailable < WEBrick::HTTPStatus::ServerError
= class WEBrick::HTTPStatus::GatewayTimeout < WEBrick::HTTPStatus::ServerError
= class WEBrick::HTTPStatus::HTTPVersionNotSupported < WEBrick::HTTPStatus::ServerError
