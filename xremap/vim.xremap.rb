=begin

|                                |  super W  |  shift S  |  ctrl C  |  alt M  |   key |
|:-------------------------------|:---------:|:---------:|:--------:|:-------:|------:|
|                                |           |           |          |         |       |
| Left  / cursor left char       |     ●     |           |          |         |     h |
| Right / cursor right char      |     ●     |           |          |         |     l |
| Down  / cursor down            |     ●     |           |          |         |     j |
| Up    / cursor up              |     ●     |           |          |         |     k |
|                                |           |           |          |         |       |
| C-Left  / cursor left word     |     ●     |           |    ●     |         |     h |
| C-Right / cursor right word    |     ●     |           |    ●     |         |     l |
| M-Left                         |     ●     |           |          |    ●    |     h |
| M-Right                        |     ●     |           |          |    ●    |     l |
|                                |           |           |          |         |       |
| C-Down                         |     ●     |           |    ●     |         |     j |
| C-Up                           |     ●     |           |    ●     |         |     k |
| S-C-Down                       |     ●     |     ●     |    ●     |         |     j |
| S-C-Up                         |     ●     |     ●     |    ●     |         |     k |
|                                |           |           |          |         |       |
| Home   / cursor bol            |     ●     |           |          |         |     u |
| End    / cursor eol            |     ●     |           |          |         |     i |
| C-Home / cursor bof            |     ●     |           |    ●     |         |     u |
| C-end  / cursor eof            |     ●     |           |    ●     |         |     i |
|                                |           |           |          |         |       |
| PgDn   / cursor eol            |     ●     |           |          |         |     b |
| PgUp   / cursor bol            |     ●     |           |          |         |     n |
| C-PgDn / cursor eof            |     ●     |           |    ●     |         |     b |
| C-PgUp / cursor bof            |     ●     |           |    ●     |         |     n |
|                                |           |           |          |         |       |
| **************                 |           |           |          |         |       |
|                                |           |           |          |         |       |
| S-Left  / select left char     |     ●     |     ●     |          |         |     h |
| S-Right / select right char    |     ●     |     ●     |          |         |     l |
| S-Down  / select down          |     ●     |     ●     |          |         |     j |
| S-Up    / select up            |     ●     |     ●     |          |         |     k |
|                                |           |           |          |         |       |
| S-C-Left  / select left word   |     ●     |     ●     |    ●     |         |     h |
| S-C-Right / select right word  |     ●     |     ●     |    ●     |         |     l |
|                                |           |           |          |         |       |
| S-Home   / select bol          |     ●     |     ●     |          |         |     u |
| S-end    / select eol          |     ●     |     ●     |          |         |     i |
| S-C-Home / select bof          |     ●     |     ●     |    ●     |         |     u |
| S-C-end  / select eof          |     ●     |     ●     |    ●     |         |     i |
|                                |           |           |          |         |       |
| S-PgDn  / select page down     |     ●     |           |    ●     |    ●    |     b |
| S-PgUp  / select page up       |     ●     |           |    ●     |    ●    |     n |
|                                |           |           |          |         |       |
| **************                 |           |           |          |         |       |
|                                |           |           |          |         |       |
| Return / \n                    |     ●     |           |          |         | space |
| S-Return                       |     ●     |     ●     |          |         | space |
| C-Return                       |     ●     |           |    ●     |         | space |
| M-Return                       |     ●     |           |          |    ●    | space |
| C-M-Return                     |     ●     |           |    ●     |    ●    | space |
|                                |           |           |          |         |       |
| #line swap down                |     ●     |           |          |    ●    |     j |
| #line swap up                  |     ●     |           |          |    ●    |     k |
|                                |           |           |          |         |       |
| #line insert before            |     ●     |     ●     |          |         | space |
| #line insert after             |     ●     |           |    ●     |         | space |
|                                |           |           |          |         |       |
| **************                 |           |           |          |         |       |
|                                |           |           |          |         |       |
| Delete                         |     ●     |           |          |         |     g |
| C-Delete / delete word right   |     ●     |           |    ●     |         |     g |
| S-Delete                       |     ●     |     ●     |          |         |     g |
| #delete eol                    |     ●     |           |          |    ●    |     d |
| #delete line                   |     ●     |           |    ●     |    ●    |     d |
|                                |           |           |          |         |       |
| BackSpace                      |     ●     |           |          |         |     y |
| C-BackSpace / delete word left |     ●     |           |    ●     |         |     y |
| M-BackSpace                    |     ●     |           |          |    ●    |     y |
| #BackSpace bol                 |     ●     |           |          |    ●    |     u |
|                                |           |           |          |         |       |
| **************                 |           |           |          |         |       |
|                                |           |           |          |         |       |
| F3                             |     ●     |           |          |         |     r |
| S-F3                           |     ●     |     ●     |          |         |     r |
|                                |           |           |          |         |       |
| **************                 |           |           |          |         |       |
|                                |           |           |          |         |       |
| escape                         |     ●     |           |          |         |     v |
|                                |           |           |          |         |       |
|                                | :-------: | :-------: | :------: | :-----: | ----: |
|                                |  super W  |  shift S  |  ctrl C  |  alt M  |   key |

