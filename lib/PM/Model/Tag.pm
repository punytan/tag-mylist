package PM::Model::Tag;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

my $model = PM::Model->new;

sub fetch_mytags {
    my $self = shift;
    my $uid  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT DISTINCT (tag) FROM usertags WHERE uid = ?});
    $sth->execute($uid);

    my $tags = $sth->fetchall_arrayref;

    return $tags;

}

1;
__END__

