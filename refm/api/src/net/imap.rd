Net::IMAP implements Internet Message Access Protocol (IMAP) clients.
The IMAP protocol is described in [[RFC:2060]].

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



= class Net::IMAP < Object

IMAP access class.

== Class Methods

--- new(host, port = 143, usessl = false, certs = nil, verify = false)
#@todo

Creates a new Net::IMAP object and connects it to the specified
port on the named host.  If usessl is true, then an attempt will
be made to use SSL (now TLS) to connect to the server.  For this
to work OpenSSL[OSSL] and the Ruby OpenSSL ([[lib:openssl]])
extension need to be installed.  The certs parameter indicates
the path or file containing the CA cert of the server, and the
verify parameter is for the OpenSSL verification callback.

--- debug
#@todo

Returns the debug mode.

--- debug=(val)
#@todo

Sets the debug mode.

--- add_authenticator(auth_type, authenticator)
#@todo

Adds an authenticator for Net::IMAP#authenticate.

--- decode_utf7
#@todo

--- encode_utf7
#@todo

== Methods

--- greeting
#@todo

Returns an initial greeting response from the server.

--- responses
#@todo

Returns recorded untagged responses.

ex).

  imap.select("inbox")
  p imap.responses["EXISTS"][-1]
  #=> 2
  p imap.responses["UIDVALIDITY"][-1]
  #=> 968263756

--- disconnect
#@todo

Disconnects from the server.

--- capability
#@todo

Sends a CAPABILITY command, and returns a listing of
capabilities that the server supports.

--- noop
#@todo

Sends a NOOP command to the server. It does nothing.

--- logout
#@todo

Sends a LOGOUT command to inform the server that the client is
done with the connection.

--- authenticate(auth_type, arg...)
#@todo

Sends an AUTEHNTICATE command to authenticate the client.
The auth_type parameter is a string that represents
the authentication mechanism to be used. Currently Net::IMAP
supports "LOGIN" and "CRAM-MD5" for the auth_type.

ex).

  imap.authenticate('LOGIN', user, password)

--- login(user, password)
#@todo

Sends a LOGIN command to identify the client and carries
the plaintext password authenticating this user.

--- select(mailbox)
#@todo

Sends a SELECT command to select a mailbox so that messages
in the mailbox can be accessed.

--- examine(mailbox)
#@todo

Sends a EXAMINE command to select a mailbox so that messages
in the mailbox can be accessed. However, the selected mailbox
is identified as read-only.

--- create(mailbox)
#@todo

Sends a CREATE command to create a new mailbox.

--- delete(mailbox)
#@todo

Sends a DELETE command to remove the mailbox.

--- rename(mailbox, newname)
#@todo

Sends a RENAME command to change the name of the mailbox to
the newname.

--- subscribe(mailbox)
#@todo

Sends a SUBSCRIBE command to add the specified mailbox name to
the server's set of "active" or "subscribed" mailboxes.

--- unsubscribe(mailbox)
#@todo

Sends a UNSUBSCRIBE command to remove the specified mailbox name
from the server's set of "active" or "subscribed" mailboxes.

--- list(refname, mailbox)
#@todo

Sends a LIST command, and returns a subset of names from
the complete set of all names available to the client.
The return value is an array of [[c:Net::IMAP::MailboxList]].

ex).

  imap.create("foo/bar")
  imap.create("foo/baz")
  p imap.list("", "foo/%")
  #=> [#<Net::IMAP::MailboxList attr=[:Noselect], delim="/", name="foo/">, #<Net::IMAP::MailboxList attr=[:Noinferiors, :Marked], delim="/", name="foo/bar">, #<Net::IMAP::MailboxList attr=[:Noinferiors], delim="/", name="foo/baz">]

--- lsub(refname, mailbox)
#@todo

Sends a LSUB command, and returns a subset of names from the set
of names that the user has declared as being "active" or
"subscribed".
The return value is an array of [[c:Net::IMAP::MailboxList]].

--- status(mailbox, attr)
#@todo

Sends a STATUS command, and returns the status of the indicated
mailbox.
return value is a hash of attributes.

ex).

  p imap.status("inbox", ["MESSAGES", "RECENT"])
  #=> {"RECENT"=>0, "MESSAGES"=>44}

--- append(mailbox, message, flags = nil, date_time = nil)
#@todo

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
#@todo

Sends a CHECK command to request a checkpoint of the currently
selected mailbox.

