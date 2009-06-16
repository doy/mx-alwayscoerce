#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 4;

{
    package MyClass;
    use Moose;
    use MooseX::AlwaysCoerce;
    use Moose::Util::TypeConstraints;

    subtype 'MyType', as 'Int';
    coerce 'MyType', from 'Str', via { length $_ };

    has foo => (is => 'rw', isa => 'MyType');

    class_has bar => (is => 'rw', isa => 'MyType');

    class_has baz => (is => 'rw', isa => 'MyType', coerce => 0);
}

ok( (my $instance = MyClass->new), 'instance' );

eval { $instance->foo('bar') };
ok( (!$@), 'attribute coercion ran' );

eval { $instance->bar('baz') };
ok( (!$@), 'class attribute coercion ran' );

eval { $instance->baz('quux') };
ok( $@, 'class attribute coercion did not run with coerce => 0' );
