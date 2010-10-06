package PM::Controller::Root;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller';

use PM::Model::Root;
use PM::Model::Session;

my $view  = PM::View->new;
my $model = PM::Model::Root->new;

sub get {
    my $self = shift;
    my $env  = shift;

    unless (PM::Model::Session->is_login($env)) {
        my $body = $view->render_with_encode(
            'root_not_login.tx', {});

        return [200, ['Content-Type' => 'text/html'], [$body]];
    }

    my @vids = $model->fetch_random_vid;

    my @data;
    for my $vid (@vids) {

        my $thumb    = PM::Utils->gen_thumb_url($vid);
        my $title    = $model->fetch_vid_title($vid);
        my @usertags = $model->fetch_usertags($vid);

        push @data, {
            vid      => $vid,
            thumb    => $thumb,
            title    => $title,
            usertags => \@usertags};
    }

    my $body = $view->render_with_encode('root_login.tx', {
        session => $env->{'psgix.session'}, data => \@data});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

