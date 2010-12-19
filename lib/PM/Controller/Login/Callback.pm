package PM::Controller::Login::Callback;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use JSON;
use PM::Model::Login::Callback;

sub get {
    my $self = shift;

    if (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $credentials = PM::Model::Login::Callback->fetch_verify_credentials($self->request->env);

    unless ($credentials) {
        return PM::Controller::HTTPError->throw(500);
    }

    my $result = PM::Model::Login::Callback->create_user($credentials);

    unless ($result) {
        return PM::Controller::HTTPError->throw(500);
    }

    $self->request->env->{'psgix.session'} = $credentials;

    return PM::Controller::HTTPError->code_301('/');
}

1;
__END__

