package PM::Model::Session;
use common::sense;
our $VERSION = '0.01';

sub is_login {
    my $class = shift;
    my $self  = shift;
    my $env   = $self->request->env;

    return defined $env->{'psgix.session'}->{id} ? 1 : 0;
}

sub id {
    my $class = shift;
    my $self  = shift;
    my $env   = $self->request->env;

    return $env->{'psgix.session'}->{id};
}

1;
__END__

