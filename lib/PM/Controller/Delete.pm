package PM::Controller::Delete;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Tag';

use PM::Model::Delete;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $vinfo = PM::Model::Delete->fetch_video_info($sm);
    my $tags = PM::Model::Delete->exists($sm, $env->{'psgix.session'}{id});
    $sm =~ /[s|n]m(\d+)/;
    my $vid = $1;

    my $body = $view->render_with_encode('delete_get.tx', {
        vinfo => $vinfo, tags => $tags,
        vid => $sm, vid_num => $vid});

    return [200, [], [$body]];
}

sub post {
    my $self = shift;
    my $env  = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $req = Plack::Request->new($env);
    if (my $thumb = PM::Model::Delete->fetch_video_info($sm)) {
        my @deleted;
        for my $tag ($req->param('tag')) {
            if (length $tag > 0) {
                PM::Model::Delete->delete(
                    $sm, $env->{'psgix.session'}{id}, $tag);
                push @deleted, $tag;
            }
        }

        my $exist_tags = PM::Model::Delete->exists(
            $sm, $env->{'psgix.session'}{id});

        my $title = $thumb->{title};

        $sm =~ /(\d+)/;
        my $body = $view->render_with_encode('delete_post.tx', {
            vid => $sm, vid_num => $1, deleted => \@deleted,
            tags => $exist_tags, title => $title});

        return [200, ['Content-Type' => 'text/html'], [$body]];

    } else {
        return PM::Controller::HTTPError->throw(404);
    }

}

1;
__END__

