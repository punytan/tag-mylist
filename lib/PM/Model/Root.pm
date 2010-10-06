package PM::Model::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

use Try::Tiny;

my $model = PM::Model->new;

sub fetch_random_vid {
    my $self = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT DISTINCT vid
          FROM usertags
      ORDER BY rand()
         LIMIT 20
    });
    $sth->execute;

    my $rows = $sth->fetchall_arrayref;

    my @vids;
    for my $row (@$rows) {
        push @vids, $row->[0];
    }

    return @vids;
}

sub fetch_vid_title {
    my $self = shift;
    my $vid  = shift;

    if (my $info = PM::Model::Add::SM->fetch_video_info($vid)) {
        return $info->{title};
    } else {
        return undef;
    }
}

sub fetch_usertags {
    my $self = shift;
    my $vid  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT tag
          FROM usertags
         WHERE vid = ?
      ORDER BY rand()
         LIMIT 10
    });
    $sth->execute($vid);
    my $ref = $sth->fetchall_arrayref;

    my @usertags;
    for my $row (@$ref) {
        push @usertags, $row->[0];
    }

    return @usertags;
}

1;
__END__

