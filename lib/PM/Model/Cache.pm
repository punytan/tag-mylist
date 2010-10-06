package PM::Model::Cache;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

use TokyoTyrant;
use YAML;

sub new {
    my $class = shift;

    my @conf = __PACKAGE__->load_connect_args;

    my $rdb = TokyoTyrant::RDB->new;
    $rdb->open(@conf) or die $rdb->errmsg($rdb->ecode);

    return bless {rdb => $rdb}, $class;
}

sub rdb {
    return shift->{rdb};
}

sub load_connect_args {
    my $self => shift;

    my $conf = YAML::LoadFile('secrets/cache.yaml');
    return ($conf->{server}, $conf->{port});
}

1;
__END__

