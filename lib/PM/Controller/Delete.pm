package PM::Controller::Delete;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use PM::Model::Delete;

sub get {
    my $self = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $thumb = PM::Utils->gen_thumb_url($sm);
    my $vinfo = PM::Model::Delete->fetch_video_info($sm);
    my $tags  = PM::Model::Delete->exists($sm, $self->request->env->{'psgix.session'}{id});

    my $body = $self->render('delete_get.tx', {
        vinfo => $vinfo,
        tags  => $tags,
        vid   => $sm,
        thumb => $thumb,
    });

    return [200, [], [$body]];
}

sub post {
    my $self = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    if (my $thumb = PM::Model::Delete->fetch_video_info($sm)) {
        my @deleted;
        for my $tag ($self->request->param('tag')) {
            if (length $tag > 0) {
                PM::Model::Delete->delete($sm, $self->request->env->{'psgix.session'}{id}, $tag);
                push @deleted, $tag;
            }
        }

        my $title = $thumb->{title};
        my $thumb = PM::Utils->gen_thumb_url($sm);
        my $exist_tags = PM::Model::Delete->exists($sm, $self->request->env->{'psgix.session'}{id});

        my $body = $self->render('delete_post.tx', {
            vid   => $sm,
            thumb => $thumb,
            tags  => $exist_tags,
            title => $title,
            deleted => \@deleted,
        });

        return [200, ['Content-Type' => 'text/html'], [$body]];

    } else {
        return PM::Controller::HTTPError->throw(404);
    }

}

1;
__END__