=end

# -------------------------------------------------------------------------------

#
remap 'Super-h', to: 'Left'
remap 'Super-l', to: 'Right'
remap 'Super-j', to: 'Down'
remap 'Super-k', to: 'Up'

#
remap 'Super-C-h', to: 'C-Left'
remap 'Super-C-l', to: 'C-Right'
remap 'Super-M-h', to: 'M-Left'
remap 'Super-M-l', to: 'M-Right'

#
remap 'Super-C-j', to: 'C-Down'
remap 'Super-C-k', to: 'C-Up'
remap 'Super-Shift-C-j', to: 'Shift-C-Down'
remap 'Super-Shift-C-k', to: 'Shift-C-Up'

#
remap 'Super-u', to: 'Home'
remap 'Super-i', to: 'End'
remap 'Super-C-u', to: 'C-Home'
remap 'Super-C-i', to: 'C-End'

#
remap 'Super-b', to: 'Page_Down'
remap 'Super-n', to: 'Page_Up'
remap 'Super-C-b', to: 'C-Page_Down'
remap 'Super-C-n', to: 'C-Page_Up'

# -------------------------------------------------------------------------------

#
remap 'Super-Shift-h', to: 'Shift-Left'
remap 'Super-Shift-l', to: 'Shift-Right'
remap 'Super-Shift-j', to: 'Shift-Down'
remap 'Super-Shift-k', to: 'Shift-Up'

#
remap 'Super-Shift-C-h', to: 'Shift-C-Left'
remap 'Super-Shift-C-l', to: 'Shift-C-Right'

#
remap 'Super-Shift-u', to: 'Shift-Home'
remap 'Super-Shift-i', to: 'Shift-End'
remap 'Super-Shift-C-u', to: 'Shift-C-Home'
remap 'Super-Shift-C-i', to: 'Shift-C-End'

#
remap 'Super-Shift-b', to: 'Shift-Page_Down'
remap 'Super-Shift-n', to: 'Shift-Page_Up'

# -------------------------------------------------------------------------------

#
remap 'Super-space', to: 'Return'
remap 'Super-C-space', to: 'C-Return'
remap 'Super-Shift-space', to: 'Shift-Return'
remap 'Super-M-space', to: 'M-Return'
remap 'Super-C-M-space', to: 'C-M-Return'

# -------------------------------------------------------------------------------

remap 'Super-g', to: 'Delete'
remap 'Super-C-g', to: 'C-Delete'
remap 'Super-Shift-g', to: 'Shift-Delete'

# -------------------------------------------------------------------------------

remap 'Super-y', to: 'BackSpace'
remap 'Super-C-y', to: 'C-BackSpace'
remap 'Super-M-y', to: 'M-BackSpace'

# -------------------------------------------------------------------------------

remap 'Super-r', to: 'F3'
remap 'Super-Shift-r', to: 'Shift-F3'

# -------------------------------------------------------------------------------

remap 'Super-v', to: 'Escape'
