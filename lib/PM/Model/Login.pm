package PM::Model::Login;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

use YAML;

sub load_oauth_token {
    my $self = shift;

    return YAML::LoadFile('secrets/oauth.yaml');
}

1;
__END__

