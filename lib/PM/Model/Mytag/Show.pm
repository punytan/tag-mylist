package PM::Model::Mytag::Show;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model::Mytag';

my $model = PM::Model->new;

sub fetch_vid {
    my $self = shift;
    my $uid  = shift;
    my $tag  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT vid
          FROM usertags
         WHERE (uid = ?)
           AND (tag = ?)
    });
    $sth->execute($uid, $tag);

    my $vids = $sth->fetchall_arrayref;

    return $vids;
}

sub fetch_tags_of {
    my $self = shift;
    my $vid  = shift;
    my $uid  = shift;

    my $sth = $model->dbh->prepare(q{
        SELECT tag
          FROM usertags
         WHERE (uid = ?)
           AND (vid = ?)
    });
    $sth->execute($uid, $vid);

    my $result = $sth->fetchall_arrayref;

    my @tags;
    for my $item (@$result) {
        push @tags, $item->[0];
    }

    return @tags;
}

1;
__END__

