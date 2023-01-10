/-  *iana-components
/+  *iana-util
=>
|%
++  utc-conversion-helper
  |=  $:  [our=@p now=@da]
          zone-name=@ta
          st=seasoned-time
          func=$-([@da delta] @da)
      ==
  ^-  @da
  =/  sour  (scot %p our)
  =/  snow  (scot %da our)
  =/  zon=zone
    .^(zone %gx /[sour]/%timezone-store/[snow]/%zones/zone-name/%noun)
  ::  get relevant zone entry
  =/  ze=zone-entry  (get-zone-entry zon st)
  =/  pre-rules=@da  (func when.st stdoff.ze)
  ?:  ?=([%nothing *] rules.ze)
    pre-rules
  ?:  ?=([%delta *] rules.ze)
    (func pre-rules +:rules.ze)
  ?:  ?=([%rule *] rules.ze)
    ::  apply offset based on rules
    =/  tzr=tz-rule
        .^  tz-rule
          %gx
          (scot %p us)
          %timezone-store
          (scot %da now)
          %rules
          name.rules.ze
          %noun
          ~
        ==
    =/  entry=rule-entry  (find-rule-entry st stdoff.ze tzr)
    (func pre-rules save.entry)
  !!

--
::  Door for conversions to/from utc that rely on
::
|_  [us=@p now=@da]
::  +from-utc: convert an @da in utc to the corresponding wallclock time
::  in the given timezone.
::
++  from-utc
  ::  accepts a timezone name and a time
  |=  [zone-name=@ta utc=@da]
  :: returns a "wallclock" time
  ^-  @da
  :: if the zone-name is utc simply return the date
  ?:  =(zone-name 'utc')  utc
  (utc-conversion-helper [us now] zone-name [utc %utc] add-delta)
::  +to-utc: convert an @da in wallclock time in the specified timezone
::  to the corresponding utc time.
::
++  to-utc
  |=  [zone-name=@ta wallclock=@da]
  ^-  @da
  ?:  =(zone-name 'utc')  wallclock
  (utc-conversion-helper [us now] zone-name [wallclock %wallclock] sub-delta)
::  +convert-between: given an @da in a timezone, convert to the
::  equivalent @da in another timezone
::
++  convert-between
  |=  [t=@da in-zone=@ta to-zone=@ta]
  ^-  @da
  ?:  =(in-zone to-zone)  t
  (from-utc to-zone (to-utc in-zone t))
--
