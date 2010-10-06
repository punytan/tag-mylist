use common::sense;
use lib 'lib';

use PM;
use PM::Plack;

use Plack::Builder;

my $c = PM::Controller->new;

builder {
    enable 'Lint';

    enable 'Session',
        store => Plack::Session::Store::TokyoTyrant->new(
            server     => ['localhost', 1978],
            key_prefix => 'PM:Session:',
        ),
        state => Plack::Session::State::Cookie->new(
            expires => 1 * 60 * 24 * 7,
            domain  => 'mylist.linknode.net',
            session_key => 'user_session',
        );

    \&router;

};

sub router {
    my $env = shift;

    my @dest = PM::Utils->split_path($env);

    if (not defined $dest[0]) {
        return $c->dispatch('Root', $env);

    } elsif ($dest[0] eq 'mytag') {

        if (not defined $dest[1]) {
            return $c->dispatch('Mytag', $env);

        } else {
            return $c->dispatch('Mytag::Show', $env, $dest[1]);
        }

    } elsif ($dest[0] eq 'add') {

        if (not defined $dest[1]) {
            return $c->dispatch('Add', $env);

        } elsif ($dest[1] =~ /^([s|n]m\d+)$/) {
            return $c->dispatch('Add::SM', $env, $1);

        } else {
            return PM::Controller::HTTPError->throw(500);

        }

    } elsif ($dest[0] eq 'delete') {

        if (not defined $dest[1]) {
            return PM::Controller::HTTPError->code_301('/');

        } elsif ($dest[1] =~ /^([s|n]m\d+)$/) {
            return $c->dispatch('Delete', $env, $1);

        } else {
            return PM::Controller::HTTPError->throw(500);

        }

    } elsif ($dest[0] eq 'login') {

        if (not defined $dest[1]) {
            return $c->dispatch('Login', $env);

        } elsif ($dest[1] eq 'callback') {
            return $c->dispatch('Login::Callback', $env);

        } else {
            return PM::Controller::HTTPError->throw(404);

        }

    } elsif ($dest[0] eq 'logout') {
        return $c->dispatch('Logout', $env);

    } elsif ($dest[0] eq 'favicon.ico') {
        my $file = PM::View->slurp('static/favicon.ico');
        return [200, ['Content-Type' => 'image/x-icon'], [$file]];

    } else {
        return PM::Controller::HTTPError->throw(404);
    }

    return PM::Controller::HTTPError->throw(404);
}

__END__

