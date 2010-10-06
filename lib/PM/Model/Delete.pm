package PM::Model::Delete;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Model';

use Try::Tiny;
use PM::Model::Add::SM;

my $model = PM::Model->new;

sub exists {
    my $self = shift;
    my $sm   = shift;
    my $uid  = shift;

    return PM::Model::Add::SM->exists($sm, $uid);
}

sub fetch_video_info {
    my $self = shift;
    my $sm   = shift;

    return PM::Model::Add::SM->fetch_video_info($sm);
}

sub delete {
    my $self = shift;
    my $sm   = shift;
    my $uid  = shift;
    my $tag  = shift;

    try {
        my $sth = $model->dbh->prepare(q{
            DELETE FROM usertags
                WHERE (uid = ?)
                    AND (vid = ?)
                    AND (tag = ?)
        });
        $sth->execute($uid, $sm, $tag);

    } catch {
        warn $_;
    };
}

1;
__END__

