= class Net::IMAP < Object

Copyright (C) 2000  Shugo Maeda <shugo@ruby-lang.org>

This library is distributed under the terms of the Ruby license.
You can freely distribute/modify this library.

  * [[unknown:"net/imap"/Net::IMAP]]
  * [[unknown:"net/imap"/Net::IMAP::ContinuationRequest]]
  * [[unknown:"net/imap"/Net::IMAP::UntaggedResponse]]
  * [[unknown:"net/imap"/Net::IMAP::TaggedResponse]]
  * [[unknown:"net/imap"/Net::IMAP::ResponseText]]
  * [[unknown:"net/imap"/Net::IMAP::ResponseCode]]
  * [[unknown:"net/imap"/Net::IMAP::MailboxList]]
  * [[unknown:"net/imap"/Net::IMAP::MailboxQuota]]
  * [[unknown:"net/imap"/Net::IMAP::MailboxQuotaRoot]]
  * [[unknown:"net/imap"/Net::IMAP::MailboxACLItem]]
  * [[unknown:"net/imap"/Net::IMAP::StatusData]]
  * [[unknown:"net/imap"/Net::IMAP::FetchData]]
  * [[unknown:"net/imap"/Net::IMAP::Envelope]]
  * [[unknown:"net/imap"/Net::IMAP::Address]]
  * [[unknown:"net/imap"/Net::IMAP::ContentDisposition]]
  * [[unknown:"net/imap"/Net::IMAP::BodyTypeBasic]]
  * [[unknown:"net/imap"/Net::IMAP::BodyTypeText]]
  * [[unknown:"net/imap"/Net::IMAP::BodyTypeMessage]]
  * [[unknown:"net/imap"/Net::IMAP::BodyTypeMultipart]]
  * [[unknown:"net/imap"/References]]

Net::IMAP implements Internet Message Access Protocol (IMAP) clients.
(The protocol is described in [[unknown:"net/imap"/[IMAP]]].)

Net::IMAP supports multiple commands. For example,

  imap = Net::IMAP.new("imap.foo.net", "imap2")
  imap.authenticate("cram-md5", "bar", "password")
  imap.select("inbox")
  fetch_thread = Thread.start { imap.fetch(1..-1, "UID") }
  search_result = imap.search(["BODY", "hello"])
  fetch_result = fetch_thread.value
  imap.disconnect

This script invokes the FETCH command and the SEARCH command concurrently.


=== References

  * [IMAP]
    M. Crispin, "INTERNET MESSAGE ACCESS PROTOCOL - VERSION 4rev1",
    RFC 2060, December 1996.

  * [LANGUAGE-TAGS]
    Alvestrand, H., "Tags for the Identification of
    Languages", RFC 1766, March 1995.

  * [MD5]
    Myers, J., and M. Rose, "The Content-MD5 Header Field", RFC
    1864, October 1995.

  * [MIME-IMB]
    Freed, N., and N. Borenstein, "MIME (Multipurpose Internet
    Mail Extensions) Part One: Format of Internet Message Bodies", RFC
    2045, November 1996.

  * [RFC-822]
    Crocker, D., "Standard for the Format of ARPA Internet Text
    Messages", STD 11, RFC 822, University of Delaware, August 1982.

  * [RFC-2087]
    Myers, J., "IMAP4 QUOTA extension", RFC 2087, January 1997.

  * [RFC-2086]
    Myers, J., "IMAP4 ACL extension", RFC 2086, January 1997.

  * [OSSL]
    http://www.openssl.org

  * [RSSL]
    http://savannah.gnu.org/projects/rubypki

== Class Methods

--- new(host, port = 143, usessl = false, certs = nil, verify = false)

Creates a new Net::IMAP object and connects it to the specified
port on the named host.  If usessl is true, then an attempt will
be made to use SSL (now TLS) to connect to the server.  For this
to work OpenSSL[[unknown:"net/imap"/[OSSL]]] and the Ruby OpenSSL[[unknown:"net/imap"/[RSSL]]]
extension need to be installed.  The certs parameter indicates
the path or file containing the CA cert of the server, and the
verify parameter is for the OpenSSL verification callback.

