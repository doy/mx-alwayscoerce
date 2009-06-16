package MooseX::AlwaysCoerce;

use strict;
use warnings;

use namespace::autoclean;
use Moose ();
use MooseX::ClassAttribute ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use Carp;

Moose::Exporter->setup_import_methods;

=head1 NAME

MooseX::AlwaysCoerce - Automatically enable coercions for Moose attributes

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

    package MyClass;

    use Moose;
    use MooseX::AlwaysCoerce;
    use MyTypeLib 'SomeType';

    has foo => (is => 'rw', isa => SomeType); # coerce => 1 automatically added

    # same, MooseX::ClassAttribute is automatically applied
    class_has bar => (is => 'rw', isa => SomeType);

=head1 DESCRIPTION

Have you ever spent an hour or more trying to figure out "WTF, why did my
coercion not run?" only to find out that you forgot C<< coerce => 1 >> ?

Just load this module in your L<Moose> class and C<< coerce => 1 >> will be
enabled for every attribute and class attribute automatically.

=cut

{
    package MooseX::AlwaysCoerce::Role::Meta::Attribute;
    use namespace::autoclean;
    use Moose::Role;

    has coerce => (is => 'rw', default => 1);

    package MooseX::AlwaysCoerce::Role::Meta::Class;
    use namespace::autoclean;
    use Moose::Role;

    around add_class_attribute => sub {
        my $next = shift;
        my $self = shift;
        $self->$next(@_, coerce => 1);
    };
}

sub init_meta {
    shift;
    my %options = @_;
    my $for_class = $options{for_class};

    MooseX::ClassAttribute->import({ into => $for_class });

    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class => $for_class,
        attribute_metaclass_roles =>
            ['MooseX::AlwaysCoerce::Role::Meta::Attribute'],
        metaclass_roles =>
            ['MooseX::AlwaysCoerce::Role::Meta::Class'],
    );

    return $for_class->meta;
}

=head1 AUTHOR

Rafael Kitover, C<< <rkitover at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-moosex-alwayscoerce at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-AlwaysCoerce>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find more information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-AlwaysCoerce>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-AlwaysCoerce>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-AlwaysCoerce>

=item * Search CPAN

L<http://search.cpan.org/dist/MooseX-AlwaysCoerce/>

=back

=head1 ACKNOWLEDGEMENTS

My own stupidity, for inspiring me to write this module.

Dave Rolsky, for telling me how to do it the L<Moose> way.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2009 Rafael Kitover

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of MooseX::AlwaysCoerce
