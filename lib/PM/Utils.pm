package PM::Utils;
use common::sense;
our $VERSION = '0.01';

sub split_path {
    my $self = shift;
    my $env  = shift;

    my @path = split /\//, $env->{PATH_INFO};

    (undef) = shift @path;

    return wantarray ? @path : \@path;
}

1;
__END__