--- debug

Returns the debug mode.

--- debug=(val)

Sets the debug mode.

--- add_authenticator(auth_type, authenticator)
      Adds an authenticator for Net::IMAP#authenticate.

=== Methods

--- greeting

Returns an initial greeting response from the server.

--- responses

Returns recorded untagged responses.

ex).

  imap.select("inbox")
  p imap.responses["EXISTS"][-1]
  #=> 2
  p imap.responses["UIDVALIDITY"][-1]
  #=> 968263756

--- disconnect

Disconnects from the server.

--- capability

Sends a CAPABILITY command, and returns a listing of
capabilities that the server supports.

--- noop

Sends a NOOP command to the server. It does nothing.

--- logout

Sends a LOGOUT command to inform the server that the client is
done with the connection.

--- authenticate(auth_type, arg...)

Sends an AUTEHNTICATE command to authenticate the client.
The auth_type parameter is a string that represents
the authentication mechanism to be used. Currently Net::IMAP
supports "LOGIN" and "CRAM-MD5" for the auth_type.

ex).

  imap.authenticate('LOGIN', user, password)

--- login(user, password)

Sends a LOGIN command to identify the client and carries
the plaintext password authenticating this user.

--- select(mailbox)

Sends a SELECT command to select a mailbox so that messages
in the mailbox can be accessed.

--- examine(mailbox)

Sends a EXAMINE command to select a mailbox so that messages
in the mailbox can be accessed. However, the selected mailbox
is identified as read-only.

--- create(mailbox)

Sends a CREATE command to create a new mailbox.

--- delete(mailbox)

Sends a DELETE command to remove the mailbox.

--- rename(mailbox, newname)

Sends a RENAME command to change the name of the mailbox to
the newname.

--- subscribe(mailbox)

Sends a SUBSCRIBE command to add the specified mailbox name to
the server's set of "active" or "subscribed" mailboxes.

--- unsubscribe(mailbox)

Sends a UNSUBSCRIBE command to remove the specified mailbox name
from the server's set of "active" or "subscribed" mailboxes.

--- list(refname, mailbox)

Sends a LIST command, and returns a subset of names from
the complete set of all names available to the client.
The return value is an array of [[unknown:"net/imap"/Net::IMAP::MailboxList]].

ex).

  imap.create("foo/bar")
  imap.create("foo/baz")
  p imap.list("", "foo/%")
  #=> [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]

--- lsub(refname, mailbox)

Sends a LSUB command, and returns a subset of names from the set
of names that the user has declared as being "active" or
"subscribed".
The return value is an array of [[unknown:"net/imap"/Net::IMAP::MailboxList]].

--- status(mailbox, attr)

Sends a STATUS command, and returns the status of the indicated
mailbox.
return value is a hash of attributes.

ex).

  p imap.status("inbox", ["MESSAGES", "RECENT"])
  #=> {"RECENT"=>0, "MESSAGES"=>44}

--- append(mailbox, message, flags = nil, date_time = nil)

Sends a APPEND command to append the message to the end of
the mailbox.

ex).

  imap.append("inbox", <<EOF.gsub(/\n/, "\r\n"), [:Seen], Time.now)
  Subject: hello
  From: shugo@ruby-lang.org
  To: shugo@ruby-lang.org
  
  hello world
  EOF

--- check

Sends a CHECK command to request a checkpoint of the currently
selected mailbox.

--- close

Sends a CLOSE command to close the currently selected mailbox.
The CLOSE command permanently removes from the mailbox all
messages that have the \Deleted flag set.

--- expunge

Sends a EXPUNGE command to permanently remove from the currently
selected mailbox all messages that have the \Deleted flag set.

--- search(keys, charset = nil)
--- uid_search(keys, charset = nil)

Sends a SEARCH command to search the mailbox for messages that
match the given searching criteria, and returns message sequence
numbers (search) or unique identifiers (uid_search).

