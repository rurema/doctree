#!/usr/local/bin/ruby -Ke

load './config'
setup_environment
require 'bitclust/interface'
BitClust::Interface.new { bitclust_context() }.main
