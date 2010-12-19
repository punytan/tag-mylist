package PM::Controller::Add;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

sub get {
    my $self = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $body = $self->render('add.tx', {});
    return [200, ['Content-Type' => 'text/html'], [$body]];
}

sub post {
    my $self = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $url = $self->request->param('url');
    if ($url =~ /([s|n]m\d+)/) {
        return PM::Controller::HTTPError->code_301("/add/$1");
    } else {
        return PM::Controller::HTTPError->code_301("/add");
    }
}

1;
__END__

