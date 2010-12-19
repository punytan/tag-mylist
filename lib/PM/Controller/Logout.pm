package PM::Controller::Logout;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use Plack::Session;

sub get {
    my $self = shift;

    my $s = Plack::Session->new($self->request->env);

    $s->expire;

    return [301, ['Location' => '/'], []];
}

1;
__END__

