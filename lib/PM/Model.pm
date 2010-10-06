package PM::Model;
use common::sense;
our $VERSION = '0.01';

use DBI;
use SQL::Abstract;
use YAML;

sub new {
    my $class = shift;
    my $opt   = shift;

    $opt = {} if ref $opt ne 'HASH';
    $opt = { 
        RaiseError => 1,
        PrintError => 0,
    };

    my @conf = __PACKAGE__->load_connect_args;

    my $dbh = DBI->connect(@conf, $opt);
    my $sql = SQL::Abstract->new;

    $dbh->{mysql_auto_reconnect} = 1;

    return bless {dbh => $dbh, sql => $sql}, $class;
}

sub dbh {
    return shift->{dbh};
}

sub sql {
    return shift->{sql};
}

sub load_connect_args {
    my $self = shift;

    my $conf = YAML::LoadFile('secrets/mysql.yaml');

    return ($conf->{dsn}, $conf->{user}, $conf->{password});
}

1;
__END__

