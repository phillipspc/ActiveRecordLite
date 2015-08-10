#Active Record Lite
[![Screenshot](/doc/screenshot_new.png)](//github.com/phillipspc/ActiveRecordLite/)
Active Record Lite is a metaprogramming project intended to replicate a portion of the functionality of Active Record. The goal was to better understand how Active Record works, particularly in regard to translating associations into SQL queries, by programming them myself.

## Features
Active Record Lite replicates the following functions of Active Record:

- ::all
- ::find
- #insert
- #update
- #save
- ::where
- belongs_to
- has_many
- has_one through

## Usage
To use Active Record Lite with your own project, you can extend the SQLObject class and call finalize! on your model. You can then use all of the methods and associations listed above as you normally would. Active Record Lite also includes a complete test spec via RSpec, which you can use to verify its functionality.
