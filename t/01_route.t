use strict;
use Test::More;
use Plack::Test;
use HTTP::Request::Common;

my $app = do 'bin/app.psgi' or die $!;

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/');
    like $res->content, qr{<div id="login"><a href="/login">Twitter経由でログイン</a></div>}, 'without login';
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(POST '/');
    is $res->code, 405;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/tag');
    is $res->code, 301;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/tag');
    is $res->code, 301;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/mytag');
    is $res->code, 301;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/add');
    is $res->code, 301;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/delete');
    is $res->code, 301;
};

test_psgi $app, sub {
    my $cb  = shift;
    my $res = $cb->(GET '/login');
    is $res->code, 301;
};

done_testing;

