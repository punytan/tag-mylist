package PM::View;
use common::sense;
our $VERSION = '0.01';

use Encode;
use Text::Xslate;
use File::Slurp;

sub new {
    my $class = shift;
    my %args  = @_;

    $args{path}      ||= ['templates'];
    $args{cache_dir} ||= File::Spec->tmpdir;

    my $xslate = Text::Xslate->new(%args);

    return bless {xslate => $xslate}, $class;
}

sub render {
    return shift->{xslate}->render(@_);
}

sub render_with_encode {
    my $self = shift;
    my $body = $self->render(@_);
    return Encode::encode_utf8($body);
}

sub slurp {
    my $self = shift;
    my $path = shift;

    return File::Slurp::read_file($path);
}

1;
__END__

