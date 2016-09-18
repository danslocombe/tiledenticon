# Tiledenticon

Create more interesting identicons

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'tiledenticon'
```


And then execute:

`$ bundle`


Or install it manually as:

`$ gem install tiledenticon
## Usage

To generate a basic identicon use

``` ruby
require 'tiledenticon'

td = Tiledenticon.new('output_directory')
td.create('my@email.com')
```

## Algorithm

The gem uses a modified version of the tiling algorithm found [here](https://github.com/danslocombe/surface-tiling)
