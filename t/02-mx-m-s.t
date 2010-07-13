#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

eval { require MooseX::Method::Signatures };
plan skip_all => "No MooseX::Method::Signatures" if $@;

plan tests => 2;

{
    package MyClass;
    use Moose;
    use MooseX::Method::Signatures;
    use MooseX::AlwaysCoerce;
    use Moose::Util::TypeConstraints;

    BEGIN {
        subtype 'MyType', as 'Int';
        coerce 'MyType', from 'Str', via { length $_ };

        subtype 'Uncoerced', as 'Int';
    }

    method foo (MyType :$foo, Uncoerced :$bar) {
        return "$foo $bar";
    }
}

ok( (my $instance = MyClass->new), 'instance' );

lives_and {
    is $instance->foo(foo => "text", bar => 42), '4 42';
} 'method called with coerced and uncoerced parameters';