--- close
#@todo

Sends a CLOSE command to close the currently selected mailbox.
The CLOSE command permanently removes from the mailbox all
messages that have the \Deleted flag set.

--- expunge
#@todo

Sends a EXPUNGE command to permanently remove from the currently
selected mailbox all messages that have the \Deleted flag set.

--- search(keys, charset = nil)
--- uid_search(keys, charset = nil)
#@todo

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
#@todo

Sends a FETCH command to retrieve data associated with a message
in the mailbox. the set parameter is a number or an array of
numbers or a Range object. the number is a message sequence
number (fetch) or a unique identifier (uid_fetch).
The return value is an array of [[c:Net::IMAP::FetchData]].

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
#@todo

Sends a STORE command to alter data associated with a message
in the mailbox. the set parameter is a number or an array of
numbers or a Range object. the number is a message sequence
number (store) or a unique identifier (uid_store).
The return value is an array of [[c:Net::IMAP::FetchData]].

ex).

  p imap.store(6..8, "+FLAGS", [:Deleted])
  #=> [#<Net::IMAP::FetchData seqno=6, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=7, attr={"FLAGS"=>[:Seen, :Deleted]}>, #<Net::IMAP::FetchData seqno=8, attr={"FLAGS"=>[:Seen, :Deleted]}>]

--- copy(set, mailbox)
--- uid_copy(set, mailbox)
#@todo

Sends a COPY command to copy the specified message(s) to the end
of the specified destination mailbox. the set parameter is
a number or an array of numbers or a Range object. the number is
a message sequence number (copy) or a unique identifier (uid_copy).

--- sort(sort_keys, search_keys, charset)
--- uid_sort(sort_keys, search_keys, charset)
#@todo

Sends a SORT command to sort messages in the mailbox.

ex).

  p imap.sort(["FROM"], ["ALL"], "US-ASCII")
  #=> [1, 2, 3, 5, 6, 7, 8, 4, 9]
  p imap.sort(["DATE"], ["SUBJECT", "hello"], "US-ASCII")
  #=> [6, 7, 8, 1]

--- setquota(mailbox, quota)
#@todo

Sends a SETQUOTA command along with the specified mailbox and
quota.  If quota is nil, then quota will be unset for that
mailbox.  Typically one needs to be logged in as server admin
for this to work.  The IMAP quota commands are described in
[[RFC:2087]].

--- getquota(mailbox)
#@todo

Sends the GETQUOTA command along with specified mailbox.
If this mailbox exists, then an array containing a
[[c:Net::IMAP::MailboxQuota]] object is returned.  This
command generally is only available to server admin.

--- getquotaroot(mailbox)
#@todo

Sends the GETQUOTAROOT command along with specified mailbox.
This command is generally available to both admin and user.
If mailbox exists, returns an array containing objects of
[[c:Net::IMAP::MailboxQuotaRoot]] and [[c:Net::IMAP::MailboxQuota]].

--- setacl(mailbox, user, rights)
#@todo

Sends the SETACL command along with mailbox, user and the
rights that user is to have on that mailbox.  If rights is nil,
then that user will be stripped of any rights to that mailbox.
The IMAP ACL commands are described in [[RFC:2086]].

--- getacl(mailbox)
#@todo

Send the GETACL command along with specified mailbox.
If this mailbox exists, an array containing objects of
[[c:Net::IMAP::MailboxACLItem]] will be returned.

--- add_response_handler(handler = Proc.new)
#@todo

Adds a response handler.

ex).

  imap.add_response_handler do |resp|
    p resp
  end

--- remove_response_handler(handler)
#@todo

Removes the response handler.

--- response_handlers
#@todo

Returns all response handlers.

#@since 1.9.0
--- starttls(cxt = nil)
#@todo

Sends a STARTTLS command to start TLS session.
#@end

#@since 1.8.2
--- disconnected?
#@todo

Returns true if disconnected from the server.
#@end

--- thread(algorithm, search_keys, charset)
#@todo

As for #search(), but returns message sequence numbers in threaded
format, as a Net::IMAP::ThreadMember tree.  The supported algorithms
are:

ORDEREDSUBJECT:: split into single-level threads according to subject,
                 ordered by date.
REFERENCES:: split into threads by parent/child relationships determined
              by which message is a reply to which.

Unlike #search(), +charset+ is a required argument.  US-ASCII
and UTF-8 are sample values.

See [SORT-THREAD-EXT] for more details.