ex).

  p imap.search(["SUBJECT", "hello"])
  #=> [1, 6, 7, 8]
  p imap.search('SUBJECT "hello"')
  #=> [1, 6, 7, 8]

--- fetch(set, attr)
--- uid_fetch(set, attr)

Sends a FETCH command to retrieve data associated with a message
in the mailbox. the set parameter is a number or an array of
numbers or a Range object. the number is a message sequence
number (fetch) or a unique identifier (uid_fetch).
The return value is an array of [[unknown:"net/imap"/Net::IMAP::FetchData]].

ex).

  p imap.fetch(6..8, "UID")
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"UID"=>98}>, #<Net::IMAP::FetchData seqno=7, attr={"UID"=>99}>, #<Net::IMAP::FetchData seqno=8, attr={"UID"=>100}>]
  p imap.fetch(6, "BODY[HEADER.FIELDS (SUBJECT)]")
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"BODY[HEADER.FIELDS (SUBJECT)]"=>"Subject: test\r\n\r\n"}>]
  data = imap.uid_fetch(98, ["RFC822.SIZE", "INTERNALDATE"])[0]
  p data.seqno
  #=> 6
  p data.attr["RFC822.SIZE"]
  #=> 611
  p data.attr["INTERNALDATE"]
  #=> "12-Oct-2000 22:40:59 +0900"
  p data.attr["UID"]
  #=> 98

--- store(set, attr, flags)
--- uid_store(set, attr, flags)

Sends a STORE command to alter data associated with a message
in the mailbox. the set parameter is a number or an array of
numbers or a Range object. the number is a message sequence
number (store) or a unique identifier (uid_store).
The return value is an array of [[unknown:"net/imap"/Net::IMAP::FetchData]].

ex).

  p imap.store(6..8, "+FLAGS", [:Deleted])
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=7, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=8, attr={"FLAGS"=>[:Seen, :Deleted]}>]

--- copy(set, mailbox)
--- uid_copy(set, mailbox)

Sends a COPY command to copy the specified message(s) to the end
of the specified destination mailbox. the set parameter is
a number or an array of numbers or a Range object. the number is
a message sequence number (copy) or a unique identifier (uid_copy).

--- sort(sort_keys, search_keys, charset)
--- uid_sort(sort_keys, search_keys, charset)

Sends a SORT command to sort messages in the mailbox.

ex).

  p imap.sort(["FROM"], ["ALL"], "US-ASCII")
  #=> [1, 2, 3, 5, 6, 7, 8, 4, 9]
  p imap.sort(["DATE"], ["SUBJECT", "hello"], "US-ASCII")
  #=> [6, 7, 8, 1]

--- setquota(mailbox, quota)

Sends a SETQUOTA command along with the specified mailbox and
quota.  If quota is nil, then quota will be unset for that
mailbox.  Typically one needs to be logged in as server admin
for this to work.  The IMAP quota commands are described in
[[unknown:"net/imap"/[RFC-2087]]].

--- getquota(mailbox)

Sends the GETQUOTA command along with specified mailbox.
If this mailbox exists, then an array containing a
[[unknown:"net/imap"/Net::IMAP::MailboxQuota]] object is returned.  This
command generally is only available to server admin.

--- getquotaroot(mailbox)

Sends the GETQUOTAROOT command along with specified mailbox.
This command is generally available to both admin and user.
If mailbox exists, returns an array containing objects of
[[unknown:"net/imap"/Net::IMAP::MailboxQuotaRoot]] and [[unknown:"net/imap"/Net::IMAP::MailboxQuota]].

--- setacl(mailbox, user, rights)

Sends the SETACL command along with mailbox, user and the
rights that user is to have on that mailbox.  If rights is nil,
then that user will be stripped of any rights to that mailbox.
The IMAP ACL commands are described in [[unknown:"net/imap"/[RFC-2086]]].

--- getacl(mailbox)

Send the GETACL command along with specified mailbox.
If this mailbox exists, an array containing objects of
[[unknown:"net/imap"/Net::IMAP::MailboxACLItem]] will be returned.

