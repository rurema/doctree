A parser is simple a class that implements

  #initialize(file_name, body, options)

and

  #scan

The initialize method takes a file name to be used, the body of the
file, and an RDoc::Options object. The scan method is then called
to return an appropriately parsed TopLevel code object.

The ParseFactory is used to redirect to the correct parser given a filename
extension. This magic works because individual parsers have to register 
themselves with us as they are loaded in. The do this using the following
incantation


   require "rdoc/parsers/parsefactory"
   
   module RDoc

     class XyzParser
       extend ParseFactory                  <<<<
       parse_files_matching /\.xyz$/        <<<<

       def initialize(file_name, body, options)
         ...
       end

       def scan
         ...
       end
     end
   end

Just to make life interesting, if we suspect a plain text file, we
also look for a shebang line just in case it's a potential
shell script

= module RDoc::ParserFactory

== class Methods

--- can_parse(file_name)

Return a parser that can handle a particular extension

--- alias_extension(old_ext, new_ext)

Alias an extension to another extension. After this call,
files ending "new_ext" will be parsed using the same parser
as "old_ext"

--- parser_for(top_level, file_name, body, options, stats)

Find the correct parser for a particular file name. Return a
SimpleParser for ones that we don't know

== Instance Methods

--- parse_files_matching(regexp)

Record the fact that a particular class parses files that match a
given extension
