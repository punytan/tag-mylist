package PM::Controller::Mytag::Show;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Mytag';

use PM::Model::Mytag;
use PM::Model::Mytag::Show;
use PM::Model::Add::SM;

sub get {
    my $self = shift;
    my $tag  = shift;

    unless (PM::Model::Session->is_login($self)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $vids = PM::Model::Mytag::Show->fetch_vid(
        $self->request->env->{'psgix.session'}{id}, $tag);

    my @vinfo;
    for my $vid (@$vids) {
        my $sm = $vid->[0];

        my $thumb = PM::Utils->gen_thumb_url($sm);
        my $info  = PM::Model::Add::SM->fetch_video_info($sm);
        my @tags  = PM::Model::Mytag::Show->fetch_tags_of(
            $sm, $self->request->env->{'psgix.session'}{id});

        push @vinfo, +{
            vid   => $sm,
            title => $info->{title},
            thumb => $thumb,
            vinfo => $info,
            tags  => \@tags
        };
    }


    my $body = $self->render('mytag_show.tx', {vinfo => \@vinfo, tag => $tag});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

