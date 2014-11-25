#!/bin/bash

PATH=$1

echo -n 'PATH: ' && echo $PATH 
echo -n 'TRAVIS_BUILD_DIR: ' && echo $TRAVIS_BUILD_DIR  

bundle install && \
bundle exec rake spec_clean spec_prep spec_standalone SPEC_OPTS='--format documentation' && \
bundle exec rake lint && \
puppet apply --modulepath=$TRAVIS_BUILD_DIR/spec/fixtures/modules --noop tests/init.pp
