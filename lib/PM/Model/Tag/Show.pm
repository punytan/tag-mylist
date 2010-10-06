package PM::Model::Tag::Show;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model::Tag';

use PM::Model::Add::SM;
my $model = PM::Model->new;

sub fetch_vid_title {
    my $self = shift;
    my $vid  = shift;

    if (my $vinfo = PM::Model::Add::SM->fetch_video_info($vid)) {
        return $vinfo->{title};
    } else {
        return undef;
    }
}

sub fetch_vids {
    my $self = shift;
    my $tag  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT vid
          FROM usertags
         WHERE tag = ?
      ORDER BY rand()
         LIMIT 30
    });
    $sth->execute($tag);

    my $ref  = $sth->fetchall_arrayref;
    my @vids = $self->arrayref_to_array($ref);

    return @vids;
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

    my $ref  = $sth->fetchall_arrayref;
    my @tags = $self->arrayref_to_array($ref);

    return @tags;
}

sub fetch_mytags {
    my $self = shift;
    my $uid  = shift;
    my $vid  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT tag
          FROM usertags
         WHERE (vid = ?)
           AND (uid = ?)
    });
    $sth->execute($vid, $uid);

    my $ref  = $sth->fetchall_arrayref;
    my @tags = $self->arrayref_to_array($ref);

    return @tags;
}

sub arrayref_to_array {
    my $self = shift;
    my $ref  = shift;

    my @array;
    for my $item (@$ref) {
        push @array, $item->[0];
    }

    return @array;
}

1;
__END__

