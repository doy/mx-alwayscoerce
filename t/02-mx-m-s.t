#!/usr/bin/env perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN {
    if (eval { require MooseX::Method::Signatures }) {
        plan tests => 2;
    } else {
        plan skip_all => 'This test needs MooseX::Method::Signatures';
    }
}

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
