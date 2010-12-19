package PM::Controller::Login;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use URI;
use OAuth::Lite::Consumer;
use PM::Model::Login;

sub get {
    my $self = shift;

    if (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    } else {
        my $uri = $self->generate_redirect_uri;
        return PM::Controller::HTTPError->code_301($uri);
    }
}

sub generate_redirect_uri {
    my $self = shift;

    my $oauth = PM::Model::Login->load_oauth_token;

    my $c = OAuth::Lite::Consumer->new(%$oauth);
    my $req_token = $c->get_request_token;

    my $uri = URI->new($c->{authorize_path});
    $uri->query($c->gen_auth_query("GET", $c->{site}, $req_token));

    return $uri->as_string
}

1;
__END__

