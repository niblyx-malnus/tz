/-  *iana-components, timezone-store
/+  default-agent, dbug, verb, iana-parser, parser-util, *iana-util
|%
+$  card   card:agent:gall
+$  state-zero
      :: zones is a map from zone names as cords to actual zones
      :: rules is a map from zone names to timezone rules
      :: links is a map from zone aliases to zone names
  $:  zones=(map @t zone)
      rules=(map @t tz-rule)
      links=(map @t @t) 
  ==
+$  versioned-state
  $%  [%0 state-zero]
  ==
--
=|  state=versioned-state
%+  verb  |
%-  agent:dbug
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this  .
      hc    ~(. +> bowl)
      def   ~(. (default-agent this %|) bowl)
  ++  on-init
    ^-  (quip card _this)
    :_  this
    [%pass /thread %agent [our.bowl dap.bowl] %poke noun+!>(%start-thread)]~
  ::
  ++  on-save  `vase`!>(state)
  ::
  ++  on-load
    |=  =vase
    ^-  (quip card _this)
    :-  [%pass /thread %agent [our.bowl dap.bowl] %poke noun+!>(%start-thread)]~
    =/  prev  !<(versioned-state vase)
    ?-  -.prev
      %0  this(state prev)
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?+    mark  (on-poke:def mark vase)
        %timezone-store-action
      =^  cards  state  (poke-handler:hc !<(action:timezone-store vase))
      [cards this]
      ::
        %noun
      ?>  =(our.bowl src.bowl)
      ?+    q.vase  (on-poke:def mark vase)
        %print-state  ~&(state `this)
        %reset-state  `this(state *versioned-state)
          %start-thread
        =/  tid  `@ta`(cat 3 'thread_' (scot %uv (sham eny.bowl)))
        =/  ta-now  `@ta`(scot %da now.bowl)
        =/  start-args
          [~ `tid byk.bowl(r da+now.bowl) %fetch-timezone !>(~)]
        :_  this
        :~  [%pass /timers %arvo %b %wait (add now.bowl ~d1)]
            [%pass /thread/[ta-now] %agent [our.bowl %spider] %poke %spider-start !>(start-args)]
        ==
      ==
    ==
  ::
  ++  on-watch  on-watch:def
  ++  on-agent  on-agent:def
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    ?+    wire  (on-arvo:def wire sign-arvo)
        [%timers ~]
      ?+    sign-arvo  (on-arvo:def wire sign-arvo)
          [%behn %wake *]
        ?~  error.sign-arvo
          :_  this
          [%pass /thread %agent [our.bowl dap.bowl] %poke noun+!>(%start-thread)]~
        (on-arvo:def wire sign-arvo)
      ==
    ==
  ++  on-leave  on-leave:def
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+    path  (on-peek:def path)
        [%x %rules @ta ~]
      ``noun+!>((lookup-rule i.t.t.path))
    ::
        [%x %zones @ta ~]
      ``noun+!>((lookup-zone i.t.t.path))
    ::
        [%x %from-utc @ta @ ~]
      ``noun+!>((from-utc [i.t.t (slav %da i.t.t.t)]:[path .]))
    ::
        [%x %to-utc @ta @ ~]
      ``noun+!>((to-utc [i.t.t (slav %da i.t.t.t)]:[path .]))
    ::
        [%x %convert-between @ @ta @ta ~]
      =/  args  [(slav %da i.t.t) i.t.t.t i.t.t.t.t]:[path .]
      ``noun+!>((convert-between args))
    ::
        [%x %zones ~]
      ``timezone-store-zone-list+!>((get-zone-names))
    ::
        [%x %links ~]
      ``timezone-store-links+!>((get-links))
    ::
        [%x %abbreviations ~]
      ``timezone-store-abbreviations+!>((get-abbreviations))
    ==
  ++  on-fail   on-fail:def
--
::
|_  bowl=bowl:gall
++  poke-handler
  |=  =action:timezone-store
  ^-  (quip card _state)
  ?-    -.action
      %import-files
    |-
    ?~  files.action
      `state
    %=  $
      files.action  t.files.action
      state  (import-single-file i.files.action)
    ==
    ::
      %import-blob
    `(import-blob data.action)
  ==
::
++  import-single-file
  |=  pax=path
  ^-  _state
  (import-from-lines (read-file:parser-util pax))
::
++  import-blob
  |=  data=@t
  ^-  _state
  (import-from-lines (turn (to-wain:format data) trip))
::
++  import-from-lines
  |=  w=wall
  ^-  _state
  =/  [zones=(map @t zone) rules=(map @t tz-rule) links=(map @t @t)]
      (parse-timezones:iana-parser w)
  %=  state
    zones  (~(uni by zones.state) zones)
    rules  (~(uni by rules.state) rules)
    links  (~(uni by links.state) links)
  ==
::
++  lookup-rule  |=(key=@t `tz-rule`(~(got by rules.state) key))
::
++  lookup-zone
  |=  key=@t
  ^-  zone
  ?:  =(key 'utc')  utc-zone
  =/  linked=(unit @t)  (~(get by links.state) key)
  %-  ~(got by zones.state)
  (fall linked key)
::
++  get-zone-names  |.(`wain`['utc' ~(tap in ~(key by zones.state))])
++  get-links  |.(`(list [@t @t])`~(tap by links.state))
++  get-abbreviations
  |.
  ^-  (list [@t (list @t)])
  %+  turn
    ~(val by zones.state)
  |=  =zone
  :-  name.zone
  (turn entries.zone |=(ze=zone-entry abbreviation.ze))
::
++  convert
  |=  $:  zone-name=@ta
          st=seasoned-time
          func=$-([@da delta] @da)
      ==
  ^-  @da
  =/  =zone  (lookup-zone zone-name)
  =/  ze=zone-entry  (get-zone-entry zone st)
  =/  pre-rules=@da  (func when.st stdoff.ze)
  ?-    -.rules.ze
    %nothing  pre-rules
    %delta  (func pre-rules +:rules.ze)
      %rule
    ::  apply offset based on rules
    =/  tzr=tz-rule  (lookup-rule name.rules.ze)
    =/  entry=rule-entry  (find-rule-entry st stdoff.ze tzr)
    (func pre-rules save.entry)
  ==
::  +from-utc: convert an @da in utc to the corresponding wallclock time
::  in the given timezone.
::
++  from-utc
  |=  [zone-name=@ta utc=@da]
  ^-  @da
  (convert zone-name [utc %utc] add-delta)
::  +to-utc: convert an @da in wallclock time in the specified timezone
::  to the corresponding utc time.
::
++  to-utc
  |=  [zone-name=@ta wallclock=@da]
  ^-  @da
  (convert zone-name [wallclock %wallclock] sub-delta)
::  +convert-between: given an @da in a timezone, convert to the
::  equivalent @da in another timezone
::
++  convert-between
  |=  [t=@da in-zone=@ta to-zone=@ta]
  ^-  @da
  (from-utc to-zone (to-utc in-zone t))
--
