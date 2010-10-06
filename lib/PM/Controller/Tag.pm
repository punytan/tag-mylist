package PM::Controller::Tag;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use PM::Model::Tag;
use YAML;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $body = $view->render_with_encode('tag_root.tx', {});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

sub post {
    my $self = shift;
    my $env  = shift;

    my $req = Plack::Request->new($env);

    if (my $tag = $req->param('tag')) {
        return PM::Controller::HTTPError->code_301("/tag/$tag");

    } else {
        return PM::Controller::HTTPError->code_301("/tag");
    }
}

1;
__END__