--- uid_thread(algorithm, search_keys, charset)
#@todo

As for #thread(), but returns unique identifiers instead of 
message sequence numbers.

--- client_thread
--- client_thread=(th)
#@todo

The thread to receive exceptions.



= class Net::IMAP::ContinuationRequest < Struct

Net::IMAP::ContinuationRequest represents command continuation requests.

The command continuation request response is indicated by a "+" token
instead of a tag.  This form of response indicates that the server is
ready to accept the continuation of a command from the client.  The
remainder of this response is a line of text.

  continue_req    ::= "+" SPACE (resp_text / base64)

== Instance Methods

--- data
#@todo

Returns the data ([[c:Net::IMAP::ResponseText]]).

--- raw_data
#@todo

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
#@todo

Returns the name such as "FLAGS", "LIST", "FETCH"....

--- data
#@todo

Returns the data such as an array of flag symbols,
a [[c:Net::IMAP::MailboxList]] object....

--- raw_data
#@todo

Returns the raw data string.



= class Net::IMAP::TaggedResponse < Struct

Net::IMAP::TaggedResponse represents tagged responses.

The server completion result response indicates the success or
failure of the operation.  It is tagged with the same tag as the
client command which began the operation.

  response_tagged ::= tag SPACE resp_cond_state CRLF
  
  tag             ::= 1*<any ATOM_CHAR except "+">
  
  resp_cond_state ::= ("OK" / "NO" / "BAD") SPACE resp_text

== Instance Methods

--- tag
#@todo

Returns the tag.

--- name
#@todo

Returns the name. the name is one of "OK", "NO", "BAD".

--- data
#@todo

Returns the data. See [[c:Net::IMAP::ResponseText]].

--- raw_data
#@todo

Returns the raw data string.



= class Net::IMAP::ResponseText < Struct

Net::IMAP::ResponseText represents texts of responses.
The text may be prefixed by the response code.

  resp_text       ::= ["[" resp_text_code "]" SPACE] (text_mime2 / text)
                      ;; text SHOULD NOT begin with "[" or "="

== Instance Methods

--- code
#@todo

Returns the response code. See [[c:Net::IMAP::ResponseCode]].

--- text
#@todo

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
#@todo

Returns the name such as "ALERT", "PERMANENTFLAGS", "UIDVALIDITY"....

--- data
#@todo

Returns the data if it exists.



= class Net::IMAP::MailboxList < Struct

Net::IMAP::MailboxList represents contents of the LIST response.

  mailbox_list    ::= "(" #("\Marked" / "\Noinferiors" /
                      "\Noselect" / "\Unmarked" / flag_extension) ")"
                      SPACE (<"> QUOTED_CHAR <"> / nil) SPACE mailbox


== Instance Methods

--- attr
#@todo

Returns the name attributes. Each name attribute is a symbol
capitalized by String#capitalize, such as :Noselect (not :NoSelect).

--- delim
#@todo

Returns the hierarchy delimiter

--- name
#@todo

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
#@todo

The mailbox with the associated quota.

--- usage
#@todo

Current storage usage of mailbox.

--- quota
#@todo

Quota limit imposed on mailbox.



= class Net::IMAP::MailboxQuotaRoot < Struct

Net::IMAP::MailboxQuotaRoot represents part of the GETQUOTAROOT
response. (GETQUOTAROOT can also return Net::IMAP::MailboxQuota.)

  quotaroot_response
                  ::= "QUOTAROOT" SPACE astring *(SPACE astring)

== Instance Methods

--- mailbox
#@todo

The mailbox with the associated quota.

--- quotaroots
#@todo

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
#@todo

Login name that has certain rights to the mailbox
that was specified with the getacl command.

--- rights
#@todo

The access rights the indicated user has to the
mailbox.



= class Net::IMAP::StatusData < Object

Net::IMAP::StatusData represents contents of the STATUS response.

== Instance Methods

--- mailbox
#@todo

Returns the mailbox name.

--- attr
#@todo

Returns a hash. Each key is one of "MESSAGES", "RECENT", "UIDNEXT",
"UIDVALIDITY", "UNSEEN". Each value is a number.



= class Net::IMAP::FetchData < Object

Net::IMAP::FetchData represents contents of the FETCH response.

== Instance Methods

--- seqno
#@todo

Returns the message sequence number.
(Note: not the unique identifier, even for the UID command response.)

--- attr
#@todo

