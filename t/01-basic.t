#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 7;

{
    package MyClass;
    use Moose;
    use MooseX::AlwaysCoerce;
    use Moose::Util::TypeConstraints;

    subtype 'MyType', as 'Int';
    coerce 'MyType', from 'Str', via { length $_ };

    subtype 'Uncoerced', as 'Int';

    has foo => (is => 'rw', isa => 'MyType');

    class_has bar => (is => 'rw', isa => 'MyType');

    class_has baz => (is => 'rw', isa => 'MyType', coerce => 0);

    has quux => (is => 'rw', isa => 'MyType', coerce => 0);

    has uncoerced_attr => (is => 'rw', isa => 'Uncoerced');

    class_has uncoerced_class_attr => (is => 'rw', isa => 'Uncoerced');
}

ok( (my $instance = MyClass->new), 'instance' );

eval { $instance->foo('bar') };
is $@, "", 'attribute coercion ran';

eval { $instance->bar('baz') };
is $@, "", 'class attribute coercion ran';

eval { $instance->baz('quux') };
ok( $@, 'class attribute coercion did not run with coerce => 0' );

undef $@;

eval { $instance->quux('mtfnpy') };
ok( $@, 'attribute coercion did not run with coerce => 0' );

eval { $instance->uncoerced_attr(10) };
is $@, "", 'set attribute having type with no coercion and no coerce=0';

eval { $instance->uncoerced_class_attr(10) };
is $@, "", 'set class attribute having type with no coercion and no coerce=0';
