#!/usr/bin/env perl
use strict;
use warnings;

use Test::More tests => 10;
use Test::Exception;
use Test::NoWarnings;

{
    package MyRole;
    use Moose::Role;
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

    has untyped_attr => (is => 'rw');

    class_has untyped_class_attr => (is => 'rw');
}

{
    package MyClass;
    use Moose;
    with 'MyRole';
}

ok( (my $instance = MyClass->new), 'instance' );

{
    local $TODO = 'waiting on Moose changes for role support';

    lives_and {
        $instance->foo('bar');
        is $instance->foo, 3;
    } 'attribute coercion ran';
}

lives_and {
    $instance->bar('baz');
    is $instance->bar, 3;
} 'class attribute coercion ran';

dies_ok { $instance->baz('quux') }
    'class attribute coercion did not run with coerce => 0';

dies_ok { $instance->quux('mtfnpy') }
    'attribute coercion did not run with coerce => 0';

lives_and {
    $instance->uncoerced_attr(10);
    is $instance->uncoerced_attr(10), 10;
} 'set attribute having type with no coercion and no coerce=0';

lives_and {
    $instance->uncoerced_class_attr(10);
    is $instance->uncoerced_class_attr(10), 10;
} 'set class attribute having type with no coercion and no coerce=0';

lives_and {
    $instance->untyped_attr(10);
    is $instance->untyped_attr, 10;
} 'set untyped attribute';

lives_and {
    $instance->untyped_class_attr(10);
    is $instance->untyped_class_attr, 10;
} 'set untyped class attribute';
