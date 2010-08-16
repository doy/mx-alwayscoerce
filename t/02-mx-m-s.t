#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 3;

use Test::Requires {
    'MooseX::Method::Signatures' => 0.01,
};

use Test::Exception;
use Test::NoWarnings;

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

TODO: {
    local $TODO = 'need rafl to help with implementation';

    lives_and {
        is $instance->foo(foo => "text", bar => 42), '4 42';
    } 'method called with coerced and uncoerced parameters';
}
