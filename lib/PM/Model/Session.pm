package PM::Model::Session;
use common::sense;
our $VERSION = '0.01';

sub is_login {
    my $self = shift;
    my $env  = shift;

    return defined $env->{'psgix.session'}->{id} ? 1 : 0;
}

sub id {
    my $self = shift;
    my $env  = shift;

    return $env->{'psgix.session'}->{id};
}

1;
__END__

