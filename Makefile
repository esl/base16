.PHONY: rel deps test

REBARVER = 3.13.2
ifeq ($(OTPVER),24.0)
	REBARVER = 3.15.1
endif

all: deps compile

compile: rebar3
	./rebar3 compile

deps: rebar3
	./rebar3 get-deps

clean: rebar3
	./rebar3 clean

test-deps: rebar3
	./rebar3 get-deps

test-compile: rebar3 test-deps
	./rebar3 compile

test: test-compile
	./rebar3 as test eunit

codecov: _build/test/cover/eunit.coverdata
	./rebar3 as test codecov analyze

rebar3:
	wget https://github.com/erlang/rebar3/releases/download/${REBARVER}/rebar3 &&\
	chmod u+x rebar3

dialyzer: rebar3
	./rebar3 dialyzer