--- add_response_handler(handler = Proc.new)

Adds a response handler.

ex).
  imap.add_response_handler do |resp|
    p resp
  end

--- remove_response_handler(handler)

Removes the response handler.

--- response_handlers

Returns all response handlers.

= class Net::IMAP::ContinuationRequest < Struct

Net::IMAP::ContinuationRequest represents command continuation requests.

The command continuation request response is indicated by a "+" token
instead of a tag.  This form of response indicates that the server is
ready to accept the continuation of a command from the client.  The
remainder of this response is a line of text.

  continue_req    ::= "+" SPACE (resp_text / base64)

== Instance Methods

--- data

Returns the data (Net::IMAP::ResponseText).

--- raw_data

Returns the raw data string.

= class Net::IMAP::UntaggedResponse < Struct

Net::IMAP::UntaggedResponse represents untagged responses.

Data transmitted by the server to the client and status responses
that do not indicate command completion are prefixed with the token
"*", and are called untagged responses.

  response_data   ::= "*" SPACE (resp_cond_state / resp_cond_bye /
                      mailbox_data / message_data / capability_data)

== Instance Methods

--- name

Returns the name such as "FLAGS", "LIST", "FETCH"....

--- data

Returns the data such as an array of flag symbols,
a [[unknown:"net/imap"/Net::IMAP::MailboxList]] object....

--- raw_data

Returns the raw data string.

= class Net::IMAP::TaggedResponse < struct

Net::IMAP::TaggedResponse represents tagged responses.

The server completion result response indicates the success or
failure of the operation.  It is tagged with the same tag as the
client command which began the operation.

  response_tagged ::= tag SPACE resp_cond_state CRLF
  
  tag             ::= 1*<any ATOM_CHAR except "+">
  
  resp_cond_state ::= ("OK" / "NO" / "BAD") SPACE resp_text

== Instance Methods

--- tag

Returns the tag.

--- name

Returns the name. the name is one of "OK", "NO", "BAD".

--- data

Returns the data. See [[unknown:"net/imap"/Net::IMAP::ResponseText]].

--- raw_data

Returns the raw data string.

= class Net::IMAP::ResponseText < Struct

Net::IMAP::ResponseText represents texts of responses.
The text may be prefixed by the response code.

  resp_text       ::= ["[" resp_text_code "]" SPACE] (text_mime2 / text)
                      ;; text SHOULD NOT begin with "[" or "="

== Instance Methods

--- code

Returns the response code. See [[unknown:"net/imap"/Net::IMAP::ResponseCode]].

--- text

Returns the text.

= class Net::IMAP::ResponseCode < Struct

Net::IMAP::ResponseCode represents response codes.

  resp_text_code  ::= "ALERT" / "PARSE" /
                      "PERMANENTFLAGS" SPACE "(" #(flag / "\*") ")" /
                      "READ-ONLY" / "READ-WRITE" / "TRYCREATE" /
                      "UIDVALIDITY" SPACE nz_number /
                      "UNSEEN" SPACE nz_number /
                      atom [SPACE 1*<any TEXT_CHAR except "]">]

== Instance Methods

--- name

Returns the name such as "ALERT", "PERMANENTFLAGS", "UIDVALIDITY"....

--- data

Returns the data if it exists.

= class Net::IMAP::MailboxList < Struct

Net::IMAP::MailboxList represents contents of the LIST response.

  mailbox_list    ::= "(" #("\Marked" / "\Noinferiors" /
                      "\Noselect" / "\Unmarked" / flag_extension) ")"
                      SPACE (<"> QUOTED_CHAR <"> / nil) SPACE mailbox


== Instance Methods

--- attr

Returns the name attributes. Each name attribute is a symbol
capitalized by String#capitalize, such as :Noselect (not :NoSelect).

--- delim

Returns the hierarchy delimiter

--- name

Returns the mailbox name.

= class Net::IMAP::MailboxQuota < Struct

