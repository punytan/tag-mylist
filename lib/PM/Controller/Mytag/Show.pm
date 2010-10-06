package PM::Controller::Mytag::Show;
use common::sense;
our $VERSION = '0.01';
use parent 'PM::Controller::Mytag';

use PM::Model::Mytag;
use PM::Model::Mytag::Show;
use PM::Model::Add::SM;
use YAML;

my $view = PM::View->new;

sub get {
    my $self = shift;
    my $env  = shift;
    my $tag  = shift;

    unless (PM::Model::Session->is_login($env)) {
        return PM::Controller::HTTPError->code_301('/');
    }

    my $vids = PM::Model::Mytag::Show->fetch_vid(
        $env->{'psgix.session'}{id}, $tag);

    my @vinfo;
    for my $vid (@$vids) {
        my $info = PM::Model::Add::SM->fetch_video_info($vid->[0]);
        if ($vid->[0] =~ /[s|n]m(\d+)/) {
            $info->{thumbid} = $1;
        }
        my @tags = PM::Model::Mytag::Show->fetch_tags_of($vid->[0],
            $env->{'psgix.session'}{id});

        push @vinfo, [$vid->[0], $info, \@tags];
    }


    my $body = $view->render_with_encode('mytag_show.tx', {
        vinfo => \@vinfo, tag => $tag});

    return [200, ['Content-Type' => 'text/html'], [$body]];
}

1;
__END__

