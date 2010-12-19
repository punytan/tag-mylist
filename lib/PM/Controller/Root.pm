package PM::Controller::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'Lanky::Handler';

use PM::Model::Root;
use PM::Model::Session;

my $model = PM::Model::Root->new;

sub get {
    my $self = shift;

    unless (PM::Model::Session->is_login($self)) {
        my $body = $self->render('root_not_login.tx', {});

        my $res = $self->request->new_response(200);
        $res->content_type('text/html');
        $res->body($body);
        return $res->finalize;
    }

    my @vids = $model->fetch_random_vid;

    my @data;
    for my $vid (@vids) {

        my $thumb    = PM::Utils->gen_thumb_url($vid);
        my $title    = $model->fetch_vid_title($vid);
        my @usertags = $model->fetch_usertags($vid);

        push @data, +{
            vid      => $vid,
            thumb    => $thumb,
            title    => $title,
            usertags => \@usertags
        };
    }

    my $body = $self->render('root_login.tx', {
        session => $self->request->env->{'psgix.session'}, data => \@data});

    my $res = $self->request->new_response(200);
    $res->content_type('text/html');
    $res->body($body);
    return $res->finalize;
}

1;
__END__

