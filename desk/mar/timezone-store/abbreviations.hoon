|_  brevs=(list [name=@t brevs=(list @t)])
++  grow
  |%
  ++  noun  brevs
  ++  json
    :-  %a
    %+  turn
      brevs
    |=  [n=@t b=(list @t)]
    (frond:enjs:format n a+(turn b |=(t=@t [%s t])))
  --
::
++  grab
  |%
  ++  noun  (list [@t (list @t)])
  --
::
++  grad  %noun
--
