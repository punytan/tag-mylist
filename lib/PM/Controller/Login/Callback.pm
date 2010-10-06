package PM::Controller::Login::Callback;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Login';

use JSON;
use PM::Model::Login::Callback;

sub get {
    my $self = shift;
    my $env  = shift;

    if (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $credentials = PM::Model::Login::Callback->fetch_verify_credentials($env);

    unless ($credentials) {
        return PM::Controller::HTTPError->throw(500);
    }

    my $result = PM::Model::Login::Callback->create_user($credentials);

    unless ($result) {
        return PM::Controller::HTTPError->throw(500);
    }

    $env->{'psgix.session'} = $credentials;

    return PM::Controller::HTTPError->code_301('/');
}

1;
__END__

