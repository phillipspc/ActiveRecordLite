#Active Record Lite
[![Screenshot](/doc/screenshot_new.png)](//github.com/phillipspc/ActiveRecordLite/)
Active Record Lite is a metaprogramming project intended to replicate a portion of the functionality of Active Record. The goal was to better understand how Active Record works, particularly in regard to translating associations into SQL queries, by programming them myself.

## Features
Active Record Lite provides the following key methods and associations:

- ::all
- ::find(id)
- #insert
- #update
- #save
- ::where(params)
- belongs_to(name, options)
- has_many(name, options)
- has_one_through(name, through_name, source_name)

## Usage
To test out Active Record Lite yourself, you can extend the SQLObject class and call finalize! on your model. You can then use all of the methods and associations listed above as specified. Active Record Lite also includes a complete test spec via RSpec, which you can use to verify its functionality.
