package PM::Controller::Logout;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use Plack::Session;

sub get {
    my $self = shift;
    my $env  = shift;

    my $s = Plack::Session->new($env);

    $s->expire;

    return [301, ['Location' => '/'], []];
}

1;
__END__

