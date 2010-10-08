package PM::Controller::Add::SM;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Add';

use PM::Model::Add::SM;
my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    if (my $thumbinfo = PM::Model::Add::SM->fetch_video_info($sm)) {

        my $exist_tags = PM::Model::Add::SM->exists(
            $sm, $env->{'psgix.session'}{id});

        my $title = $thumbinfo->{title};
        my $tags  = $thumbinfo->{tags};
        my $thumb = PM::Utils->gen_thumb_url($sm);

        my @without_duplication = $self->throw_duplication($exist_tags, $tags);

        my $body = $view->render_with_encode('add_sm_get.tx', {
            vid   => $sm,
            title => $title,
            thumb => $thumb,
            tags  => \@without_duplication,
            exist_tags => $exist_tags});

        return [200, ['Content-Type' => 'text/html'], [$body]];

    } else {
        return PM::Controller::HTTPError->throw(404);

    }

}

sub throw_duplication {
    my $self = shift;
    my $a1 = shift;
    my $a2 = shift;

    my @r;
    my %tmp;

    for my $key (@$a1) {
        $tmp{$key}++;
    }

    for my $key (@$a2) {
        $tmp{$key}++;
    }

    for my $key (keys %tmp) {
        push @r, $key if $tmp{$key} < 2;
    }

    return @r;
}

sub post {
    my $self = shift;
    my $env  = shift;
    my $sm   = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $req = Plack::Request->new($env);

    if (my $thumbinfo = PM::Model::Add::SM->fetch_video_info($sm)) {

        my @added;
        for my $tag ($req->param('tag')) {
            if (length $tag > 0) {
                PM::Model::Add::SM->add(
                    $sm, $env->{'psgix.session'}{id}, $tag);
                push @added, $tag;
            }
        }

        my $title = $thumbinfo->{title};
        my $thumb = PM::Utils->gen_thumb_url($sm);
        my $exist_tags = PM::Model::Add::SM->exists(
            $sm, $env->{'psgix.session'}{id});

        my $body = $view->render_with_encode('add_sm_post.tx', {
            vid   => $sm,
            thumb => $thumb,
            title => $title,
            added => \@added,
            all_tags => $exist_tags});

        return [200, ['Content-Type' => 'text/html'], [$body]];

    } else {
        return PM::Controller::HTTPError->throw(404);
    }
}

1;
__END__

