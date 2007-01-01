require wsdl/info

= class WSDL::SOAP::Operation::OperationInfo < Object

== Class Methods

--- new(style, op_name, optype_name, headerparts, bodyparts, faultpart, soapaction)

== Instance Methods

--- bodyparts

--- faultpart

--- headerparts

--- op_name

--- optype_name

--- soapaction

--- style


= class WSDL::SOAP::Operation < WSDL::Info

== Class Methods

--- new


== Instance Methods

--- input_info

--- operation_style

--- output_info

--- parse_attr(attr, value)

--- parse_element(element)

--- soapaction

--- style


== Private Instance Methods

--- parent_binding

--- param_info(name_info, param)