Returns a hash. Each key is a data item name, and each value is
its value.

The current data items are:

: BODY
      A form of BODYSTRUCTURE without extension data.
: BODY[<section>]<<origin_octet>>
      A string expressing the body contents of the specified section.
: BODYSTRUCTURE
      An object that describes the [MIME-IMB] body structure of a message.
      See [[c:Net::IMAP::BodyTypeBasic]], [[c:Net::IMAP::BodyTypeText]],
      [[c:Net::IMAP::BodyTypeMessage]], [[c:Net::IMAP::BodyTypeMultipart]].
: ENVELOPE
      A [[c:Net::IMAP::Envelope]] object that describes the envelope
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
      A number expressing the [[RFC:822]] size of the message.
: RFC822.TEXT
      Equivalent to BODY[TEXT].
: UID
      A number expressing the unique identifier of the message.



= class Net::IMAP::Envelope < Struct

Net::IMAP::Envelope represents envelope structures of messages.

== Instance Methods

--- date
#@todo

Retunns a string that represents the date.

--- subject
#@todo

Retunns a string that represents the subject.

--- from
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the from.

--- sender
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the sender.

--- reply_to
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the reply-to.

--- to
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the to.

--- cc
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the cc.

--- bcc
#@todo

Retunns an array of [[c:Net::IMAP::Address]] that represents the bcc.

--- in_reply_to
#@todo

Retunns a string that represents the in-reply-to.

--- message_id
#@todo

Retunns a string that represents the message-id.



= class Net::IMAP::Address < Struct

Net::IMAP::Address represents electronic mail addresses.

== Instance Methods

--- name
#@todo

Returns the phrase from [[RFC:822]] mailbox.

--- route
#@todo

Returns the route from [[RFC:822]] route-addr.

--- mailbox
#@todo

nil indicates end of [[RFC:822]] group.
If non-nil and host is nil, returns [[RFC:822]] group name.
Otherwise, returns [[RFC:822]] local-part

--- host
#@todo

nil indicates [[RFC:822]] group syntax.
Otherwise, returns [[RFC:822]] domain name.



= class Net::IMAP::ContentDisposition < Struct

Net::IMAP::ContentDisposition represents Content-Disposition fields.

== Instance Methods

--- dsp_type
#@todo

Returns the disposition type.

--- param
#@todo

Returns a hash that represents parameters of the Content-Disposition
field.



= class Net::IMAP::ThreadMember < Struct

