package PM::Controller::Tag;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use PM::Model::Tag;
use YAML;

sub get {
    my $self = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $body = $self->render('tag_root.tx', {});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

sub post {
    my $self = shift;

    if (my $tag = $self->request->param('tag')) {
        return PM::Controller::HTTPError->code_301("/tag/$tag");
    } else {
        return PM::Controller::HTTPError->code_301("/tag");
    }
}

1;
__END__

