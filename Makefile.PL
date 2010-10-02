use inc::Module::Install;
name 'PM';
all_from 'lib/PM.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
