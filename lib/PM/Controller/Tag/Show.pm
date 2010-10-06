package PM::Controller::Tag::Show;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Tag';

use PM::Model::Tag::Show;
use PM::Model::Add::SM;
use YAML;

my $view = PM::View->new;
my $model = PM::Model::Tag::Show->new;

sub get {
    my $self = shift;
    my $env  = shift;
    my $tag  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my @vids = $model->fetch_vids($tag);

    my @data;
    for my $vid (@vids) {

        my $thumb    = PM::Utils->gen_thumb_url($vid);
        my $title    = $model->fetch_vid_title($vid);
        my @usertags = $model->fetch_usertags($vid);
        my @mytags   = $model->fetch_mytags(
            $env->{'psgix.session'}{id}, $vid);

        push @data, {
            vid      => $vid,
            thumb    => $thumb,
            title    => $title,
            usertags => \@usertags,
            mytags   => \@mytags};
    }

    my $body = $view->render_with_encode(
        'tag_show.tx', {data => \@data, tag => $tag});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

