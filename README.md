# Tiledenticon

Create more interesting identicons

---

![alt text](https://raw.githubusercontent.com/danslocombe/tiledenticon/95cedba67f5d9a2c9d2022a240064cdbd9e0e65f/demo/angus.koepp%40kshlerinluettgen.net.png "angus.koepp@kshlerinluettgen.net")

angus.koepp@kshlerinluettgen.net 

---

![alt text](https://raw.githubusercontent.com/danslocombe/tiledenticon/95cedba67f5d9a2c9d2022a240064cdbd9e0e65f/demo/carmen.ondricka%40bins.biz.png "carmen.ondricka@bins.biz")

carmen.ondricka@bins.biz

---

![alt text](https://raw.githubusercontent.com/danslocombe/tiledenticon/95cedba67f5d9a2c9d2022a240064cdbd9e0e65f/demo/kayleigh_ryan%40boehm.io.png "mitchell_blick@harveygerhold.org")

mitchell_blick@harveygerhold.org

---


![alt text](https://raw.githubusercontent.com/danslocombe/tiledenticon/95cedba67f5d9a2c9d2022a240064cdbd9e0e65f/demo/natasha.konopelski%40lueilwitz.biz.png "natasha.konopelski@lueilwitz.biz.png")

natasha.konopelski@lueilwitz.biz.png

---


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'tiledenticon'
```


And then execute:

`$ bundle`


Or install it manually as:

`$ gem install tiledenticon`
## Usage

To generate a basic identicon use

``` ruby
require 'tiledenticon'

td = Tiledenticon.new('output_directory')
td.create('my@email.com')
```

## Algorithm

The gem uses a modified version of the tiling algorithm found [here](https://github.com/danslocombe/surface-tiling)