Net::IMAP::ThreadMember represents a thread-node returned 
by [[m:Net::IMAP#thread]]

== Instance Methods

--- seqno
#@todo

The sequence number of this message.

--- children
#@todo

an array of [[c:Net::IMAP::ThreadMember]] objects for mail
items that are children of this in the thread.



= class Net::IMAP::BodyTypeBasic < Struct

Net::IMAP::BodyTypeBasic represents basic body structures of messages.

== Instance Methods

--- media_type
#@todo

Returns the content media type name as defined in [MIME-IMB].

--- subtype
#@todo

Returns the content subtype name as defined in [MIME-IMB].

--- media_subtype
#@todo

media_subtype is obsolete.  Use #subtype instead.

--- param
#@todo

Returns a hash that represents parameters as defined in [MIME-IMB].

--- content_id
#@todo

Returns a string giving the content id as defined in [MIME-IMB].

--- description
#@todo

Returns a string giving the content description as defined in [MIME-IMB].

--- encoding
#@todo

Returns a string giving the content transfer encoding as defined in [MIME-IMB].

--- size
#@todo

Returns a number giving the size of the body in octets.

--- md5
#@todo

Returns a string giving the body MD5 value as defined in [MD5].

--- disposition
#@todo

Returns a [[c:Net::IMAP::ContentDisposition]] object giving
the content disposition.

--- language
#@todo

Returns a string or an array of strings giving the body
language value as defined in [LANGUAGE-TAGS].

--- extension
#@todo

Returns extension data.

--- multipart?
#@todo

Returns false.



= class Net::IMAP::BodyTypeText < Struct

Net::IMAP::BodyTypeText represents TEXT body structures of messages.

== Instance Methods

--- media_type
#@todo

--- subtype
#@todo

--- media_subtype
#@todo

obsolete. use #subtype instead.

--- param
#@todo

--- content_id
#@todo

--- description
#@todo

--- encoding
#@todo

--- size
#@todo

--- lines
#@todo

Returns the size of the body in text lines.

And Net::IMAP::BodyTypeText has all methods of [[c:Net::IMAP::BodyTypeBasic]].

--- md5
#@todo

--- disposition
#@todo

--- language
#@todo

--- extension
#@todo

--- multipart?
#@todo

Returns false.



= class Net::IMAP::BodyTypeMessage < Struct

Net::IMAP::BodyTypeMessage represents MESSAGE/RFC822 body
 structures of messages.

== Instance Methods

--- media_type
#@todo

--- subtype
#@todo

--- media_subtype
#@todo

obsolete. use #subtype instead.

--- param
#@todo

--- content_id
#@todo

--- description
#@todo

--- encoding
#@todo

--- size
#@todo

--- envelope
#@todo

Returns a [[c:Net::IMAP::Envelope]] giving the envelope structure.

--- body
#@todo

Returns an object giving the body structure.

And Net::IMAP::BodyTypeMessage has all methods of [[c:Net::IMAP::BodyTypeText]].

--- lines
#@todo

Returns the size of the body in text lines.

And Net::IMAP::BodyTypeText has all methods of [[c:Net::IMAP::BodyTypeBasic]].

--- md5
#@todo

--- disposition
#@todo

--- language
#@todo

--- extension
#@todo

--- multipart?
#@todo

Returns false.



= class Net::IMAP::BodyTypeMultipart < Struct

== Instance Methods

--- media_type
#@todo

Returns the content media type name as defined in [MIME-IMB].

--- subtype
#@todo

Returns the content subtype name as defined in [MIME-IMB].

--- media_subtype
#@todo

obsolete. use #subtype instead.

--- parts
#@todo

Returns multiple parts.

--- param
#@todo

Returns a hash that represents parameters as defined in
[MIME-IMB].

--- disposition
#@todo

Returns a [[c:Net::IMAP::ContentDisposition]] object giving
the content disposition.

--- language
#@todo

Returns a string or an array of strings giving the body
language value as defined in [LANGUAGE-TAGS].

--- extension
#@todo

Returns extension data.

--- multipart?
#@todo

Returns true.


#@# internal classes:
#@# = class Net::IMAP::Atom
#@# = class Net::IMAP::Literal
#@# = class Net::IMAP::QuotedString
#@# = class Net::IMAP::MessageSet
#@# = class Net::IMAP::RawData



= class Net::IMAP::LoginAuthenticator

Authenticator for the "LOGIN" authentication type.
See [[c:Net::IMAP#authenticate]].

== Class Methods

--- new(user, password)
#@todo

== Instance Methods

--- process(data)
#@todo



= class Net::IMAP::CramMD5Authenticator

Authenticator for the "CRAM-MD5" authentication type.
See [[c:Net::IMAP#authenticate]].

== Class Methods

--- new(user, password)
#@todo

== Instance Methods

--- process(challenge)
#@todo



#@since 1.9.0
= class Net::IMAP::PlainAuthenticator

Authenticator for the "PLAIN" authentication type.
See [[c:Net::IMAP#authenticate]].

== Class Methods

--- new(user, password)
#@todo

== Instance Methods

--- process(data)
#@todo



= class Net::IMAP::DigestMD5Authenticator

Authenticator for the "DIGEST-MD5" authentication type.
See [[c:Net::IMAP#authenticate]].

== Class Methods

--- new(user, password, authname = nil)
#@todo

== Instance Methods

--- process(challenge)
#@todo
#@end



= class Net::IMAP::Error < StandardError

Superclass of all IMAP errors.

= class Net::IMAP::DataFormatError < Net::IMAP::Error

Error raised when data is in the incorrect format.

= class Net::IMAP::ResponseParseError < Net::IMAP::Error

Error raised when a response from the server is non-parseable.

= class Net::IMAP::ResponseError < Net::IMAP::Error

Superclass of all errors used to encapsulate "fail" responses
from the server.

= class Net::IMAP::NoResponseError < Net::IMAP::ResponseError

Error raised upon a "NO" response from the server, indicating
that the client command could not be completed successfully.

= class Net::IMAP::BadResponseError < Net::IMAP::ResponseError

Error raised upon a "BAD" response from the server, indicating
that the client command violated the IMAP protocol, or an internal
server failure has occurred.

= class Net::IMAP::ByeResponseError < Net::IMAP::ResponseError

Error raised upon a "BYE" response from the server, indicating 
that the client is not being allowed to login, or has been timed
out due to inactivity.
