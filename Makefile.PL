use inc::Module::Install;

name     'MooseX-AlwaysCoerce';
all_from 'lib/MooseX/AlwaysCoerce.pm';
author   'Rafael Kitover <rkitover@cpan.org>';
license  'perl';

test_requires 'Test::More';

requires 'Moose';

auto_provides;
auto_install;

resources repository =>
    'git://github.com/rkitover/mx-alwayscoerce.git';

WriteAll;
