package PM::Controller::Mytag;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use PM::Model::Mytag;
use YAML;

sub get {
    my $self = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $tags = PM::Model::Mytag->fetch_mytags(
        $self->request->env->{'psgix.session'}{id});

    my $body = $self->render('mytag_root.tx', {tags => $tags});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

