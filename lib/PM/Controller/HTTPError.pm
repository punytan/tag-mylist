package PM::Controller::HTTPError;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use HTTP::Status;

sub throw {
    my $self = shift;
    my $code = shift;

    my $msg = HTTP::Status::status_message($code);

    return [$code, ['Content-Type' => 'text/plain'], [$msg]];
}

sub code_301{
    my $self = shift;
    my $location = shift;

    my $code = 301;
    my $msg = HTTP::Status::status_message($code);
    return [$code, ['Location' => $location], [$msg]];
}

1;
__END__

