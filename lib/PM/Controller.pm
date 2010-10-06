package PM::Controller;
use common::sense;
our $VERSION = '0.01';

use Encode;

use PM::View;
use PM::Controller::Root;
use PM::Controller::Login;
use PM::Controller::Login::Callback;
use PM::Controller::Logout;
use PM::Controller::HTTPError;
use PM::Controller::Add;
use PM::Controller::Add::SM;
use PM::Controller::Mytag;
use PM::Controller::Mytag::Show;
use PM::Controller::Delete;

use PM::Model::Session;

sub new {
    my $class = shift;
    my %args  = @_;

    return bless \%args, $class;
}

sub head { shift->get(@_) }
sub get  { PM::Controller::HTTPError->throw(405) }
sub post { PM::Controller::HTTPError->throw(405) }
sub put  { PM::Controller::HTTPError->throw(405) }
sub delete { PM::Controller::HTTPError->throw(405) }

sub dispatch {
    my $self   = shift;
    my $action = shift;
    my @args   = @_;

    my $method = lc $args[0]->{REQUEST_METHOD};

    my $c = __PACKAGE__ . '::' . $action;

    return $c->$method(@args);
}

1;
__END__