Net::IMAP::MailboxQuota represents contents of GETQUOTA response.
This object can also be a response to GETQUOTAROOT.  In the syntax
specification below, the delimiter used with the "#" construct is a
single space (SPACE).

   quota_list      ::= "(" #quota_resource ")"
   
   quota_resource  ::= atom SPACE number SPACE number
   
   quota_response  ::= "QUOTA" SPACE astring SPACE quota_list

== Instance Methods

--- mailbox

The mailbox with the associated quota.

--- usage

Current storage usage of mailbox.

--- quota

Quota limit imposed on mailbox.

= class Net::IMAP::MailboxQuotaRoot < Struct

Net::IMAP::MailboxQuotaRoot represents part of the GETQUOTAROOT
response. (GETQUOTAROOT can also return Net::IMAP::MailboxQuota.)

  quotaroot_response
                  ::= "QUOTAROOT" SPACE astring *(SPACE astring)

== Instance Methods

--- mailbox

The mailbox with the associated quota.

--- quotaroots

Zero or more quotaroots that effect the quota on the
specified mailbox.

= class Net::IMAP::MailboxACLItem < Struct

Net::IMAP::MailboxACLItem represents response from GETACL.

  acl_data        ::= "ACL" SPACE mailbox *(SPACE identifier SPACE
                       rights)
  
  identifier      ::= astring
  
  rights          ::= astring

== Instance Methods

--- user

Login name that has certain rights to the mailbox
that was specified with the getacl command.

--- rights

The access rights the indicated user has to the
mailbox.

= class Net::IMAP::StatusData < Object

Net::IMAP::StatusData represents contents of the STATUS response.

== Instance Methods

--- mailbox

Returns the mailbox name.

--- attr

Returns a hash. Each key is one of "MESSAGES", "RECENT", "UIDNEXT",
"UIDVALIDITY", "UNSEEN". Each value is a number.

= class Net::IMAP::FetchData < Object

Net::IMAP::FetchData represents contents of the FETCH response.


== Instance Methods

--- seqno

Returns the message sequence number.
(Note: not the unique identifier, even for the UID command response.)

--- attr

Returns a hash. Each key is a data item name, and each value is
its value.

The current data items are:

  : BODY
      A form of BODYSTRUCTURE without extension data.
  : BODY[<section>]<<origin_octet>>
      A string expressing the body contents of the specified section.
  : BODYSTRUCTURE
      An object that describes the [[unknown:"net/imap"/[MIME-IMB]]] body structure of a message.
      See [[unknown:"net/imap"/Net::IMAP::BodyTypeBasic]], [[unknown:"net/imap"/Net::IMAP::BodyTypeText]],
      [[unknown:"net/imap"/Net::IMAP::BodyTypeMessage]], [[unknown:"net/imap"/Net::IMAP::BodyTypeMultipart]].
      : ENVELOPE
          A [[unknown:"net/imap"/Net::IMAP::Envelope]] object that describes the envelope
          structure of a message.
      : FLAGS
          A array of flag symbols that are set for this message. flag symbols
          are capitalized by String#capitalize.
      : INTERNALDATE
          A string representing the internal date of the message.
      : RFC822
          Equivalent to BODY[].
      : RFC822.HEADER
          Equivalent to BODY.PEEK[HEADER].
      : RFC822.SIZE
          A number expressing the [[unknown:"net/imap"/[RFC-822]]] size of the message.
      : RFC822.TEXT
          Equivalent to BODY[TEXT].
      : UID
          A number expressing the unique identifier of the message.

= class Net::IMAP::Envelope < Struct

Net::IMAP::Envelope represents envelope structures of messages.

== Instance Methods

--- date

Retunns a string that represents the date.

--- subject

Retunns a string that represents the subject.

--- from

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the from.

--- sender

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the sender.

--- reply_to

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the reply-to.

--- to

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the to.

--- cc

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the cc.

--- bcc

Retunns an array of [[unknown:"net/imap"/Net::IMAP::Address]] that represents the bcc.

--- in_reply_to

Retunns a string that represents the in-reply-to.

