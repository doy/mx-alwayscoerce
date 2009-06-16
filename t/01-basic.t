#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 3;

{
    package MyClass;
    use Moose;
    use MooseX::AlwaysCoerce;
    use Moose::Util::TypeConstraints;

    subtype 'MyType', as 'Int';
    coerce 'MyType', from 'Str', via { length $_ };

    has foo => (is => 'rw', isa => 'MyType');

    class_has bar => (is => 'rw', isa => 'MyType');
}

ok( (my $instance = MyClass->new), 'instance' );

eval { $instance->foo('bar') };
ok( (!$@), 'attribute coercion ran' );

eval { $instance->bar('baz') };
ok( (!$@), 'class attribute coercion ran' );
