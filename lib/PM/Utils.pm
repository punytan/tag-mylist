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

sub gen_thumb_url {
    my $self = shift;
    my $vid  = shift;

    if ($vid =~ /[s|n]m(\d+)/) {
        return "http://tn-skr2.smilevideo.jp/smile?i=$1";

    } else {
        return undef;
    }
}

1;
__END__