--- message_id

Retunns a string that represents the message-id.

= class Net::IMAP::Address < Struct

[[unknown:"net/imap"/Net::IMAP::Address]] represents electronic mail addresses.

== Instance Methods

--- name

Returns the phrase from [[unknown:"net/imap"/[RFC-822]]] mailbox.

--- route

Returns the route from [[unknown:"net/imap"/[RFC-822]]] route-addr.

--- mailbox

nil indicates end of [[unknown:"net/imap"/[RFC-822]]] group.
If non-nil and host is nil, returns [[unknown:"net/imap"/[RFC-822]]] group name.
Otherwise, returns [[unknown:"net/imap"/[RFC-822]]] local-part

--- host

nil indicates [[unknown:"net/imap"/[RFC-822]]] group syntax.
Otherwise, returns [[unknown:"net/imap"/[RFC-822]]] domain name.

= class Net::IMAP::ContentDisposition < Struct

Net::IMAP::ContentDisposition represents Content-Disposition fields.

== Instance Methods

--- dsp_type

Returns the disposition type.

--- param

Returns a hash that represents parameters of the Content-Disposition
field.

= class Net::IMAP::BodyTypeBasic < Struct

Net::IMAP::BodyTypeBasic represents basic body structures of messages.


== Instance Methods

--- media_type

Returns the content media type name as defined in [[unknown:"net/imap"/[MIME-IMB]]].

--- subtype

Returns the content subtype name as defined in [[unknown:"net/imap"/[MIME-IMB]]].

--- param

Returns a hash that represents parameters as defined in
[[unknown:"net/imap"/[MIME-IMB]]].

--- content_id

Returns a string giving the content id as defined in [[unknown:"net/imap"/[MIME-IMB]]].

--- description

Returns a string giving the content description as defined in
[[unknown:"net/imap"/[MIME-IMB]]].

--- encoding

Returns a string giving the content transfer encoding as defined in
[[unknown:"net/imap"/[MIME-IMB]]].

--- size

Returns a number giving the size of the body in octets.

--- md5

Returns a string giving the body MD5 value as defined in [[unknown:"net/imap"/[MD5]]].

--- disposition

Returns a [[unknown:"net/imap"/Net::IMAP::ContentDisposition]] object giving
the content disposition.

--- language

Returns a string or an array of strings giving the body
language value as defined in [LANGUAGE-TAGS].

--- extension

Returns extension data.

--- multipart?

Returns false.

= class Net::IMAP::BodyTypeText < Struct

Net::IMAP::BodyTypeText represents TEXT body structures of messages.

== Instance Methods

--- lines

Returns the size of the body in text lines.

And Net::IMAP::BodyTypeText has all methods of [[unknown:"net/imap"/Net::IMAP::BodyTypeBasic]].

= class Net::IMAP::BodyTypeMessage < Struct

Net::IMAP::BodyTypeMessage represents MESSAGE/RFC822 body structures of messages.

== Instance Methods

--- envelope

Returns a [[unknown:"net/imap"/Net::IMAP::Envelope]] giving the envelope structure.

--- body

Returns an object giving the body structure.

And Net::IMAP::BodyTypeMessage has all methods of [[unknown:"net/imap"/Net::IMAP::BodyTypeText]].

= class Net::IMAP::BodyTypeMultipart < Struct

== Instance Methods

--- media_type

Returns the content media type name as defined in [[unknown:"net/imap"/[MIME-IMB]]].

--- subtype

Returns the content subtype name as defined in [[unknown:"net/imap"/[MIME-IMB]]].

--- parts

Returns multiple parts.

--- param

Returns a hash that represents parameters as defined in
[[unknown:"net/imap"/[MIME-IMB]]].

--- disposition

Returns a [[unknown:"net/imap"/Net::IMAP::ContentDisposition]] object giving
the content disposition.

--- language

Returns a string or an array of strings giving the body
language value as defined in [LANGUAGE-TAGS].

--- extension

Returns extension data.

--- multipart?

Returns true.
