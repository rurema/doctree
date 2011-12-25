= class XMLRPC::DateTime < Object

This class is important to handle XMLRPC dateTime.iso8601 values,
correcly, because normal UNIX-dates (class Date) only handle dates
from year 1970 on, and class Time handles dates without the time
component. XMLRPC::DateTime is able to store a XMLRPC
dateTime.iso8601 value correctly.

== Class Methods

--- new( year, month, day, hour, min, sec )

Creates a new XMLRPC::DateTime instance with the
parameters year, month, day as date and
hour, min, sec as time.
Raises ArgumentError if a parameter is out of range, or year is not
of type Integer.

== Instance Methods

--- year
--- month
--- day
--- hour
--- min
--- sec

Return the value of the specified date/time component.

--- mon

Alias for [[m:XMLRPC::DateTime#month]].

--- year=()
--- month=()
--- day=()
--- hour=()
--- min=()
--- sec=()

Set value as the new date/time component.
Raises ArgumentError if value is out of range, or in the case
of XMLRPC::DateTime#year= if value is not of type Integer.

--- mon=()

Alias for [[m:XMLRPC::DateTime#month=]].

--- to_time

Return a Time object of the date/time which self represents.
If the (('year')) is below 1970, this method returns nil,
because Time cannot handle years below 1970.
The used timezone is GMT.

--- to_date

Return a Date object of the date which self represents.
The Date object do ((*not*)) contain the time component (only date).

--- to_a
Returns all date/time components in an array.
Returns [year, month, day, hour, min, sec].
