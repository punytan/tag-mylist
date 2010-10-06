package PM::Model::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

use Try::Tiny;

my $model = PM::Model->new;

sub fetch_random_vid {
    my $self = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT vid FROM usertags ORDER BY rand() limit 20});
    $sth->execute;

    my $rows = $sth->fetchall_arrayref;

    my @vids;
    for my $row (@$rows) {
        push @vids, $row->[0];
    }
    return @vids;
}

sub fetch_video_info {
    my $self = shift;
    my $vid  = shift;

    return PM::Model::Add::SM->fetch_video_info($vid);
}

1;
__END__

